extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const EnemyKnockUpEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyKnockUpEffect.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

const Regards_Explosion_AS_Scene = preload("res://TowerRelated/Color_Violet/Prominence/Assets/RegardsAssets/Regards_ExplosionRing.tscn")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")

const ShowTowersWithParticleComponent = preload("res://MiscRelated/CommonComponents/ShowTowersWithParticleComponent.gd")

const Prominence_SwordBeam_Pic01 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_01.png")
const Prominence_SwordBeam_Pic02 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_02.png")
const Prominence_SwordBeam_Pic03 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_03.png")
const Prominence_SwordBeam_Pic04 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_04.png")
const Prominence_SwordBeam_Pic05 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_05.png")
const Prominence_SwordBeam_Pic06 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_06.png")
const Prominence_SwordBeam_Pic07 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_07.png")
const Prominence_SwordBeam_Pic08 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeam_08.png")

const Prominence_SwordBeam_Explosion_Pic01 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion01.png")
const Prominence_SwordBeam_Explosion_Pic02 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion02.png")
const Prominence_SwordBeam_Explosion_Pic03 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion03.png")
const Prominence_SwordBeam_Explosion_Pic04 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion04.png")
const Prominence_SwordBeam_Explosion_Pic05 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion05.png")
const Prominence_SwordBeam_Explosion_Pic06 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion06.png")
const Prominence_SwordBeam_Explosion_Pic07 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion07.png")
const Prominence_SwordBeam_Explosion_Pic08 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion08.png")
const Prominence_SwordBeam_Explosion_Pic09 = preload("res://TowerRelated/Color_Violet/Prominence/Assets/SwordAssets/SwordBeamExplosion/SwordBeam_Explosion09.png")

const Prominence_Globule_Bullet_Pic = preload("res://TowerRelated/Color_Violet/Prominence/Assets/GlobuleAssets/Globule_Proj.png")
const Prominence_Globule_Pic = preload("res://TowerRelated/Color_Violet/Prominence/Assets/GlobuleAssets/GlobulePic_Normal.png")

const Prominence_Sword_Normal_Pic = preload("res://TowerRelated/Color_Violet/Prominence/Prominence_Sword_Normal.png")
const Prominence_Sword_Empowered_Pic = preload("res://TowerRelated/Color_Violet/Prominence/Prominence_Sword_Empowered.png")

const Prominence_Regards_Ability_Icon = preload("res://TowerRelated/Color_Violet/Prominence/Assets/RegardsAssets/Regards_AbilityIcon.png")

const GlobuleTopLeft_AttackModule_Icon = preload("res://TowerRelated/Color_Violet/Prominence/Assets/AMAssets/GlobuleTopLeft_AttackModule_Icon.png")
const GlobuleTopRight_AttackModule_Icon = preload("res://TowerRelated/Color_Violet/Prominence/Assets/AMAssets/GlobuleTopRight_AttackModule_Icon.png")
const GlobuleBottomLeft_AttackModule_Icon = preload("res://TowerRelated/Color_Violet/Prominence/Assets/AMAssets/GlobuleBottomLeft_AttackModule_Icon.png")
const GlobuleBottomRight_AttackModule_Icon = preload("res://TowerRelated/Color_Violet/Prominence/Assets/AMAssets/GlobuleBottomRight_AttackModule_Icon.png")
const RegardsShockwave_AttackModule_Icon = preload("res://TowerRelated/Color_Violet/Prominence/Assets/AMAssets/RegardsShockWave_AttackModule_Icon.png")
const RegardsExplosionAttack_AttackModule_Icon = preload("res://TowerRelated/Color_Violet/Prominence/Assets/AMAssets/RegardsExplosionAttack_AttackModule_Icon.png")


const globule_distance_from_center : float = 40.0
const sword_epicenter_y_shift : float = 13.0

# after regards ability

const after_regards_sword_attack_command_clause : int = 100

const base_after_regards_empowered_attks : int = 3
var _current_regards_empowered_attks : int = 0

# regards ability

