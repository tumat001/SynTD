extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const LaChasseurBullet_Pic = preload("res://TowerRelated/Color_Green/La_Chasseur/Assets/Attks/LaChasseur_Bullet.png")
const LaChasseur_NormalShot_Pic = preload("res://TowerRelated/Color_Green/La_Chasseur/Assets/Attks/LaChasseur_ShotNonFinal.png")
const LaChasseur_FinalShot_Pic = preload("res://TowerRelated/Color_Green/La_Chasseur/Assets/Attks/LaChasseur_ShotFinal.png")
const LaChasseur_ShotAttackModule_Icon = preload("res://TowerRelated/Color_Green/La_Chasseur/Assets/GUI/ShotAttackModule_Icon.png")

const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")


#

signal on_hit_bonus_changed()

const bonus_on_hit_damage_per_kill : float = 3.0
const on_hit_damage_type : int = DamageType.PHYSICAL
const shot_base_damage_ratio : float = 10.0
const shot_on_hit_dmg_ratio : float = 5.0

const gold_gained_per_kill : int = 3

const shots_per_ability : int = 4

# order matters. ascending
const breakpoint_of_cast_to_is_casted_map : Dictionary = {
	0.5 : false,
	1.0 : false
}

var hunt_down_ability : BaseAbility
var hunt_down_breakpoint_not_reached_clause : int = -10
var hunt_down_no_enemies_in_range_clause : int = -11

var current_cast_count : int = 0
var current_shots_to_take_count : int = 0

var shot_attack_module : InstantDamageAttackModule

var on_hit_damage_effect : TowerOnHitDamageAdderEffect

#

var _attk_module_disabled_by_hunt_down_ability : AbstractAttackModule
var _is_in_hunt_down : bool = false

#

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.LA_CHASSEUR)
	
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
	range_module.position.y += 20
	range_module.position.x -= 17
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 660#550
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 20
	attack_module.position.x += 17
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(8, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(LaChasseurBullet_Pic)
	
	add_attack_module(attack_module)
	
	#
	
	shot_attack_module = InstantDamageAttackModule_Scene.instance()
	shot_attack_module.base_damage_scale = shot_base_damage_ratio
	shot_attack_module.base_damage = info.base_damage
	shot_attack_module.base_damage_type = DamageType.PHYSICAL
	shot_attack_module.base_attack_speed = 4
	shot_attack_module.base_attack_wind_up = 0
	shot_attack_module.is_main_attack = false
	shot_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	shot_attack_module.position.y -= 20
	shot_attack_module.position.x += 17
	shot_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	shot_attack_module.on_hit_damage_scale = shot_on_hit_dmg_ratio
	
	shot_attack_module.connect("on_post_mitigation_damage_dealt", self, "_check_if_shot_killed_enemy", [], CONNECT_PERSIST)
	shot_attack_module.connect("on_enemy_hit", self, "_on_enemy_hit_by_shot", [], CONNECT_PERSIST)
	
	shot_attack_module.set_image_as_tracker_image(LaChasseur_ShotAttackModule_Icon)
	
	shot_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.LA_CHASSEUR_DISABLE)
	
	add_attack_module(shot_attack_module)
	
	#
	
	_construct_and_connect_ability()
	_construct_effects()
	
	#
	
	game_elements.enemy_manager.connect("enemy_spawned", self, "_on_enemy_spawned_by_manager_l", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_l", [], CONNECT_PERSIST)
	shot_attack_module.connect("on_damage_instance_constructed", self, "_on_damage_instance_constructed_by_shot_attk_module", [], CONNECT_PERSIST)
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	add_tower_effect(on_hit_damage_effect)


func _construct_effects():
	var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.LA_CHASSEUR_ON_HIT_DMG_EFFECT)
	attr_mod.flat_modifier = 0
	var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.LA_CHASSEUR_ON_HIT_DMG_EFFECT, attr_mod, on_hit_damage_type)
	
	on_hit_damage_effect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.LA_CHASSEUR_ON_HIT_DMG_EFFECT)
	
	

