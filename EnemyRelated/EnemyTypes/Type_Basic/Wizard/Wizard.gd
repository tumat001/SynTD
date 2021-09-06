extends "res://EnemyRelated/AbstractEnemy.gd"

const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const ExplosionParticle_Scene = preload("res://EnemyRelated/CommonParticles/ExplosionParticle/ExplosionParticle.tscn")

const Wizard_Beam_Scene = preload("res://EnemyRelated/CommonParticles/Wizard_Beam/Wizard_Beam.tscn")

const _base_range : float = 80.0

const _explosion_dmg : float = 2.0
const _explosion_cooldown : float = 7.0
const _explosion_cooldown_no_targets_in_range : float = 3.0


var _targeting_for_explosion : int = Targeting.RANDOM

var tower_detecting_range_module : TowerDetectingRangeModule

var explosion_ability : BaseAbility
#var explosion_activation_clause : ConditionalClauses


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.WIZARD))


func _ready():
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
			_summon_beam_to_target(valid_targets[0])
			explosion_ability.start_time_cooldown(_explosion_cooldown)

func _summon_beam_to_target(target):
	if target != null:
		var beam = Wizard_Beam_Scene.instance()
		beam.connect("time_visible_is_over", self, "_summon_explosion_to_target", [target], CONNECT_ONESHOT)
		
		beam.time_visible = 0.3
		beam.frames.set_animation_speed("default", 8 / 0.3)
		beam.visible = true
		beam.global_position = global_position
		beam.frame = 0
		
		get_tree().get_root().add_child(beam)
		beam.update_destination_position(target.global_position)


func _summon_explosion_to_target(target):
	if target != null:
		target.take_damage(explosion_ability.get_potency_to_use(last_calculated_final_ability_potency) * _explosion_dmg)
		_create_and_show_expl_particle(target.global_position)


func _create_and_show_expl_particle(pos):
	var particle = ExplosionParticle_Scene.instance()
	particle.position = pos
	
	get_tree().get_root().add_child(particle)
