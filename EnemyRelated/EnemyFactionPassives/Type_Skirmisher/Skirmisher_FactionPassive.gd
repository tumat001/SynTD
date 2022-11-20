extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"

const MapManager = preload("res://GameElementsRelated/MapManager.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")
const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")
const EnemyEffectShieldEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyEffectShieldEffect.gd")

const AbstractSkirmisherEnemy = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const SkirmBlue_Smoke_Particle_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkrimBlue_Smoke_Particle.tscn")
const SkirmBlue_Rallier_Particle_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkirmBlue_Rallier_Particle.tscn")
const SkirmBlue_Ascender_Particle_Scene = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Ascender/Ascender_TransformParticle/Ascender_TransformParticle.tscn")
const SkirmRed_ArtilleryExplosion_Particle_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkirmRed_Artillery_AestheticExplosion.tscn")

const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")
const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")
const ArcingBaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.tscn")

const TowerStunEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerStunEffect.gd")

const Blaster_Bullet_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Blaster/Assets/Blaster_Bullet.png")
const Artillery_Bullet_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Artillery/Assets/Artillery_ArcBullet.png")
const Danseur_Bullet_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Danseur/Assets/Danseur_BulletProj.png")


enum PathType {
	BLUE_PATH = 0,
	RED_PATH = 1
}

var _initialized_at_least_once : bool = false

var game_elements : GameElements
var map_manager : MapManager
var enemy_manager : EnemyManager

var skirmisher_gen_purpose_rng : RandomNumberGenerator

var paths_for_blues : Array = []
var paths_for_reds : Array = []


var smoke_particle_pool_component : AttackSpritePoolComponent
var rallier_speed_particle_pool_component : AttackSpritePoolComponent
var ascender_ascend_particle_pool_component : AttackSpritePoolComponent

var artillery_explosion_particle_pool_component : AttackSpritePoolComponent

#
var blaster_bullet_attk_module : BulletAttackModule
var trail_component_for_blaster_bullet : MultipleTrailsForNodeComponent

var artillery_arc_bullet_attk_module : ArcingBulletAttackModule
var trail_component_for_artillery_bullet : MultipleTrailsForNodeComponent

var danseur_bullet_attk_module : BulletAttackModule


const blaster_range : float = 120.0
const blaster_damage_per_bullet : float = 0.5

const artillery_damage_per_shot : float = 3.5
const artillery_stun_duration_on_shot_hit : float = 2.0

const danseur_proj_and_detection_range : float = 130.0
const danseur_damage_per_proj : float = 0.3

#

const starting_side_point_distance_from_placable : float = 30.0
const distance_max_from_starting_placable_pos_to_offset : float = 70.0
const distance_max_from_placable_center_to_ending_offset : float = 110.0
const distance_min_of_ending_offset_to_entry_offset = 40.0

const min_entry_unit_offset : float = 0.05
const max_exit_unit_offset : float = 0.95

var enemy_path_to_through_placable_datas : Dictionary
#var through_placable_data : Array

var through_placable_datas_thread : Thread

const closest_offset_adv_param_metadata_name__entry_offset_pos = "entry_offset_pos"

###############

func _apply_faction_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
		map_manager = game_elements.map_manager
		enemy_manager = game_elements.enemy_manager
	
	_set_blue_and_red_paths()
	
	if !enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		enemy_manager.connect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path", [], CONNECT_PERSIST)
	
	if !_initialized_at_least_once:
		_initialized_at_least_once = true
		
		skirmisher_gen_purpose_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SKIRMISHER_GEN_PURPOSE)
		
		_initialize_smoke_particle_pool_component()
		_initialize_rallier_speed_particle_pool_component()
		_initialize_ascender_ascend_particle_pool_component()
		
		_initialize_blaster_bullet_attk_module()
		_initialize_blaster_trail_for_node_component()
		
		_initialize_artillery_explosion_particle_pool_component()
		_initialize_artillery_arc_bullet_attk_module()
		_initialize_artillery_trail_for_node_component()
		
		_initialize_and_generate_through_placable_data__threaded()
		
		_initialize_danseur_bullet_attk_module()
	
	#_initialize_enemy_manager_spawn_pattern()
	#if !enemy_manager.is_connected("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed"):
	#	enemy_manager.connect("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed", [], CONNECT_PERSIST)
	
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	._apply_faction_to_game_elements(arg_game_elements)


