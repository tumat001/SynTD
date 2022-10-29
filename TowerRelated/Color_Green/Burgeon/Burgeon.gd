extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")
const BurgeonArcingSeed = preload("res://TowerRelated/Color_Green/Burgeon/ArcingSeed/BurgeonArcingSeed.gd")
const BurgeonArcingSeed_Scene = preload("res://TowerRelated/Color_Green/Burgeon/ArcingSeed/BurgeonArcingSeed.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")

const Burgeon_AirAttackProj = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Proj.png")

const Burgeon_AirAttack_Explosion01 = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Explosion/Burgeon_Explosion_01.png")
const Burgeon_AirAttack_Explosion02 = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Explosion/Burgeon_Explosion_02.png")
const Burgeon_AirAttack_Explosion03 = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Explosion/Burgeon_Explosion_03.png")
const Burgeon_AirAttack_Explosion04 = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Explosion/Burgeon_Explosion_04.png")
const Burgeon_AirAttack_Explosion05 = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Explosion/Burgeon_Explosion_05.png")
const Burgeon_AirAttack_Explosion06 = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Explosion/Burgeon_Explosion_06.png")
const Burgeon_AirAttack_Explosion07 = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Explosion/Burgeon_Explosion_07.png")
const Burgeon_AirAttack_Explosion08 = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Explosion/Burgeon_Explosion_08.png")

const Burgeon_Seed_Pic = preload("res://TowerRelated/Color_Green/Burgeon/Assets/Burgeon_Seed.png")
const MiniBurgeon_Sprite = preload("res://TowerRelated/Color_Green/Burgeon/Assets/MiniBurgeon/MiniBurgeon_Omni.png")
const BurgeonExplosion_AttackModule_Icon = preload("res://TowerRelated/Color_Green/Burgeon/Assets/AMAssets/BurgeonExplosion_AttackModule_Icon.png")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")


const heal_reduc_amount : float = -40.0
const heal_reduc_duration : float = 8.0

const air_attack_arm_time : float = 1.25
const sensor_modulate : Color = Color(1, 1, 1, 0)
const aoe_modulate : Color = Color(1, 1, 1, 0.7)

const air_attack_base_dmg : float = 5.0
const air_attack_damage_scale : float = 0.75

var air_proj_attack_module : ArcingBulletAttackModule
var explosion_attack_module : AOEAttackModule
var sensor_attack_module : AOEAttackModule

#

var tower_detecting_range_module : TowerDetectingRangeModule

var proliferate_ability : BaseAbility
var _is_proliferate_ability_ready : bool
const proliferate_base_cooldown : float = 20.0
const proliferate_mini_burgeon_base_duration : float = 30.0

var proliferate_seed_attack_module : ArcingBulletAttackModule
var mini_burgeon_offset_from_tower : Vector2 = Vector2(5, 8)
var mini_burgeon_time_map : Dictionary

