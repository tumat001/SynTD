extends "res://EnemyRelated/AbstractEnemy.gd"

const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const ExplosionParticle_Scene = preload("res://EnemyRelated/CommonParticles/ExplosionParticle/ExplosionParticle.tscn")

const Wizard_Beam_Scene = preload("res://EnemyRelated/CommonParticles/Wizard_Beam/Wizard_Beam.tscn")


var beam_explosion_interval_timer : Timer
const _beam_explosion_interval_delay : float = 0.33
const _base_beam_explosion_count : int = 3
var _current_beam_count_left : int
var _current_target_for_beam

#

const _base_range : float = 80.0

const _explosion_dmg : float = 2.05 / _base_beam_explosion_count
const _explosion_cooldown : float = 6.0 #4.62 #7.0
const _explosion_cooldown_no_targets_in_range : float = 2.0 #3.0


var _targeting_for_explosion : int = Targeting.RANDOM

var tower_detecting_range_module : TowerDetectingRangeModule

var explosion_ability : BaseAbility

#var explosion_activation_clause : ConditionalClauses


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.WIZARD))


func _ready():
	beam_explosion_interval_timer = Timer.new()
	beam_explosion_interval_timer.connect("timeout", self, "_on_beam_explosion_interval_timer_timeout")
	beam_explosion_interval_timer.one_shot = false
	add_child(beam_explosion_interval_timer)
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.detection_range = _base_range
	
	add_child(tower_detecting_range_module)
	
	_construct_and_connect_ability()


#

func _construct_and_connect_ability():
	explosion_ability = BaseAbility.new()
	
	explosion_ability.is_timebound = true
	explosion_ability._time_current_cooldown = _explosion_cooldown / 2
	explosion_ability.connect("updated_is_ready_for_activation", self, "_explosion_ready_for_activation_updated")
	
	#explosion_activation_clause = explosion_ability.activation_conditional_clauses
	
	register_ability(explosion_ability)


func _explosion_ready_for_activation_updated(is_ready):
	if is_ready:
		call_deferred("_explosion_ability_activated")


func _explosion_ability_activated():
	var targets = tower_detecting_range_module.get_all_in_map_and_active_towers_in_range()
	
	if targets.size() == 0:
		explosion_ability.start_time_cooldown(_explosion_cooldown_no_targets_in_range)
	else:
		var valid_targets = Targeting.enemies_to_target(targets, _targeting_for_explosion, 1, global_position)
		
		if valid_targets.size() > 0:
			_current_beam_count_left = _base_beam_explosion_count
			_current_target_for_beam = valid_targets[0]
			_consume_beam_charge_for_summon_beam_to_target(_current_target_for_beam)
			beam_explosion_interval_timer.start(_beam_explosion_interval_delay)


func _summon_beam_to_target(target, final_potency : float):
	if is_instance_valid(target):
		var beam = Wizard_Beam_Scene.instance()
		beam.connect("time_visible_is_over", self, "_summon_explosion_to_target", [target, final_potency], CONNECT_ONESHOT)
		
		beam.time_visible = 0.3
		beam.frames.set_animation_speed("default", 8 / 0.3)
		beam.visible = true
		beam.global_position = global_position
		beam.frame = 0
		
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
		beam.update_destination_position(target.global_position)


func _summon_explosion_to_target(target, final_potency : float):
	if is_instance_valid(target):
		target.take_damage(final_potency * _explosion_dmg, self)
		_create_and_show_expl_particle(target.global_position)


func _create_and_show_expl_particle(pos):
	var particle = ExplosionParticle_Scene.instance()
	particle.position = pos
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)

#

func _on_beam_explosion_interval_timer_timeout():
	_consume_beam_charge_for_summon_beam_to_target(_current_target_for_beam)


func _consume_beam_charge_for_summon_beam_to_target(arg_tower):
	if _current_beam_count_left > 0:
		if !is_instance_valid(_current_target_for_beam) or _current_target_for_beam.is_queued_for_deletion():
			var targets = tower_detecting_range_module.get_all_in_map_and_active_towers_in_range()
			var valid_targets = Targeting.enemies_to_target(targets, _targeting_for_explosion, 1, global_position)
			if valid_targets.size() > 0:
				_current_target_for_beam = valid_targets[0]
		
		#
		
		explosion_ability.on_ability_before_cast_start(_explosion_cooldown)
		
		_summon_beam_to_target(arg_tower, explosion_ability.get_potency_to_use(last_calculated_final_ability_potency))
		explosion_ability.start_time_cooldown(_explosion_cooldown)
		
		explosion_ability.on_ability_after_cast_ended(_explosion_cooldown)
		
		_current_beam_count_left -= 1
		
	else:
		beam_explosion_interval_timer.stop()