func _remove_faction_from_game_elements(arg_game_elements : GameElements):
	if enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		enemy_manager.disconnect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path")
	
	_reverse_actions_on_path_generation()
	
	#
	
	if enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		enemy_manager.disconnect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path")
	
	if enemy_manager.is_connected("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed"):
		enemy_manager.disconnect("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed")
	
	._remove_faction_from_game_elements(arg_game_elements)


#

func _set_blue_and_red_paths():
	var all_paths = map_manager.base_map.get_all_enemy_paths()
	
	for path in all_paths:
		if !path.marker_id_to_value_map.has(EnemyPath.MarkerIds.SKIRMISHER_CLONE_OF_BASE_PATH) and !path.marker_id_to_value_map.has(EnemyPath.MarkerIds.SKIRMISHER_BASE_PATH_ALREADY_CLONED):
			paths_for_blues.append(path)
	
	for blue_path in paths_for_blues:
		var red_path = blue_path.get_copy_of_path(true)
		red_path.marker_id_to_value_map[EnemyPath.MarkerIds.SKIRMISHER_CLONE_OF_BASE_PATH] = blue_path #Storing pair path
		
		paths_for_reds.append(red_path)
		
		blue_path.marker_id_to_value_map[EnemyPath.MarkerIds.SKIRMISHER_BASE_PATH_ALREADY_CLONED] = red_path #storing pair path
		
		map_manager.base_map.add_enemy_path(red_path)
		
		# for danseur/finisher
		enemy_path_to_through_placable_datas[red_path] = []

func _reverse_actions_on_path_generation():
	var all_paths = map_manager.base_map.all_enemy_paths.duplicate(false)
	
	for path in paths_for_blues:
		path.marker_id_to_value_map.erase(EnemyPath.MarkerIds.SKIRMISHER_BASE_PATH_ALREADY_CLONED)
	
	var paths_to_remove : Array = []
	for path in paths_for_reds:
		map_manager.base_map.remove_enemy_path(path)
		paths_to_remove.append(path)
	
	for path in paths_to_remove:
		paths_for_reds.erase(path)
		path.queue_free()

#

func _before_enemy_is_added_to_path(enemy, path):
	if enemy is AbstractSkirmisherEnemy:
		enemy.skirmisher_faction_passive = self
	
	#
	
	var path_index = enemy_manager.get_spawn_path_to_take_index() % paths_for_blues.size()
	
	if enemy.enemy_spawn_metadata_from_ins != null and enemy.enemy_spawn_metadata_from_ins.has(StoreOfEnemyMetadataIdsFromIns.SKIRMISHER_SPAWN_AT_PATH_TYPE):
		var path_type = enemy.enemy_spawn_metadata_from_ins[StoreOfEnemyMetadataIdsFromIns.SKIRMISHER_SPAWN_AT_PATH_TYPE]
		
		if enemy.get("skirmisher_path_color_type"):
			enemy.skirmisher_path_color_type = path_type
		
		if path_type == PathType.RED_PATH:
			_add_enemy_to_red_path(enemy, path_index)
		else:
			_add_enemy_to_blue_path(enemy, path_index)
		
	else:
		_add_enemy_to_blue_path(enemy, path_index)
	

func _add_enemy_to_blue_path(enemy, path_index):
	var path = _get_path_to_use(path_index, paths_for_blues)
	
	path.add_child(enemy)

func _get_path_to_use(path_index, paths):
	var index = path_index
	
	return paths[index]


func _add_enemy_to_red_path(enemy, path_index):
	var path = _get_path_to_use(path_index, paths_for_reds)
	
	path.add_child(enemy)


# path spawn pattern related

#func _on_path_to_spawn_pattern_changed(arg_pattern):
#	_initialize_enemy_manager_spawn_pattern()
#
#func _initialize_enemy_manager_spawn_pattern():
#	if enemy_manager.current_path_to_spawn_pattern == EnemyManager.PathToSpawnPattern.SWITCH_PER_SPAWN or enemy_manager.current_path_to_spawn_pattern == EnemyManager.PathToSpawnPattern.SWITCH_PER_ROUND_END:
#		enemy_manager.custom_path_pattern_source_obj = self
#		enemy_manager.custom_path_pattern_assignment_method = "custom_path_pattern_assignment_method"
#	else:
#		enemy_manager.custom_path_pattern_source_obj = null
#		enemy_manager.custom_path_pattern_assignment_method = ""
#
#func custom_path_pattern_assignment_method(data : Array):
#	var index = enemy_manager.get_spawn_path_index_to_take() % paths_for_blues.size()
#	return enemy_manager.spawn_paths[index]


