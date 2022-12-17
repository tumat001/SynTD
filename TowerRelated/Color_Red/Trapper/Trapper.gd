extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const TrapperTrap_Scene = preload("res://TowerRelated/Color_Red/Trapper/Subs/TrapperTrap.tscn")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")

#

const initial_trap_placement_speed : float = 600.0

var trap_attack_module : BulletAttackModule
var trap_placmement_timer : TimerForTower
const trap_placement_delay_amount : float = 0.5
const trap_count : int = 3
var _current_trap_count : int = 0
const trap_vector2_offset := Vector2(0, 3)

const trap_base_dmg_scale_amount : float = 2.0
const trap_base_dmg_amount : float = 1.0

var trap_placement_rng : RandomNumberGenerator

#


#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.TRAPPER)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 12
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage_scale = trap_base_dmg_scale_amount
	attack_module.base_damage = trap_base_dmg_amount / trap_base_dmg_scale_amount
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = 1
	attack_module.base_proj_speed = initial_trap_placement_speed
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 12
	
	attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01)
	
	attack_module.bullet_scene = TrapperTrap_Scene
	trap_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	#
	
	trap_placmement_timer = TimerForTower.new()
	trap_placmement_timer.one_shot = false
	trap_placmement_timer.connect("timeout", self, "_on_trap_placmement_timer_timeout", [], CONNECT_PERSIST)
	trap_placmement_timer.set_tower_and_properties(self)
	trap_placmement_timer.stop_on_round_end_instead_of_pause = true
	add_child(trap_placmement_timer)
	
	trap_placement_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.TRAPPER_TRAP_POS)
	
	connect("on_round_start", self, "_on_round_start_t", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_t", [], CONNECT_PERSIST)
	
	game_elements.enemy_manager.connect("last_enemy_standing", self, "_on_last_enemy_standing", [], CONNECT_PERSIST)
	game_elements.enemy_manager.connect("last_enemy_standing_killed_by_damage_no_revives", self, "_on_last_enemy_standing_killed_by_damage_no_revives", [], CONNECT_PERSIST)
	
	#
	
	_post_inherit_ready()

#


func _on_round_start_t():
	if is_current_placable_in_map():
		_current_trap_count = 0
		
		trap_placmement_timer.start(trap_placement_delay_amount)
	else:
		_connect_and_wait_for_placable_transfer()

func _on_round_end_t():
	_end_attempts_at_trap_placement()
	_current_trap_count = 0
	
	if trap_attack_module.is_connected("on_enemy_hit", self, "_on_enemy_hit_by_trap__as_oneshot"):
		trap_attack_module.disconnect("on_enemy_hit", self, "_on_enemy_hit_by_trap__as_oneshot")



func _on_trap_placmement_timer_timeout():
	_attempt_place_trap_at_track()

func _attempt_place_trap_at_track():
	if _current_trap_count < trap_count:
		var pos = _generate_pos_for_trap_firing()
		
		if pos != null:
			_fire_trap_at_pos(pos)
			_current_trap_count += 1
		else:
			_connect_and_wait_for_placable_transfer()
		
	else:
		_end_attempts_at_trap_placement()

func _end_attempts_at_trap_placement():
	trap_placmement_timer.stop()
	_disconnect_wait_for_placable_transfer()

##

func _generate_pos_for_trap_firing():
	var curr_range = get_last_calculated_range_of_main_attk_module()
	var angle = deg2rad(trap_placement_rng.randi_range(0, 359))
	var dist = trap_placement_rng.randi_range(0, curr_range)
	
	var candidate_pos = global_position + Vector2(dist, 0).rotated(angle)
	var map = game_elements.map_manager.base_map
	var path = map.get_random_enemy_path__with_params()
	
	candidate_pos = path.curve.get_closest_point(candidate_pos)
	
	if is_instance_valid(path) and global_position.distance_to(candidate_pos) <= curr_range:
		return candidate_pos + trap_vector2_offset
	else:
		return null

func _fire_trap_at_pos(arg_pos):
	var trap = trap_attack_module.construct_bullet(arg_pos)
	trap.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	trap.rotation_degrees = 0
	trap.decrease_pierce = false
	trap.beyond_first_hit_multiplier = 1 # no decrease
	trap.decrease_life_distance = false
	trap.decrease_life_duration = false
	
	trap.connect("tree_entered", self, "_on_trap_tree_entered", [trap, arg_pos], CONNECT_ONESHOT)
	
	trap_attack_module.set_up_bullet__add_child_and_emit_signals(trap)

func _on_trap_tree_entered(trap, arg_pos):
	if is_instance_valid(trap):
		trap.send_to_position(arg_pos, initial_trap_placement_speed)

#

func _connect_and_wait_for_placable_transfer():
	if !is_connected("on_tower_transfered_to_placable", self, "_on_tower_transfered_to_new_placable"):
		connect("on_tower_transfered_to_placable", self, "_on_tower_transfered_to_new_placable")

func _on_tower_transfered_to_new_placable(tower_self, arg_placable):
	if is_current_placable_in_map():
		trap_placmement_timer.start(trap_placement_delay_amount)

func _disconnect_wait_for_placable_transfer():
	if is_connected("on_tower_transfered_to_placable", self, "_on_tower_transfered_to_new_placable"):
		disconnect("on_tower_transfered_to_placable", self, "_on_tower_transfered_to_new_placable")
	

#

func _on_last_enemy_standing(enemy):
	if !trap_attack_module.is_connected("on_enemy_hit", self, "_on_enemy_hit_by_trap__as_oneshot"):
		trap_attack_module.connect("on_enemy_hit", self, "_on_enemy_hit_by_trap__as_oneshot", [], CONNECT_DEFERRED)

func _on_last_enemy_standing_killed_by_damage_no_revives(damage_instance_report, enemy):
	if trap_attack_module.is_connected("on_enemy_hit", self, "_on_enemy_hit_by_trap__as_oneshot"):
		trap_attack_module.disconnect("on_enemy_hit", self, "_on_enemy_hit_by_trap__as_oneshot")

func _on_enemy_hit_by_trap__as_oneshot(enemy, damage_register_id, damage_instance, module):
	if !enemy.is_enemy_type_boss():
		enemy.execute_self_by(0, trap_attack_module)


#

func set_heat_module(module):
	module.heat_per_attack = 12
	.set_heat_module(module)

func _construct_heat_effect():
	var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_dmg_attr_mod.flat_modifier = 1.5
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module.benefits_from_bonus_base_damage:
			module.calculate_final_base_damage()
	
	emit_signal("final_base_damage_changed")

