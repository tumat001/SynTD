extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"

const MapManager = preload("res://GameElementsRelated/MapManager.gd")
const EnemyPath = preload("res://EnemyRelated/EnemyPath.gd")
const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")
const EnemyEffectShieldEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyEffectShieldEffect.gd")
const TowerKnockUpEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerKnockUpEffect.gd")
const TowerForcedPlacableMovementEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerForcedPlacableMovementEffect.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const EnemyReviveEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyReviveEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const EnemyHealEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyHealEffect.gd")
const SkirmisherNodeDrawer = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/SkirmisherNodeDrawer.gd")
const SkirmisherNodeDrawer_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/SkirmisherNodeDrawer.tscn")
const EnemyShieldEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyShieldEffect.gd")

const AbstractSkirmisherEnemy = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")
const CenterBasedAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.tscn")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const EnemyPathsArray = preload("res://MiscRelated/DataCollectionRelated/EnemyPathsArray.gd")

const SkirmBlue_Smoke_Particle_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkrimBlue_Smoke_Particle.tscn")
const SkirmBlue_Rallier_Particle_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkirmBlue_Rallier_Particle.tscn")
const SkirmBlue_Ascender_Particle_Scene = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Ascender/Ascender_TransformParticle/Ascender_TransformParticle.tscn")
const SkirmRed_ArtilleryExplosion_Particle_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkirmRed_Artillery_AestheticExplosion.tscn")
const SkirmRed_Finisher_SlashFade_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkirmRed_Finisher_SlashFade.tscn")
const SkirmRed_Tosser_Explosion_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Skirmisher/Particles/SkirmRed_Tosser_Explosion.tscn")

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
const Finisher_Bullet_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Finisher/Assets/Finisher_SlashProj.png")
const Finisher_BulletSmall_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Finisher/Assets/Finisher_SlashProj_Small.png")
const Tosser_Bomb_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Tosser/Assets/Tosser_Bomb.png")
const Tosser_Empowered_Bomb_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Tosser/Assets/Tosser_Bomb_Empowered.png")

const Homerunner_BlueFlag_E_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Flag/Homerunner_BlueFlag_ForE.png")
const Homerunner_BlueFlag_W_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Flag/Homerunner_BlueFlag_ForW.png")
const Homerunner_RedFlag_E_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Flag/Homerunner_RedFlag_ForE.png")
const Homerunner_RedFlag_W_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Flag/Homerunner_RedFlag_ForW.png")

const EnemySpawnLocIndicator_Flag = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/EnemySpawnLocIndicator_Flag.gd")
const BlueFlagEmpParticle_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/_FactionAssets/Textures/Faction_FlagPathIndicatorEmp_Blue_Particle.png")
const RedFlagEmpParticle_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/_FactionAssets/Textures/Faction_FlagPathIndicatorEmp_Red_Particle.png")


#

enum PathType {
	BLUE_PATH = 0,
	RED_PATH = 1
}

var _initialized_at_least_once : bool = false

var game_elements : GameElements
var map_manager : MapManager
var enemy_manager : EnemyManager

var skirmisher_gen_purpose_rng : RandomNumberGenerator

#var paths_for_blues : Array = []
#var paths_for_reds : Array = []

var blue_path_array : EnemyPathsArray = EnemyPathsArray.new()
var red_path_array : EnemyPathsArray = EnemyPathsArray.new()

##############

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

var finisher_execute_bullet_attk_module : BulletAttackModule
var finisher_normal_bullet_attk_module : BulletAttackModule
var trail_component_for_finisher_proj : MultipleTrailsForNodeComponent
var finisher_execute_fade_particle_pool_component : AttackSpritePoolComponent

var tosser_arc_bullet_attk_module : ArcingBulletAttackModule
var tosser_bomb_explosion_particle_pool_component : AttackSpritePoolComponent
const tosser_bomb_normal_animation_name : String = "default"
const tosser_bomb_empowered_animation_name : String = "empowered"


const blaster_range : float = 120.0
const blaster_damage_per_bullet : float = 0.65

const artillery_damage_per_shot : float = 3.5
const artillery_stun_duration_on_shot_hit : float = 2.0

const danseur_proj_and_detection_range : float = 130.0
const danseur_damage_per_proj : float = 0.5 #0.3

const finisher_execute_damage_per_bullet : float = 2.0
const finisher_normal_damage_per_bullet : float = 2.0


const tosser_flight_duration : float = 1.125
const tosser_bomb_detonation_delay_on_landing : float = 1.5

const tosser_angle_deviation : float = PI / 10    # dev of 90 covers 180 deg (semicircle)
const tosser_distance_for_finding_placables : float = 150.0

const homerunner_blue_active_ap_bonus : float = 1.5
const homerunner_blue_shield_health_ratio_for_no_ap_used : float = 20.0

const homerunner_red_active_revive_delay : float = 3.0
const homerunner_red_active_revive_heal_health_max_percent : float = 15.0


# DANSEUR SPECIFIC

const danseur__starting_side_point_distance_from_placable : float = 30.0

const danseur__distance_max_from_starting_placable_pos_to_offset : float = 70.0
const danseur__distance_max_from_placable_center_to_ending_offset : float = 110.0
const danseur__distance_min_of_ending_offset_to_entry_offset = 30.0
const danseur__interval_magnitude : float = 15.0

const danseur__min_entry_unit_offset : float = 0.05
const danseur__max_exit_unit_offset : float = 0.95

var danseur__enemy_path_to__id_to_through_placable_datas : Dictionary
var danseur__enemy_path_to_curve_ids_already_calculated : Dictionary = {}

# FINISHER SPECIFIC

const finisher__starting_side_point_distance_from_placable : float = 40.0

const finisher__distance_max_from_starting_placable_pos_to_offset : float = 130.0
const finisher__distance_max_from_placable_center_to_ending_offset : float = 140.0
const finisher__distance_min_of_ending_offset_to_entry_offset = 30.0
const finisher__interval_magnitude : float = 15.0

const finisher__min_entry_unit_offset : float = 0.05
const finisher__max_exit_unit_offset : float = 0.95

var finisher__enemy_path_to__id_to_through_placable_datas : Dictionary
var finisher__enemy_path_to_curve_ids_already_calculated : Dictionary = {}


# TOSSER SPECIFIC

var tosser__plain_knock_up_effect : TowerKnockUpEffect
var tosser__forced_mov_knock_up_effect : TowerKnockUpEffect

const tosser_plain_knock_up_duration : float = 1.1
const tosser_plain_knock_up_stun_duration : float = 2.5
const tosser_plain_knock_up_y_accel_amount : float = 200.0

const tosser_forced_mov_knock_up_duration : float = 1.25
const tosser_forced_mov_up_y_accel_amount : float = 250.0
const tosser_forced_mov_to_placable_duration : float = tosser_forced_mov_knock_up_duration


# ARTILLERY SPECIFIC
var pos_basis_for_artillery_targeting : Vector2
var artillery_tower_targets : Array

var _queued_request_for_artillery_target_update : bool

# HOMERUNNER SPECIFIC

var _current_active_blue_homerunner_flag : Sprite
var _is_blue_flag_active : bool

var _current_active_red_homerunner_flag : Sprite
var _is_red_flag_active : bool

var homerunner_ap_effect : EnemyAttributesEffect
var homerunner_shield_effect : EnemyShieldEffect
var homerunner_revive_effect : EnemyReviveEffect

#var homerunner_blue_effects : Array

var homerunner_blue_effects__for_with_abilities : Array
var homerunner_blue_effects__for_none : Array
var homerunner_red_effects : Array


# General misc stuffs

var skirmisher_node_draw : SkirmisherNodeDrawer

var blue_spawn_loc_flags : Array
var red_spawn_loc_flags : Array
var blue_flag_emp_particle_pool_compo : AttackSpritePoolComponent
var red_flag_emp_particle_pool_compo : AttackSpritePoolComponent
var spawn_loc_flags_emp_particle_timer : Timer

var _is_showing_spawn_loc_flags : bool
var _is_spawn_loc_blue_flags_empowered : bool
var _is_spawn_loc_red_flags_empowered : bool

const delay_delta_per_particle : float = 0.3#0.65
const particle_count_per_flag_per_show : int = 3