################# SMOKE RELATED

func _initialize_smoke_particle_pool_component():
	smoke_particle_pool_component = AttackSpritePoolComponent.new()
	smoke_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	smoke_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	smoke_particle_pool_component.source_for_funcs_for_attk_sprite = self
	smoke_particle_pool_component.func_name_for_creating_attack_sprite = "_create_smoke_particle"
	smoke_particle_pool_component.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_smoke_particle_properties_when_get_from_pool_after_add_child"

func _create_smoke_particle():
	var particle = SkirmBlue_Smoke_Particle_Scene.instance()
	
	particle.speed_accel_towards_center = 600
	particle.initial_speed_towards_center = -150
	particle.max_speed_towards_center = -20
	
	particle.min_starting_distance_from_center = 35
	particle.max_starting_distance_from_center = 35
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.modulate.a = 0.75
	
	return particle

func _set_smoke_particle_properties_when_get_from_pool_after_add_child(arg_particle):
	pass

func request_smoke_particles_to_play(arg_position : Vector2, arg_count : int = 14):
	for i in arg_count:
		var particle = smoke_particle_pool_component.get_or_create_attack_sprite_from_pool()
		
		particle.center_pos_of_basis = arg_position
		particle.lifetime = 0.8
		
		particle.visible = true
		particle.reset_for_another_use()
	
	

### RALLIER RELATED

func _initialize_rallier_speed_particle_pool_component():
	rallier_speed_particle_pool_component = AttackSpritePoolComponent.new()
	rallier_speed_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	rallier_speed_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	rallier_speed_particle_pool_component.source_for_funcs_for_attk_sprite = self
	rallier_speed_particle_pool_component.func_name_for_creating_attack_sprite = "_create_rallier_speed_particle"
	#rallier_speed_particle_pool_component.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_smoke_particle_properties_when_get_from_pool_after_add_child"

func _create_rallier_speed_particle():
	var particle = SkirmBlue_Rallier_Particle_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	particle.scale *= 2
	
	return particle

func request_rallier_speed_particle_to_play(arg_position : Vector2):
	var particle = rallier_speed_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.global_position = arg_position
	particle.lifetime = 0.35
	particle.frame = 0
	particle.set_anim_speed_based_on_lifetime()
	
	particle.has_lifetime = false #TOOO
	
	particle.visible = true
	particle.modulate.a = 0.75
	

####### ASCENDER RELATED


func _initialize_ascender_ascend_particle_pool_component():
	ascender_ascend_particle_pool_component = AttackSpritePoolComponent.new()
	ascender_ascend_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	ascender_ascend_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	ascender_ascend_particle_pool_component.source_for_funcs_for_attk_sprite = self
	ascender_ascend_particle_pool_component.func_name_for_creating_attack_sprite = "_create_ascender_ascend_particle"

func _create_ascender_ascend_particle():
	var particle = SkirmBlue_Ascender_Particle_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	return particle

func request_ascender_ascend_particle_to_play(arg_position : Vector2):
	var particle = ascender_ascend_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.global_position = arg_position
	particle.lifetime = 0.3
	particle.frame = 0
	particle.set_anim_speed_based_on_lifetime()
	
	particle.visible = true
	particle.modulate.a = 0.75
	

########### blaster related

func _initialize_blaster_bullet_attk_module():
	blaster_bullet_attk_module = BulletAttackModule_Scene.instance()
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	blaster_bullet_attk_module.bullet_shape = bullet_shape
	blaster_bullet_attk_module.bullet_scene = BaseBullet_Scene
	blaster_bullet_attk_module.set_texture_as_sprite_frame(Blaster_Bullet_Pic)
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(blaster_bullet_attk_module)


func request_blaster_bullet_to_shoot(arg_enemy_source, arg_source_pos, arg_dest_pos):
	var bullet = blaster_bullet_attk_module.construct_bullet(arg_dest_pos, arg_source_pos)
	
	bullet.can_hit_towers = true
	bullet.life_distance = blaster_range + 40 # for allowance
	
	bullet.pierce = 1
	
	bullet.connect("hit_a_tower", self, "_on_blaster_bullet_hit_tower")
	
	bullet.coll_source_layer = CollidableSourceAndDest.Source.FROM_ENEMY
	bullet.coll_destination_mask = CollidableSourceAndDest.Destination.TO_TOWER
	
	blaster_bullet_attk_module.set_up_bullet__add_child_and_emit_signals(bullet)
	
	trail_component_for_blaster_bullet.create_trail_for_node(bullet)
	
	return bullet

