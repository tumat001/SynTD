extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

var health_gain_mod : PercentModifier
var health_gain_effect : EnemyAttributesEffect
var gold_gain_val

const gold_amount_limit_for_offerable : int = 40


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.A_CHALLENGE, "A Challenge", arg_tier, arg_tier_for_activation):
	
	health_gain_mod = PercentModifier.new(StoreOfEnemyEffectsUUID.RED_PACT_A_CHALLENGE_ENEMY_BONUS_HEALTH)
	health_gain_mod.ignore_flat_limits = false
	health_gain_mod.percent_based_on = PercentType.BASE
	
	if tier == 0:
		health_gain_mod.percent_amount = 10
		health_gain_mod.flat_maximum = 50
		gold_gain_val = 5
	elif tier == 1:
		health_gain_mod.percent_amount = 8
		health_gain_mod.flat_maximum = 25
		gold_gain_val = 3
	elif tier == 2:
		health_gain_mod.percent_amount = 6
		health_gain_mod.flat_maximum = 10
		gold_gain_val = 2
	elif tier == 3:
		health_gain_mod.percent_amount = 4
		health_gain_mod.flat_maximum = 4
		gold_gain_val = 1
	
	
	good_descriptions = [
		"Gain additional %s gold at the end of the round." % gold_gain_val
	]
	
	bad_descriptions = [
		"Enemies gain %s more max health, up to %s." % [str(health_gain_mod.percent_amount) + "%", health_gain_mod.flat_maximum]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_AChallenge_Icon.png")


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_enemy_spawned"):
		game_elements.enemy_manager.connect("enemy_spawned", self, "_enemy_spawned", [], CONNECT_PERSIST)
	
	if health_gain_effect == null:
		health_gain_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_HEALTH, health_gain_mod, StoreOfEnemyEffectsUUID.RED_PACT_A_CHALLENGE_ENEMY_BONUS_HEALTH)
		health_gain_effect.is_timebound = false
		health_gain_effect.respect_scale = false
		

func _enemy_spawned(enemy):
	if enemy != null:
		enemy._add_effect(health_gain_effect)


func _on_round_end(curr_stageround):
	game_elements.gold_manager.increase_gold_by(gold_gain_val, game_elements.GoldManager.IncreaseGoldSource.SYNERGY)


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.enemy_manager.is_connected("enemy_spawned", self, "_enemy_spawned"):
		game_elements.enemy_manager.disconnect("enemy_spawned", self, "_enemy_spawned")
	
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	

######

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.gold_manager.current_gold < gold_amount_limit_for_offerable
