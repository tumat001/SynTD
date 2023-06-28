extends MarginContainer

const BaseTooltip = preload("res://GameHUDRelated/Tooltips/BaseTooltip.gd")
const GoldIncomeTooltip = preload("res://GameHUDRelated/StatsPanel/GoldIncomeTooltip.gd")
const GoldIncomeTooltip_Scene = preload("res://GameHUDRelated/StatsPanel/GoldIncomeTooltip.tscn")

const GoldBackgroundGlow_Inc_Pic = preload("res://GameHUDRelated/StatsPanel/Assets/GoldIndicatorBackground_Glow_LightBlue.png")
const GoldBackgroundGlow_Dec_Pic = preload("res://GameHUDRelated/StatsPanel/Assets/GoldIndicatorBackground_Glow_Red.png")

const LevelUpBackgroundGlow_Inc_Pic = preload("res://GameHUDRelated/StatsPanel/Assets/LevelIndicatorBackground_Glow_LightBlue.png")
const LevelUpBackgroundGlow_Dec_Pic = preload("res://GameHUDRelated/StatsPanel/Assets/LevelIndicatorBackground_Glow_Red.png")

const GenStats_SmallButton = preload("res://GameHUDRelated/StatsPanel/SmallButtonRelated/GenStats_SmallButton.gd")
const GenStats_SmallButton_Scene = preload("res://GameHUDRelated/StatsPanel/SmallButtonRelated/GenStats_SmallButton.tscn")


##

const background_glow_pic_max_mod_a : float = 0.3

const first_time__glow__in_duration = 0.4
const x_time__glow__in_duration = 0.2

const first_time__glow__out_duration = 0.6
const x_time__glow__out_duration = 0.3


const level_change__glow__in_duration = 0.6
const level_change__glow__out_duration = 1.2



const gold_gradient_max_modulate_a__start : float = 0.5
const gold_gradient_min_modulate_a__for_looping : float = 0.30
const gold_gradient_max_modulate_a__for_looping : float = 0.45

const gold_gradient_starting_transition_duration : float = 0.5
const gold_gradient_wait_after_starting_transition_duration : float = 1.5

const gold_gradient_transition_duration_for_looping : float = 2.0
const gold_gradient_middle_wait_duration_for_looping : float = 1.0

const gold_gradient_fade_duration_on_end : float = 0.8


######

var game_elements
var gold_manager setget set_gold_manager
var relic_manager setget set_relic_manager
var shop_manager setget set_shop_manager
var level_manager setget set_level_manager
var stage_round_manager setget set_stage_round_manager
var right_side_panel setget set_right_side_panel


var _mod_a_tweener_for_gold_background_glow : SceneTreeTween
var _mod_a_tweener_for_level_background_glow : SceneTreeTween

const gradient_color__transparent := Color(0, 0, 0, 0)
const gold_gradient_modulate : Color = Color(217/255.0, 164/255.0, 2/255.0)
var _gold_gradient_texture_2d : GradientTexture2D

var _gold_gradient_texture_mod_tweener : SceneTreeTween
var _is_showing_gold_gradient : bool

#

onready var gold_amount_label = $HBoxContainer/Middle/GoldPanel/MarginContainer3/HBoxContainer/MarginContainer2/GoldAmountLabel
onready var gold_button = $HBoxContainer/Middle/GoldPanel/GoldButton
onready var gold_background_glow_texture_rect = $HBoxContainer/Middle/GoldPanel/GoldBackgroundGlowTexture
onready var gold_gradient_control_tint = $HBoxContainer/Middle/GoldPanel/GoldControlGradientTint

onready var streak_panel = $HBoxContainer/Middle/StreakPanel

onready var level_label = $HBoxContainer/LeftSide/LevelPanel/MarginContainer3/MarginContainer2/LevelLabel
onready var level_background_glow_texture_rect = $HBoxContainer/LeftSide/LevelPanel/MarginContainer/LevelUpBackgroundGlowTexture

onready var relic_label = $HBoxContainer/Right/RelicPanel/MarginContainer3/HBoxContainer/MarginContainer2/RelicAmountLabel
onready var shop_percentage_stat_panel = $HBoxContainer/LeftSide/ShopPercentStatsPanel

onready var relic_panel = $HBoxContainer/Right/RelicPanel
onready var round_damage_stats_button = $HBoxContainer/Right/RoundDamageStatsButton

onready var relic_general_store_button = $HBoxContainer/Right/RelicGeneralStoreButton

#

onready var other_small_button_container = $HBoxContainer/Right/OtherSmallButtonContainer

#