func _on_blaster_bullet_hit_tower(bullet, arg_tower):
	arg_tower.take_damage(blaster_damage_per_bullet)
	bullet.decrease_pierce(1)


#

func _initialize_blaster_trail_for_node_component():
	trail_component_for_blaster_bullet = MultipleTrailsForNodeComponent.new()
	trail_component_for_blaster_bullet.node_to_host_trails = CommsForBetweenScenes.current_game_elements__other_node_hoster
	trail_component_for_blaster_bullet.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	trail_component_for_blaster_bullet.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_blaster_bullet", [], CONNECT_PERSIST)
	

func _trail_before_attached_to_blaster_bullet(arg_trail, node):
	arg_trail.max_trail_length = 3
	arg_trail.trail_color = Color(244/255.0, 0, 2/255.0)
	arg_trail.width = 2
	
	arg_trail.set_to_idle_and_available_if_node_is_not_visible = true


########### ARTILLERY RELATED

func _initialize_artillery_explosion_particle_pool_component():
	artillery_explosion_particle_pool_component = AttackSpritePoolComponent.new()
	artillery_explosion_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	artillery_explosion_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	artillery_explosion_particle_pool_component.source_for_funcs_for_attk_sprite = self
	artillery_explosion_particle_pool_component.func_name_for_creating_attack_sprite = "_create_artillery_explosion_particle"

func _create_artillery_explosion_particle():
	var particle = SkirmRed_ArtilleryExplosion_Particle_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_TOWERS
	particle.scale *= 2.6
	
	particle.lifetime = 0.25
	particle.set_anim_speed_based_on_lifetime()
	
	return particle

func request_artillery_explosion_particle_to_play(arg_position : Vector2):
	var particle = artillery_explosion_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.global_position = arg_position
	particle.lifetime = 0.25
	particle.frame = 0
	particle.set_anim_speed_based_on_lifetime()
	
	particle.visible = true
	particle.modulate.a = 0.6


#
func _initialize_artillery_arc_bullet_attk_module():
	artillery_arc_bullet_attk_module = ArcingBulletAttackModule_Scene.instance()
	
	artillery_arc_bullet_attk_module.base_proj_speed = 3
	artillery_arc_bullet_attk_module.max_height = 300
	artillery_arc_bullet_attk_module.bullet_rotation_per_second = 125
	
	artillery_arc_bullet_attk_module.bullet_scene = ArcingBaseBullet_Scene
	artillery_arc_bullet_attk_module.set_texture_as_sprite_frame(Artillery_Bullet_Pic)
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(artillery_arc_bullet_attk_module)

func request_artillery_bullet_to_shoot(arg_enemy_source, arg_source_pos, arg_dest_pos, arg_target_placable):
	var bullet = artillery_arc_bullet_attk_module.construct_bullet(arg_dest_pos, arg_source_pos)
	
	bullet.connect("on_final_location_reached", self, "_on_final_location_reached__artillery_bullet", [arg_target_placable])
	
	artillery_arc_bullet_attk_module.set_up_bullet__add_child_and_emit_signals(bullet)
	
	return bullet

func _on_final_location_reached__artillery_bullet(arg_final_location, bullet, target_placable):
	request_artillery_explosion_particle_to_play(arg_final_location)
	
	var tower = target_placable.tower_occupying
	if is_instance_valid(tower):
		tower.take_damage(artillery_damage_per_shot)
		
		var stun_effect = TowerStunEffect.new(artillery_stun_duration_on_shot_hit, StoreOfTowerEffectsUUID.ARTILLERY_STUN_EFFECT)
		stun_effect.is_from_enemy = true
		
		tower.add_tower_effect(stun_effect)


func _initialize_artillery_trail_for_node_component():
	trail_component_for_artillery_bullet = MultipleTrailsForNodeComponent.new()
	trail_component_for_artillery_bullet.node_to_host_trails = CommsForBetweenScenes.current_game_elements__other_node_hoster
	trail_component_for_artillery_bullet.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	trail_component_for_artillery_bullet.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_artillery_bullet", [], CONNECT_PERSIST)
	

