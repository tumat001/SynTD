extends MarginContainer

const StageRoundManager = preload("res://GameElementsRelated/StageRoundManager.gd")

const WinIcon = preload("res://GameHUDRelated/StatsPanel/Assets/StreakIndicator_WinIcon.png")
const LoseIcon = preload("res://GameHUDRelated/StatsPanel/Assets/StreakIndicator_LoseIcon.png")
const NoneIcon = preload("res://GameHUDRelated/StatsPanel/Assets/StreakIndicator_NoneIcon.png")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const CenterBasedAttackParticle = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd")
const CenterBasedAttackParticle_Scene = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.tscn")


const StreakIndicatorBackground_Glow_Lose = preload("res://GameHUDRelated/StatsPanel/Assets/StreakIndicatorBackground_Glow_Lose.png")
const StreakIndicatorBackground_Glow_Win = preload("res://GameHUDRelated/StatsPanel/Assets/StreakIndicatorBackground_Glow_Win.png")

const StreakIndicator_BrokenParticle_White9x9 = preload("res://GameHUDRelated/StatsPanel/Assets/StreakIndicator_BrokenParticle_White_9x9.png")


#

const glow_background_mod_a_max_val : float = 0.3

const glow_duration__long__in : float = 0.75
const glow_duration__long__out : float = 1.50

const glow_duration__short__in : float = 0.4
const glow_duration__short__out : float = 0.6


const streak_particle_broken_modulate__win := Color(30.0/255, 217.0/255, 2.0/255)
const streak_particle_broken_modulate__lose := Color(218.0/255, 2.0/255, 5.0/255)


const streak_gradient_color__transparent := Color(0, 0, 0, 0)

const streak_gradient_color__lose := Color(218.0/255, 2.0/255, 5.0/255)
const streak_gradient_color__win := Color(30.0/255, 217.0/255, 2.0/255)


const streak_gradient_max_modulate_a__start : float = 0.5
const streak_gradient_min_modulate_a__for_looping : float = 0.3
const streak_gradient_max_modulate_a__for_looping : float = 0.45

const streak_gradient_starting_transition_duration : float = 0.5
const streak_gradient_wait_after_starting_transition_duration : float = 1.5

const streak_gradient_transition_duration_for_looping : float = 2.0
const streak_gradient_middle_wait_duration_for_looping : float = 1.0

const streak_gradient_fade_duration_on_end : float = 0.8

#

var stage_round_manager : StageRoundManager setget set_stage_round_manager

var streak_broken_particle_pool_component : AttackSpritePoolComponent


var non_essential_rng : RandomNumberGenerator


var _gradient_texture_2d__lose : GradientTexture2D
var _gradient_texture_2d__win : GradientTexture2D

var _gradient_texture_mod_tweener : SceneTreeTween

#

onready var streak_label = $MarginContainer/HBoxContainer/MarginContainer/StreakLabel
onready var streak_icon = $MarginContainer/HBoxContainer/StreakIcon

onready var glow_background = $MarginContainer2/GlowBackground

onready var control_gradient_tint = $MarginContainer2/ControlGradientTint

#

func _ready():
	glow_background.modulate.a = 0
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	_initialize_all_particle_pool_components()
	_initialize_gradient_relateds()
	


func _initialize_gradient_relateds():
	control_gradient_tint.modulate.a = 0
	
	var size = control_gradient_tint.get_rect().size
	_gradient_texture_2d__lose = control_gradient_tint.get_rect_gradient_texture__0_to_1__topdown(size)
	_gradient_texture_2d__win = control_gradient_tint.get_rect_gradient_texture__0_to_1__topdown(size)
	
	var gradient_lose = control_gradient_tint.construct_gradient_two_color(streak_gradient_color__transparent, streak_gradient_color__lose)
	var gradient_win = control_gradient_tint.construct_gradient_two_color(streak_gradient_color__transparent, streak_gradient_color__win)
	
	_gradient_texture_2d__lose.gradient = gradient_lose
	_gradient_texture_2d__win.gradient = gradient_win


# setters

func set_stage_round_manager(arg_manager : StageRoundManager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)
	stage_round_manager.connect("round_ended__for_streak_panel_glow_purposes", self, "_on_round_ended__for_streak_panel_glow_purposes", [], CONNECT_PERSIST)
	
	_update_display()


#

func _on_round_ended(curr_stageround):
	_update_display()

func _update_display():
	var win_streak = stage_round_manager.current_win_streak
	var lose_streak = stage_round_manager.current_lose_streak
	
	if win_streak >= 1:
		streak_label.text = str(win_streak)
		streak_icon.texture = WinIcon
	elif lose_streak >= 1:
		streak_label.text = str(lose_streak)
		streak_icon.texture = LoseIcon
	else:
		streak_label.text = "0"
		streak_icon.texture = NoneIcon

############

