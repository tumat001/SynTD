extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")

#const SimpleObeliskBullet_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Ana_BlueVioletGreen.png")
const SimplexBeam01_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_01.png")
const SimplexBeam02_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_02.png")
const SimplexBeam03_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_03.png")
const SimplexBeam04_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_04.png")
const SimplexBeam05_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_05.png")
const SimplexBeam06_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_06.png")

#

const Simplex_Bar_Foreground_01 = preload("res://TowerRelated/Color_Gray/Simplex/BarAssets/Simplex_Bar_Foreground_01.png")
const Simplex_Bar_Foreground_02 = preload("res://TowerRelated/Color_Gray/Simplex/BarAssets/Simplex_Bar_Foreground_02.png")

const Simplex_Bar_Cooling_01 = preload("res://TowerRelated/Color_Gray/Simplex/BarAssets/Simplex_Bar_Foreground_Cooling01.png")
const Simplex_Bar_Full_01 = preload("res://TowerRelated/Color_Gray/Simplex/BarAssets/Simplex_Bar_Foreground_Full01.png")

##

signal current_fire_time_changed(arg_val)


#####

const fire_base_time_before_cooldown : float = 12.0
const fire_base_cooldown_time : float = 5.0
const fire_time_decay_multiplier_per_delta : float = 2.0

const delta_per_recharge_tick : float = 0.5

const fire_cd_bar_aesth_delta_per_update_tick : float = 0.2

#

var _current_fire_time : float


var _fire_cd_timer : TimerForTower
var _recharge_cd_timer : TimerForTower
var _fire_cd_timer__for_bar_aesth : TimerForTower

var _is_during_cd : bool
var _is_recharging : bool


var original_main_attk_module : WithBeamInstantDamageAttackModule

#

onready var simplex_fire_bar = $TowerBase/KnockUpLayer/SimplexFireBar


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SIMPLEX)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 26
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 26
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", SimplexBeam01_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam02_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam03_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam04_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam05_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam06_pic)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	
	original_main_attk_module = attack_module
	
	add_attack_module(attack_module)
	
	##
	
	_initialize_fire_bar()
	_construct_timers()
	
	connect("on_main_attack", self, "_on_main_attack_s", [], CONNECT_PERSIST)
	
	connect("on_tower_transfered_in_map_from_bench", self, "_on_placed_in_map_s", [], CONNECT_PERSIST)
	connect("on_tower_transfered_on_bench_from_in_map", self, "_on_placed_in_bench_s", [], CONNECT_PERSIST)
	
	##
	
	set_current_fire_time(0)
	set_is_during_cd(false)
	set_is_recharging(false)
	
	##
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	if is_current_placable_in_map():
		simplex_fire_bar.modulate.a = 1
		#_on_placed_in_map_s(self, current_placable, null)
	else:
		simplex_fire_bar.modulate.a = 0
		#_on_placed_in_bench_s(self, current_placable, null)


##

func _construct_timers():
	_fire_cd_timer = TimerForTower.new()
	
	_fire_cd_timer.one_shot = true
	_fire_cd_timer.connect("timeout", self, "_on_fire_cd_timer_timeout", [], CONNECT_PERSIST)
	_fire_cd_timer.stop_on_round_end_instead_of_pause = false
	_fire_cd_timer.stop_on_disabled_from_attacking = false
	_fire_cd_timer.set_tower_and_properties(self)
	add_child(_fire_cd_timer)
	
	#####
	
	_recharge_cd_timer = TimerForTower.new()
	_recharge_cd_timer.one_shot = false
	_recharge_cd_timer.connect("timeout", self, "_on_recharge_cd_timer_timeout", [], CONNECT_PERSIST)
	_recharge_cd_timer.stop_on_round_end_instead_of_pause = false
	_recharge_cd_timer.stop_on_disabled_from_attacking = false
	_recharge_cd_timer.set_tower_and_properties(self)
	add_child(_recharge_cd_timer)
	
	#####
	
	_fire_cd_timer__for_bar_aesth = TimerForTower.new()
	_fire_cd_timer__for_bar_aesth.one_shot = false
	_fire_cd_timer__for_bar_aesth.connect("timeout", self, "_on_fire_cd_timer__for_bar_aesth_timeout", [], CONNECT_PERSIST)
	_fire_cd_timer__for_bar_aesth.stop_on_round_end_instead_of_pause = false
	_fire_cd_timer__for_bar_aesth.stop_on_disabled_from_attacking = false
	_fire_cd_timer__for_bar_aesth.set_tower_and_properties(self)
	add_child(_fire_cd_timer__for_bar_aesth)
	
	