const regards_ability_cooldown : float = 60.0
const regards_ability_energy_module_cooldown : float = 20.0
const regards_stun_duration : float = 3.0
const regards_height_y_accel : float = 60.0
const regards_damage_amount : float = 12.0

const regards_globule_attacking_count_requirement : int = 2
const regards_globule_attacking_count_clause : int = 10

var regards_ability_attk_module : InstantDamageAttackModule
var prominence_attk_module : WithBeamInstantDamageAttackModule
var sword_explosion_attk_module : AOEAttackModule

var regards_ability : BaseAbility
var regards_activation_conditional_clauses : ConditionalClauses
var regards_knock_up_effect : EnemyKnockUpEffect

var sword_y_speed : float = 0
var sword_y_max_height : float = -120.0


var range_module_has_enemy_in_range_map : Dictionary = {}

var regards_candidate_tower_indicator_shower : ShowTowersWithParticleComponent

var _tower_info : TowerTypeInformation

#

var is_energy_module_on : bool = false

#

onready var prominence_sword_sprite = $TowerBase/KnockUpLayer/ProminenceSword


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.PROMINENCE)
	_tower_info = info
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	
	# Globules
	var top_left_globule = _construct_globule_attk_module(info)
	top_left_globule.position.x -= globule_distance_from_center
	top_left_globule.position.y -= globule_distance_from_center
	top_left_globule.set_image_as_tracker_image(GlobuleTopLeft_AttackModule_Icon)
	add_attack_module(top_left_globule)
	
	var top_right_globule = _construct_globule_attk_module(info)
	top_right_globule.position.x += globule_distance_from_center
	top_right_globule.position.y -= globule_distance_from_center
	top_right_globule.set_image_as_tracker_image(GlobuleTopRight_AttackModule_Icon)
	add_attack_module(top_right_globule)
	
	var bottom_left_globule = _construct_globule_attk_module(info)
	bottom_left_globule.position.x -= globule_distance_from_center
	bottom_left_globule.position.y += globule_distance_from_center
	bottom_left_globule.set_image_as_tracker_image(GlobuleBottomLeft_AttackModule_Icon)
	add_attack_module(bottom_left_globule)
	
	var bottom_right_globule = _construct_globule_attk_module(info)
	bottom_right_globule.position.x += globule_distance_from_center
	bottom_right_globule.position.y += globule_distance_from_center
	bottom_right_globule.set_image_as_tracker_image(GlobuleBottomRight_AttackModule_Icon)
	add_attack_module(bottom_right_globule)
	
	#
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += sword_epicenter_y_shift
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1.0 / 0.15
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= sword_epicenter_y_shift
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic01)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic02)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic03)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic04)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic05)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic06)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic07)
	beam_sprite_frame.add_frame("default", Prominence_SwordBeam_Pic08)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 8 / 0.15)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.15
	attack_module.show_beam_at_windup = true
	attack_module.show_beam_regardless_of_state = true
	
	attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(after_regards_sword_attack_command_clause)
	
	attack_module.connect("on_enemy_hit", self, "_sword_beam_attk_module_hit_enemy", [], CONNECT_PERSIST)
	
	prominence_attk_module = attack_module
	prominence_attk_module.is_displayed_in_tracker = true
	
	add_attack_module(attack_module)
	
	#
	
	regards_ability_attk_module = InstantDamageAttackModule_Scene.instance()
	regards_ability_attk_module.base_damage = regards_damage_amount
	regards_ability_attk_module.base_damage_type = DamageType.PHYSICAL
	regards_ability_attk_module.base_attack_speed = 0
	regards_ability_attk_module.base_attack_wind_up = 0
	regards_ability_attk_module.is_main_attack = false
	regards_ability_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	regards_ability_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	regards_ability_attk_module.on_hit_damage_scale = info.on_hit_multiplier
	
	regards_ability_attk_module.benefits_from_bonus_base_damage = false
	regards_ability_attk_module.benefits_from_bonus_attack_speed = false
	regards_ability_attk_module.benefits_from_bonus_on_hit_effect = false
	regards_ability_attk_module.benefits_from_bonus_on_hit_damage = false
	
	regards_ability_attk_module.can_be_commanded_by_tower = false
	
	regards_ability_attk_module.set_image_as_tracker_image(RegardsShockwave_AttackModule_Icon)
	
	add_attack_module(regards_ability_attk_module)
	
	#
	
	sword_explosion_attk_module = AOEAttackModule_Scene.instance()
	sword_explosion_attk_module.base_damage_scale = 3
	sword_explosion_attk_module.base_damage = 5 / sword_explosion_attk_module.base_damage_scale
	sword_explosion_attk_module.base_damage_type = DamageType.PHYSICAL
	sword_explosion_attk_module.base_attack_speed = 0
	sword_explosion_attk_module.base_attack_wind_up = 0
	sword_explosion_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	sword_explosion_attk_module.is_main_attack = false
	sword_explosion_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	sword_explosion_attk_module.benefits_from_bonus_explosion_scale = true
	sword_explosion_attk_module.benefits_from_bonus_base_damage = true
	sword_explosion_attk_module.benefits_from_bonus_attack_speed = false
	sword_explosion_attk_module.benefits_from_bonus_on_hit_damage = false
	sword_explosion_attk_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic01)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic02)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic03)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic04)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic05)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic06)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic07)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic08)
	sprite_frames.add_frame("default", Prominence_SwordBeam_Explosion_Pic09)
	
	sword_explosion_attk_module.aoe_sprite_frames = sprite_frames
	sword_explosion_attk_module.sprite_frames_only_play_once = true
	sword_explosion_attk_module.pierce = -1
	sword_explosion_attk_module.duration = 0.3
	sword_explosion_attk_module.damage_repeat_count = 1
	
	sword_explosion_attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	sword_explosion_attk_module.base_aoe_scene = BaseAOE_Scene
	sword_explosion_attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	sword_explosion_attk_module.can_be_commanded_by_tower = false
	
	sword_explosion_attk_module.set_image_as_tracker_image(RegardsExplosionAttack_AttackModule_Icon)
	
	add_attack_module(sword_explosion_attk_module)
	
	#
	
	top_left_globule.range_module.mirror_range_module_targeting_changes(range_module)
	top_right_globule.range_module.mirror_range_module_targeting_changes(range_module)
	bottom_left_globule.range_module.mirror_range_module_targeting_changes(range_module)
	bottom_right_globule.range_module.mirror_range_module_targeting_changes(range_module)
	
	#
	
	_construct_ability()
	_construct_tower_indicator_shower()
	
	connect("final_ability_potency_changed", self, "_on_ap_changed_p", [], CONNECT_PERSIST)
	#connect("global_position_changed", self, "_on_global_pos_changed_p", [], CONNECT_PERSIST)
	#connect("tower_dropped_from_dragged", self, "_on_dropped_from_drag", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	_construct_and_add_knock_up_effect()
	
	_on_ap_changed_p()


