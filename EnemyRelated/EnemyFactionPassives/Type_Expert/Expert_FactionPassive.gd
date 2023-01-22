extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")
const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const SizeAdaptingAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/SizeAdaptingAttackSprite.gd")
const SizeAdaptingAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/SizeAdaptingAttackSprite.tscn")
const CenterBasedAttackParticle = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd")
const CenterBasedAttackParticle_Scene = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.tscn")

#

var game_elements : GameElements
var enemy_manager

var non_essential_rng : RandomNumberGenerator

#

var enemy_id_to_method_call_map : Dictionary = {
	EnemyConstants.Enemies.CHARGE : "_before_enemy_is_spawned__charge",
	EnemyConstants.Enemies.GRANDMASTER : "_before_enemy_is_spawned__grandmaster",
	EnemyConstants.Enemies.ENCHANTRESS : "_before_enemy_is_spawned__enchantress"
}

#

var trail_for_charge_speed_boost_component : MultipleTrailsForNodeComponent
const charge_trail_color := Color(254/255.0, 224/255.0, 134/255.0, 0.65)
const trail_for_charge_offset := Vector2(0, -6)


var trail_for_grandmaster_speed_boost_component : MultipleTrailsForNodeComponent
const grandmaster_trail_color := Color(51/255.0, 1/255.0, 109/255.0, 0.65)
const trail_for_grandmaster_offset := Vector2(0, -6)

var grandmaster_shield_particle_pool_component : AttackSpritePoolComponent
var grandmaster_shield_break_fragment_particle_pool_component : AttackSpritePoolComponent

var enchantress_shield_particle_pool_component : AttackSpritePoolComponent
var enchantress_shield_break_fragment_particle_pool_component : AttackSpritePoolComponent


#

func _apply_faction_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
		enemy_manager = arg_game_elements.enemy_manager
		non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	if trail_for_charge_speed_boost_component == null:
		_initialize_trail_for_charge_speed_boost_component()
		
		_initialize_trail_for_grandmaster_speed_boost_component()
		_initialize_all_grandmaster_particle_pool_components()
		
		_initialize_all_enchantress_particle_pool_components()
	
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
		arg_enemy.connect("grandmaster_shield_effect_added", self, "_on_grandmaster_shield_effect_added", [arg_enemy])


#

func _on_charge_speed_boost_started(arg_enemy):
	var trail = trail_for_charge_speed_boost_component.create_trail_for_node(arg_enemy)
	
	arg_enemy.connect("speed_boost_ended", self, "_on_charge_speed_boost_ended", [trail], CONNECT_ONESHOT)

func _on_charge_speed_boost_ended(arg_trail):
	arg_trail.disable_one_time()


func _on_grandmaster_speed_boost_started(arg_enemy):
	var trail = trail_for_grandmaster_speed_boost_component.create_trail_for_node(arg_enemy)
	
	arg_enemy.connect("speed_boost_ended", self, "_on_grandmaster_speed_boost_ended", [trail], CONNECT_ONESHOT)

func _on_grandmaster_speed_boost_ended(arg_trail):
	arg_trail.disable_one_time()


###

func _initialize_all_grandmaster_particle_pool_components():
	grandmaster_shield_particle_pool_component = AttackSpritePoolComponent.new()
	grandmaster_shield_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	grandmaster_shield_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	grandmaster_shield_particle_pool_component.source_for_funcs_for_attk_sprite = self
	grandmaster_shield_particle_pool_component.func_name_for_creating_attack_sprite = "_create_grandmaster_shield_particle"
	
	grandmaster_shield_break_fragment_particle_pool_component = AttackSpritePoolComponent.new()
	grandmaster_shield_break_fragment_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	grandmaster_shield_break_fragment_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	grandmaster_shield_break_fragment_particle_pool_component.source_for_funcs_for_attk_sprite = self
	grandmaster_shield_break_fragment_particle_pool_component.func_name_for_creating_attack_sprite = "_create_grandmaster_shield_break_fragment_particle"
	

func _create_grandmaster_shield_particle():
	var particle = SizeAdaptingAttackSprite_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	particle.stop_process_at_invisible = true
	
	particle.texture_to_use = preload("res://EnemyRelated/EnemyTypes/Type_Expert/Grandmaster/Assets/ShieldParticle/Grandmaster_ShieldParticle.png")
	
	particle.modulate.a = 0.65
	
	particle.has_lifetime = false
	particle.lifetime = 1.0
	
	particle.adapt_ratio = 1.5
	
	return particle


