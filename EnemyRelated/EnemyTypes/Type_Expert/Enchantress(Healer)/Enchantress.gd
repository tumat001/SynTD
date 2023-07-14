extends "res://EnemyRelated/AbstractEnemy.gd"


const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const HealParticle_Scene = preload("res://EnemyRelated/CommonParticles/HealParticle/HealParticle.tscn")

const _heal_cooldown : float = 7.5
const _heal_range : float = 140.0
const _heal_amount : float = 10.0
const _shield_ratio : float = 35.0
const _shield_duration : float = 3.0

const no_enemies_in_range_clause : int = -10


var heal_ability : BaseAbility
var heal_activation_clause : ConditionalClauses
var heal_effect : EnemyHealEffect

var shield_effect : EnemyShieldEffect

#var range_module : RangeModule
var targeting_option : int = Targeting.PERCENT_EXECUTE

var expert_faction_passive


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.ENCHANTRESS))


func _ready():
#	range_module = RangeModule_Scene.instance()
#	range_module.can_display_range = false
#	range_module.base_range_radius = _heal_range
#	range_module.set_range_shape(CircleShape2D.new())
#
#	range_module.clear_all_targeting()
#	range_module.add_targeting_option(targeting_option)
#	range_module.set_current_targeting(targeting_option)
#
#	range_module.connect("enemy_entered_range", self, "_enemy_entered_range_h")
#	range_module.connect("enemy_left_range", self, "_enemy_exited_range_h")
#
#	add_child(range_module)
#	range_module.update_range()
	
	_construct_and_connect_ability()
	_construct_heal_and_shield_effect()


#

#func _enemy_entered_range_h(enemy):
#	heal_activation_clause.remove_clause(no_enemies_in_range_clause)
#
#
#func _enemy_exited_range_h(enemy):
#	if range_module.enemies_in_range.size() == 0:
#		heal_activation_clause.attempt_insert_clause(no_enemies_in_range_clause)

#

func _construct_and_connect_ability():
	heal_ability = BaseAbility.new()
	
	heal_ability.is_timebound = true
	heal_ability._time_current_cooldown = _heal_cooldown / 2
	heal_ability.connect("updated_is_ready_for_activation", self, "_heal_ready_for_activation_updated")
	
	heal_activation_clause = heal_ability.activation_conditional_clauses
	#heal_activation_clause.attempt_insert_clause(no_enemies_in_range_clause)
	
	register_ability(heal_ability)

func _construct_heal_and_shield_effect():
	var heal_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.ENCHANTRESS_HEAL_EFFECT)
	heal_modi.flat_modifier = _heal_amount
	
	heal_effect = EnemyHealEffect.new(heal_modi, StoreOfEnemyEffectsUUID.ENCHANTRESS_HEAL_EFFECT)
	heal_effect.is_from_enemy = true
	
	var shield_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.ENCHANTRESS_SHIELD_EFFECT)
	shield_modi.percent_amount = _shield_ratio
	shield_modi.percent_based_on = PercentType.MISSING
	shield_modi.flat_minimum = 1.0
	shield_modi.flat_maximum = 9999999.0
	shield_modi.ignore_flat_limits = false
	
	shield_effect = EnemyShieldEffect.new(shield_modi, StoreOfEnemyEffectsUUID.ENCHANTRESS_SHIELD_EFFECT)
	shield_effect.time_in_seconds = _shield_duration
	shield_effect.is_timebound = true
	shield_effect.is_from_enemy = true


func _heal_ready_for_activation_updated(is_ready):
	if is_ready:
		call_deferred("_heal_ability_activated")


func _heal_ability_activated():
	#var targets = range_module.get_targets(2, targeting_option, true)
	var targets = game_elements.enemy_manager.get_enemies_within_distance_of_position__with_count_and_targeting(global_position, _heal_range, 2, targeting_option, true)
	
	if targets.size() > 0:
		heal_ability.on_ability_before_cast_start(_heal_cooldown)
		
		for target in targets:
			# shield related
			var copy_of_shield_effect = shield_effect._get_copy_scaled_by(heal_ability.get_potency_to_use(last_calculated_final_ability_potency))
			
			# do the bool check only for signal connects. dont put the "add_effect" method here.
			if !target.last_calculated_has_effect_shield_against_enemies:
				expert_faction_passive.connect_enemy_shielded_by_enchantress(target, copy_of_shield_effect)
			
			target._add_effect__use_provided_effect(copy_of_shield_effect)
			
			####
			
			target._add_effect(heal_effect._get_copy_scaled_by(heal_ability.get_potency_to_use(last_calculated_final_ability_potency)))
			
			_construct_and_add_heal_particle(target.global_position)
		
		heal_ability.start_time_cooldown(_heal_cooldown)
		
		
		heal_ability.on_ability_after_cast_ended(_heal_cooldown)
		
	else:
		heal_ability.start_time_cooldown(2)  # try again after 2 sec



func _construct_and_add_heal_particle(pos):
	no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
	
	var attk_sprite : AttackSprite = HealParticle_Scene.instance()
	attk_sprite.position = pos
	attk_sprite.connect("tree_exiting", self, "_particle_expired", [], CONNECT_ONESHOT)
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(attk_sprite)

func _particle_expired():
	no_movement_from_self_clauses.remove_clause(NoMovementClauses.CUSTOM_CLAUSE_01)


########