func _construct_globule_attk_module(info) -> BulletAttackModule:
	var globule_range_module = RangeModule_Scene.instance()
	globule_range_module.base_range_radius = info.base_range
	globule_range_module.set_range_shape(CircleShape2D.new())
	
	globule_range_module.can_display_range = false
	globule_range_module.can_display_circle_arc = true
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 260 #200
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.range_module = globule_range_module
	attack_module.use_self_range_module = true
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(9, 6)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Prominence_Globule_Bullet_Pic)
	
	#
	
	#attack_module.position.y -= sword_epicenter_y_shift
	
	var globule_sprite : Sprite = Sprite.new()
	globule_sprite.texture = Prominence_Globule_Pic
	
	attack_module.add_child(globule_sprite)
	
	#
	
	_monitor_globule_if_attacking_enemies(attack_module)
	
	#
	
	return attack_module


func _construct_ability():
	regards_ability = BaseAbility.new()
	
	regards_ability.is_timebound = true
	regards_ability.connect("ability_activated", self, "_regards_ability_activated", [], CONNECT_PERSIST)
	regards_ability.icon = Prominence_Regards_Ability_Icon
	
	regards_ability.set_properties_to_usual_tower_based()
	regards_ability.tower = self
	
	regards_ability.set_properties_to_auto_castable()
	regards_ability.auto_cast_func = "_regards_ability_activated"
	
	
	regards_ability.descriptions = _tower_info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION]
	regards_ability.simple_descriptions = _tower_info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION]
	
	regards_ability.display_name = "Regards"
	
	regards_activation_conditional_clauses = regards_ability.activation_conditional_clauses
	regards_activation_conditional_clauses.attempt_insert_clause(regards_globule_attacking_count_clause)
	
	register_ability_to_manager(regards_ability)