# SHARED BY FINISHER AND DANSEUR

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
		#_initialize_and_generate_through_placable_data([])
		
		_initialize_danseur_bullet_attk_module()
		
		_initialize_finisher_execute_bullet_attk_module()
		_initialize_finisher_normal_bullet_attk_module()
		_initialize_finisher_trail_for_node_component()
		_initialize_finisher_execute_fade_particle_pool_component()
		
		_initialize_tosser_arc_bullet_attk_module()
		_initialize_tosser_tower_effects()
		_initialize_tosser_bomb_explosion_particle_pool_component()
		
		_initialize_homerunner_effects()
		
		_initialize_skirmisher_node_draw()
		_initialize_skirmisher_spawn_loc_flags()
	
	#_initialize_enemy_manager_spawn_pattern()
	#if !enemy_manager.is_connected("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed"):
	#	enemy_manager.connect("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed", [], CONNECT_PERSIST)
	
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("round_started", self ,"_on_round_start", [], CONNECT_PERSIST)
	game_elements.enemy_manager.connect("path_to_spawn_pattern_changed", self, "_on_enemy_manager_spawn_pattern_changed", [], CONNECT_PERSIST)
	
	_update_spawn_pattern_based_on_enemy_mngr_pattern()
	
	_show_flags_if_curr_stageround_is_appropriate(game_elements.stage_round_manager.current_stageround)
	
	._apply_faction_to_game_elements(arg_game_elements)


func _remove_faction_from_game_elements(arg_game_elements : GameElements):
	if enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		enemy_manager.disconnect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path")
	
	_reverse_actions_on_path_generation()
	

		#
	#if enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
	#	enemy_manager.disconnect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path")
	
	
	#if enemy_manager.is_connected("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed"):
		#enemy_manager.disconnect("path_to_spawn_pattern_changed", self, "_on_path_to_spawn_pattern_changed")
	
	if game_elements.enemy_manager.is_connected("path_to_spawn_pattern_changed", self, "_on_enemy_manager_spawn_pattern_changed"):
		game_elements.enemy_manager.connect("path_to_spawn_pattern_changed", self, "_on_enemy_manager_spawn_pattern_changed")
	
	._remove_faction_from_game_elements(arg_game_elements)


#

func _set_blue_and_red_paths():
	#
	_clear_all_flags()
	
	#
	
	var all_paths = map_manager.base_map.get_all_enemy_paths()
	
	for path in all_paths:
		if !path.marker_id_to_value_map.has(EnemyPath.MarkerIds.SKIRMISHER_CLONE_OF_BASE_PATH) and !path.marker_id_to_value_map.has(EnemyPath.MarkerIds.SKIRMISHER_BASE_PATH_ALREADY_CLONED):
			#paths_for_blues.append(path)
			blue_path_array.add_enemy_spawn_path(path)
	
	var i = 0
	for blue_path in blue_path_array.get_spawn_paths__not_copy():
		var red_path = blue_path.get_copy_of_path(true)
		red_path.marker_id_to_value_map[EnemyPath.MarkerIds.SKIRMISHER_CLONE_OF_BASE_PATH] = blue_path #Storing pair path
		
		#paths_for_reds.append(red_path)
		red_path_array.add_enemy_spawn_path(red_path)
		
		blue_path.marker_id_to_value_map[EnemyPath.MarkerIds.SKIRMISHER_BASE_PATH_ALREADY_CLONED] = red_path #storing pair path
		
		var emit_signal_on_add_path : bool = blue_path_array.get_spawn_paths__not_copy().size() <= (i + 1) #paths_for_blues.size() <= (i + 1)
		map_manager.base_map.add_enemy_path(red_path, emit_signal_on_add_path)
		
		# signals related
		blue_path.connect("curve_changed", self, "_on_curve_of_original_path_changed", [blue_path, red_path], CONNECT_PERSIST)
		blue_path.connect("is_used_and_active_changed", self, "_on_enemy_path_is_used_and_active_changed", [blue_path, red_path], CONNECT_PERSIST)
		
		red_path.connect("curve_changed", self, "_on_curve_of_red_path_changed", [red_path], CONNECT_PERSIST)
		
		# for danseur/finisher pathings
		danseur__enemy_path_to__id_to_through_placable_datas[red_path] = {}
		danseur__enemy_path_to_curve_ids_already_calculated[red_path] = []

		finisher__enemy_path_to__id_to_through_placable_datas[red_path] = {}
		finisher__enemy_path_to_curve_ids_already_calculated[red_path] = []
		
		i += 1
		
		# flag related
		
		var blue_flag = _create_flag_for_path(blue_path, EnemySpawnLocIndicator_Flag.FlagTextureIds.BLUE)
		blue_flag.visible = false
		blue_spawn_loc_flags.append(blue_flag)
		var red_flag = _create_flag_for_path(red_path, EnemySpawnLocIndicator_Flag.FlagTextureIds.RED)
		red_flag.visible = false
		red_spawn_loc_flags.append(red_flag)

func _reverse_actions_on_path_generation():
	var all_paths = map_manager.base_map.all_enemy_paths.duplicate(false)
	
	for path in blue_path_array.get_spawn_paths__not_copy(): #paths_for_blues:
		path.marker_id_to_value_map.erase(EnemyPath.MarkerIds.SKIRMISHER_BASE_PATH_ALREADY_CLONED)
	
	var paths_to_remove : Array = []
	for path in red_path_array.get_spawn_paths__not_copy(): #paths_for_reds:
		map_manager.base_map.remove_enemy_path(path)
		paths_to_remove.append(path)
	
	for path in paths_to_remove:
		#paths_for_reds.erase(path)
		red_path_array.remove_enemy_spawn_path(path)
		path.queue_free()


func _clear_all_flags():
	for flag in blue_spawn_loc_flags:
		flag.queue_free()
	for flag in red_spawn_loc_flags:
		flag.queue_free()
	
	blue_spawn_loc_flags.clear()
	red_spawn_loc_flags.clear()

func _create_flag_for_path(arg_path, arg_flag_texture_id) -> EnemySpawnLocIndicator_Flag:
	return game_elements.map_manager.base_map.create_spawn_loc_flag_at_path(arg_path, game_elements.map_manager.base_map.default_flag_offset_from_path, arg_flag_texture_id)

#

func _before_enemy_is_added_to_path(enemy, path):
	if enemy is AbstractSkirmisherEnemy:
		enemy.skirmisher_faction_passive = self
		
		if enemy.enemy_id == EnemyConstants.Enemies.HOMERUNNER:
			enemy.connect("flag_implanted", self, "_on_flag_implanted_by_homerunner", [], CONNECT_ONESHOT)
	
	#
	
	#var path_index = enemy_manager.get_spawn_path_to_take_index() % blue_path_array.get_spawn_paths__not_copy().size() #paths_for_blues.size()
	
	if enemy.enemy_spawn_metadata_from_ins != null and enemy.enemy_spawn_metadata_from_ins.has(StoreOfEnemyMetadataIdsFromIns.SKIRMISHER_SPAWN_AT_PATH_TYPE):
		var path_type = enemy.enemy_spawn_metadata_from_ins[StoreOfEnemyMetadataIdsFromIns.SKIRMISHER_SPAWN_AT_PATH_TYPE]
		
		#if enemy.get("skirmisher_path_color_type"):
		#	enemy.skirmisher_path_color_type = path_type
		
		var is_enemy_abstract_skirmisher : bool = enemy is AbstractSkirmisherEnemy
		
		if path_type == PathType.RED_PATH: #FOR RED ENEMIES
			
			if is_enemy_abstract_skirmisher:
				enemy.skirmisher_path_color_type = AbstractSkirmisherEnemy.ColorType.RED
				#enemy.set_show_emp_particle_layer(_is_red_flag_active)
			
			var path_index = red_path_array.get_spawn_path_index_to_take()
			_add_enemy_to_red_path(enemy, path_index)
			red_path_array.switch_path_index_to_next()
			
			if _is_red_flag_active and is_enemy_abstract_skirmisher:
				_add_effects_to_enemy(homerunner_red_effects, enemy)
			
		else: #FOR BLUE ENEMIES
			
			if is_enemy_abstract_skirmisher:
				enemy.skirmisher_path_color_type = AbstractSkirmisherEnemy.ColorType.BLUE
				#enemy.set_show_emp_particle_layer(_is_blue_flag_active)
			
			var path_index = blue_path_array.get_spawn_path_index_to_take()
			_add_enemy_to_blue_path(enemy, path_index)
			blue_path_array.switch_path_index_to_next()
			
			if _is_blue_flag_active and is_enemy_abstract_skirmisher:
				_add_blue_effects_to_blue_skirmisher(enemy)
		
	else:
		
		if StoreOfEnemyMetadataIdsFromIns.is_enemy_metadata_free_from_reserved_paths_metadata(enemy.enemy_spawn_metadata_from_ins, []):
			var path_index = blue_path_array.get_spawn_path_index_to_take()
			_add_enemy_to_blue_path(enemy, path_index)
			blue_path_array.switch_path_index_to_next()


