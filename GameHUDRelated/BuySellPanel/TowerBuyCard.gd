extends MarginContainer

const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTooltip = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.gd")
const TowerTooltipScene = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.tscn")

const tier01_crown = preload("res://GameHUDRelated/BuySellPanel/Tier01_Crown.png")
const tier02_crown = preload("res://GameHUDRelated/BuySellPanel/Tier02_Crown.png")
const tier03_crown = preload("res://GameHUDRelated/BuySellPanel/Tier03_Crown.png")
const tier04_crown = preload("res://GameHUDRelated/BuySellPanel/Tier04_Crown.png")
const tier05_crown = preload("res://GameHUDRelated/BuySellPanel/Tier05_Crown.png")
const tier06_crown = preload("res://GameHUDRelated/BuySellPanel/Tier06_Crown.png")

const BuyCard_Normal_Tier01 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier01_Normal.png")
const BuyCard_Normal_Tier02 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier02_Normal.png")
const BuyCard_Normal_Tier03 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier03_Normal.png")
const BuyCard_Normal_Tier04 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier04_Normal.png")
const BuyCard_Normal_Tier05 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier05_Normal.png")
const BuyCard_Normal_Tier06 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier06_Normal.png")

const BuyCard_Highlighted_Tier01 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier01_Highlighted.png")
const BuyCard_Highlighted_Tier02 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier02_Highlighted.png")
const BuyCard_Highlighted_Tier03 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier03_Highlighted.png")
const BuyCard_Highlighted_Tier04 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier04_Highlighted.png")
const BuyCard_Highlighted_Tier05 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier05_Highlighted.png")
const BuyCard_Highlighted_Tier06 = preload("res://GameHUDRelated/BuySellPanel/TowerBuyCardAssets/BuyAndInfoTowerBackground_Tier06_Highlighted.png")



signal viewing_tower_description_tooltip(tower_type_id)
signal tower_bought(tower_type_id, tower_cost)

signal card_pressed_down()
signal card_released_up_and_not_queue_freed()

const can_buy_modulate : Color = Color(1, 1, 1, 1)
const cannot_buy_modulate : Color = Color(0.5, 0.5, 0.5, 1)

const shine_sparkle_rotation_speed_per_sec : int = 560
const shine_sparkle_fade_per_sec : float = 1.25
const shine_sparkle_y_initial_speed : int = -75 # updwards
const shine_sparkle_y_accel_per_sec : int = 150
const shine_max_duration : float = 0.5
var shine_current_y_vel : float = 0

#

var tower_information : TowerTypeInformation
var disabled : bool = false
var current_tooltip : TowerTooltip

var current_gold : int
var tower_inventory_bench setget set_tower_inventory_bench
var can_buy__set_from_clauses : bool

var is_playing_shine_sparkle : bool = false
var shine_current_duration : float

var game_settings_manager
var buy_sell_level_roll_panel
var buy_slot

var _mouse_pos_when_pressed : Vector2
var _is_being_dragged_by_player_input : bool = false
var _mouse_offset_from_top_left_pos : Vector2
var _mouse_moved_after_press : bool = false
const time_after_press_threshold_for_buy : float = 0.15
var _time_after_press : float

#

var _is_hovered_over : bool
var _current_normal_texture : Texture
var _current_highlighted_texture : Texture

#

onready var ingredient_icon_rect = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/IngredientInfo/HBoxContainer/IngredientIcon
onready var tower_name_label = $MarginContainer/VBoxContainer/MarginerLower/Lower/TowerNameLabel
onready var tower_cost_label = $MarginContainer/VBoxContainer/MarginerLower/Lower/TowerCostLabel

onready var color_icon_01 = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Color01Icon
onready var color_label_01 = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Marginer/Color01Label
onready var color_icon_02 = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Color02Icon
onready var color_label_02 = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Marginer/Color02Label

onready var tower_image_rect = $MarginContainer/VBoxContainer/MarginerUpper/Upper/Marginer/TowerImage
onready var tier_crown_rect = $MarginContainer/VBoxContainer/TierCrownPanel/TierCrown

onready var buy_card = $BuyCard

onready var shine_texture_rect = $MarginContainer/ShineContainer/ShinePic
onready var shiny_border_texture_rect = $Control/ShinyBorder

#onready var border_shine = $BorderShine

#

func _ready():
	update_display()
	
	shine_texture_rect.rect_pivot_offset.x = shine_texture_rect.rect_size.x / 2
	shine_texture_rect.rect_pivot_offset.y = shine_texture_rect.rect_size.y / 2
	
	#border_shine.set_control_to_match_border(shiny_border_texture_rect)