var tower_info

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BURGEON)
	tower_info = info
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var attk_module_y_shift : float = 24
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attk_module_y_shift
	
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = info.base_damage
	proj_attack_module.base_damage_type = info.base_damage_type
	proj_attack_module.base_attack_speed = info.base_attk_speed
	proj_attack_module.base_attack_wind_up = 8
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = true
	proj_attack_module.base_pierce = info.base_pierce
	proj_attack_module.base_proj_speed = 2 # 2 sec to reach the location
	#attack_module.base_proj_life_distance = info.base_range
	proj_attack_module.module_id = StoreOfAttackModuleID.MAIN
	proj_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	proj_attack_module.benefits_from_bonus_base_damage = true
	proj_attack_module.benefits_from_bonus_on_hit_damage = true
	proj_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proj_attack_module.position.y -= attk_module_y_shift
	#var bullet_shape = CircleShape2D.new()
	#bullet_shape.radius = 3
	
	#proj_attack_module.bullet_shape = bullet_shape
	proj_attack_module.bullet_scene = BurgeonArcingSeed_Scene
	proj_attack_module.set_texture_as_sprite_frame(Burgeon_AirAttackProj)
	
	proj_attack_module.max_height = 150
	proj_attack_module.bullet_rotation_per_second = 180
	
	proj_attack_module.is_displayed_in_tracker = false
	
	add_attack_module(proj_attack_module)
	
	air_proj_attack_module = proj_attack_module
	
	
	# PROJ EXPLOSION AOE
	
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = air_attack_damage_scale
	explosion_attack_module.on_hit_damage_scale = air_attack_damage_scale
	explosion_attack_module.base_damage = air_attack_base_dmg / explosion_attack_module.base_damage_scale
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Burgeon_AirAttack_Explosion01)
	sprite_frames.add_frame("default", Burgeon_AirAttack_Explosion02)
	sprite_frames.add_frame("default", Burgeon_AirAttack_Explosion03)
	sprite_frames.add_frame("default", Burgeon_AirAttack_Explosion04)
	sprite_frames.add_frame("default", Burgeon_AirAttack_Explosion05)
	sprite_frames.add_frame("default", Burgeon_AirAttack_Explosion06)
	sprite_frames.add_frame("default", Burgeon_AirAttack_Explosion07)
	sprite_frames.add_frame("default", Burgeon_AirAttack_Explosion08)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 4
	explosion_attack_module.duration = 0.35
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(BurgeonExplosion_AttackModule_Icon)
	
	add_attack_module(explosion_attack_module)
	
	
	# Sensor AOE
	
	sensor_attack_module = AOEAttackModule_Scene.instance()
	sensor_attack_module.base_damage = 0
	sensor_attack_module.base_damage_type = DamageType.ELEMENTAL
	sensor_attack_module.base_attack_speed = 0
	sensor_attack_module.base_attack_wind_up = 0
	sensor_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	sensor_attack_module.is_main_attack = false
	sensor_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	sensor_attack_module.benefits_from_bonus_explosion_scale = false
	sensor_attack_module.benefits_from_bonus_base_damage = false
	sensor_attack_module.benefits_from_bonus_attack_speed = false
	sensor_attack_module.benefits_from_bonus_on_hit_damage = false
	sensor_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var sensor_sprite_frames = SpriteFrames.new()
	sensor_sprite_frames.add_frame("default", Burgeon_AirAttack_Explosion01)
	
	sensor_attack_module.aoe_sprite_frames = sensor_sprite_frames
	sensor_attack_module.sprite_frames_only_play_once = false
	sensor_attack_module.pierce = -1
	sensor_attack_module.duration = 1
	sensor_attack_module.damage_repeat_count = 1
	sensor_attack_module.is_decrease_duration = false
	
	sensor_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	sensor_attack_module.base_aoe_scene = BaseAOE_Scene
	sensor_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	sensor_attack_module.absolute_z_index_of_aoe = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	sensor_attack_module.can_be_commanded_by_tower = false
	
	sensor_attack_module.is_displayed_in_tracker = false
	#sensor_attack_module.set_image_as_tracker_image(VolcanoCrater_AttackModule_Icon)
	
	add_attack_module(sensor_attack_module)
	
	
	# Mini burgeon seed proliferate
	
	proliferate_seed_attack_module = ArcingBulletAttackModule_Scene.instance()
	proliferate_seed_attack_module.base_damage = 0
	proliferate_seed_attack_module.base_damage_type = 0
	proliferate_seed_attack_module.base_attack_speed = 0
	proliferate_seed_attack_module.base_attack_wind_up = 0
	proliferate_seed_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proliferate_seed_attack_module.is_main_attack = false
	proliferate_seed_attack_module.base_pierce = info.base_pierce
	proliferate_seed_attack_module.base_proj_speed = 2 # 2 sec to reach the location
	#attack_module.base_proj_life_distance = info.base_range
	proliferate_seed_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	proliferate_seed_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	proliferate_seed_attack_module.benefits_from_bonus_base_damage = false
	proliferate_seed_attack_module.benefits_from_bonus_on_hit_damage = false
	proliferate_seed_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proliferate_seed_attack_module.position.y -= attk_module_y_shift
	#var bullet_shape = CircleShape2D.new()
	#bullet_shape.radius = 3
	
	#proliferate_seed_attack_module.bullet_shape = bullet_shape
	proliferate_seed_attack_module.bullet_scene = BurgeonArcingSeed_Scene
	proliferate_seed_attack_module.set_texture_as_sprite_frame(Burgeon_Seed_Pic)
	
	proliferate_seed_attack_module.max_height = 150
	proliferate_seed_attack_module.bullet_rotation_per_second = 180
	
	proliferate_seed_attack_module.is_displayed_in_tracker = false
	
	proliferate_seed_attack_module.can_be_commanded_by_tower = false
	proliferate_seed_attack_module.kill_bullets_at_end_of_round = false
	
	add_attack_module(proliferate_seed_attack_module)
	
	
	#
	
	_construct_proliferate_ability()
	
	air_proj_attack_module.connect("before_bullet_is_shot", self, "_air_proj_created", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	_construct_tower_detecting_module()
	_construct_and_add_heal_reduc_effect()



func _air_proj_created(air_proj : BurgeonArcingSeed):
	air_proj.connect("on_final_location_reached", self, "_air_proj_landed", [], CONNECT_ONESHOT)
	air_proj.destroy_self_after_zero_life_distance = false


func _air_proj_landed(curr_position, air_proj : BurgeonArcingSeed):
	air_proj.connect("on_arm_time_timeout", self, "_air_proj_arm_time_timeout", [], CONNECT_ONESHOT)
	air_proj.arm_self_for_time(air_attack_arm_time)
	
	air_proj.rotation_per_second = 0


func _air_proj_arm_time_timeout(air_proj : BurgeonArcingSeed):
	air_proj.connect("on_sensor_tripped", self, "_air_proj_sensor_tripped", [], CONNECT_ONESHOT)
	
	var sensor_aoe = sensor_attack_module.construct_aoe(air_proj.global_position, air_proj.global_position)
	sensor_aoe.modulate = sensor_modulate
	
	air_proj.associate_sensor_trigger_with_aoe(sensor_aoe)


func _air_proj_sensor_tripped(air_proj : BurgeonArcingSeed):
	var explosion = explosion_attack_module.construct_aoe(air_proj.global_position, air_proj.global_position)
	explosion.scale *= 1.5
	explosion.modulate = aoe_modulate
	explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)
	
	air_proj.queue_free()