func _add_enemy_to_blue_path(enemy, path_index):
	#var path = _get_path_to_use(path_index, blue_path_array.get_spawn_paths__not_copy())#paths_for_blues)
	var path = blue_path_array.get_path_based_on_current_index()
	
	path.add_child(enemy)

func _get_path_to_use(path_index, paths):
	var index = path_index
	
	return paths[index]


func _add_enemy_to_red_path(enemy, path_index):
	#var path = _get_path_to_use(path_index, red_path_array.get_spawn_paths__not_copy())#paths_for_reds)
	var path = red_path_array.get_path_based_on_current_index()
	
	path.add_child(enemy)


# path spawn pattern related
# removed because it is not needed (job already done by above)

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
	
	#
	
	pos_basis_for_artillery_targeting = game_elements.get_middle_coordinates_of_playable_map()


func request_artillery_bullet_to_shoot(arg_enemy_source, arg_source_pos, arg_dest_pos, arg_target_placable):
	var bullet = artillery_arc_bullet_attk_module.construct_bullet(arg_dest_pos, arg_source_pos)
	
	bullet.connect("on_final_location_reached", self, "_on_final_location_reached__artillery_bullet", [arg_target_placable])
	
	artillery_arc_bullet_attk_module.set_up_bullet__add_child_and_emit_signals(bullet)
	
	trail_component_for_artillery_bullet.create_trail_for_node(bullet)
	
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


# 

func _on_round_start__for_artillery_targets_purpose():
	_clear_queue_for_req__and_update_targets_for_artillery()
	
	if !game_elements.tower_manager.is_connected("tower_transfered_to_placable", self, "_on_tower_transfered_to_placable"):
		game_elements.tower_manager.connect("tower_transfered_to_placable", self, "_on_tower_transfered_to_placable")
		game_elements.tower_manager.connect("tower_in_queue_free", self, "_on_tower_in_queue_free")
		game_elements.tower_manager.connect("tower_last_calculated_untargetability_changed", self, "_on_tower_last_calculated_untargetability_changed")

func _on_round_end__for_artillery_targets_purpose():
	if game_elements.tower_manager.is_connected("tower_transfered_to_placable", self, "_on_tower_transfered_to_placable"):
		game_elements.tower_manager.disconnect("tower_transfered_to_placable", self, "_on_tower_transfered_to_placable")
		game_elements.tower_manager.disconnect("tower_in_queue_free", self, "_on_tower_in_queue_free")
		game_elements.tower_manager.disconnect("tower_last_calculated_untargetability_changed", self, "_on_tower_last_calculated_untargetability_changed")



func _on_tower_transfered_to_placable(arg_tower, arg_placable):
	_queue_request_update_targets_for_artillery__if_tower_is_in_curr_targets(arg_tower)

func _on_tower_in_queue_free(arg_tower):
	_queue_request_update_targets_for_artillery__if_tower_is_in_curr_targets(arg_tower)

func _on_tower_last_calculated_untargetability_changed(arg_val, arg_tower):
	_queue_request_update_targets_for_artillery__if_tower_is_in_curr_targets(arg_tower)


func _queue_request_update_targets_for_artillery__if_tower_is_in_curr_targets(arg_tower):
	if artillery_tower_targets.has(arg_tower):
		_queue_request_update_targets_for_artillery()


#

func _queue_request_update_targets_for_artillery():
	if !_queued_request_for_artillery_target_update:
		_queued_request_for_artillery_target_update = true
		call_deferred("_clear_queue_for_req__and_update_targets_for_artillery")

func _clear_queue_for_req__and_update_targets_for_artillery():
	_queued_request_for_artillery_target_update = false
	update_targets_for_artillery()

#

func update_targets_for_artillery():
	var alive_towers = game_elements.tower_manager.get_all_in_map_and_alive_towers_except_in_queue_free()
	
	# this take one of the 4 closest towers from the arg_source_pos
	var center_tower_count : int = 4
	artillery_tower_targets = Targeting.enemies_to_target(alive_towers, Targeting.CLOSE, center_tower_count, pos_basis_for_artillery_targeting)
	

func get_target_for_artillery():
	if artillery_tower_targets.size() > 0:
		var rand_int = skirmisher_gen_purpose_rng.randi_range(0, artillery_tower_targets.size() - 1)
		
		return artillery_tower_targets[rand_int]
	
	return null

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

#################### FINISHER RELATED


func _initialize_finisher_execute_bullet_attk_module():
	finisher_execute_bullet_attk_module = BulletAttackModule_Scene.instance()
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents.x = 35
	bullet_shape.extents.y = 8
	
	finisher_execute_bullet_attk_module.bullet_shape = bullet_shape
	finisher_execute_bullet_attk_module.bullet_scene = BaseBullet_Scene
	finisher_execute_bullet_attk_module.set_texture_as_sprite_frame(Finisher_Bullet_Pic)
	
	finisher_execute_bullet_attk_module.base_proj_speed = 750
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(finisher_execute_bullet_attk_module)


func request_finisher_execute_bullet_to_shoot(arg_enemy_source, arg_source_pos, arg_dest_pos, arg_bullet_life_distance):
	var bullet = finisher_execute_bullet_attk_module.construct_bullet(arg_dest_pos, arg_source_pos)
	
	bullet.can_hit_towers = true
	bullet.life_distance = arg_bullet_life_distance - 10 # for allowance
	
	bullet.decrease_pierce = false
	bullet.pierce = 1
	
	bullet.connect("hit_a_tower", self, "_on_finisher_execute_bullet_hit_tower")
	bullet.connect("tree_exiting", self, "_on_finisher_execute_bullet_tree_exiting", [bullet])
	
	bullet.coll_source_layer = CollidableSourceAndDest.Source.FROM_ENEMY
	bullet.coll_destination_mask = CollidableSourceAndDest.Destination.TO_TOWER
	
	finisher_execute_bullet_attk_module.set_up_bullet__add_child_and_emit_signals(bullet)
	trail_component_for_finisher_proj.create_trail_for_node(bullet)
	
	return bullet

func _on_finisher_execute_bullet_hit_tower(bullet, arg_tower):
	arg_tower.take_damage(finisher_execute_damage_per_bullet)
	

func _on_finisher_execute_bullet_tree_exiting(arg_bullet):
	request_finisher_execute_fade_particle_to_play(arg_bullet.global_position, arg_bullet.rotation)
	


func _initialize_finisher_execute_fade_particle_pool_component():
	finisher_execute_fade_particle_pool_component = AttackSpritePoolComponent.new()
	finisher_execute_fade_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	finisher_execute_fade_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	finisher_execute_fade_particle_pool_component.source_for_funcs_for_attk_sprite = self
	finisher_execute_fade_particle_pool_component.func_name_for_creating_attack_sprite = "_create_finisher_execute_fade_particle"

func _create_finisher_execute_fade_particle():
	var particle = SkirmRed_Finisher_SlashFade_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	return particle

func request_finisher_execute_fade_particle_to_play(arg_position : Vector2, arg_rotation : float):
	var particle = finisher_execute_fade_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.global_position = arg_position
	particle.lifetime = 0.3
	particle.frame = 0
	particle.set_anim_speed_based_on_lifetime()
	particle.rotation = arg_rotation
	
	particle.visible = true
	particle.modulate.a = 0.75
	
	
	var disp := Vector2(100, 0)
	disp = disp.rotated(arg_rotation)
	particle.x_displacement_per_sec = disp.x
	particle.y_displacement_per_sec = disp.y
	
	particle.upper_limit_x_displacement_per_sec = disp.x
	particle.upper_limit_y_displacement_per_sec = disp.y

##

func _initialize_finisher_normal_bullet_attk_module():
	finisher_normal_bullet_attk_module = BulletAttackModule_Scene.instance()
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents.x = 12
	bullet_shape.extents.y = 8
	
	finisher_normal_bullet_attk_module.bullet_shape = bullet_shape
	finisher_normal_bullet_attk_module.bullet_scene = BaseBullet_Scene
	finisher_normal_bullet_attk_module.set_texture_as_sprite_frame(Finisher_BulletSmall_Pic)
	
	finisher_normal_bullet_attk_module.base_proj_speed = 450
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(finisher_normal_bullet_attk_module)


func request_finisher_normal_bullet_to_shoot(arg_enemy_source, arg_source_pos, arg_dest_pos, arg_bullet_life_distance):
	var bullet = finisher_normal_bullet_attk_module.construct_bullet(arg_dest_pos, arg_source_pos)
	
	bullet.can_hit_towers = true
	bullet.life_distance = arg_bullet_life_distance - 10 # for allowance
	
	bullet.decrease_pierce = false
	bullet.pierce = 1
	
	bullet.connect("hit_a_tower", self, "_on_finisher_normal_bullet_hit_tower")
	
	bullet.coll_source_layer = CollidableSourceAndDest.Source.FROM_ENEMY
	bullet.coll_destination_mask = CollidableSourceAndDest.Destination.TO_TOWER
	
	finisher_normal_bullet_attk_module.set_up_bullet__add_child_and_emit_signals(bullet)
	trail_component_for_finisher_proj.create_trail_for_node(bullet)
	
	return bullet