func update_display():
	if tower_information != null:
		tower_name_label.text = tower_information.tower_name
		tower_cost_label.text = str(tower_information.tower_cost)
		
		# Color related
		var color01
		var color02
		
		if tower_information.colors.size() > 0:
			color01 = tower_information.colors[0]
		if tower_information.colors.size() > 1:
			color02 = tower_information.colors[1]
		
		if color01 != null:
			color_icon_01.texture = TowerColors.get_color_symbol_on_card(color01)
			color_label_01.text = TowerColors.get_color_name_on_card(color01)
		else:
			color_icon_01.texture = null
			color_label_01.text = ""
			#color_icon_01.self_modulate.a = 0
			#color_label_01.self_modulate.a = 0
		
		if color02 != null:
			color_icon_02.texture = TowerColors.get_color_symbol_on_card(color02)
			color_label_02.text = TowerColors.get_color_name_on_card(color02)
		else:
			color_icon_02.texture = null
			color_label_02.text = ""
			#color_icon_02.self_modulate.a = 0
			#color_label_02.self_modulate.a = 0
		
		# Ingredient Related
		if tower_information.ingredient_effect != null:
			ingredient_icon_rect.texture = tower_information.ingredient_effect.tower_base_effect.effect_icon
		else:
			ingredient_icon_rect.texture = null
			#ingredient_icon_rect.self_modulate.a = 0
		
		# TowerImageRelated
		if tower_information.tower_image_in_buy_card != null:
			tower_image_rect.texture = tower_information.tower_image_in_buy_card
			tower_image_rect.visible = true
		else:
			tower_image_rect.visible = false
		
		# Tier Crown Related
		if tower_information.tower_tier == 1:
			tier_crown_rect.texture = tier01_crown
		elif tower_information.tower_tier == 2:
			tier_crown_rect.texture = tier02_crown
		elif tower_information.tower_tier == 3:
			tier_crown_rect.texture = tier03_crown
		elif tower_information.tower_tier == 4:
			tier_crown_rect.texture = tier04_crown
		elif tower_information.tower_tier == 5:
			tier_crown_rect.texture = tier05_crown
		elif tower_information.tower_tier == 6:
			tier_crown_rect.texture = tier06_crown
		
		# tower card related
		_set_buy_card_texture_based_on_tier()
		
		#
		_update_can_buy_card()


func create_energy_display(energy_array : Array) -> String:
	return PoolStringArray(energy_array).join(" / ")


func _on_BuyCard_gui_input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_LEFT:
				pass
				
			BUTTON_RIGHT:
				if event.pressed:
					if !is_instance_valid(current_tooltip):
						_free_old_and_create_tooltip_for_tower()
					else:
						current_tooltip.queue_free()


func _free_old_and_create_tooltip_for_tower():
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
	
	if !disabled:
		current_tooltip = TowerTooltipScene.instance()
		current_tooltip.tower_info = tower_information
		current_tooltip.tooltip_owner = buy_card
		current_tooltip.game_settings_manager = game_settings_manager
		
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(current_tooltip)
	
	emit_signal("viewing_tower_description_tooltip", tower_information)

#func _on_BuyCard_mouse_exited():
#	kill_current_tooltip()

func kill_current_tooltip():
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()


# Gold related

func _can_afford() -> bool:
	return current_gold >= tower_information.tower_cost


# Tower bench related

