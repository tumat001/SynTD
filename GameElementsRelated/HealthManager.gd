extends Node

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

const CenterBasedAttackParticle = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd")
const PlayerHealthDamageParticle_Scene = preload("res://MiscRelated/CommonTextures/PlayerHealthDamageParticle/Imp/PlayerHealthDamageParticle.tscn")
const PlayerHealthDamageParticle = preload("res://MiscRelated/CommonTextures/PlayerHealthDamageParticle/Imp/PlayerHealthDamageParticle.gd")
const PlayerHeartHitParticle = preload("res://MiscRelated/CommonTextures/PlayerHealthDamageParticle/HeartHitParticle/PlayerHeartHitParticle.gd")
const PlayerHeartHitParticle_Scene = preload("res://MiscRelated/CommonTextures/PlayerHealthDamageParticle/HeartHitParticle/PlayerHeartHitParticle.tscn")


enum IncreaseHealthSource {
	
	TOWER = 100,
	SYNERGY = 200,
	
}

enum DecreaseHealthSource {
	
	TOWER = 100,
	ENEMY = 110,
	SYNERGY = 200,
	
}

signal starting_health_changed(arg_val)
signal current_health_changed(current_health)
signal zero_health_reached()


var game_elements setget set_game_elements

var starting_health : float setget set_starting_health
var current_health : float setget set_health
#var round_info_panel : RoundInfoPanel

#

var non_essential_rng : RandomNumberGenerator

#

const dmg_num_for__very_small : float = 1.0
const dmg_num_for__small : float = 2.0
const dmg_num_for__medium : float = 19.0



var player_health_dmg_particle_pool_component : AttackSpritePoolComponent
var _player_health_dmg_particle_destination_pos : Vector2

var _player_health_dmg_particles_in_flight : int

var multiple_trail_component_for_player_health_dmg_particle : MultipleTrailsForNodeComponent

#

var player_heart_hit_particle_pool_component : AttackSpritePoolComponent

const particle_count_for_dmg_very_small : int = 0
const particle_count_for_dmg_small : int = 3
const particle_count_for_dmg_medium : int = 6
const particle_count_for_dmg_large : int = 10


#

func _ready():
	_initialize_particle_pool_components()
	_initialize_trail_component_for_player_health_dmg_particle()
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)

#

func set_game_elements(arg_elements):
	game_elements = arg_elements
	
	call_deferred("_deferred_set_dest_pos")

func _deferred_set_dest_pos():
	_player_health_dmg_particle_destination_pos = game_elements.right_side_panel.get_heart_icon_global_pos_of_round_info_panel()



#

func set_health(health : float):
	current_health = health
	
	_health_changed()
	_check_if_no_health_remaining()


func increase_health_by(increase : float, increase_source : int):
	current_health += increase
	
	_health_changed()

func decrease_health_by(decrease : float, decrease_source : int):
	current_health -= decrease
	
	_health_changed()
	_check_if_no_health_remaining()


func decrease_health_by__using_player_dmg_particle(decrease: float, decrease_source : int, arg_source_pos_for_particle : Vector2):
	create_player_health_damage_particle(arg_source_pos_for_particle, decrease, decrease_source)
	

#

func _health_changed():
	call_deferred("emit_signal", "current_health_changed", current_health)
	#round_info_panel.set_health_display(current_health)

func _check_if_no_health_remaining():
	if current_health <= 0:
		call_deferred("emit_signal", "zero_health_reached")

#

func set_starting_health(arg_val):
	starting_health = arg_val
	
	emit_signal("starting_health_changed", arg_val)

#

