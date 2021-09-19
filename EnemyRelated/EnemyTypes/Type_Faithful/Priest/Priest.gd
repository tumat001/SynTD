extends "res://EnemyRelated/EnemyTypes/Type_Faithful/AbstractFaithfulEnemy.gd"

const invul_cooldown : float = 12.0
const invul_base_duration : float = 2.0
const invul_no_movement_duration : float = 1.5

const no_diety_in_range_clause : int = -10

var invul_ability : BaseAbility
var invul_activation_clause : ConditionalClauses

var invul_effect : EnemyInvulnerabilityEffect

var movement_timer : Timer

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.PRIEST))

func _ready():
	_construct_and_connect_ability()
	_construct_effect()
	
	movement_timer = Timer.new()
	movement_timer.one_shot = true
	add_child(movement_timer)
	movement_timer.connect("timeout", self, "_movement_timer_timeout")

#

func _construct_effect():
	invul_effect = EnemyInvulnerabilityEffect.new(StoreOfEnemyEffectsUUID.PRIEST_INVUL_EFFECT, invul_base_duration)
	invul_effect.is_from_enemy = true

func _construct_and_connect_ability():
	invul_ability = BaseAbility.new()
	
	invul_ability.is_timebound = true
	invul_ability._time_current_cooldown = invul_cooldown / 2
	invul_ability.connect("updated_is_ready_for_activation", self, "_invul_ready_for_activation_updated")
	
	invul_activation_clause = invul_ability.activation_conditional_clauses
	invul_activation_clause.attempt_insert_clause(no_diety_in_range_clause)
	
	register_ability(invul_ability)


func _invul_ready_for_activation_updated(is_ready):
	if is_ready:
		call_deferred("_give_invul_to_diety")

func _give_invul_to_diety():
	if deity != null:
		var copy_of_effect = invul_effect._get_copy_scaled_by(invul_ability.get_potency_to_use(last_calculated_final_ability_potency))
		deity._add_effect(copy_of_effect)
		
		no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
		movement_timer.start(invul_no_movement_duration)
	
	invul_ability.start_time_cooldown(invul_cooldown)


func _movement_timer_timeout():
	no_movement_from_self_clauses.remove_clause(NoMovementClauses.CUSTOM_CLAUSE_01)



#

func on_self_enter_deity_range(deity):
	.on_self_enter_deity_range(deity)
	invul_activation_clause.remove_clause(no_diety_in_range_clause)


func on_self_leave_deity_range(deity):
	.on_self_leave_deity_range(deity)
	invul_activation_clause.attempt_insert_clause(no_diety_in_range_clause)


func on_deity_tree_exiting():
	.on_deity_tree_exiting()
	invul_activation_clause.attempt_insert_clause(no_diety_in_range_clause)