func set_tower_inventory_bench(arg_bench):
	tower_inventory_bench = arg_bench
	
	tower_inventory_bench.connect("tower_entered_bench_slot", self, "_tower_added_in_bench_slot", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	tower_inventory_bench.connect("tower_removed_from_bench_slot", self, "_tower_removed_from_bench_slot", [], CONNECT_PERSIST | CONNECT_DEFERRED)

func _tower_added_in_bench_slot(tower, bench_slot):
	_update_can_buy_card()

func _tower_removed_from_bench_slot(tower, bench_slot):
	_update_can_buy_card()


# Can buy tower

func _update_can_buy_card():
	if can_buy_card():
		set_tower_card_modulate(can_buy_modulate)
	else:
		set_tower_card_modulate(cannot_buy_modulate)

func can_buy_card():
	return _can_afford() and !tower_inventory_bench.is_bench_full() and can_buy__set_from_clauses


# Tower combination related

func play_shine_sparkle_on_card():
	shine_current_duration = shine_max_duration
	
	shine_texture_rect.visible = true
	is_playing_shine_sparkle = true
	
	shine_current_y_vel = shine_sparkle_y_initial_speed
	shine_texture_rect.rect_rotation = 0
	shine_texture_rect.modulate = Color(1, 1, 1, 1)


func _process(delta):
	if (is_playing_shine_sparkle):
		shine_current_duration -= delta
		
		shine_current_y_vel += shine_sparkle_y_accel_per_sec * delta
		shine_texture_rect.rect_position.y += shine_current_y_vel * delta
		
		shine_texture_rect.rect_rotation += shine_sparkle_rotation_speed_per_sec * delta
		
		var fade_amount = delta * shine_sparkle_fade_per_sec
		shine_texture_rect.modulate.a -= fade_amount
	
	if (shine_current_duration <= 0):
		hide_shine_sparkle_on_card()
	
	if _is_being_dragged_by_player_input:
		var mouse_pos = get_viewport().get_mouse_position()
		rect_global_position = mouse_pos + _mouse_offset_from_top_left_pos
		
		if buy_sell_level_roll_panel.is_mouse_pos_within_panel_bounds():
			modulate.a = 1
		else:
			modulate.a = 0.5
		
		_time_after_press += delta / Engine.time_scale
		
		if !_mouse_moved_after_press and mouse_pos != _mouse_pos_when_pressed:
			_mouse_moved_after_press = true

func hide_shine_sparkle_on_card():
	is_playing_shine_sparkle = false
	shine_texture_rect.visible = false


#func set_show_border_shine(arg_val : bool):
#	border_shine.show_border_shine = arg_val


###

func set_tower_card_modulate(arg_modulate):
	set_control_modulate(self, arg_modulate)
	shine_texture_rect.self_modulate = can_buy_modulate
	shiny_border_texture_rect.self_modulate = can_buy_modulate

func set_control_modulate(arg_control, arg_modulate):
	arg_control.self_modulate = arg_modulate
	for child in arg_control.get_children():
		if child.get("self_modulate"):
			child.self_modulate = arg_modulate
		
		if child.get_child_count() > 0:
			for inner_child in child.get_children():
				set_control_modulate(inner_child, arg_modulate)




func _on_BuyCard_button_down():
	_time_after_press = 0
	_is_being_dragged_by_player_input = true
	_mouse_moved_after_press = false
	var mouse_pos = get_viewport().get_mouse_position()
	_mouse_offset_from_top_left_pos = rect_global_position - mouse_pos
	
	_mouse_pos_when_pressed = mouse_pos
	
	emit_signal("card_pressed_down")

func _on_BuyCard_button_up():
	_on_BuyCard_released()

func _on_BuyCard_released():
	_is_being_dragged_by_player_input = false
	
	#if !disabled and can_buy_card() and !is_queued_for_deletion() and (!buy_sell_level_roll_panel.is_mouse_pos_within_panel_bounds() or !_mouse_moved_after_press):
	if !disabled and can_buy_card() and !is_queued_for_deletion() and (!buy_sell_level_roll_panel.is_mouse_pos_within_panel_bounds() or _time_after_press < time_after_press_threshold_for_buy or !_mouse_moved_after_press):
		disabled = true
		emit_signal("tower_bought", tower_information)
		
		if is_instance_valid(current_tooltip):
			current_tooltip.queue_free()
		
		queue_free()
	else:
		rect_global_position = buy_slot.rect_global_position
		modulate.a = 1
		emit_signal("card_released_up_and_not_queue_freed")
	
	_mouse_moved_after_press = false
	_time_after_press = 0


#

func _set_buy_card_texture_based_on_tier():
	if tower_information.tower_tier == 1:
		_current_normal_texture = BuyCard_Normal_Tier01
		_current_highlighted_texture = BuyCard_Highlighted_Tier01
		
	elif tower_information.tower_tier == 2:
		_current_normal_texture = BuyCard_Normal_Tier02
		_current_highlighted_texture = BuyCard_Highlighted_Tier02
		
	elif tower_information.tower_tier == 3:
		_current_normal_texture = BuyCard_Normal_Tier03
		_current_highlighted_texture = BuyCard_Highlighted_Tier03
		
	elif tower_information.tower_tier == 4:
		_current_normal_texture = BuyCard_Normal_Tier04
		_current_highlighted_texture = BuyCard_Highlighted_Tier04
		
	elif tower_information.tower_tier == 5:
		_current_normal_texture = BuyCard_Normal_Tier05
		_current_highlighted_texture = BuyCard_Highlighted_Tier05
		
	elif tower_information.tower_tier == 6:
		_current_normal_texture = BuyCard_Normal_Tier06
		_current_highlighted_texture = BuyCard_Highlighted_Tier06
	
	_update_buy_card_texture()


#func _on_BuyCard_mouse_entered():
#	_is_hovered_over = true
#	_update_buy_card_texture()
#
#
#func _on_BuyCard_mouse_exited():
#	_is_hovered_over = false
#	_update_buy_card_texture()
#
#
#func _on_BuyCardContainer_visibility_changed():
#	if !visible:
#		_is_hovered_over = false
#		_update_buy_card_texture()


func _update_buy_card_texture():
	
	buy_card.texture_normal = _current_normal_texture
	buy_card.texture_hover = _current_highlighted_texture
	