func _ready():
	gold_background_glow_texture_rect.modulate.a = 0
	level_background_glow_texture_rect.modulate.a = 0
	
	_initialize_gold_gradient_control_tint()

func _initialize_gold_gradient_control_tint():
	gold_gradient_control_tint.modulate.a = 0
	
	var size = gold_background_glow_texture_rect.get_rect().size
	_gold_gradient_texture_2d = gold_gradient_control_tint.get_rect_gradient_texture__0_to_1__topdown(size)
	
	var gradient = gold_gradient_control_tint.construct_gradient_two_color(gradient_color__transparent, gold_gradient_modulate)
	
	_gold_gradient_texture_2d.gradient = gradient
	


# setters

func set_gold_manager(arg_manager):
	gold_manager = arg_manager
	
	gold_manager.connect("current_gold_changed", self, "set_gold_amount_label", [], CONNECT_PERSIST)
	set_gold_amount_label(gold_manager.current_gold)
	
	gold_manager.connect("gold_breakpoint_changed", self, "_on_gold_breakpoint_changed", [], CONNECT_PERSIST)

func set_relic_manager(arg_manager):
	relic_manager = arg_manager
	
	relic_manager.connect("current_relic_count_changed", self, "_on_current_relic_amount_changed", [], CONNECT_PERSIST)
	_on_current_relic_amount_changed(relic_manager.current_relic_count)
	#set_relic_amount_label(relic_manager.current_relic_count)

func set_shop_manager(arg_manager):
	shop_manager = arg_manager
	shop_percentage_stat_panel.shop_manager = shop_manager

func set_level_manager(arg_manager):
	level_manager = arg_manager
	
	level_manager.connect("on_current_level_changed", self, "set_level_label", [], CONNECT_PERSIST)
	set_level_label(level_manager.current_level)
	shop_percentage_stat_panel.level_manager = level_manager
	
	level_manager.connect("level_changed__for_panel_glow", self, "_on_level_changed__for_panel_glow", [], CONNECT_PERSIST)

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	streak_panel.stage_round_manager = stage_round_manager

func set_right_side_panel(arg_panel):
	right_side_panel = arg_panel
	
	round_damage_stats_button.right_side_panel = right_side_panel


# updating of stuffs

func set_gold_amount_label(new_amount):
	gold_amount_label.text = str(new_amount)

func set_level_label(new_level):
	level_label.text = str(new_level)


func _on_current_relic_amount_changed(arg_new_amount):
	set_relic_amount_label(arg_new_amount)
	set_relic_general_store_button_visibility(arg_new_amount)

func set_relic_amount_label(new_amount):
	relic_panel.visible = new_amount != 0
	relic_label.text = str(new_amount)

func set_relic_general_store_button_visibility(arg_relic_amount):
	relic_general_store_button.visible = relic_manager._has_received_at_least_one_relic and arg_relic_amount <= 0


# gold income tooltip


func _on_GoldButton_about_tooltip_construction_requested():
	var tooltip = GoldIncomeTooltip_Scene.instance()
	tooltip.gold_manager = gold_manager
	
	gold_button.display_requested_about_tooltip(tooltip)



###


func _on_RelicGeneralStoreButton_pressed_mouse_event(event):
	relic_manager.show_whole_screen_relic_general_store_panel()


####################

func _on_gold_breakpoint_changed(arg_is_increase, arg_is_decrease, arg_first_time, arg_is_max_val_for_interest):
	if arg_is_increase:
		_play_gold_interval_passed_with_increase(arg_first_time)
	elif arg_is_decrease:
		_play_gold_interval_passed_with_decrease(arg_first_time)
	
	if arg_is_max_val_for_interest and !_is_showing_gold_gradient:
		_start_gold_gradient_tint_show()
	elif !arg_is_max_val_for_interest and _is_showing_gold_gradient:
		_end_gold_gradient_tint_show()


func _play_gold_interval_passed_with_increase(arg_first_time):
	gold_background_glow_texture_rect.texture = GoldBackgroundGlow_Inc_Pic
	
	_mod_a_tweener_for_gold_background_glow = create_tween()
	#_mod_a_tweener_for_gold_background_glow.connect("step_finished", self, "_on_gold_glow_background_mod_tweener_fade_in_finished", [arg_first_time])
	
	if arg_first_time:
		_mod_a_tweener_for_gold_background_glow.tween_property(gold_background_glow_texture_rect, "modulate:a", background_glow_pic_max_mod_a, first_time__glow__in_duration)
		_mod_a_tweener_for_gold_background_glow.tween_property(gold_background_glow_texture_rect, "modulate:a", 0.0, first_time__glow__out_duration)
	else:
		_mod_a_tweener_for_gold_background_glow.tween_property(gold_background_glow_texture_rect, "modulate:a", background_glow_pic_max_mod_a, x_time__glow__in_duration)
		_mod_a_tweener_for_gold_background_glow.tween_property(gold_background_glow_texture_rect, "modulate:a", 0.0, x_time__glow__out_duration)
	