func create_shield_for_grandmaster(arg_enemy):
	var particle = grandmaster_shield_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.size_adapting_to = arg_enemy
	particle.node_to_follow_to__override_disp_per_sec = arg_enemy
	particle.node_to_follow_to__override_disp_per_sec__offset = arg_enemy.get_offset_modifiers()
	
	particle.node_to_listen_for_queue_free__turn_invis = arg_enemy
	
	particle.has_lifetime = false
	particle.change_config_based_on_size_adapting_to()
	
	return particle
	


func _on_grandmaster_shield_effect_added(arg_enemy):
	var shield_particle = create_shield_for_grandmaster(arg_enemy)
	
	shield_particle.node_to_listen_for_queue_free__turn_invis = arg_enemy
	
	arg_enemy.connect("grandmaster_shield_effect_removed", self, "_on_grandmaster_shield_effect_removed", [arg_enemy, shield_particle])
	arg_enemy.connect("grandmaster_shield_effect_broken", self, "_on_grandmaster_shield_effect_broken", [arg_enemy, shield_particle])

func _on_grandmaster_shield_effect_removed(arg_enemy, arg_shield_particle):
	remove_shield_for_grandmaster(arg_shield_particle)
	_disconnect_grandmaster_shield_rem_and_broken_signals(arg_enemy)

func _on_grandmaster_shield_effect_broken(arg_enemy, arg_shield_particle):
	break_and_remove_shield_for_grandmaster(arg_shield_particle, arg_shield_particle.global_position)
	_disconnect_grandmaster_shield_rem_and_broken_signals(arg_enemy)


func _disconnect_grandmaster_shield_rem_and_broken_signals(arg_enemy):
	arg_enemy.disconnect("grandmaster_shield_effect_removed", self, "_on_grandmaster_shield_effect_removed")
	arg_enemy.disconnect("grandmaster_shield_effect_broken", self, "_on_grandmaster_shield_effect_broken")


func remove_shield_for_grandmaster(arg_shield_particle):
	arg_shield_particle.visible = false

func break_and_remove_shield_for_grandmaster(arg_shield_particle, arg_pos_of_grandmaster):
	remove_shield_for_grandmaster(arg_shield_particle)
	#_play_grandmaster_shield_break_particles(arg_pos_of_grandmaster)
	call_deferred("_play_grandmaster_shield_break_particles", arg_pos_of_grandmaster)

#

func _create_grandmaster_shield_break_fragment_particle():
	var particle = CenterBasedAttackParticle_Scene.instance()
	
	particle.texture_to_use = preload("res://EnemyRelated/EnemyTypes/Type_Expert/Grandmaster/Assets/ShieldParticle/Grandmaster_ShieldParticle_Break.png")
	
	particle.speed_accel_towards_center = 240
	particle.initial_speed_towards_center = non_essential_rng.randf_range(-80, -130)
	
	particle.max_speed_towards_center = -5
	
	particle.lifetime_to_start_transparency = 0.45
	particle.transparency_per_sec = 1 / 0.45
	
	particle.min_starting_angle = 0
	particle.max_starting_angle = 359
	
	return particle


func _play_grandmaster_shield_break_particles(arg_pos):
	for i in 8:
		var particle = grandmaster_shield_break_fragment_particle_pool_component.get_or_create_attack_sprite_from_pool()
		
		particle.center_pos_of_basis = arg_pos
		particle.lifetime = 0.9
		
		particle.reset_for_another_use()
		particle.is_enabled_mov_toward_center = true
		particle.rotation = particle.global_position.angle_to_point(arg_pos)
		
		particle.visible = true
		particle.modulate.a = 0.8

#####

func _initialize_all_enchantress_particle_pool_components():
	enchantress_shield_particle_pool_component = AttackSpritePoolComponent.new()
	enchantress_shield_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	enchantress_shield_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	enchantress_shield_particle_pool_component.source_for_funcs_for_attk_sprite = self
	enchantress_shield_particle_pool_component.func_name_for_creating_attack_sprite = "_create_enchantress_shield_particle"
	
	enchantress_shield_break_fragment_particle_pool_component = AttackSpritePoolComponent.new()
	enchantress_shield_break_fragment_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	enchantress_shield_break_fragment_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	enchantress_shield_break_fragment_particle_pool_component.source_for_funcs_for_attk_sprite = self
	enchantress_shield_break_fragment_particle_pool_component.func_name_for_creating_attack_sprite = "_create_enchantress_shield_break_fragment_particle"

func _create_enchantress_shield_particle():
	var particle = SizeAdaptingAttackSprite_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	particle.stop_process_at_invisible = true
	
	particle.texture_to_use = preload("res://EnemyRelated/EnemyTypes/Type_Expert/Enchantress(Healer)/Assets/Enchantress_ShieldParticle.png")
	
	particle.modulate.a = 0.65
	
	particle.has_lifetime = false
	particle.lifetime = 1.0
	
	particle.adapt_ratio = 1.5
	
	return particle