func _trail_before_attached_to_artillery_bullet(arg_trail, node):
	arg_trail.max_trail_length = 6
	arg_trail.trail_color = Color(244/255.0, 0, 2/255.0)
	arg_trail.width = 3
	
	arg_trail.set_to_idle_and_available_if_node_is_not_visible = true

############### DANSEUR RELATED

func _initialize_danseur_bullet_attk_module():
	danseur_bullet_attk_module = BulletAttackModule_Scene.instance()
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents.x = 9
	bullet_shape.extents.y = 4
	
	danseur_bullet_attk_module.bullet_shape = bullet_shape
	danseur_bullet_attk_module.bullet_scene = BaseBullet_Scene
	danseur_bullet_attk_module.set_texture_as_sprite_frame(Danseur_Bullet_Pic)
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(danseur_bullet_attk_module)


func request_danseur_proj_to_shoot(arg_enemy_source, arg_source_pos, arg_dest_pos):
	var bullet = danseur_bullet_attk_module.construct_bullet(arg_dest_pos, arg_source_pos)
	
	bullet.can_hit_towers = true
	bullet.life_distance = danseur_proj_and_detection_range + 40 # for allowance
	
	bullet.pierce = 1
	
	bullet.connect("hit_a_tower", self, "_on_danseur_proj_hit_tower")
	
	bullet.coll_source_layer = CollidableSourceAndDest.Source.FROM_ENEMY
	bullet.coll_destination_mask = CollidableSourceAndDest.Destination.TO_TOWER
	
	danseur_bullet_attk_module.set_up_bullet__add_child_and_emit_signals(bullet)
	
	return bullet

func _on_danseur_proj_hit_tower(bullet, arg_tower):
	arg_tower.take_damage(danseur_damage_per_proj)
	bullet.decrease_pierce(1)


func request_add_enemy_effect_shield_on_self__as_danseur(arg_enemy):
	var self_effect_shield = EnemyEffectShieldEffect.new(StoreOfEnemyEffectsUUID.DANSEUR_EFFECT_SHIELD_EFFECT)
	self_effect_shield.is_from_enemy = true
	self_effect_shield.status_bar_icon = preload("res://EnemyRelated/CommonStatusBarIcons/EffectShieldEffect/EffectShieldEffect_StatusBarIcon.png")
	
	arg_enemy._add_effect(self_effect_shield)

func request_remove_enemy_effect_shield_on_self__as_danseur(arg_enemy):
	var eff_shield_effect = arg_enemy.get_effect_with_uuid(StoreOfEnemyEffectsUUID.DANSEUR_EFFECT_SHIELD_EFFECT)
	if eff_shield_effect != null:
		arg_enemy._remove_effect(eff_shield_effect)


########################## DANSUER AND FINISHER THROUGH PLACABLE PATHS

class ThroughPlacableData:
	var placable
	
	var entry_offset : float
	var exit_offset : float
	var exit_position : Vector2
	
	var entry_higher_than_exit : bool


func _initialize_and_generate_through_placable_data__threaded():
	if !game_elements.is_connected("tree_exiting", self, "_on_game_elements_exit_tree"):
		game_elements.connect("tree_exiting", self, "_on_game_elements_exit_tree")
	
	through_placable_datas_thread = Thread.new()
	through_placable_datas_thread.start(self, "_initialize_and_generate_through_placable_data")
	

func _initialize_and_generate_through_placable_data(arg_data):
	for placable in game_elements.map_manager.get_all_placables():
		if placable.visible:
			_generate_through_placable_data_of_placable__using_default_starting_poses(placable)
	
	for datas in enemy_path_to_through_placable_datas.values():
		datas.sort_custom(self, "_sort_based_on_entry_offset")

func _generate_through_placable_data_of_placable__using_default_starting_poses(arg_placable):
	var all_poses := []
	var top_pos = arg_placable.global_position + Vector2(0, -starting_side_point_distance_from_placable)
	var bot_pos = arg_placable.global_position + Vector2(0, starting_side_point_distance_from_placable)
	var left_pos = arg_placable.global_position + Vector2(-starting_side_point_distance_from_placable, 0)
	var right_pos = arg_placable.global_position + Vector2(starting_side_point_distance_from_placable, 0)
	
	all_poses.append(top_pos)
	all_poses.append(bot_pos)
	all_poses.append(left_pos)
	all_poses.append(right_pos)
	
	for path in paths_for_reds:
		var path_length = path.curve.get_baked_length()
		
		for pos in all_poses:
			var data = _generate_through_placable_data_of_placable__using_given_pos(arg_placable, path, pos, path_length)
			if data != null:
				enemy_path_to_through_placable_datas[path].append(data)


