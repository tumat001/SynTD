extends "res://EnemyRelated/AbstractEnemy.gd"


const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const HealParticle_Scene = preload("res://EnemyRelated/CommonParticles/HealParticle/HealParticle.tscn")

const _heal_cooldown : float = 10.0
const _heal_range : float = 140.0
const _heal_amount : float = 8.0
const _shield_ratio : float = 45.0

const no_enemies_in_range_clause : int = -10


var heal_ability : BaseAbility
var heal_activation_clause : ConditionalClauses
var heal_effect : EnemyHealEffect

var shield_effect : EnemyShieldEffect

var range_module : RangeModule
var targeting_option : int = Targeting.PERCENT_EXECUTE


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.ENCHANTRESS))


func _ready():
	range_module = RangeModule_Scene.instance()
	range_module.can_display_range = false
	range_module.base_range_radius = _heal_range
	range_module.set_range_shape(CircleShape2D.new())
	
	range_module.clear_all_targeting()
	range_module.add_targeting_option(targeting_option)
	range_module.set_current_targeting(targeting_option)
	
	range_module.connect("enemy_entered_range", self, "_enemy_entered_range_h")
	range_module.connect("enemy_left_range", self, "_enemy_exited_range_h")
	
	add_child(range_module)
	range_module.update_range()
	
	_construct_and_connect_ability()
	_construct_heal_and_shield_effect()


#

func _enemy_entered_range_h(enemy):
	heal_activation_clause.remove_clause(no_enemies_in_range_clause)


func _enemy_exited_range_h(enemy):
	if range_module.enemies_in_range.size() == 0:
		heal_activation_clause.attempt_insert_clause(no_enemies_in_range_clause)

#

func _construct_and_connect_ability():
	heal_ability = BaseAbility.new()
	
	heal_ability.is_timebound = true
	heal_ability._time_current_cooldown = _heal_cooldown / 2
	heal_ability.connect("updated_is_ready_for_activation", self, "_heal_ready_for_activation_updated")
	
	heal_activation_clause = heal_ability.activation_conditional_clauses
	heal_activation_clause.attempt_insert_clause(no_enemies_in_range_clause)
	
	register_ability(heal_ability)

func _construct_heal_and_shield_effect():
	var heal_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.ENCHANTRESS_HEAL_EFFECT)
	heal_modi.flat_modifier = _heal_amount
	
	heal_effect = EnemyHealEffect.new(heal_modi, StoreOfEnemyEffectsUUID.ENCHANTRESS_HEAL_EFFECT)
	
	var shield_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.ENCHANTRESS_SHIELD_EFFECT)
	shield_modi.percent_amount = _shield_ratio
	shield_modi.percent_based_on = PercentType.MISSING
	
	shield_effect = EnemyShieldEffect.new(shield_modi, StoreOfEnemyEffectsUUID.ENCHANTRESS_SHIELD_EFFECT)
	shield_effect.time_in_seconds = 5
	shield_effect.is_timebound = true


func _heal_ready_for_activation_updated(is_ready):
	if is_ready:
		call_deferred("_heal_ability_activated")


func _heal_ability_activated():
	var targets = range_module.get_targets(2, targeting_option, true)
	for target in targets:
		if target != self:
			target._add_effect(shield_effect._get_copy_scaled_by(heal_ability.last_calculated_final_ability_potency))
			target._add_effect(heal_effect._get_copy_scaled_by(heal_ability.last_calculated_final_ability_potency))
			
			_construct_and_add_heal_particle(target.global_position)
			heal_ability.start_time_cooldown(_heal_cooldown)
			no_movement_from_self = true
			return


func _construct_and_add_heal_particle(pos):
	var attk_sprite : AttackSprite = HealParticle_Scene.instance()
	attk_sprite.position = pos
	attk_sprite.connect("tree_exiting", self, "_particle_expired", [], CONNECT_ONESHOT)
	
	get_tree().get_root().add_child(attk_sprite)

func _particle_expired():
	no_movement_from_self = false