func create_shield_for_enchantress_target(arg_enemy):
	var particle = enchantress_shield_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.size_adapting_to = arg_enemy
	particle.node_to_follow_to__override_disp_per_sec = arg_enemy
	particle.node_to_follow_to__override_disp_per_sec__offset = arg_enemy.get_offset_modifiers()
	
	particle.node_to_listen_for_queue_free__turn_invis = arg_enemy
	
	particle.has_lifetime = false
	particle.change_config_based_on_size_adapting_to()
	
	
	return particle



func _before_enemy_is_spawned__enchantress(arg_enemy):
	arg_enemy.expert_faction_passive = self

func connect_enemy_shielded_by_enchantress(arg_enemy, arg_shield_effect):
	#arg_shield_effect.connect("shield_effect_added__not_refresh", self, "_on_enchantress_shield_effect_added__not_refreshed", [arg_shield_effect], CONNECT_ONESHOT)
	if !arg_enemy.is_connected("shield_added_but_not_refreshed", self, "_on_enchantress_shield_effect_added__not_refreshed"):
		arg_enemy.connect("shield_added_but_not_refreshed", self, "_on_enchantress_shield_effect_added__not_refreshed", [arg_enemy, arg_shield_effect.effect_uuid])

func _on_enchantress_shield_effect_added__not_refreshed(arg_shield_effect, arg_enemy, arg_expected_id):
	if arg_shield_effect.effect_uuid == arg_expected_id:
		var shield_particle = create_shield_for_enchantress_target(arg_enemy)
		
		if !arg_enemy.is_connected("shield_removed_but_not_broken", self, "_on_enchantress_shield_effect_removed"):
			arg_enemy.connect("shield_removed_but_not_broken", self, "_on_enchantress_shield_effect_removed", [shield_particle, arg_expected_id, arg_enemy])
			arg_enemy.connect("shield_broken", self, "_on_enchantress_shield_effect_broken", [shield_particle, arg_expected_id, arg_enemy])

func _on_enchantress_shield_effect_removed(arg_shield_id, shield_particle, arg_expected_id, arg_enemy):
	if arg_shield_id == arg_expected_id:
		shield_particle.turn_invisible_from_lifetime_end__from_outside()
		
		_disconnect_enchantress_signals(arg_enemy)

func _on_enchantress_shield_effect_broken(arg_shield_id, shield_particle, arg_expected_id, arg_enemy):
	if arg_shield_id == arg_expected_id:
		shield_particle.turn_invisible_from_lifetime_end__from_outside()
		_disconnect_enchantress_signals(arg_enemy)
		#_play_enchantress_shield_break_particles(shield_particle.global_position)
		call_deferred("_play_enchantress_shield_break_particles", shield_particle.global_position)


func _disconnect_enchantress_signals(arg_enemy):
	if arg_enemy.is_connected("shield_removed_but_not_broken", self, "_on_enchantress_shield_effect_removed"):
		arg_enemy.disconnect("shield_removed_but_not_broken", self, "_on_enchantress_shield_effect_removed")
	
	if arg_enemy.is_connected("shield_broken", self, "_on_enchantress_shield_effect_broken"):
		arg_enemy.disconnect("shield_broken", self, "_on_enchantress_shield_effect_broken")



func _create_enchantress_shield_break_fragment_particle():
	var particle = CenterBasedAttackParticle_Scene.instance()
	
	particle.texture_to_use = preload("res://EnemyRelated/EnemyTypes/Type_Expert/Enchantress(Healer)/Assets/Enchantress_ShieldParticle_Break.png")
	
	particle.speed_accel_towards_center = 240
	particle.initial_speed_towards_center = non_essential_rng.randf_range(-80, -130)
	
	particle.max_speed_towards_center = -5
	
	particle.lifetime_to_start_transparency = 0.45
	particle.transparency_per_sec = 1 / 0.45
	
	particle.min_starting_angle = 0
	particle.max_starting_angle = 359
	
	return particle


func _play_enchantress_shield_break_particles(arg_pos):
	for i in 6:
		var particle = enchantress_shield_break_fragment_particle_pool_component.get_or_create_attack_sprite_from_pool()
		
		particle.center_pos_of_basis = arg_pos
		particle.lifetime = 0.9
		
		particle.reset_for_another_use()
		particle.is_enabled_mov_toward_center = true
		particle.rotation = particle.global_position.angle_to_point(arg_pos)
		
		particle.visible = true
		particle.modulate.a = 0.8

#####