func _on_round_ended__for_streak_panel_glow_purposes(arg_is_win, arg_steak_amount, arg_is_max_reached, arg_is_streak_broken, arg_streak_broken_magnitude, arg_is_streak_broken_magnitude_max):
	if arg_is_win:
		glow_background.texture = StreakIndicatorBackground_Glow_Win
		
	else:
		glow_background.texture = StreakIndicatorBackground_Glow_Lose
		
	
	
	var tweener : SceneTreeTween = create_tween()
	var fade_in_duration : float
	var fade_out_duration : float
	
	if arg_is_max_reached:
		fade_in_duration = glow_duration__long__in
		fade_out_duration = glow_duration__long__out
		
		if _gradient_texture_mod_tweener == null:
			_start_gradient_tint_show(arg_is_win)
		
	elif arg_is_streak_broken:
		fade_in_duration = glow_duration__long__in
		fade_out_duration = glow_duration__long__out
		
		_play_streak_broken_particles(arg_is_win)
		_end_gradient_tint_show()
		
	else:
		fade_in_duration = glow_duration__short__in
		fade_out_duration = glow_duration__short__out
		
		
	
	
	tweener.tween_property(glow_background, "modulate:a", glow_background_mod_a_max_val, fade_in_duration)
	tweener.tween_property(glow_background, "modulate:a", 0.0, fade_out_duration)
	



##

func _initialize_all_particle_pool_components():
	streak_broken_particle_pool_component = AttackSpritePoolComponent.new()
	streak_broken_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	streak_broken_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	streak_broken_particle_pool_component.source_for_funcs_for_attk_sprite = self
	streak_broken_particle_pool_component.func_name_for_creating_attack_sprite = "_create_streak_break_fragment_particle"

func _create_streak_break_fragment_particle():
	var particle = CenterBasedAttackParticle_Scene.instance()
	
	particle.texture_to_use = StreakIndicator_BrokenParticle_White9x9
	
	particle.speed_accel_towards_center = 240
	particle.initial_speed_towards_center = non_essential_rng.randf_range(-80, -130)
	
	particle.max_speed_towards_center = -5
	
	particle.lifetime_to_start_transparency = 0.45
	particle.transparency_per_sec = 1 / 0.45
	
	particle.min_starting_angle = 0
	particle.max_starting_angle = 359
	
	particle.min_starting_distance_from_center = 10
	particle.max_starting_distance_from_center = 20
	
	particle.z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
	particle.z_as_relative = false
	
	return particle


func _play_streak_broken_particles(arg_is_win):
	var center_pos = rect_global_position + (rect_size / 2)
	
	for i in 8:
		var particle = streak_broken_particle_pool_component.get_or_create_attack_sprite_from_pool()
		
		particle.center_pos_of_basis = center_pos
		particle.lifetime = 0.9
		
		particle.reset_for_another_use()
		particle.is_enabled_mov_toward_center = true
		particle.rotation = particle.global_position.angle_to_point(center_pos)
		
		if arg_is_win:
			particle.modulate = streak_particle_broken_modulate__win
			
		else:
			particle.modulate = streak_particle_broken_modulate__lose
			
		
		particle.modulate.a = 0.8
		particle.visible = true
		
		



func _start_gradient_tint_show(arg_is_win : bool):
	if arg_is_win:
		control_gradient_tint.texture = _gradient_texture_2d__win
	else:
		control_gradient_tint.texture = _gradient_texture_2d__lose
	
	var tweener = create_tween()
	
	tweener.tween_property(control_gradient_tint, "modulate:a", streak_gradient_max_modulate_a__start, streak_gradient_starting_transition_duration)
	tweener.tween_property(control_gradient_tint, "modulate:a", streak_gradient_max_modulate_a__start, streak_gradient_wait_after_starting_transition_duration)
	tweener.connect("finished", self, "_on_control_gradient_tint_starting_anim_finished", [], CONNECT_ONESHOT)


func _on_control_gradient_tint_starting_anim_finished():
	_start_gradient_tint_loop_anim()

func _start_gradient_tint_loop_anim():
	var tweener = create_tween()
	
	tweener.set_loops()
	tweener.tween_property(control_gradient_tint, "modulate:a", streak_gradient_min_modulate_a__for_looping, streak_gradient_transition_duration_for_looping)
	tweener.tween_property(control_gradient_tint, "modulate:a", streak_gradient_max_modulate_a__for_looping, streak_gradient_transition_duration_for_looping)
	tweener.tween_property(control_gradient_tint, "modulate:a", streak_gradient_max_modulate_a__for_looping, streak_gradient_middle_wait_duration_for_looping)
	
	_gradient_texture_mod_tweener = tweener


func _end_gradient_tint_show():
	if _gradient_texture_mod_tweener != null:
		_gradient_texture_mod_tweener.stop()
		_gradient_texture_mod_tweener = null
	
	#
	
	var tweener = create_tween()
	tweener.tween_property(control_gradient_tint, "modulate:a", 0.0, streak_gradient_fade_duration_on_end)
	