func _initialize_particle_pool_components():
	player_health_dmg_particle_pool_component = AttackSpritePoolComponent.new()
	player_health_dmg_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__node_hoster_below_screen_effects_mngr
	player_health_dmg_particle_pool_component.node_to_listen_for_queue_free = self
	player_health_dmg_particle_pool_component.source_for_funcs_for_attk_sprite = self
	player_health_dmg_particle_pool_component.func_name_for_creating_attack_sprite = "_create_player_health_dmg_particle__for_pool_compo"
	
	#
	
	player_heart_hit_particle_pool_component = AttackSpritePoolComponent.new()
	player_heart_hit_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__node_hoster_below_screen_effects_mngr
	player_heart_hit_particle_pool_component.node_to_listen_for_queue_free = self
	player_heart_hit_particle_pool_component.source_for_funcs_for_attk_sprite = self
	player_heart_hit_particle_pool_component.func_name_for_creating_attack_sprite = "_create_player_heart_hit_particle__for_pool_compo"
	

func _create_player_health_dmg_particle__for_pool_compo():
	var particle = PlayerHealthDamageParticle_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.connect("reached_final_destination", self, "_on_player_health_dmg_particle_reached_final_destination", [particle], CONNECT_PERSIST)
	particle.connect("request_beam_attachment", self, "_on_player_health_dmg_particle_request_beam_attachment", [particle], CONNECT_PERSIST)
	
	particle.dmg_num_for__very_small = dmg_num_for__very_small
	particle.dmg_num_for__small = dmg_num_for__small
	particle.dmg_num_for__medium = dmg_num_for__medium
	
	return particle

func _configure_center_based_particle_angle_based_on_map_pos(arg_particle : CenterBasedAttackParticle):
	var particle_pos = arg_particle.global_position
	#var angle_range = game_elements.calculate_and_store_angle_range_for_facing_towards_inside_of_playable_map(particle_pos)
	
	#arg_particle.min_starting_angle = angle_range[0]
	#arg_particle.max_starting_angle = angle_range[1]
	
	arg_particle.reset_for_another_use()


func create_player_health_damage_particle(arg_source_pos : Vector2, arg_dmg_amount : float, arg_decrease_source : int):
	var particle : PlayerHealthDamageParticle = player_health_dmg_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.cause_damage_at_destination_reach = true
	
	particle.global_position = arg_source_pos
	particle.center_pos_of_basis = arg_source_pos
	particle.secondary_center = _player_health_dmg_particle_destination_pos
	
	particle.reset_for_another_use()
	particle.set_properties_to_use_based_on_dmg_amount(arg_dmg_amount)
	
	particle.dmg_source_id = arg_decrease_source
	
	particle.visible = true
	
	set_any_particle_random_modulate(particle)
	
	#particle.connect("request_beam_detachment", self, "_on_player_health_dmg_particle_request_beam_detachment", [particle], CONNECT_PERSIST)
	
	_inc_player_health_dmg_particles_in_flight()

func set_any_particle_random_modulate(particle):
	var modulate_magnitude : float = non_essential_rng.randf_range(0.7, 1.3)
	particle.modulate = Color(modulate_magnitude, modulate_magnitude, modulate_magnitude, 1)
	



#

func _on_player_health_dmg_particle_reached_final_destination(arg_particle):
	if arg_particle.cause_damage_at_destination_reach:
		decrease_health_by(arg_particle.get_dmg_amount(), arg_particle.dmg_source_id)
	
	_dec_player_health_dmg_particles_in_flight()
	
	if arg_particle.cause_damage_at_destination_reach:
		#create_player_heart_hit_particles(arg_particle.get_dmg_amount())
		call_deferred("create_player_heart_hit_particles", arg_particle.get_dmg_amount())

func _inc_player_health_dmg_particles_in_flight():
	_player_health_dmg_particles_in_flight += 1
	_update_states_based_on_player_health_dmg_particles_in_flight()

func _dec_player_health_dmg_particles_in_flight():
	_player_health_dmg_particles_in_flight -= 1
	_update_states_based_on_player_health_dmg_particles_in_flight()


func _update_states_based_on_player_health_dmg_particles_in_flight():
	if _player_health_dmg_particles_in_flight > 0:
		game_elements.stage_round_manager.add_clause_to_block_end_round_conditional_clauses(game_elements.stage_round_manager.BlockEndRoundClauseIds.PLAYER_HEALTH_DMG_PROJ_IN_FLIGHT)
	else:
		game_elements.stage_round_manager.remove_clause_to_block_end_round_conditional_clauses(game_elements.stage_round_manager.BlockEndRoundClauseIds.PLAYER_HEALTH_DMG_PROJ_IN_FLIGHT, true)