func _construct_and_add_knock_up_effect():
	regards_knock_up_effect = EnemyKnockUpEffect.new(1, regards_height_y_accel, StoreOfEnemyEffectsUUID.PROMINENCE_KNOCK_UP_EFFECT)
	regards_knock_up_effect.custom_stun_duration = regards_stun_duration
	
	var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(regards_knock_up_effect, StoreOfTowerEffectsUUID.PROMINENCE_KNOCK_UP_EFFECT)
	tower_effect.force_apply = true
	
	add_tower_effect(tower_effect, [regards_ability_attk_module], false)


func _construct_tower_indicator_shower():
	regards_candidate_tower_indicator_shower = ShowTowersWithParticleComponent.new()
	regards_candidate_tower_indicator_shower.set_tower_particle_indicator_to_usual_properties()
	regards_candidate_tower_indicator_shower.set_source_and_provider_func_name(self, "_get_candidate_towers")



#

func add_after_regards_empowered_attack_count(amount : int):
	_current_regards_empowered_attks += amount
	
	if _current_regards_empowered_attks > 0:
		prominence_attk_module.can_be_commanded_by_tower_other_clauses.remove_clause(after_regards_sword_attack_command_clause)
	else:
		prominence_attk_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(after_regards_sword_attack_command_clause)
		prominence_sword_sprite.texture = Prominence_Sword_Normal_Pic


func _sword_beam_attk_module_hit_enemy(enemy, damage_register_id, damage_instance, module):
	var explosion = sword_explosion_attk_module.construct_aoe(enemy.global_position, enemy.global_position)
	explosion.scale *= 2.5
	explosion.modulate.a = 0.7
	
	sword_explosion_attk_module.set_up_aoe__add_child_and_emit_signals(explosion)
	
	add_after_regards_empowered_attack_count(-1)

#


func _regards_ability_activated():
	var cd_to_use : float
	if !is_energy_module_on:
		cd_to_use = _get_cd_to_use(regards_ability_cooldown)
	else:
		cd_to_use = _get_cd_to_use(regards_ability_energy_module_cooldown)
	
	regards_ability.on_ability_before_cast_start(cd_to_use)
	regards_ability.start_time_cooldown(cd_to_use)
	
	_sword_gain_height()
	regards_ability.on_ability_after_cast_ended(cd_to_use)


func _sword_gain_height():
	sword_y_speed = sword_y_max_height * 1.25

func _sword_lose_height():
	sword_y_speed = -sword_y_max_height * 6
	prominence_sword_sprite.texture = Prominence_Sword_Empowered_Pic


func _physics_process(delta):
	prominence_sword_sprite.offset.y += sword_y_speed * delta
	
	# gaining - on max height
	if sword_y_speed < 0 and prominence_sword_sprite.offset.y <= sword_y_max_height:
		_sword_lose_height()
		
		
	# losing - on ground
	elif sword_y_speed > 0 and prominence_sword_sprite.offset.y >= 0:
		_sword_landed_to_ground()
		
		sword_y_speed = 0
		prominence_sword_sprite.offset.y = 0


func _sword_landed_to_ground():
	if is_instance_valid(range_module):
		_execute_knock_up()
	
	add_after_regards_empowered_attack_count(base_after_regards_empowered_attks)