func _on_finisher_normal_bullet_hit_tower(bullet, arg_tower):
	arg_tower.take_damage(finisher_normal_damage_per_bullet)


#

func request_add_enemy_effect_shield_on_self__as_finisher(arg_enemy):
	var self_effect_shield = EnemyEffectShieldEffect.new(StoreOfEnemyEffectsUUID.FINISHER_EFFECT_SHIELD_EFFECT)
	self_effect_shield.is_from_enemy = true
	self_effect_shield.status_bar_icon = preload("res://EnemyRelated/CommonStatusBarIcons/EffectShieldEffect/EffectShieldEffect_StatusBarIcon.png")
	
	arg_enemy._add_effect(self_effect_shield)

func request_remove_enemy_effect_shield_on_self__as_finisher(arg_enemy):
	var eff_shield_effect = arg_enemy.get_effect_with_uuid(StoreOfEnemyEffectsUUID.FINISHER_EFFECT_SHIELD_EFFECT)
	if eff_shield_effect != null:
		arg_enemy._remove_effect(eff_shield_effect)

#

func _initialize_finisher_trail_for_node_component():
	trail_component_for_finisher_proj = MultipleTrailsForNodeComponent.new()
	trail_component_for_finisher_proj.node_to_host_trails = CommsForBetweenScenes.current_game_elements__other_node_hoster
	trail_component_for_finisher_proj.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	trail_component_for_finisher_proj.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_finisher_bullet", [], CONNECT_PERSIST)
	

func _trail_before_attached_to_finisher_bullet(arg_trail, node):
	arg_trail.max_trail_length = 8
	arg_trail.trail_color = Color(244/255.0, 0, 2/255.0)
	arg_trail.width = 4
	
	arg_trail.set_to_idle_and_available_if_node_is_not_visible = true


################ TOSSER SPECIFIC

func _initialize_tosser_arc_bullet_attk_module():
	tosser_arc_bullet_attk_module = ArcingBulletAttackModule_Scene.instance()
	
	tosser_arc_bullet_attk_module.base_proj_speed = tosser_flight_duration
	tosser_arc_bullet_attk_module.max_height = 300
	tosser_arc_bullet_attk_module.bullet_rotation_per_second = 0
	
	tosser_arc_bullet_attk_module.bullet_scene = ArcingBaseBullet_Scene
	#tosser_arc_bullet_attk_module.set_texture_as_sprite_frame(Tosser_Bomb_Pic)
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(tosser_arc_bullet_attk_module)

func _initialize_tosser_tower_effects():
	tosser__plain_knock_up_effect = TowerKnockUpEffect.new(tosser_plain_knock_up_duration, tosser_plain_knock_up_y_accel_amount, StoreOfTowerEffectsUUID.TOSSER_KNOCK_UP_EFFECT)
	tosser__plain_knock_up_effect.custom_stun_duration = tosser_plain_knock_up_stun_duration
	tosser__plain_knock_up_effect.is_from_enemy = true
	tosser__plain_knock_up_effect.is_timebound = true
	 
	tosser__forced_mov_knock_up_effect = TowerKnockUpEffect.new(tosser_forced_mov_knock_up_duration, tosser_forced_mov_up_y_accel_amount, StoreOfTowerEffectsUUID.TOSSER_FORCED_MOV_KNOCK_UP_EFFECT)
	tosser__forced_mov_knock_up_effect.is_from_enemy = true
	tosser__forced_mov_knock_up_effect.is_timebound = true


func _initialize_tosser_bomb_explosion_particle_pool_component():
	tosser_bomb_explosion_particle_pool_component = AttackSpritePoolComponent.new()
	tosser_bomb_explosion_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	tosser_bomb_explosion_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	tosser_bomb_explosion_particle_pool_component.source_for_funcs_for_attk_sprite = self
	tosser_bomb_explosion_particle_pool_component.func_name_for_creating_attack_sprite = "_create_tosser_bomb_particle"

func _create_tosser_bomb_particle():
	var particle = SkirmRed_Tosser_Explosion_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_TOWERS
	particle.scale *= 1.0
	
	particle.lifetime = 0.275
	particle.set_anim_speed_based_on_lifetime()
	
	return particle

func request_tosser_bomb_explosion_particle_to_play(arg_position : Vector2, arg_anim_name_to_play : String):
	var particle = tosser_bomb_explosion_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.global_position = arg_position
	particle.lifetime = 0.25
	particle.frame = 0
	particle.set_anim_speed_based_on_lifetime()
	particle.play(arg_anim_name_to_play)
	
	particle.visible = true
	particle.modulate.a = 0.6

##

# calls enemy source method once, with params (placable)
func request_tosser_bomb_cluster_to_shoot(arg_enemy_source, arg_source_pos, arg_dest_pos : Vector2, arg_target_placable, arg_enemy_source_method):
	var angle_of_enemy_to_placable = arg_enemy_source.global_position.angle_to_point(arg_target_placable.global_position)
	var placable_to_displace_to = _get_nearest_placable_between_angles_and_distance_of_source_placable(arg_target_placable, angle_of_enemy_to_placable)
	var will_bombs_displace : bool = is_instance_valid(placable_to_displace_to)
	
	var texture_to_use : Texture
	
	if will_bombs_displace:
		texture_to_use = Tosser_Empowered_Bomb_Pic
	else:
		texture_to_use = Tosser_Bomb_Pic
	
	#
	var bomb_count : int = 4
	var offset_from_center_distance : float = 20.0
	var _first_bomb
	var all_bombs : Array
	
	for i in bomb_count:
		var final_dest_pos = arg_target_placable.global_position + Vector2(offset_from_center_distance, 0).rotated(2*PI * (float(i) / bomb_count))
		var bullet = tosser_arc_bullet_attk_module.construct_bullet(final_dest_pos, arg_source_pos)
		
		bullet.set_texture_as_sprite_frames(texture_to_use)
		bullet.decrease_life_duration = false
		bullet.life_duration = tosser_bomb_detonation_delay_on_landing
		bullet.destroy_self_after_zero_life_distance = false
		
		if _first_bomb == null:
			_first_bomb = bullet
		
		all_bombs.append(bullet)
		tosser_arc_bullet_attk_module.set_up_bullet__add_child_and_emit_signals(bullet)
	
	if is_instance_valid(_first_bomb):
		_first_bomb.connect("on_final_location_reached", self, "_on_final_location_reached__tosser_bullet", [arg_target_placable, placable_to_displace_to, arg_enemy_source, arg_enemy_source_method, will_bombs_displace, all_bombs])



func _on_final_location_reached__tosser_bullet(arg_final_location, bullet, target_placable, placable_to_displace_to, arg_enemy_source, arg_enemy_source_method, arg_is_empowered, arg_all_bombs):
	if is_instance_valid(bullet):
		bullet.connect("on_current_life_duration_expire", self, "_on_tosser_bullet__current_duration_expired", [bullet, target_placable, placable_to_displace_to, arg_enemy_source, arg_enemy_source_method, arg_is_empowered, arg_all_bombs], CONNECT_ONESHOT)
	
	for bomb in arg_all_bombs:
		if is_instance_valid(bomb):
			bomb.decrease_life_duration = true
			bomb.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_TOWERS

func _on_tosser_bullet__current_duration_expired(arg_bullet, target_placable, arg_placable_to_displace_to, arg_enemy_source, arg_enemy_source_method, arg_is_empowered, arg_all_bombs):
	if is_instance_valid(target_placable) and is_instance_valid(target_placable.tower_occupying):
		#arg_enemy_source.call(arg_enemy_source_method, arg_placable_to_displace_to)
		var anim_name_to_play : String
		
		if is_instance_valid(arg_placable_to_displace_to):
			_knock_tower_to_target_placable_and_knockup_stun(target_placable.tower_occupying, arg_placable_to_displace_to)
			anim_name_to_play = tosser_bomb_empowered_animation_name
		else:
			_knock_up_tower_and_stun(target_placable.tower_occupying)
			anim_name_to_play = tosser_bomb_normal_animation_name
		
		for bomb in arg_all_bombs:
			if is_instance_valid(bomb):
				request_tosser_bomb_explosion_particle_to_play(bomb.global_position, anim_name_to_play)

# toss related funcs:

func _get_nearest_placable_between_angles_and_distance_of_source_placable(arg_source_placable, arg_angle_of_enemy_to_placable):
	#var angle_01 = arg_angle_of_enemy_to_placable - tosser_angle_deviation
	#var angle_02 = arg_angle_of_enemy_to_placable + tosser_angle_deviation
	
	var angle_01 = arg_angle_of_enemy_to_placable + tosser_angle_deviation
	var angle_02 = arg_angle_of_enemy_to_placable + (2*PI - tosser_angle_deviation)
	
	#
	var all_placables = map_manager.get_all_placables_based_on_targeting_params(arg_source_placable.global_position, 100, MapManager.PlacableState.UNOCCUPIED, MapManager.SortOrder.CLOSEST, MapManager.RangeState.ANY)
	var angle_param = Targeting.AngleTargetParameters.new()
	angle_param.target_node_2ds = all_placables
	angle_param.source_position = arg_source_placable.global_position
	angle_param.angle_a = angle_01
	angle_param.angle_b = angle_02
	angle_param.max_distance_incl = tosser_distance_for_finding_placables
	
	#
	var placables_between_angles_and_distance = Targeting.get_nodes_within_angle(angle_param)
	var nearest = Targeting.enemies_to_target(placables_between_angles_and_distance, Targeting.CLOSE, 1, arg_source_placable.global_position)
	
	if nearest.size() > 0:
		return nearest[0]
	else:
		return null

func _knock_up_tower_and_stun(arg_tower):
	arg_tower.add_tower_effect(tosser__plain_knock_up_effect)

func _knock_tower_to_target_placable_and_knockup_stun(arg_tower, arg_destination_placable):
	var forced_placable_mov_effect = TowerForcedPlacableMovementEffect.new(arg_destination_placable, arg_tower.current_placable, TowerForcedPlacableMovementEffect.TIME_BASED_MOVEMENT_SPEED, StoreOfTowerEffectsUUID.TOSSER_FORCED_MOV_EFFECT)
	forced_placable_mov_effect.is_from_enemy = true
	forced_placable_mov_effect.time_in_seconds = tosser_forced_mov_to_placable_duration
	
	arg_tower.add_tower_effect(forced_placable_mov_effect)
	arg_tower.add_tower_effect(tosser__forced_mov_knock_up_effect)



########################## DANSUER AND FINISHER THROUGH PLACABLE PATHS

class ThroughPlacableData:
	var placable
	
	var entry_offset : float
	var exit_offset : float
	var exit_position : Vector2
	
	var entry_higher_than_exit : bool
	
	
	var enemy_path_state_id


func _initialize_and_generate_through_placable_data__threaded():
	if !game_elements.is_connected("tree_exiting", self, "_on_game_elements_exit_tree"):
		game_elements.connect("tree_exiting", self, "_on_game_elements_exit_tree")
	
	through_placable_datas_thread = Thread.new()
	through_placable_datas_thread.start(self, "_initialize_and_generate_through_placable_data")

func _initialize_and_generate_through_placable_data(arg_data):
	_defer_curve_changes_for_all_paths()
	
	_generate_through_placable_data__using_current_path_id__for_danseur()
	_generate_through_placable_data__using_current_path_id__for_finisher()
	
	_remove_defer_curve_changes_for_all_paths()

func _defer_curve_changes_for_all_paths():
	for path in blue_path_array.get_spawn_paths__not_copy():
		path.curve_change_defer_conditional_clauses.attempt_insert_clause(path.CurveChangeDeferClauseIds.SKIRMISHER_CALCULATING_CURVE_THROUGH_PLACABLES)
	
	for path in red_path_array.get_spawn_paths__not_copy():
		path.curve_change_defer_conditional_clauses.attempt_insert_clause(path.CurveChangeDeferClauseIds.SKIRMISHER_CALCULATING_CURVE_THROUGH_PLACABLES)
	

func _remove_defer_curve_changes_for_all_paths():
	for path in blue_path_array.get_spawn_paths__not_copy():
		path.curve_change_defer_conditional_clauses.remove_clause(path.CurveChangeDeferClauseIds.SKIRMISHER_CALCULATING_CURVE_THROUGH_PLACABLES)
	
	for path in red_path_array.get_spawn_paths__not_copy():
		path.curve_change_defer_conditional_clauses.remove_clause(path.CurveChangeDeferClauseIds.SKIRMISHER_CALCULATING_CURVE_THROUGH_PLACABLES)
	

## DANSEUR SPECIFIC

func _generate_through_placable_data__using_current_path_id__for_danseur():
	for placable in game_elements.map_manager.get_all_placables():
		if placable.visible:
			_generate_through_placable_data_of_placable__using_default_starting_poses__as_danseur(placable)
	
	for enemy_path in danseur__enemy_path_to__id_to_through_placable_datas.keys():
		
		var id_to_datas_map = danseur__enemy_path_to__id_to_through_placable_datas[enemy_path]
		for datas in id_to_datas_map.values():
			datas.sort_custom(self, "_sort_based_on_entry_offset")
		
		if !danseur__enemy_path_to_curve_ids_already_calculated[enemy_path].has(enemy_path.current_curve_id):
			danseur__enemy_path_to_curve_ids_already_calculated[enemy_path].append(enemy_path.current_curve_id)

func _generate_through_placable_data_of_placable__using_default_starting_poses__as_danseur(arg_placable):
	var all_poses := []
	var top_pos = arg_placable.global_position + Vector2(0, -danseur__starting_side_point_distance_from_placable)
	var bot_pos = arg_placable.global_position + Vector2(0, danseur__starting_side_point_distance_from_placable)
	var left_pos = arg_placable.global_position + Vector2(-danseur__starting_side_point_distance_from_placable, 0)
	var right_pos = arg_placable.global_position + Vector2(danseur__starting_side_point_distance_from_placable, 0)
	
	var NW_pos = arg_placable.global_position + Vector2(-danseur__starting_side_point_distance_from_placable, 0).rotated(PI / 4)
	var NE_pos = arg_placable.global_position + Vector2(-danseur__starting_side_point_distance_from_placable, 0).rotated(3 * PI / 4)
	var SE_pos = arg_placable.global_position + Vector2(-danseur__starting_side_point_distance_from_placable, 0).rotated(5 * PI / 4)
	var SW_pos = arg_placable.global_position + Vector2(-danseur__starting_side_point_distance_from_placable, 0).rotated(7 * PI / 4)
	
	all_poses.append(top_pos)
	all_poses.append(bot_pos)
	all_poses.append(left_pos)
	all_poses.append(right_pos)
	
	all_poses.append(NW_pos)
	all_poses.append(NE_pos)
	all_poses.append(SE_pos)
	all_poses.append(SW_pos)
	
	for path in red_path_array.get_spawn_paths__not_copy(): #paths_for_reds:
		if !_is_id_to_through_placable_data_map__has_current_curve_id__as_danseur(path):
			_create_id_to_through_placable_data_map_using__path_current_curve_id__as_danseur(path, all_poses, arg_placable)


func _is_id_to_through_placable_data_map__has_current_curve_id__as_danseur(path):
	return danseur__enemy_path_to_curve_ids_already_calculated[path].has(path.current_curve_id)

func _create_id_to_through_placable_data_map_using__path_current_curve_id__as_danseur(path, all_poses, arg_placable):
	
	if !danseur__enemy_path_to__id_to_through_placable_datas[path].has(path.current_curve_id):
		danseur__enemy_path_to__id_to_through_placable_datas[path][path.current_curve_id] = []
	
	var path_length = path.curve.get_baked_length()
	
	for pos in all_poses:
		var data = _generate_through_placable_data_of_placable__using_given_pos__as_danseur(arg_placable, path, pos, path_length)
		if data != null:
			danseur__enemy_path_to__id_to_through_placable_datas[path][path.current_curve_id].append(data)