#

func _initialize_trail_component_for_player_health_dmg_particle():
	multiple_trail_component_for_player_health_dmg_particle = MultipleTrailsForNodeComponent.new()
	multiple_trail_component_for_player_health_dmg_particle.node_to_host_trails = CommsForBetweenScenes.current_game_elements__node_hoster_below_screen_effects_mngr
	multiple_trail_component_for_player_health_dmg_particle.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	multiple_trail_component_for_player_health_dmg_particle.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	

func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = node.beam_length
	arg_trail.trail_color = Color(217/255.0, 2/255.0, 6/255.0) * node.modulate.r
	arg_trail.width = node.beam_width
	arg_trail.modulate.a = 0.75
	arg_trail.set_to_idle_and_available_if_node_is_not_visible = true
	
	arg_trail.z_index_modifier = 0

func _on_player_health_dmg_particle_request_beam_attachment(arg_particle):
	multiple_trail_component_for_player_health_dmg_particle.create_trail_for_node(arg_particle)

#func _on_player_health_dmg_particle_request_beam_detachment(arg_particle):
#	multiple_trail_component_for_player_health_dmg_particle.


##

func _create_player_heart_hit_particle__for_pool_compo():
	var particle = PlayerHeartHitParticle_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	particle.stop_process_at_invisible = true
	particle.rng_to_use = non_essential_rng
	particle.has_lifetime = true
	
	return particle

func create_player_heart_hit_particles(arg_dmg_amount : float):
	var count : int
	
	if dmg_num_for__very_small >= arg_dmg_amount:
		count = particle_count_for_dmg_very_small
	elif dmg_num_for__small >= arg_dmg_amount:
		count = particle_count_for_dmg_small
	elif dmg_num_for__medium >= arg_dmg_amount:
		count = particle_count_for_dmg_medium
	else:
		count = particle_count_for_dmg_large
	
	
	for i in count:
		var particle : PlayerHeartHitParticle = player_heart_hit_particle_pool_component.get_or_create_attack_sprite_from_pool()
		
		particle.speed_accel_towards_center = 290
		particle.initial_speed_towards_center = non_essential_rng.randf_range(-60, -110)
		
		particle.max_speed_towards_center = -5
		
		particle.lifetime = 1.1
		particle.lifetime_to_start_transparency = 0.55
		particle.transparency_per_sec = 1 / 0.5
		
		particle.center_pos_of_basis = _player_health_dmg_particle_destination_pos
		
		particle.randomize_texture_properties()
		particle.reset_for_another_use()
		particle.is_enabled_mov_toward_center = true
		particle.rotation = particle.global_position.angle_to_point(_player_health_dmg_particle_destination_pos)
		
		particle.visible = true
		particle.modulate.a = 0.6
	

#####

# to create a "sucking" effect. Used by Biomorph (Vio Tower)
# immediately damages the player.
func create_player_health_damage_particle__with_diff_dest_pos(arg_dest_pos : Vector2, arg_dmg_amount : float, arg_decrease_source : int):
	var particle : PlayerHealthDamageParticle = player_health_dmg_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.cause_damage_at_destination_reach = false
	
	particle.global_position = _player_health_dmg_particle_destination_pos
	particle.center_pos_of_basis = _player_health_dmg_particle_destination_pos
	particle.secondary_center = arg_dest_pos
	
	particle.reset_for_another_use()
	particle.set_properties_to_use_based_on_dmg_amount(arg_dmg_amount)
	
	particle.dmg_source_id = arg_decrease_source
	
	particle.visible = true
	
	set_any_particle_random_modulate(particle)
	
	_inc_player_health_dmg_particles_in_flight()
	
	##
	
	decrease_health_by(arg_dmg_amount, arg_decrease_source)

################