#

func _execute_knock_up():
	var enemies : Array = range_module.enemies_in_range.duplicate(true)
	var candidate_towers_and_enemies = _get_candidate_towers_and_enemies_in_range()
	var candidate_towers : Array = []
	if candidate_towers_and_enemies.size() > 0:
		for enemy in candidate_towers_and_enemies[1]:
			if !enemies.has(enemy):
				enemies.append(enemy)
		
		candidate_towers = candidate_towers_and_enemies[0]
	
	regards_ability_attk_module._attack_enemies(enemies)
	
	_construct_and_show_regards_expanding_attk_sprite(global_position, range_module)
	
	for tower in candidate_towers:
		_construct_and_show_regards_expanding_attk_sprite(tower.global_position, tower.range_module)


func _get_candidate_towers_and_enemies_in_range() -> Array:
	var towers = _get_candidate_towers()
	
	var enemies : Array = []
	
	for tower in towers:
		for enemy in tower.range_module.enemies_in_range:
			if !enemies.has(enemy):
				enemies.append(enemy)
	
	return [towers, enemies]
	
	return []

func _get_candidate_towers():
	var towers = tower_manager.get_all_active_towers()
	var sorted_towers = Targeting.enemies_to_target(towers, Targeting.FAR, towers.size(), global_position, true)
	var bucket : Array = []
	
	for tower in sorted_towers:
		if is_instance_valid(tower.range_module) and tower != self:
			bucket.append(tower)
			
			if bucket.size() > 0 and !is_energy_module_on:
				break
	
	return bucket


func _construct_and_show_regards_expanding_attk_sprite(arg_global_pos, arg_range_module):
	if is_instance_valid(arg_range_module):
		var particle = Regards_Explosion_AS_Scene.instance()
		
		CommonAttackSpriteTemplater.configure_scale_and_expansion_of_expanding_attk_sprite(particle, 10, arg_range_module.last_calculated_final_range)
		
		particle.position = arg_global_pos
		particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
		CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)


#

func _monitor_globule_if_attacking_enemies(module):
	range_module_has_enemy_in_range_map[module.range_module] = false
	
	module.range_module.connect("enemy_entered_range", self, "_on_globule_enemy_entered_range", [module.range_module], CONNECT_PERSIST)
	module.range_module.connect("enemy_left_range", self, "_on_globule_enemy_exited_range", [module.range_module], CONNECT_PERSIST)


func _on_globule_enemy_entered_range(enemy, globule_range_module):
	_update_module_has_enemy_in_range_map(globule_range_module, true)

func _on_globule_enemy_exited_range(enemy, globule_range_module):
	var has_enemies : bool = globule_range_module.enemies_in_range.size() != 0
	_update_module_has_enemy_in_range_map(globule_range_module, has_enemies)


func _update_module_has_enemy_in_range_map(globule_range_module, has_enemy : bool):
	range_module_has_enemy_in_range_map[globule_range_module] = has_enemy
	
	var modules_with_enemies : int = 0
	for has_enemies in range_module_has_enemy_in_range_map.values():
		if has_enemies:
			modules_with_enemies += 1
	
	# if requirements met
	if modules_with_enemies >= regards_globule_attacking_count_requirement:
		regards_activation_conditional_clauses.remove_clause(regards_globule_attacking_count_clause)
	else:
		regards_activation_conditional_clauses.attempt_insert_clause(regards_globule_attacking_count_clause)

#

func _on_ap_changed_p():
	var ap_scale = regards_ability.get_potency_to_use(last_calculated_final_ability_potency)
	
	regards_knock_up_effect.custom_stun_duration = regards_stun_duration * ap_scale
	regards_knock_up_effect.knock_up_y_acceleration = regards_height_y_accel * ap_scale


# energy module related


func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"All towers cast Regards using Prominence's ability potency.",
			"Cooldown is reduced to 20 s."
		]


func _module_turned_on(_first_time_per_round : bool):
	is_energy_module_on = true

func _module_turned_off():
	is_energy_module_on = false
