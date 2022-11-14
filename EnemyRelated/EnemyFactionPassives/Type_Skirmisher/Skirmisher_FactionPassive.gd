extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"

const MapManager = preload("res://GameElementsRelated/MapManager.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")
const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")

const AbstractSkirmisherEnemy = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const SkirmBlue_Smoke_Particle_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkrimBlue_Smoke_Particle.tscn")
const SkirmBlue_Rallier_Particle_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkirmBlue_Rallier_Particle.tscn")

enum PathType {
	BLUE_PATH = 0,
	RED_PATH = 1
}

var game_elements : GameElements
var map_manager : MapManager
var enemy_manager : EnemyManager

var paths_for_blues : Array = []
var paths_for_reds : Array = []


var smoke_particle_pool_component : AttackSpritePoolComponent
var rallier_speed_particle_pool_component : AttackSpritePoolComponent


###############

func _apply_faction_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
		map_manager = game_elements.map_manager
		enemy_manager = game_elements.enemy_manager
	
	_set_blue_and_red_paths()
	
	if !enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		enemy_manager.connect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path", [], CONNECT_PERSIST)
	
	if smoke_particle_pool_component == null:
		_initialize_smoke_particle_pool_component()
		_initialize_rallier_speed_particle_pool_component()
	
	#_initialize_enemy_manager_spawn_pattern()
	#if !enemy_manager.is_connected("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed"):
	#	enemy_manager.connect("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed", [], CONNECT_PERSIST)
	
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
	
	######
	
	if enemy is AbstractSkirmisherEnemy:
		enemy.skirmisher_faction_passive = self
	

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
#	print(index)
#	return enemy_manager.spawn_paths[index]


#################

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
	
	

###

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
	
	particle.visible = true
	particle.modulate.a = 0.75
	


