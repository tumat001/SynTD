extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const VarianceVessel_NormalProj_Pic = preload("res://TowerRelated/Color_Violet/Variance_Vessel/Attks/VarianceVessel_NormalProj.png")
const VarianceVessel_SuperProj_Pic = preload("res://TowerRelated/Color_Violet/Variance_Vessel/Attks/VarianceVessel_SuperProj.png")

const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")

#

const bullet_pierce : int = 1

const attacks_for_super_bullet_salvo : int = 10
const super_bullet_count_per_salvo : int = 3
const super_bullet_min_life_distance : float = 1500.0
const delay_per_bullet_in_salvo : float = 0.15
const bullet_salvo_y_extent_hitbox : float = 6.0
var _current_attacks_left_to_trigger_salvo : int = attacks_for_super_bullet_salvo
var _current_salvo_count_left : int
var _current_pos_of_fire_for_salvo : Vector2
var _current_distance_to_pos_of_fire : float
var _has_pos_to_fire_for_salvo : bool

const cannot_be_commanded_by_tower_clause__as_vessel : int = -10
const y_shift_of_attk_module : float = 6.0

var variance_creator setget set_variance_creator

var normal_bullet_attack_module : BulletAttackModule
var super_bullet_attack_module : BulletAttackModule

var timer_for_salvo : TimerForTower

const base_round_lifetime_count : int = 1
var _current_round_lifetime_count : int = base_round_lifetime_count


