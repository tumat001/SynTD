extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")
const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const SizeAdaptingAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/SizeAdaptingAttackSprite.gd")
const SizeAdaptingAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/SizeAdaptingAttackSprite.tscn")

#

var game_elements : GameElements
var enemy_manager

#

const enemy_id_to_method_call_map : Dictionary = {
	EnemyConstants.Enemies.CHARGE : "_before_enemy_is_spawned__charge",
	EnemyConstants.Enemies.GRANDMASTER : "_before_enemy_is_spawned__grandmaster",
	
}

#

var trail_for_charge_speed_boost_component : MultipleTrailsForNodeComponent
const charge_trail_color := Color(254/255.0, 224/255.0, 134/255.0, 0.65)
const trail_for_charge_offset := Vector2(0, -6)


var trail_for_grandmaster_speed_boost_component : MultipleTrailsForNodeComponent
const grandmaster_trail_color := Color(51/255.0, 1/255.0, 109/255.0, 0.65)
const trail_for_grandmaster_offset := Vector2(0, -6)

var grandmaster_shield_particle_pool_component : AttackSpritePoolComponent


#

func _apply_faction_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
		enemy_manager = arg_game_elements.enemy_manager
	
	if trail_for_charge_speed_boost_component == null:
		_initialize_trail_for_charge_speed_boost_component()
		
		_initialize_trail_for_grandmaster_speed_boost_component()
		_initialize_grandmaster_shield_particle_pool_components()
	
	if !enemy_manager.is_connected("before_enemy_spawned", self, "_before_enemy_is_spawned"):
		enemy_manager.connect("before_enemy_spawned", self, "_before_enemy_is_spawned", [], CONNECT_PERSIST)
	

#

func _remove_faction_from_game_elements(arg_game_elements : GameElements):
	if enemy_manager.is_connected("before_enemy_spawned", self, "_before_enemy_is_spawned"):
		enemy_manager.disconnect("before_enemy_spawned", self, "_before_enemy_is_spawned")
	

#######

func _initialize_trail_for_charge_speed_boost_component():
	trail_for_charge_speed_boost_component = MultipleTrailsForNodeComponent.new()
	trail_for_charge_speed_boost_component.node_to_host_trails = CommsForBetweenScenes.current_game_elements__node_hoster_below_screen_effects_mngr
	trail_for_charge_speed_boost_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	#trail_for_charge_speed_boost_component.connect("on_trail_before_attached_to_node", self, "_trail_for_charge_before_attached_to_node", [], CONNECT_PERSIST)
	trail_for_charge_speed_boost_component.connect("on_trail_constructed", self, "_on_trail_for_charge_constructed", [], CONNECT_PERSIST)

func _on_trail_for_charge_constructed(arg_trail):
	arg_trail.trail_offset = trail_for_charge_offset
	arg_trail.set_to_idle_and_available_if_node_is_not_visible = true
	
	arg_trail.trail_color = charge_trail_color
	arg_trail.max_trail_length = 14
	arg_trail.width = 4
	
	arg_trail.z_index_modifier = -1

#func _trail_for_charge_before_attached_to_node(arg_trail, arg_node):
#	pass



func _initialize_trail_for_grandmaster_speed_boost_component():
	trail_for_grandmaster_speed_boost_component = MultipleTrailsForNodeComponent.new()
	trail_for_grandmaster_speed_boost_component.node_to_host_trails = CommsForBetweenScenes.current_game_elements__node_hoster_below_screen_effects_mngr
	trail_for_grandmaster_speed_boost_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	#trail_for_grandmaster_speed_boost_component.connect("on_trail_before_attached_to_node", self, "_trail_for_charge_before_attached_to_node", [], CONNECT_PERSIST)
	trail_for_grandmaster_speed_boost_component.connect("on_trail_constructed", self, "_on_trail_for_grandmaster_constructed", [], CONNECT_PERSIST)

