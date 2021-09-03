extends "res://GameInfoRelated/EnemyEffectRelated/BeforeEnemyReachEndPathBaseEffect.gd"

const EnemyHealEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyHealEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

const RYB_DamageRes_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_RYB/Assets/RYB_DamageRes_StatusBarIcon.png")

var damage_res_amount : float
var heal_amount : float

var syn_weak_ref : WeakRef


func _init(arg_damage_res_amount : float, 
		arg_heal_amount : float,
		arg_syn_weak_ref).(StoreOfEnemyEffectsUUID.RYB_BEFORE_END_REACH_EFFECT):
	
	damage_res_amount = arg_damage_res_amount
	heal_amount = arg_heal_amount
	syn_weak_ref = arg_syn_weak_ref
	
	prevent_exit = true
	
	is_clearable = false


#

func before_enemy_reached_exit(enemy):
	if syn_weak_ref.get_ref().current_enemy_escape_count_in_round < syn_weak_ref.get_ref().enemy_escape_count_before_deactivation:
		enemy.shift_unit_position(-1) # send back to start
		
		enemy._add_effect(_construct_heal_effect())
		enemy._add_effect(_construct_damage_resistance_effect())
	
	syn_weak_ref.get_ref().current_enemy_escape_count_in_round += 1


func _construct_damage_resistance_effect() -> EnemyAttributesEffect:
	var modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.RYB_ENEMY_DAMAGE_RESISTANCE_EFFECT)
	modi.flat_modifier = damage_res_amount
	
	var attr_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_RESISTANCE, modi, StoreOfEnemyEffectsUUID.RYB_ENEMY_DAMAGE_RESISTANCE_EFFECT)
	attr_effect.is_clearable = false
	attr_effect.status_bar_icon = RYB_DamageRes_StatusBarIcon
	
	return attr_effect

func _construct_heal_effect() -> EnemyHealEffect:
	var modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.RYB_ENEMY_HEAL_EFFECT)
	modi.percent_amount = heal_amount
	modi.percent_based_on = PercentType.MISSING
	
	var effect = EnemyHealEffect.new(modi, StoreOfEnemyEffectsUUID.RYB_ENEMY_HEAL_EFFECT)
	
	return effect


#

func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	var copy = get_script().new(damage_res_amount, heal_amount, syn_weak_ref)
	_configure_copy_to_match_self(copy)
	
	copy.prevent_exit = prevent_exit
	
	return copy