#

func _construct_tower_detecting_module():
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	
	#tower_detecting_range_module.detection_range = tower_info.base_range
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.mirror_tower_range_module_range_changes(self)
	add_child(tower_detecting_range_module)

#

func _construct_proliferate_ability():
	proliferate_ability = BaseAbility.new()
	
	proliferate_ability.is_timebound = true
	
	proliferate_ability.set_properties_to_usual_tower_based()
	proliferate_ability.tower = self
	
	proliferate_ability.connect("updated_is_ready_for_activation", self, "_can_cast_proliferate_changed", [], CONNECT_PERSIST)
	register_ability_to_manager(proliferate_ability, false)


func _can_cast_proliferate_changed(can_cast):
	_is_proliferate_ability_ready = can_cast
	_attempt_cast_proliferate()


func _attempt_cast_proliferate():
	if _is_proliferate_ability_ready:
		_cast_proliferate()

func _cast_proliferate():
	var candidate_tower = _find_candidate_tower()
	
	if is_instance_valid(candidate_tower):
		var cd = _get_cd_to_use(proliferate_base_cooldown)
		proliferate_ability.on_ability_before_cast_start(cd)
		
		_fire_proliferate_seed_at_tower(candidate_tower)
		proliferate_ability.start_time_cooldown(cd)
		proliferate_ability.on_ability_after_cast_ended(cd)
		
	else:
		proliferate_ability.start_time_cooldown(3) #refresh


func _find_candidate_tower():
	var towers = tower_detecting_range_module.get_all_in_map_and_active_towers_in_range()
	
	var attacking_towers : Array = []
	var non_attacking_towers : Array = []
	for tower in towers:
		if is_instance_valid(tower.range_module):
			if tower.range_module.enemies_in_range.size() > 0:
				attacking_towers.append(tower)
			else:
				non_attacking_towers.append(tower)
	
	var towers_to_use : Array
	if attacking_towers.size() > 0:
		towers_to_use = attacking_towers
	else:
		towers_to_use = non_attacking_towers
	
	
	var rand_towers = Targeting.enemies_to_target(towers_to_use, Targeting.RANDOM, 1, global_position, false)
	if rand_towers.size() > 0:
		return rand_towers[0]
	else:
		return null