func _on_fire_cd_timer_timeout():
	_fully_recharge_from_cooldown()

func _on_fire_cd_timer__for_bar_aesth_timeout():
	set_current_fire_time(_current_fire_time - ((fire_base_time_before_cooldown / fire_base_cooldown_time) * fire_cd_bar_aesth_delta_per_update_tick))

#####

func _on_main_attack_s(attk_speed_delay, enemies, module):
	set_current_fire_time(_current_fire_time + attk_speed_delay)
	
	_update_texture_of_fire_bar(true)
	
	if _current_fire_time >= fire_base_time_before_cooldown:
		_reached_max_fire_time()
	else:
		_start_recharge_timer_wait()
	

func _reached_max_fire_time():
	#_current_fire_time = fire_base_time_before_cooldown
	disabled_from_attacking_clauses.attempt_insert_clause(DisabledFromAttackingSourceClauses.SIMPLEX_RECHARGE)
	
	_fire_cd_timer.start(fire_base_cooldown_time)
	_fire_cd_timer__for_bar_aesth.start(fire_cd_bar_aesth_delta_per_update_tick)
	_stop_recharge_timer_wait()
	
	set_is_during_cd(true)
	
	
	original_main_attk_module.call_deferred("hide_all_beams")

func _fully_recharge_from_cooldown():
	#_current_fire_time = 0
	set_current_fire_time(0)
	disabled_from_attacking_clauses.remove_clause(DisabledFromAttackingSourceClauses.SIMPLEX_RECHARGE)
	
	#_fire_cd_timer.stop()  no need for stop since it is one shot
	_fire_cd_timer__for_bar_aesth.stop()
	
	set_is_during_cd(false)


func _start_recharge_timer_wait():
	_recharge_cd_timer.start(delta_per_recharge_tick)

func _on_recharge_cd_timer_timeout():
	#_current_fire_time -= delta_per_recharge_tick * fire_time_decay_multiplier_per_delta
	set_current_fire_time(_current_fire_time - (delta_per_recharge_tick * fire_time_decay_multiplier_per_delta))
	
	set_is_recharging(true)
	
	if _current_fire_time <= 0:
		#_current_fire_time = 0
		_stop_recharge_timer_wait()
	
	_update_texture_of_fire_bar()

func _stop_recharge_timer_wait():
	_recharge_cd_timer.stop()
	set_is_recharging(false)


#####

func set_current_fire_time(arg_val : float):
	if arg_val > fire_base_time_before_cooldown:
		arg_val = fire_base_time_before_cooldown
	if arg_val < 0:
		arg_val = 0
	_current_fire_time = arg_val
	
	#
	
	_update_value_of_fire_bar()
	
	emit_signal("current_fire_time_changed", _current_fire_time)



func _initialize_fire_bar():
	simplex_fire_bar.max_value = fire_base_time_before_cooldown

func _update_value_of_fire_bar():
	simplex_fire_bar.current_value = fire_base_time_before_cooldown - _current_fire_time


##

func set_is_during_cd(arg_val):
	_is_during_cd = arg_val
	
	_update_texture_of_fire_bar()

func set_is_recharging(arg_val):
	_is_recharging = arg_val
	
	_update_texture_of_fire_bar()

func _update_texture_of_fire_bar(arg_is_firing : bool = false):
	if arg_is_firing:
		_update_simplex_fire_texture_bar__to_normal()
		return
	
	if _is_during_cd:
		simplex_fire_bar.fill_foreground_pic = Simplex_Bar_Full_01
	else:
		if _is_recharging:
			simplex_fire_bar.fill_foreground_pic = Simplex_Bar_Cooling_01
			
		else:
			_update_simplex_fire_texture_bar__to_normal()

func _update_simplex_fire_texture_bar__to_normal():
	if _current_fire_time > (fire_base_time_before_cooldown * 0.75) and simplex_fire_bar.fill_foreground_pic != Simplex_Bar_Foreground_01:
		simplex_fire_bar.fill_foreground_pic = Simplex_Bar_Foreground_01
	elif simplex_fire_bar.fill_foreground_pic != Simplex_Bar_Foreground_02:
		simplex_fire_bar.fill_foreground_pic = Simplex_Bar_Foreground_02


##########

func _on_placed_in_bench_s(tower_self, arg_bench_placable, arg_map_placable):
	var tweener = create_tween()
	tweener.tween_property(simplex_fire_bar, "modulate:a", 0.0, 0.35)
	

func _on_placed_in_map_s(tower_self, arg_map_placable, arg_bench_placable):
	var tweener = create_tween()
	tweener.tween_property(simplex_fire_bar, "modulate:a", 1.0, 0.35)
	