#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.VARIANCE_VESSEL)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = 0
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = 0
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = bullet_pierce
	attack_module.base_proj_speed = 560
	#attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.position.y -= y_shift_of_attk_module
	
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(9, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(VarianceVessel_NormalProj_Pic)
	
	attack_module.set_image_as_tracker_image(VarianceVessel_NormalProj_Pic)
	
	attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(cannot_be_commanded_by_tower_clause__as_vessel)
	
	normal_bullet_attack_module = attack_module
	add_attack_module(attack_module)
	
	#
	
	_construct_super_proj_attk_module()
	
	timer_for_salvo = TimerForTower.new()
	timer_for_salvo.one_shot = false
	timer_for_salvo.connect("timeout", self, "_on_salvo_timer_timeout", [], CONNECT_PERSIST)
	timer_for_salvo.set_tower_and_properties(self)
	add_child(timer_for_salvo)
	
	connect("on_round_end", self, "_on_round_end_v", [], CONNECT_PERSIST)
	#connect("on_round_start", self, "_on_round_start_v", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("before_round_starts", self, "_before_on_round_start_v", [], CONNECT_PERSIST)
	
	#contributing_to_synergy_clauses.attempt_insert_clause(ContributingToSynergyClauses.GENERIC_DOES_NOT_CONTRIBUTE)
	set_contribute_to_synergy_color_count(false)
	tower_limit_slots_taken = 0
	is_a_summoned_tower = true
	
	#
	
	can_absorb_ingredient_conditonal_clauses.attempt_insert_clause(CanAbsorbIngredientClauses.CAN_NOT_ABSORB_INGREDIENT_GENERIC_TAG)
	
	_post_inherit_ready()


func _construct_super_proj_attk_module():
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = 0
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = bullet_pierce
	attack_module.base_proj_speed = 750
	attack_module.base_proj_life_distance = super_bullet_min_life_distance
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.position.y -= y_shift_of_attk_module
	
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(10, bullet_salvo_y_extent_hitbox)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(VarianceVessel_SuperProj_Pic)
	
	attack_module.set_image_as_tracker_image(VarianceVessel_SuperProj_Pic)
	
	attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(cannot_be_commanded_by_tower_clause__as_vessel)
	
	super_bullet_attack_module = attack_module
	
	add_attack_module(attack_module)


##

func set_variance_creator(arg_creator):
	variance_creator = arg_creator
	
	variance_creator.connect("tree_exiting", self, "_on_creator_queue_free", [], CONNECT_ONESHOT)
	variance_creator.connect("on_main_attack", self, "_on_variance_creator_main_attack")
	
	tower_type_info.tower_descriptions = variance_creator.get_tower_descriptions_to_use_for_vessel()
	

func _on_creator_queue_free():
	queue_free()

#

func _on_variance_creator_main_attack(attk_speed_delay, enemies, module):
	if enemies.size() > 0 and !last_calculated_disabled_from_attacking:
		var enemy = enemies[0]
		
		_attack_with_normal_proj_towards_enemy(enemy)
		
		_current_attacks_left_to_trigger_salvo -= 1
		if _current_attacks_left_to_trigger_salvo <= 0:
			_attack_as_salvo_with_super_proj(enemy.global_position)
			_current_attacks_left_to_trigger_salvo = attacks_for_super_bullet_salvo

func _attack_with_normal_proj_towards_enemy(arg_enemy):
	var bullet = normal_bullet_attack_module.construct_bullet(arg_enemy.global_position)
	_configure_bullet_dmg_instance(bullet, arg_enemy.global_position)
	
	normal_bullet_attack_module.set_up_bullet__add_child_and_emit_signals(bullet)

func _configure_bullet_dmg_instance(arg_bullet : BaseBullet, arg_target_pos):
	arg_bullet.life_distance = global_position.distance_to(arg_target_pos) * 1.5
	
	var variance_yellow_dmg_inst = variance_creator.yellow_inst_dmg_attk_module.construct_damage_instance()
	arg_bullet.damage_instance = variance_yellow_dmg_inst
	
	var pierce_to_use : int = bullet_pierce
	if is_instance_valid(variance_creator.main_attack_module) and variance_creator.main_attack_module is BulletAttackModule:
		pierce_to_use = variance_creator.main_attack_module.last_calculated_final_pierce
	arg_bullet.pierce = pierce_to_use




func _attack_as_salvo_with_super_proj(arg_pos):
	var distance = super_bullet_attack_module.global_position.distance_to(arg_pos)
	if super_bullet_min_life_distance > distance:
		distance = super_bullet_min_life_distance
	_current_distance_to_pos_of_fire = distance
	
	_current_salvo_count_left = super_bullet_count_per_salvo
	_update_vector_to_fire_salvo(distance)
	if _has_pos_to_fire_for_salvo:
		_fire_super_bullet_as_part_of_salvo()
		timer_for_salvo.start(delay_per_bullet_in_salvo)

func _update_vector_to_fire_salvo(arg_distance_to_enemy):
	var line_param := Targeting.LineTargetParameters.new()
	line_param.target_positions = game_elements.enemy_manager.get_all_targetable_enemy_positions()
	line_param.line_width = bullet_salvo_y_extent_hitbox #* 2
	line_param.line_width_reduction_forgiveness = 25 #bullet_salvo_y_extent_hitbox / 3
	line_param.line_range = arg_distance_to_enemy
	line_param.source_position = super_bullet_attack_module.global_position
	
	var angle_and_count = Targeting.get_deg_angle_and_enemy_hit_count__that_hits_most_enemies(line_param)
	_has_pos_to_fire_for_salvo = angle_and_count.size() > 0
	
	if _has_pos_to_fire_for_salvo:
		_current_pos_of_fire_for_salvo = Targeting.convert_deg_angle_to_pos_to_target(angle_and_count, _current_distance_to_pos_of_fire, super_bullet_attack_module.global_position)  #_convert_deg_angle_to_pos_to_target(angle_and_count, super_bullet_life_distance)


func _fire_super_bullet_as_part_of_salvo():
	_current_salvo_count_left -= 1
	
	var bullet = super_bullet_attack_module.construct_bullet(_current_pos_of_fire_for_salvo)
	_configure_bullet_dmg_instance(bullet, _current_pos_of_fire_for_salvo)
	bullet.life_distance = _current_distance_to_pos_of_fire #super_bullet_life_distance
	bullet.decrease_pierce = false 
	
	super_bullet_attack_module.set_up_bullet__add_child_and_emit_signals(bullet)


func _on_salvo_timer_timeout():
	if _current_salvo_count_left > 0:
		_fire_super_bullet_as_part_of_salvo()
		
	else:
		timer_for_salvo.stop()


###

func _on_round_end_v():
	_current_attacks_left_to_trigger_salvo = attacks_for_super_bullet_salvo
	_current_salvo_count_left = 0
	_has_pos_to_fire_for_salvo = false
	_current_distance_to_pos_of_fire = 0
	


func _before_on_round_start_v(curr_stageround):
	if is_instance_valid(variance_creator): # needed since it will prevent this from passing when called by tower manager.. Jank solution but whatever
		_current_round_lifetime_count -= 1
		if _current_round_lifetime_count <= 0:
			queue_free()
	
