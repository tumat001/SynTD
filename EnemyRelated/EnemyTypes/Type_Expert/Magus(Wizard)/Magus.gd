extends "res://EnemyRelated/AbstractEnemy.gd"


const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const ExplosionParticle_Scene = preload("res://EnemyRelated/CommonParticles/ExplosionParticle/ExplosionParticle.tscn")

const _base_range : float = 140.0

const _explosion_dmg : float = 5.0
const _explosion_cooldown : float = 5.0
const _explosion_cooldown_no_targets_in_range : float = 3.0
const _explosion_modulate : Color = Color(0.25, 0, 1, 1)

var _targeting_for_explosion : int = Targeting.EXECUTE

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
			_summon_explosion_to_target(valid_targets[0])
			explosion_ability.start_time_cooldown(_explosion_cooldown)


func _summon_explosion_to_target(target):
	if target != null:
		target.take_damage(explosion_ability.last_calculated_final_ability_potency * _explosion_dmg)
		_create_and_show_expl_particle(target.global_position)


func _create_and_show_expl_particle(pos):
	var particle = ExplosionParticle_Scene.instance()
	particle.position = pos
	particle.modulate = _explosion_modulate
	particle.scale *= 1.5
	
	get_tree().get_root().add_child(particle)