func _generate_through_placable_data_of_placable__using_given_pos__as_danseur(arg_placable, arg_enemy_path : EnemyPath, arg_starting_global_pos : Vector2, arg_path_length : float):
	# poses of in path as ENTRY
	var nearest_pos : Vector2 = arg_enemy_path.curve.get_closest_point(arg_starting_global_pos - arg_enemy_path.global_position)
	var nearest_global_pos = nearest_pos + arg_enemy_path.global_position
	
	if nearest_global_pos.distance_to(arg_placable.global_position) <= danseur__distance_max_from_starting_placable_pos_to_offset:
		var dict = {
			closest_offset_adv_param_metadata_name__entry_offset_pos : nearest_pos
		}

		var closest_offset_adv_param = EnemyPath.ClosestOffsetAdvParams.new()
		closest_offset_adv_param.obj_func_source = self
		closest_offset_adv_param.func_predicate = "_test_on_closest_offset_adv_params__as_danseur"
		closest_offset_adv_param.metadata = dict
		
		#
		
		var angle : float = nearest_global_pos.angle_to_point(arg_placable.global_position)
		var valid_offset_and_pos = arg_enemy_path.get_closest_offset_and_pos_in_a_line__global_source_pos(danseur__interval_magnitude, danseur__distance_max_from_placable_center_to_ending_offset, angle, arg_placable.global_position, closest_offset_adv_param)
		
		if valid_offset_and_pos != null:
			var valid_offset = valid_offset_and_pos[0]
			var valid_pos = valid_offset_and_pos[1]
			
			if _check_if_valid_offset_meets_requirements__as_danseur(valid_offset, arg_path_length):
				var through_placable_data = ThroughPlacableData.new()
				through_placable_data.placable = arg_placable
				through_placable_data.entry_offset = arg_enemy_path.curve.get_closest_offset(nearest_pos)
				through_placable_data.exit_offset = valid_offset
				through_placable_data.exit_position = valid_pos
				through_placable_data.entry_higher_than_exit = through_placable_data.entry_offset > valid_offset
				
				return through_placable_data
	
	return null

# closest_pos = closest pos of path from test pos. same in meaning to candidate_pos
func _test_on_closest_offset_adv_params__as_danseur(arg_test_pos, arg_source_pos, arg_max_distance_of_test_to_source, arg_closest_pos : Vector2, arg_test_to_source_dist, arg_metadata):
	return arg_closest_pos.distance_to(arg_metadata[closest_offset_adv_param_metadata_name__entry_offset_pos]) >= danseur__distance_min_of_ending_offset_to_entry_offset

func _check_if_valid_offset_meets_requirements__as_danseur(arg_offset : float, arg_enemy_path_length : float):
	return arg_offset > (arg_enemy_path_length * danseur__min_entry_unit_offset) and arg_offset < (arg_enemy_path_length * danseur__max_exit_unit_offset)


func get_next_through_placable_data_based_on_curr__as_danseur(arg_curr_offset, arg_path):
	var allowance = 35.0
	
	var datas : Array = danseur__enemy_path_to__id_to_through_placable_datas[arg_path][arg_path.current_curve_id]
	var i = datas.bsearch_custom(arg_curr_offset + allowance, self, "_bsearch_compare_for_entry_offset")
	
	if datas.size() > i:
		return datas[i]
	else:
		return null



## FINISHER SPECIFIC

func _generate_through_placable_data__using_current_path_id__for_finisher():
	for placable in game_elements.map_manager.get_all_placables():
		if placable.visible:
			_generate_through_placable_data_of_placable__using_default_starting_poses__as_finisher(placable)
	
	for enemy_path in finisher__enemy_path_to__id_to_through_placable_datas.keys():
		
		var id_to_datas_map = finisher__enemy_path_to__id_to_through_placable_datas[enemy_path]
		#for datas in id_to_datas_map.values():
		#	datas.sort_custom(self, "_sort_based_on_entry_offset")
		var datas = id_to_datas_map[enemy_path.current_curve_id]
		datas.sort_custom(self, "_sort_based_on_entry_offset")
		
		if !finisher__enemy_path_to_curve_ids_already_calculated[enemy_path].has(enemy_path.current_curve_id):
			finisher__enemy_path_to_curve_ids_already_calculated[enemy_path].append(enemy_path.current_curve_id)


func _generate_through_placable_data_of_placable__using_default_starting_poses__as_finisher(arg_placable):
	var all_poses := []
	var top_pos = arg_placable.global_position + Vector2(0, -finisher__starting_side_point_distance_from_placable)
	var bot_pos = arg_placable.global_position + Vector2(0, finisher__starting_side_point_distance_from_placable)
	var left_pos = arg_placable.global_position + Vector2(-finisher__starting_side_point_distance_from_placable, 0)
	var right_pos = arg_placable.global_position + Vector2(finisher__starting_side_point_distance_from_placable, 0)
	
	var NW_pos = arg_placable.global_position + Vector2(-finisher__starting_side_point_distance_from_placable, 0).rotated(PI / 4)
	var NE_pos = arg_placable.global_position + Vector2(-finisher__starting_side_point_distance_from_placable, 0).rotated(3 * PI / 4)
	var SE_pos = arg_placable.global_position + Vector2(-finisher__starting_side_point_distance_from_placable, 0).rotated(5 * PI / 4)
	var SW_pos = arg_placable.global_position + Vector2(-finisher__starting_side_point_distance_from_placable, 0).rotated(7 * PI / 4)
	
	all_poses.append(top_pos)
	all_poses.append(bot_pos)
	all_poses.append(left_pos)
	all_poses.append(right_pos)
	
	all_poses.append(NW_pos)
	all_poses.append(NE_pos)
	all_poses.append(SE_pos)
	all_poses.append(SW_pos)
	
	for path in red_path_array.get_spawn_paths__not_copy(): #paths_for_reds:
		if !_is_id_to_through_placable_data_map__has_current_curve_id__as_finisher(path):
			_create_id_to_through_placable_data_map_using__path_current_curve_id__as_finisher(path, all_poses, arg_placable)

func _is_id_to_through_placable_data_map__has_current_curve_id__as_finisher(path):
	return finisher__enemy_path_to_curve_ids_already_calculated[path].has(path.current_curve_id)

func _create_id_to_through_placable_data_map_using__path_current_curve_id__as_finisher(path, all_poses, arg_placable):
	if !finisher__enemy_path_to__id_to_through_placable_datas[path].has(path.current_curve_id):
		finisher__enemy_path_to__id_to_through_placable_datas[path][path.current_curve_id] = []
	
	var path_length = path.curve.get_baked_length()
	
	for pos in all_poses:
		var data = _generate_through_placable_data_of_placable__using_given_pos__as_finisher(arg_placable, path, pos, path_length)
		if data != null:
			finisher__enemy_path_to__id_to_through_placable_datas[path][path.current_curve_id].append(data)


func _generate_through_placable_data_of_placable__using_given_pos__as_finisher(arg_placable, arg_enemy_path : EnemyPath, arg_starting_global_pos : Vector2, arg_path_length : float):
	# poses of in path as ENTRY
	var nearest_pos : Vector2 = arg_enemy_path.curve.get_closest_point(arg_starting_global_pos - arg_enemy_path.global_position)
	var nearest_global_pos = nearest_pos + arg_enemy_path.global_position
	
	if nearest_global_pos.distance_to(arg_placable.global_position) <= finisher__distance_max_from_starting_placable_pos_to_offset:
		var dict = {
			closest_offset_adv_param_metadata_name__entry_offset_pos : nearest_pos
		}

		var closest_offset_adv_param = EnemyPath.ClosestOffsetAdvParams.new()
		closest_offset_adv_param.obj_func_source = self
		closest_offset_adv_param.func_predicate = "_test_on_closest_offset_adv_params__as_finisher"
		closest_offset_adv_param.metadata = dict
		
		#
		
		var angle : float = nearest_global_pos.angle_to_point(arg_placable.global_position)
		var valid_offset_and_pos = arg_enemy_path.get_closest_offset_and_pos_in_a_line__global_source_pos(finisher__interval_magnitude, finisher__distance_max_from_placable_center_to_ending_offset, angle, arg_placable.global_position, closest_offset_adv_param)
		
		if valid_offset_and_pos != null:
			var valid_offset = valid_offset_and_pos[0]
			var valid_pos = valid_offset_and_pos[1]
			
			if _check_if_valid_offset_meets_requirements__as_finisher(valid_offset, arg_path_length):
				var through_placable_data = ThroughPlacableData.new()
				through_placable_data.placable = arg_placable
				through_placable_data.entry_offset = arg_enemy_path.curve.get_closest_offset(nearest_pos)
				through_placable_data.exit_offset = valid_offset
				through_placable_data.exit_position = valid_pos
				through_placable_data.entry_higher_than_exit = through_placable_data.entry_offset > valid_offset
				
				return through_placable_data
	
	return null

# closest_pos = closest pos of path from test pos. same in meaning to candidate_pos
func _test_on_closest_offset_adv_params__as_finisher(arg_test_pos, arg_source_pos, arg_max_distance_of_test_to_source, arg_closest_pos : Vector2, arg_test_to_source_dist, arg_metadata):
	return arg_closest_pos.distance_to(arg_metadata[closest_offset_adv_param_metadata_name__entry_offset_pos]) >= finisher__distance_min_of_ending_offset_to_entry_offset

func _check_if_valid_offset_meets_requirements__as_finisher(arg_offset : float, arg_enemy_path_length : float):
	return arg_offset > (arg_enemy_path_length * finisher__min_entry_unit_offset) and arg_offset < (arg_enemy_path_length * finisher__max_exit_unit_offset)


