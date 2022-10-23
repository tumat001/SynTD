
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerEffect_DomSyn_YellowEnergyEffectGiver = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_YellowEnergyEffectGiver.gd")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")

const Yellow_EnergyParticle_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Assets/Yellow_ActivePowerParticle.png")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")


signal disconnect_from_battery(me)

signal module_turned_on(first_time_per_round)
signal module_turned_off()

signal attempt_turn_module_on(me)
signal attempt_turn_module_off(me)

var energy_consumption_per_round : int = 1

var is_turned_on : bool

var module_effect_descriptions : Array = []

var tower_connected_to : AbstractTower setget _set_tower_connected_to

var energy_particles_pool : AttackSpritePoolComponent
var energy_particle_spawn_timer : Timer
var non_essential_rng : RandomNumberGenerator
const particle_spawn_interval : float = 0.15

var _energy_on_attack_sprite


# Setter

func _set_tower_connected_to(arg_tower : AbstractTower):
	# Old if existing
	if is_instance_valid(tower_connected_to):
		tower_connected_to.disconnect("tower_in_queue_free", self, "_tower_connected_in_queue_free")
		tower_connected_to.disconnect("tower_not_in_active_map", self, "_tower_not_active_in_map")
	
	# New incomming
	if is_instance_valid(arg_tower):
		tower_connected_to = arg_tower
		tower_connected_to.connect("tower_in_queue_free", self, "_tower_connected_in_queue_free")
		tower_connected_to.connect("tower_not_in_active_map", self, "_tower_not_active_in_map")


# Tower signals

func _tower_connected_in_queue_free(arg_tower):
	attempt_turn_off()
	disconnect_from_battery()

func _tower_not_active_in_map():
	attempt_turn_off()


# Attempt

func attempt_turn_on():
	call_deferred("emit_signal", "attempt_turn_module_on", self)

func attempt_turn_off():
	call_deferred("emit_signal", "attempt_turn_module_off", self)



# Functions called by EnergyBattery.
func module_turn_on(first_time_per_round : bool):
	is_turned_on = true
	call_deferred("emit_signal", "module_turned_on", first_time_per_round)
	
	var effect := TowerEffect_DomSyn_YellowEnergyEffectGiver.new()
	tower_connected_to.add_tower_effect(effect)
	
	if energy_particles_pool == null:
		_initialize_energy_particles_pool()
	
	energy_particle_spawn_timer.start(particle_spawn_interval)

func module_turn_off():
	is_turned_on = false
	call_deferred("emit_signal", "module_turned_off")
	
	if is_instance_valid(tower_connected_to):
		var effect = tower_connected_to.get_tower_effect(StoreOfTowerEffectsUUID.ENERGY_MODULE_ENERGY_EFFECT_GIVER)
		if effect != null:
			tower_connected_to.remove_tower_effect(effect)
	
	if is_instance_valid(energy_particle_spawn_timer):
		energy_particle_spawn_timer.stop()

# Call this when queue freeing the tower

func disconnect_from_battery():
	call_deferred("emit_signal", "disconnect_from_battery", self)


# Particle effects related

func _initialize_energy_particles_pool():
	energy_particles_pool = AttackSpritePoolComponent.new()
	energy_particles_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	energy_particles_pool.node_to_listen_for_queue_free = tower_connected_to
	energy_particles_pool.source_for_funcs_for_attk_sprite = self
	energy_particles_pool.func_name_for_creating_attack_sprite = "_create_energy_particle"
	energy_particles_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_before_add_child = "_set_energy_particle_properties_when_get_from_pool_before_add_child"
	
	energy_particle_spawn_timer = Timer.new()
	energy_particle_spawn_timer.one_shot = false
	energy_particle_spawn_timer.connect("timeout", self, "_on_energy_particle_spawn_timer_timeout", [], CONNECT_PERSIST)
	tower_connected_to.add_child(energy_particle_spawn_timer)
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)


func _create_energy_particle():
	var particle = AttackSprite_Scene.instance()
	particle.texture_to_use = Yellow_EnergyParticle_Pic
	
	particle.lifetime = 0.5
	particle.queue_free_at_end_of_lifetime = false
	particle.frames_based_on_lifetime = false
	
	return particle

func _set_energy_particle_properties_when_get_from_pool_before_add_child(particle):
	particle.lifetime = 0.5
	particle.visible = true
	particle.modulate.a = 1

func _on_energy_particle_spawn_timer_timeout():
	var particle = energy_particles_pool.get_or_create_attack_sprite_from_pool()
	
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	particle.position = tower_connected_to.global_position
	var tower_half_size : Vector2 = tower_connected_to.get_current_anim_size() / 2.0
	particle.position.x += non_essential_rng.randi_range(-tower_half_size.x, tower_half_size.x)
	particle.position.y += non_essential_rng.randi_range(-16, 10)