func _construct_and_connect_ability():
	hunt_down_ability = BaseAbility.new()
	
	hunt_down_ability.is_timebound = true
	
	hunt_down_ability.set_properties_to_usual_tower_based()
	hunt_down_ability.tower = self
	
	hunt_down_ability.activation_conditional_clauses.attempt_insert_clause(hunt_down_breakpoint_not_reached_clause)
	
	hunt_down_ability.connect("updated_is_ready_for_activation", self, "_can_cast_hunt_down_updated", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	register_ability_to_manager(hunt_down_ability, false)

#

func _on_enemy_spawned_by_manager_l(arg_enemy):
	var number_of_spawned_ratio : float = float(game_elements.enemy_manager.current_enemy_spawned_from_ins_count) / float(game_elements.enemy_manager.enemy_count_in_round)
	#print("original_cast_count: " + str(current_cast_count))
	#print("ratio: " + str(number_of_spawned_ratio) + ", curr: " + str(game_elements.enemy_manager.current_enemy_spawned_from_ins_count) + ", total: " + str(game_elements.enemy_manager.enemy_count_in_round))
	
	for breakpoint_number in breakpoint_of_cast_to_is_casted_map.keys():
		if breakpoint_of_cast_to_is_casted_map[breakpoint_number] == false and breakpoint_number <= number_of_spawned_ratio:
			if is_current_placable_in_map():
				current_cast_count += 1
			breakpoint_of_cast_to_is_casted_map[breakpoint_number] = true
		#print(str(breakpoint_number) + " " + str(breakpoint_of_cast_to_is_casted_map[breakpoint_number]))
		#print("cast count: " + str(current_cast_count))
	
	if current_cast_count > 0:
		hunt_down_ability.activation_conditional_clauses.remove_clause(hunt_down_breakpoint_not_reached_clause)
	#print("----")

#

func _on_range_module_enemy_entered_n(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		hunt_down_ability.activation_conditional_clauses.remove_clause(hunt_down_no_enemies_in_range_clause)

func _on_range_module_enemy_exited_n(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		if range_module.enemies_in_range.size() > 0:
			hunt_down_ability.activation_conditional_clauses.remove_clause(hunt_down_no_enemies_in_range_clause)
		else:
			hunt_down_ability.activation_conditional_clauses.attempt_insert_clause(hunt_down_no_enemies_in_range_clause)


#

func _can_cast_hunt_down_updated(arg_is_ready : bool):
	if arg_is_ready and !_is_in_hunt_down:
		_cast_hunt_down(false)

func _cast_hunt_down(is_a_recast : bool):
	if (!is_a_recast):
		_is_in_hunt_down = true
	
	hunt_down_ability.activation_conditional_clauses.attempt_insert_clause(hunt_down_breakpoint_not_reached_clause)
	
	hunt_down_ability.on_ability_before_cast_start(hunt_down_ability.ON_ABILITY_CAST_NO_COOLDOWN)
	
	#
	
	if !is_instance_valid(_attk_module_disabled_by_hunt_down_ability):
		_attk_module_disabled_by_hunt_down_ability = main_attack_module
		if is_instance_valid(_attk_module_disabled_by_hunt_down_ability):
			_attk_module_disabled_by_hunt_down_ability.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.LA_CHASSEUR_DISABLE)
	
	#
	
	#print("casted hunt down: " + str(current_cast_count) + ", is a recast: " + str(is_a_recast))
	
	current_cast_count -= 1
	if current_cast_count < 0:
		current_cast_count = 0
	
	current_shots_to_take_count = 4
	
	if (!is_a_recast):
		shot_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.LA_CHASSEUR_DISABLE)
	
	hunt_down_ability.on_ability_after_cast_ended(hunt_down_ability.ON_ABILITY_CAST_NO_COOLDOWN)


#

func _on_round_end_l():
	current_cast_count = 0
	current_shots_to_take_count = 0
	
	_reset_breakpoint_checks()
	_end_hunt_down()


func _reset_breakpoint_checks():
	for breakpoint_number in breakpoint_of_cast_to_is_casted_map.keys():
		breakpoint_of_cast_to_is_casted_map[breakpoint_number] = false


#

func _check_if_shot_killed_enemy(damage_report, killed_enemy : bool, enemy, damage_register_id : int, module):
	if killed_enemy and current_shots_to_take_count == 1:
		_on_final_shot_killed_target()
	
	current_shots_to_take_count -= 1
	
	if current_shots_to_take_count == 0:
		#shot_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.LA_CHASSEUR_DISABLE)
		_on_final_shot_event()
	else:
		shot_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.LA_CHASSEUR_DISABLE)


func _on_final_shot_killed_target():
	game_elements.gold_manager.increase_gold_by(gold_gained_per_kill, GoldManager.IncreaseGoldSource.TOWER_GOLD_INCOME)
	game_elements.display_gold_particles(global_position, gold_gained_per_kill)
	
	on_hit_damage_effect.on_hit_damage.damage_as_modifier.flat_modifier += bonus_on_hit_damage_per_kill
	emit_signal("on_hit_bonus_changed")


func _on_final_shot_event():
	if current_cast_count > 0:
		_cast_hunt_down(true)
	else:
		_end_hunt_down()

func _end_hunt_down():
	if is_instance_valid(_attk_module_disabled_by_hunt_down_ability):
		_attk_module_disabled_by_hunt_down_ability.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.LA_CHASSEUR_DISABLE)
	_attk_module_disabled_by_hunt_down_ability = null
	
	shot_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.LA_CHASSEUR_DISABLE)
	
	_is_in_hunt_down = false

#

func _on_enemy_hit_by_shot(arg_enemy, damage_register_id, damage_instance, attk_module):
	var beam = BeamAesthetic_Scene.instance()
	beam.time_visible = 0.75
	beam.is_timebound = true
	beam.queue_free_if_time_over = true
	beam.modulate_a_subtract_per_sec = 1 / 0.75
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
	
	if current_shots_to_take_count == 1:
		beam.set_texture_as_default_anim(LaChasseur_FinalShot_Pic)
	else:
		beam.set_texture_as_default_anim(LaChasseur_NormalShot_Pic)
	
	
	beam.position = shot_attack_module.global_position
	beam.update_destination_position(arg_enemy.global_position)
	

func _on_damage_instance_constructed_by_shot_attk_module(arg_damage_instance, attk_module):
	#arg_damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE].damage_as_modifier.flat_modifier = main_attack_module.last_calculated_final_damage * shot_total_base_damage_ratio * hunt_down_ability.get_potency_to_use(last_calculated_final_ability_potency)
	arg_damage_instance.scale_only_damage_by(hunt_down_ability.get_potency_to_use(last_calculated_final_ability_potency))
	
#	arg_damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE].damage_as_modifier.flat_modifier = main_attack_module.last_calculated_final_damage
#	var scale_of_base_dmg = shot_total_base_damage_ratio * hunt_down_ability.get_potency_to_use(last_calculated_final_ability_potency)
#
#	arg_damage_instance.scale_only_base_damage_by(scale_of_base_dmg)