#func get_next_through_placable_data_based_on_curr__as_finisher(arg_curr_offset, arg_path):
#	var allowance = 10.0
#
#	var datas : Array = finisher__enemy_path_to_through_placable_datas[arg_path]
#	var i = datas.bsearch_custom(arg_curr_offset + allowance, self, "_bsearch_compare_for_entry_offset")
#
#	if datas.size() > i:
#		return datas[i]
#	else:
#		return null

func get_next_through_placable_data_based_on_curr__as_finisher(arg_curr_offset, arg_path):
	var allowance = 35.0
	
	var datas : Array = finisher__enemy_path_to__id_to_through_placable_datas[arg_path][arg_path.current_curve_id]
	var i = datas.bsearch_custom(arg_curr_offset + allowance, self, "_bsearch_compare_for_entry_offset")
	
	if datas.size() > i:
		return datas[i]
	else:
		return null

# SHARED BY DANSEUR/FINISHER Pathing/Dashing
func _on_game_elements_exit_tree():
	through_placable_datas_thread.wait_to_finish()

func _sort_based_on_entry_offset(a : ThroughPlacableData, b : ThroughPlacableData):
	return a.entry_offset < b.entry_offset

func _bsearch_compare_for_entry_offset(a : ThroughPlacableData, b : float):
	return a.entry_offset < b


########## HOMERUNNER SPECIFIC

func _initialize_homerunner_effects():
	var ap_modi_uuid = StoreOfEnemyEffectsUUID.HOMERUNNER_BLUE_AP_EFFECT
	var ap_modi = FlatModifier.new(ap_modi_uuid)
	ap_modi.flat_modifier = homerunner_blue_active_ap_bonus
	
	homerunner_ap_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ABILITY_POTENCY, ap_modi, ap_modi_uuid)
	homerunner_ap_effect.is_from_enemy = true
	homerunner_ap_effect.is_clearable = false
	
	#homerunner_blue_effects.append(homerunner_ap_effect)
	homerunner_blue_effects__for_with_abilities.append(homerunner_ap_effect)
	#
	
	var shield_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.HOMERUNNER_BLUE_SHIELD_EFFECT)
	shield_modi.percent_amount = homerunner_blue_shield_health_ratio_for_no_ap_used
	shield_modi.percent_based_on = PercentType.MAX
	
	homerunner_shield_effect = EnemyShieldEffect.new(shield_modi, StoreOfEnemyEffectsUUID.HOMERUNNER_BLUE_SHIELD_EFFECT)
	homerunner_shield_effect.is_timebound = false
	homerunner_shield_effect.is_from_enemy = true
	
	#homerunner_blue_effects.append(homerunner_shield_effect)
	homerunner_blue_effects__for_none.append(homerunner_shield_effect)
	
	#
	var rev_heal_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.HOMERUNNER_RED_GRANTED_REVIVE_HEAL_EFFECT)
	rev_heal_modi.percent_amount = homerunner_red_active_revive_heal_health_max_percent
	rev_heal_modi.percent_based_on = PercentType.MAX
	
	var rev_heal_effect = EnemyHealEffect.new(rev_heal_modi, StoreOfEnemyEffectsUUID.HOMERUNNER_RED_GRANTED_REVIVE_HEAL_EFFECT)
	
	homerunner_revive_effect = EnemyReviveEffect.new(rev_heal_effect, StoreOfEnemyEffectsUUID.HOMERUNNER_RED_GRANTED_REVIVE_EFFECT, homerunner_red_active_revive_delay)
	homerunner_revive_effect.is_timebound = false
	homerunner_revive_effect.is_from_enemy = true
	
	homerunner_red_effects.append(homerunner_revive_effect)


func _on_flag_implanted_by_homerunner(arg_flag_pos_plus_offset : Vector2, arg_flag_facing_w : bool, arg_color_type : int):
	if arg_color_type == AbstractSkirmisherEnemy.ColorType.BLUE:
		_on_blue_flag_implanted_by_homerunner(arg_flag_pos_plus_offset, arg_flag_facing_w)
	elif arg_color_type == AbstractSkirmisherEnemy.ColorType.RED:
		_on_red_flag_implanted_by_homerunner(arg_flag_pos_plus_offset, arg_flag_facing_w)

func _on_blue_flag_implanted_by_homerunner(arg_flag_pos_plus_offset : Vector2, arg_flag_facing_w : bool):
	if game_elements.stage_round_manager.round_started:
		_current_active_blue_homerunner_flag = _create_flag_at_pos(arg_flag_pos_plus_offset, arg_flag_facing_w, true)
		_is_blue_flag_active = true
		_create_and_add_blue_effect_to_enemies_and_enemy_manager()
		skirmisher_node_draw.show_blue_flag_aura(arg_flag_pos_plus_offset)

func _create_and_add_blue_effect_to_enemies_and_enemy_manager():
	_add_blue_effects_to_blue_skirmishers()
	#_add_effects_to_all_skirmishers_with_color_type(homerunner_blue_effects, AbstractSkirmisherEnemy.ColorType.BLUE)
	
#

func _on_red_flag_implanted_by_homerunner(arg_flag_pos_plus_offset : Vector2, arg_flag_facing_w : bool):
	if game_elements.stage_round_manager.round_started:
		_current_active_red_homerunner_flag = _create_flag_at_pos(arg_flag_pos_plus_offset, arg_flag_facing_w, false)
		_is_red_flag_active = true
		
		_create_and_add_red_effect_to_enemies_and_enemy_manager()
		skirmisher_node_draw.show_red_flag_aura(arg_flag_pos_plus_offset)

func _create_and_add_red_effect_to_enemies_and_enemy_manager():
	_add_effects_to_all_skirmishers_with_color_type(homerunner_red_effects, AbstractSkirmisherEnemy.ColorType.RED)

# commons

func _create_flag_at_pos(arg_flag_pos : Vector2, arg_flag_facing_w : bool, arg_flag_is_blue : bool):
	var flag_sprite = Sprite.new()
	
	if arg_flag_is_blue:
		if arg_flag_facing_w:
			flag_sprite.texture = Homerunner_BlueFlag_W_Pic
		else:
			flag_sprite.texture = Homerunner_BlueFlag_E_Pic
	else:
		if arg_flag_facing_w:
			flag_sprite.texture = Homerunner_RedFlag_W_Pic
		else:
			flag_sprite.texture = Homerunner_RedFlag_E_Pic
	
	flag_sprite.z_index = ZIndexStore.PARTICLE_EFFECTS
	flag_sprite.global_position = arg_flag_pos
	CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(flag_sprite)
	
	return flag_sprite

func _add_effects_to_all_skirmishers_with_color_type(arg_effects : Array, arg_color_type : int):
	for enemy in enemy_manager.get_all_enemies():
		if enemy is AbstractSkirmisherEnemy and enemy.skirmisher_path_color_type == arg_color_type:
			_add_effects_to_enemy(arg_effects, enemy)

func _add_effects_to_enemy(arg_effects, arg_enemy : AbstractSkirmisherEnemy):
	for effect in arg_effects:
		arg_enemy._add_effect(effect)
	
	arg_enemy.set_show_emp_particle_layer(true)


func _add_blue_effects_to_blue_skirmishers():
	for enemy in enemy_manager.get_all_enemies():
		if enemy is AbstractSkirmisherEnemy and enemy.skirmisher_path_color_type == AbstractSkirmisherEnemy.ColorType.BLUE:
			_add_blue_effects_to_blue_skirmisher(enemy)

func _add_blue_effects_to_blue_skirmisher(arg_enemy : AbstractSkirmisherEnemy):
	if arg_enemy.is_blue_and_benefits_from_ap:
		for effect in homerunner_blue_effects__for_with_abilities:
			arg_enemy._add_effect(effect)
		
	else:
		for effect in homerunner_blue_effects__for_none:
			arg_enemy._add_effect(effect)
	
	arg_enemy.set_show_emp_particle_layer(true)


#### Node draw related

func _initialize_skirmisher_node_draw():
	skirmisher_node_draw = SkirmisherNodeDrawer_Scene.instance()
	skirmisher_node_draw.z_index = ZIndexStore.ABOVE_MAP_ENVIRONMENT
	
	CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(skirmisher_node_draw)


#### Spawn flag loc related

func _initialize_skirmisher_spawn_loc_flags():
	_initialize_blue_flag_emp_particle_pool_component()
	_initialize_red_flag_emp_particle_pool_component()
	
	spawn_loc_flags_emp_particle_timer = Timer.new()
	spawn_loc_flags_emp_particle_timer.connect("timeout", self, "_on_particle_for_spawn_loc_flags_timeout", [], CONNECT_PERSIST)
	spawn_loc_flags_emp_particle_timer.one_shot = false
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(spawn_loc_flags_emp_particle_timer)