func _generate_through_placable_data_of_placable__using_given_pos(arg_placable, arg_enemy_path : EnemyPath, arg_starting_global_pos : Vector2, arg_path_length : float):
	# poses of in path as ENTRY
	var nearest_pos : Vector2 = arg_enemy_path.curve.get_closest_point(arg_starting_global_pos - arg_enemy_path.global_position)
	var nearest_global_pos = nearest_pos + arg_enemy_path.global_position
	
	if nearest_global_pos.distance_to(arg_placable.global_position) <= distance_max_from_starting_placable_pos_to_offset:
		var dict = {
			closest_offset_adv_param_metadata_name__entry_offset_pos : nearest_pos
		}

		var closest_offset_adv_param = EnemyPath.ClosestOffsetAdvParams.new()
		closest_offset_adv_param.obj_func_source = self
		closest_offset_adv_param.func_predicate = "_test_on_closest_offset_adv_params"
		closest_offset_adv_param.metadata = dict
		
		#
		
		var angle : float = nearest_global_pos.angle_to_point(arg_placable.global_position)
		#var valid_offset_and_pos = arg_enemy_path.get_closest_offset_and_pos_in_a_line__global_source_pos(15, distance_max_from_placable_center_to_ending_offset, angle, arg_placable.global_position)
		var valid_offset_and_pos = arg_enemy_path.get_closest_offset_and_pos_in_a_line__global_source_pos(15, distance_max_from_placable_center_to_ending_offset, angle, arg_placable.global_position, closest_offset_adv_param)
		
		if valid_offset_and_pos != null:
			var valid_offset = valid_offset_and_pos[0]
			var valid_pos = valid_offset_and_pos[1]
			
			if _check_if_valid_offset_meets_requirements(valid_offset, arg_path_length):
				var through_placable_data = ThroughPlacableData.new()
				through_placable_data.placable = arg_placable
				through_placable_data.entry_offset = arg_enemy_path.curve.get_closest_offset(nearest_pos)
				through_placable_data.exit_offset = valid_offset
				through_placable_data.exit_position = valid_pos
				through_placable_data.entry_higher_than_exit = through_placable_data.entry_offset > valid_offset
				
				return through_placable_data
	
	return null

# closest_pos = closest pos of path from test pos. same in meaning to candidate_pos
func _test_on_closest_offset_adv_params(arg_test_pos, arg_source_pos, arg_max_distance_of_test_to_source, arg_closest_pos : Vector2, arg_test_to_source_dist, arg_metadata):
	return arg_closest_pos.distance_to(arg_metadata[closest_offset_adv_param_metadata_name__entry_offset_pos]) >= distance_min_of_ending_offset_to_entry_offset

func _check_if_valid_offset_meets_requirements(arg_offset : float, arg_enemy_path_length : float):
	return arg_offset > (arg_enemy_path_length * min_entry_unit_offset) and arg_offset < (arg_enemy_path_length * max_exit_unit_offset)


func _sort_based_on_entry_offset(a : ThroughPlacableData, b : ThroughPlacableData):
	return a.entry_offset < b.entry_offset

#
func _on_game_elements_exit_tree():
	through_placable_datas_thread.wait_to_finish()

#

#func register_enemy_to_offset_checkpoints_of_through_placable_data(arg_enemy):
#	var path_of_enemy = arg_enemy.current_path
#	var curr_enemy_offset = arg_enemy.offset
#

func get_next_through_placable_data_based_on_curr(arg_curr_offset, arg_path):
	var datas : Array = enemy_path_to_through_placable_datas[arg_path]
	var i = datas.bsearch_custom(arg_curr_offset, self, "_bsearch_compare_for_entry_offset")
	
	if datas.size() > i:
		return datas[i]
	else:
		return null

func _bsearch_compare_for_entry_offset(a : ThroughPlacableData, b : float):
	return a.entry_offset < b


##########

func _on_round_end(arg_stagerounds):
	blaster_bullet_attk_module.on_round_end()
	artillery_arc_bullet_attk_module.on_round_end()
	danseur_bullet_attk_module.on_round_end()