func _play_gold_interval_passed_with_decrease(arg_first_time):
	gold_background_glow_texture_rect.texture = GoldBackgroundGlow_Dec_Pic
	
	_mod_a_tweener_for_gold_background_glow = create_tween()
	
	_mod_a_tweener_for_gold_background_glow.tween_property(gold_background_glow_texture_rect, "modulate:a", background_glow_pic_max_mod_a, x_time__glow__in_duration)
	_mod_a_tweener_for_gold_background_glow.tween_property(gold_background_glow_texture_rect, "modulate:a", 0.0, x_time__glow__out_duration)
	


####

func _on_level_changed__for_panel_glow(arg_is_increase, arg_is_decrease):
	if arg_is_increase:
		_play_level_changed_with_increase()
	elif arg_is_decrease:
		_play_level_changed_with_decrease()
	

func _play_level_changed_with_increase():
	level_background_glow_texture_rect.texture = LevelUpBackgroundGlow_Inc_Pic
	
	_mod_a_tweener_for_level_background_glow = create_tween()
	_mod_a_tweener_for_level_background_glow.tween_property(level_background_glow_texture_rect, "modulate:a", background_glow_pic_max_mod_a, level_change__glow__in_duration)
	_mod_a_tweener_for_level_background_glow.tween_property(level_background_glow_texture_rect, "modulate:a", 0.0, level_change__glow__out_duration)

func _play_level_changed_with_decrease():
	level_background_glow_texture_rect.texture = LevelUpBackgroundGlow_Dec_Pic
	
	_mod_a_tweener_for_level_background_glow = create_tween()
	_mod_a_tweener_for_level_background_glow.tween_property(level_background_glow_texture_rect, "modulate:a", background_glow_pic_max_mod_a, level_change__glow__in_duration)
	_mod_a_tweener_for_level_background_glow.tween_property(level_background_glow_texture_rect, "modulate:a", 0.0, level_change__glow__out_duration)


########


func _start_gold_gradient_tint_show():
	gold_gradient_control_tint.texture = _gold_gradient_texture_2d
	
	var tweener = create_tween()
	
	tweener.tween_property(gold_gradient_control_tint, "modulate:a", gold_gradient_max_modulate_a__start, gold_gradient_starting_transition_duration)
	tweener.tween_property(gold_gradient_control_tint, "modulate:a", gold_gradient_max_modulate_a__start, gold_gradient_wait_after_starting_transition_duration)
	tweener.connect("finished", self, "_on_gold_gradient_control_tint_starting_anim_finished", [], CONNECT_ONESHOT)
	
	_is_showing_gold_gradient = true

func _on_gold_gradient_control_tint_starting_anim_finished():
	_start_gradient_tint_loop_anim()

func _start_gradient_tint_loop_anim():
	var tweener = create_tween()
	
	tweener.set_loops()
	tweener.tween_property(gold_gradient_control_tint, "modulate:a", gold_gradient_min_modulate_a__for_looping, gold_gradient_transition_duration_for_looping)
	tweener.tween_property(gold_gradient_control_tint, "modulate:a", gold_gradient_max_modulate_a__for_looping, gold_gradient_transition_duration_for_looping)
	tweener.tween_property(gold_gradient_control_tint, "modulate:a", gold_gradient_max_modulate_a__for_looping, gold_gradient_middle_wait_duration_for_looping)
	
	_gold_gradient_texture_mod_tweener = tweener


func _end_gold_gradient_tint_show():
	if _gold_gradient_texture_mod_tweener != null:
		_gold_gradient_texture_mod_tweener.stop()
		_gold_gradient_texture_mod_tweener = null
	
	#
	
	var tweener = create_tween()
	tweener.tween_property(gold_gradient_control_tint, "modulate:a", 0.0, gold_gradient_fade_duration_on_end)
	
	_is_showing_gold_gradient = false


############


func construct_small_button_using_cons_params(arg_params : GenStats_SmallButton.ConstructorParams):
	var button = GenStats_SmallButton_Scene.instance()
	
	other_small_button_container.add_child(button)
	
	button.set_prop_based_on_constructor(arg_params)
	
	return button