func _on_trail_for_grandmaster_constructed(arg_trail):
	arg_trail.trail_offset = trail_for_charge_offset
	arg_trail.set_to_idle_and_available_if_node_is_not_visible = true
	
	arg_trail.trail_color = grandmaster_trail_color
	arg_trail.max_trail_length = 14
	arg_trail.width = 4
	
	arg_trail.z_index_modifier = -1

##

func _before_enemy_is_spawned(arg_enemy):
	if enemy_id_to_method_call_map.has(arg_enemy.enemy_id):
		call(enemy_id_to_method_call_map[arg_enemy.enemy_id], arg_enemy)

func _before_enemy_is_spawned__charge(arg_enemy):
	if !arg_enemy.is_connected("speed_boost_started", self, "_on_charge_speed_boost_started"):
		arg_enemy.connect("speed_boost_started", self, "_on_charge_speed_boost_started", [arg_enemy])

func _before_enemy_is_spawned__grandmaster(arg_enemy):
	if !arg_enemy.is_connected("speed_boost_started", self, "_on_grandmaster_speed_boost_started"):
		arg_enemy.connect("speed_boost_started", self, "_on_grandmaster_speed_boost_started", [arg_enemy])



#

func _on_charge_speed_boost_started(arg_enemy):
	var trail = trail_for_charge_speed_boost_component.create_trail_for_node(arg_enemy)
	
	arg_enemy.connect("speed_boost_ended", self, "_on_charge_speed_boost_ended", [trail], CONNECT_ONESHOT)

func _on_charge_speed_boost_ended(arg_trail):
	arg_trail.disable_one_time()


func _on_grandmaster_speed_boost_started(arg_enemy):
	var trail = trail_for_grandmaster_speed_boost_component.create_trail_for_node(arg_enemy)
	var shield_particle = create_shield_for_grandmaster(arg_enemy)
	
	arg_enemy.connect("speed_boost_ended", self, "_on_grandmaster_speed_boost_ended", [trail, shield_particle], CONNECT_ONESHOT)

func _on_grandmaster_speed_boost_ended(arg_trail, arg_shield_particle):
	arg_trail.disable_one_time()


###

func _initialize_grandmaster_shield_particle_pool_components():
	grandmaster_shield_particle_pool_component = AttackSpritePoolComponent.new()
	grandmaster_shield_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	grandmaster_shield_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	grandmaster_shield_particle_pool_component.source_for_funcs_for_attk_sprite = self
	grandmaster_shield_particle_pool_component.func_name_for_creating_attack_sprite = "_create_grandmaster_shield_particle"
	

func _create_grandmaster_shield_particle():
	var particle = SizeAdaptingAttackSprite_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	particle.stop_process_at_invisible = true
	
	particle.texture_to_use = preload("res://EnemyRelated/EnemyTypes/Type_Expert/Grandmaster/Assets/ShieldParticle/Grandmaster_ShieldParticle.png")
	
	particle.modulate.a = 0.65
	
	particle.has_lifetime = false
	particle.lifetime = 1.0
	
	particle.node_to_follow_to__override_disp_per_sec__offset = Vector2(0, -6)
	particle.adapt_ratio = 1.5
	
	return particle


func create_shield_for_grandmaster(arg_enemy):
	var particle = grandmaster_shield_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.size_adapting_to = arg_enemy
	particle.node_to_follow_to__override_disp_per_sec = arg_enemy
	
	particle.has_lifetime = false
	particle.change_config_based_on_size_adapting_to()
	
	return particle
	

func remove_shield_for_grandmaster(arg_shield_particle):
	arg_shield_particle.visible = false
	

func break_and_remove_shield_for_grandmaster(arg_shield_particle, arg_pos_of_grandmaster):
	remove_shield_for_grandmaster(arg_shield_particle)
	_play_grandmaster_shield_break_particles(arg_pos_of_grandmaster)

func _play_grandmaster_shield_break_particles(arg_pos):
	pass

