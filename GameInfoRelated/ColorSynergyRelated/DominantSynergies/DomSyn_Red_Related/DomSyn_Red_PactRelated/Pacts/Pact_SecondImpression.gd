extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

var toughness_gain_effect : EnemyAttributesEffect
var armor_gain_effect : EnemyAttributesEffect

var toughness_loss_effect : EnemyAttributesEffect
var armor_loss_effect : EnemyAttributesEffect

var gain_val
var loss_val

const gain_duration : float = 15.0


func _init(arg_tier : int).(StoreOfPactUUID.SECOND_IMPRESSION, "Second Impression", arg_tier):
	var possible_gain_values : Array
	var possible_loss_values : Array
	
	if tier == 0:
		pass
	elif tier == 1:
		pass
	elif tier == 2:
		possible_gain_values = [5, 6, 7]
		possible_loss_values = [-11, -12, -13]
	elif tier == 3:
		possible_gain_values = [4, 5, 6]
		possible_loss_values = [-6, -8, -10]
	
	var index_rng = pact_mag_rng.randi_range(0, 2)
	gain_val = possible_gain_values[index_rng]
	loss_val = possible_loss_values[index_rng]
	
	good_descriptions = [
		"Enemies lose %s armor and toughness after losing the buff." % -loss_val
	]
	
	bad_descriptions = [
		"Enemies gain %s armor and toughness for %s seconds." % [gain_val, gain_duration]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_SecondImpression_Icon.png")


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_enemy_spawned"):
		game_elements.enemy_manager.connect("enemy_spawned", self, "_enemy_spawned", [], CONNECT_PERSIST)
	
	if toughness_gain_effect == null:
		var toughness_gain_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.RED_PACT_SECOND_IMPRESSION_TOUGHNESS_GAIN)
		toughness_gain_modi.flat_modifier = gain_val
		toughness_gain_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, toughness_gain_modi, StoreOfEnemyEffectsUUID.RED_PACT_SECOND_IMPRESSION_TOUGHNESS_GAIN)
		toughness_gain_effect.is_timebound = true
		toughness_gain_effect.time_in_seconds = gain_duration
		
		var toughness_loss_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.RED_PACT_SECOND_IMPRESSION_TOUGHNESS_LOSS)
		toughness_loss_modi.flat_modifier = loss_val
		toughness_loss_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, toughness_loss_modi, StoreOfEnemyEffectsUUID.RED_PACT_SECOND_IMPRESSION_TOUGHNESS_LOSS)
		toughness_loss_effect.is_timebound = false
		
		var armor_gain_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.RED_PACT_SECOND_IMPRESSION_ARMOR_GAIN)
		armor_gain_modi.flat_modifier = gain_val
		armor_gain_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ARMOR, armor_gain_modi, StoreOfEnemyEffectsUUID.RED_PACT_SECOND_IMPRESSION_ARMOR_GAIN)
		armor_gain_effect.is_timebound = true
		armor_gain_effect.time_in_seconds = gain_duration
		
		var armor_loss_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.RED_PACT_SECOND_IMPRESSION_ARMOR_LOSS)
		armor_loss_modi.flat_modifier = loss_val
		armor_loss_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ARMOR, armor_loss_modi, StoreOfEnemyEffectsUUID.RED_PACT_SECOND_IMPRESSION_ARMOR_LOSS)
		armor_loss_effect.is_timebound = false

func _enemy_spawned(enemy):
	if enemy != null:
		enemy._add_effect(armor_gain_effect._get_copy_scaled_by(1))
		enemy._add_effect(toughness_gain_effect._get_copy_scaled_by(1))
		enemy.connect("effect_removed", self, "_enemy_lost_effect")

func _enemy_lost_effect(effect, enemy):
	if effect.effect_uuid == StoreOfEnemyEffectsUUID.RED_PACT_SECOND_IMPRESSION_TOUGHNESS_GAIN:
		enemy.disconnect("effect_removed", self, "_enemy_lost_effect")
		enemy._add_effect(armor_loss_effect._get_copy_scaled_by(1))
		enemy._add_effect(toughness_loss_effect._get_copy_scaled_by(1))



func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	if game_elements.enemy_manager.is_connected("enemy_spawned", self, "_enemy_spawned"):
		game_elements.enemy_manager.disconnect("enemy_spawned", self, "_enemy_spawned")