func _initialize_blue_flag_emp_particle_pool_component():
	blue_flag_emp_particle_pool_compo = AttackSpritePoolComponent.new()
	blue_flag_emp_particle_pool_compo.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	blue_flag_emp_particle_pool_compo.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	blue_flag_emp_particle_pool_compo.source_for_funcs_for_attk_sprite = self
	blue_flag_emp_particle_pool_compo.func_name_for_creating_attack_sprite = "_create_blue_flag_emp_particle"

func _create_blue_flag_emp_particle():
	var particle = CenterBasedAttackSprite_Scene.instance()
	
	particle.texture_to_use = BlueFlagEmpParticle_Pic
	
	particle.speed_accel_towards_center = 100
	particle.initial_speed_towards_center = -50
	particle.max_speed_towards_center = -20
	
	particle.min_starting_distance_from_center = 15
	particle.max_starting_distance_from_center = 15
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.modulate.a = 0.75
	
	return particle

func request_blue_flag_particles_to_play(arg_position : Vector2, arg_count : int = particle_count_per_flag_per_show):
	for i in arg_count:
		var particle = blue_flag_emp_particle_pool_compo.get_or_create_attack_sprite_from_pool()
		
		particle.center_pos_of_basis = arg_position
		particle.lifetime = 0.85
		
		particle.visible = true
		particle.reset_for_another_use()



func _initialize_red_flag_emp_particle_pool_component():
	red_flag_emp_particle_pool_compo = AttackSpritePoolComponent.new()
	red_flag_emp_particle_pool_compo.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	red_flag_emp_particle_pool_compo.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	red_flag_emp_particle_pool_compo.source_for_funcs_for_attk_sprite = self
	red_flag_emp_particle_pool_compo.func_name_for_creating_attack_sprite = "_create_red_flag_emp_particle"

func _create_red_flag_emp_particle():
	var particle = CenterBasedAttackSprite_Scene.instance()
	
	particle.texture_to_use = RedFlagEmpParticle_Pic
	
	particle.speed_accel_towards_center = 100
	particle.initial_speed_towards_center = -50
	particle.max_speed_towards_center = -20
	
	particle.min_starting_distance_from_center = 15
	particle.max_starting_distance_from_center = 15
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.modulate.a = 0.75
	
	return particle

func request_red_flag_particles_to_play(arg_position : Vector2, arg_count : int = particle_count_per_flag_per_show):
	for i in arg_count:
		var particle = red_flag_emp_particle_pool_compo.get_or_create_attack_sprite_from_pool()
		
		particle.center_pos_of_basis = arg_position
		particle.lifetime = 0.85
		
		particle.visible = true
		particle.reset_for_another_use()
	

##########

func _on_round_end(arg_stageround):
	blaster_bullet_attk_module.on_round_end()
	artillery_arc_bullet_attk_module.on_round_end()
	danseur_bullet_attk_module.on_round_end()
	
	finisher_execute_bullet_attk_module.on_round_end()
	finisher_normal_bullet_attk_module.on_round_end()
	
	tosser_arc_bullet_attk_module.on_round_end()
	
	#
	if is_instance_valid(_current_active_blue_homerunner_flag):
		_current_active_blue_homerunner_flag.queue_free()
	_is_blue_flag_active = false
	
	if is_instance_valid(_current_active_red_homerunner_flag):
		_current_active_red_homerunner_flag.queue_free()
	_is_red_flag_active = false
	
	skirmisher_node_draw.hide_blue_flag_aura()
	skirmisher_node_draw.hide_red_flag_aura()
	
	#
	
	_show_flags_if_curr_stageround_is_appropriate(arg_stageround)
	
	#
	
	blue_path_array.reset_path_indices()
	red_path_array.reset_path_indices()
	
	#
	
	_on_round_end__for_artillery_targets_purpose()

func _on_round_start(arg_stageround):
	if _is_showing_spawn_loc_flags:
		_is_showing_spawn_loc_flags = false
		_is_spawn_loc_blue_flags_empowered = false
		_is_spawn_loc_red_flags_empowered = false
		
		spawn_loc_flags_emp_particle_timer.stop()
	
	_on_round_start__for_artillery_targets_purpose()

func _show_flags_if_curr_stageround_is_appropriate(arg_stageround):
	_is_showing_spawn_loc_flags = true
	
	
#	if arg_stageround.is_stageround_id_equal_than_second_param("01", arg_stageround.id):
#		#temp
#		_show_blue_flags__emp()
#		#_show_red_flags__emp()
#
#	elif arg_stageround.is_stageround_id_equal_than_second_param("02", arg_stageround.id):
#		#temp
#		#_show_blue_flags__normal()
#		_show_red_flags__normal()
#
	if arg_stageround.is_stageround_id_equal_than_second_param("41", arg_stageround.id):
		_show_blue_flags__normal()
		
	elif arg_stageround.is_stageround_id_equal_than_second_param("51", arg_stageround.id):
		_show_red_flags__normal()
		
	elif arg_stageround.is_stageround_id_equal_than_second_param("61", arg_stageround.id):
		_show_blue_flags__normal()
		_show_red_flags__normal()
		
	elif arg_stageround.is_stageround_id_equal_than_second_param("71", arg_stageround.id):
		_show_blue_flags__emp()
		_show_red_flags__normal()
		
	elif arg_stageround.is_stageround_id_equal_than_second_param("81", arg_stageround.id):
		_show_blue_flags__normal()
		_show_red_flags__emp()
		
	elif arg_stageround.is_stageround_id_equal_than_second_param("91", arg_stageround.id):
		_show_blue_flags__emp()
		_show_red_flags__emp()
		
	else:
		_is_showing_spawn_loc_flags = false


func _show_blue_flags__normal():
	for flag in blue_spawn_loc_flags:
		#flag.visible = true
		game_elements.map_manager.base_map.attempt_make_flag_visible_following_conditions(flag)

func _show_red_flags__normal():
	for flag in red_spawn_loc_flags:
		#flag.visible = true
		game_elements.map_manager.base_map.attempt_make_flag_visible_following_conditions(flag)


func _show_blue_flags__emp():
	_is_spawn_loc_blue_flags_empowered = true
	_show_blue_flags__normal()
	_start_particle_for_spawn_loc_flag_timer()

func _show_red_flags__emp():
	_is_spawn_loc_red_flags_empowered = true
	_show_red_flags__normal()
	_start_particle_for_spawn_loc_flag_timer()



func _start_particle_for_spawn_loc_flag_timer():
	if spawn_loc_flags_emp_particle_timer.time_left == 0:
		spawn_loc_flags_emp_particle_timer.start(delay_delta_per_particle)

func _on_particle_for_spawn_loc_flags_timeout():
	if _is_spawn_loc_blue_flags_empowered:
		for flag in blue_spawn_loc_flags:
			if flag.visible:
				request_blue_flag_particles_to_play(flag.global_position)
	
	if _is_spawn_loc_red_flags_empowered:
		for flag in red_spawn_loc_flags:
			if flag.visible:
				request_red_flag_particles_to_play(flag.global_position)


###########################################

func _on_curve_of_original_path_changed(arg_new_curve, arg_curve_id, arg_original_path, arg_red_version_of_path):
	var reversed_curve = arg_original_path.get_copy_of_curve(true)
	arg_red_version_of_path.set_curve_and_id(reversed_curve, arg_curve_id)

func _on_enemy_path_is_used_and_active_changed(arg_val, arg_original_path, arg_red_version_path):
	arg_red_version_path.is_used_and_active = arg_val



func _on_enemy_manager_spawn_pattern_changed(arg_pattern_type_id):
	_update_spawn_pattern_based_on_enemy_mngr_pattern()

func _update_spawn_pattern_based_on_enemy_mngr_pattern():
	if enemy_manager.current_path_to_spawn_pattern == game_elements.EnemyManager.PathToSpawnPattern.SWITCH_PER_SPAWN:
		enemy_manager.current_path_to_spawn_pattern= game_elements.EnemyManager.PathToSpawnPattern.NO_CHANGE

func _on_curve_of_red_path_changed(arg_new_curve, arg_curve_id, arg_red_path):
	_defer_curve_changes_for_all_paths()
	
	if !_is_id_to_through_placable_data_map__has_current_curve_id__as_danseur(arg_red_path):
		_generate_through_placable_data__using_current_path_id__for_danseur()
	
	if !_is_id_to_through_placable_data_map__has_current_curve_id__as_finisher(arg_red_path):
		_generate_through_placable_data__using_current_path_id__for_finisher()
	
	_remove_defer_curve_changes_for_all_paths()