func _fire_proliferate_seed_at_tower(tower):
	var seed_proj = proliferate_seed_attack_module.construct_bullet(tower.global_position + mini_burgeon_offset_from_tower)
	seed_proj.connect("on_final_location_reached", self, "_proliferate_seed_landed", [tower], CONNECT_ONESHOT)
	
	proliferate_seed_attack_module.set_up_bullet__add_child_and_emit_signals(seed_proj)


#

func _proliferate_seed_landed(seed_pos, seed_proj, tower):
	if is_instance_valid(tower):
		var mini_burgeon = _construct_mini_burgeon_attack_module(seed_pos, tower)
		
		mini_burgeon_time_map[mini_burgeon] = proliferate_mini_burgeon_base_duration * last_calculated_final_ability_potency


func _construct_mini_burgeon_attack_module(seed_position : Vector2, landed_tower) -> ArcingBulletAttackModule:
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = tower_info.base_damage
	proj_attack_module.base_damage_type = tower_info.base_damage_type
	proj_attack_module.base_attack_speed = tower_info.base_attk_speed
	proj_attack_module.base_attack_wind_up = 8
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = false
	proj_attack_module.base_pierce = tower_info.base_pierce
	proj_attack_module.base_proj_speed = 2 # 2 sec to reach the location
	#attack_module.base_proj_life_distance = info.base_range
	proj_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	proj_attack_module.on_hit_damage_scale = 0
	
	proj_attack_module.benefits_from_bonus_base_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_effect = false
	
	#var bullet_shape = CircleShape2D.new()
	#bullet_shape.radius = 3
	
	#proj_attack_module.bullet_shape = bullet_shape
	proj_attack_module.bullet_scene = BurgeonArcingSeed_Scene
	proj_attack_module.set_texture_as_sprite_frame(Burgeon_AirAttackProj)
	
	proj_attack_module.max_height = 150
	proj_attack_module.bullet_rotation_per_second = 180
	
	proj_attack_module.is_displayed_in_tracker = false
	
	
	#
	
	var sprite = Sprite.new()
	sprite.texture = MiniBurgeon_Sprite
	sprite.z_index = ZIndexStore.PARTICLE_EFFECTS
	sprite.z_as_relative = false
	proj_attack_module.add_child(sprite)
	
	#
	
	proj_attack_module.connect("tree_exiting", self, "_mini_burgeon_tree_exiting", [proj_attack_module], CONNECT_PERSIST)
	proj_attack_module.connect("before_bullet_is_shot", self, "_air_proj_created", [], CONNECT_PERSIST)
	
	landed_tower.add_child(proj_attack_module)
	add_attack_module(proj_attack_module)
	
	proj_attack_module.global_position = seed_position
	
	if is_instance_valid(landed_tower.range_module):
		proj_attack_module._set_range_module(landed_tower.range_module)
		
	
	return proj_attack_module


#

func _process(delta):
	if is_round_started:
		for mini_burgeon in mini_burgeon_time_map:
			mini_burgeon_time_map[mini_burgeon] -= delta
			
			var time = mini_burgeon_time_map[mini_burgeon]
			if time <= 0:
				mini_burgeon.queue_free()

func _mini_burgeon_tree_exiting(mini_burgeon):
	remove_attack_module(mini_burgeon)
	mini_burgeon_time_map.erase(mini_burgeon)

#

func _construct_and_add_heal_reduc_effect():
	var modi = PercentModifier.new(StoreOfEnemyEffectsUUID.BURGEON_HEAL_REDUC_EFFECT)
	modi.percent_amount = heal_reduc_amount
	modi.percent_based_on = PercentType.BASE
	
	var heal_reduc_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_HEALTH_MODIFIER, modi, StoreOfEnemyEffectsUUID.BURGEON_HEAL_REDUC_EFFECT)
	heal_reduc_effect.is_timebound = true
	heal_reduc_effect.time_in_seconds = heal_reduc_duration
	heal_reduc_effect.is_from_enemy = false
	heal_reduc_effect.status_bar_icon = preload("res://EnemyRelated/CommonStatusBarIcons/HealReduc_StatusBarIcon.png")
	
	var tower_effect = TowerOnHitEffectAdderEffect.new(heal_reduc_effect, StoreOfTowerEffectsUUID.BURGEON_HEAL_REDUC_EFFECT)
	
	add_tower_effect(tower_effect)

