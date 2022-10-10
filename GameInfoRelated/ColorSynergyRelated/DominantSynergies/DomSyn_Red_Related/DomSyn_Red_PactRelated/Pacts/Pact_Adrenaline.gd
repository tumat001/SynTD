extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")

const initial_window_duration : float = 5.0

const speed_increase_duration : float = 5.0
var speed_percent_increase : float

const debuff_duration : float = 20.0
var speed_percent_decrease : float
const toughness_flat_decrease : float = 5.0

var speed_increase_effect : EnemyAttributesEffect
var toughness_loss_effect : EnemyAttributesEffect
var speed_decrease_effect : EnemyAttributesEffect
var adrenaline_initial_marker_effect : EnemyStackEffect

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.ADRENALINE, "Adrenaline", arg_tier, arg_tier_for_activation):
	var possible_speed_gain_values : Array
	var possible_speed_loss_values : Array
	
	if tier == 0:
		possible_speed_gain_values = [72, 75, 78]
		possible_speed_loss_values = [-32, -33, -34]
	elif tier == 1:
		possible_speed_gain_values = [72, 75, 78]
		possible_speed_loss_values = [-24, -25, -26]
	elif tier == 2:
		possible_speed_gain_values = [51, 54, 57]
		possible_speed_loss_values = [-17, -18, -19]
	elif tier == 3:
		possible_speed_gain_values = [30, 33, 36]
		possible_speed_loss_values = [-10, -11, -12]
	
	var index_rng = pact_mag_rng.randi_range(0, 2)
	speed_percent_increase = possible_speed_gain_values[index_rng]
	speed_percent_decrease = possible_speed_loss_values[index_rng]
	
	good_descriptions = [
		"Upon losing Rush, the enemy loses %s speed for %s seconds. The enemy also loses %s toughness for the same duration." % [str(-speed_percent_decrease) + "%", debuff_duration, toughness_flat_decrease]
	]
	
	bad_descriptions = [
		"Enemies hit by attacks in the first %s seconds from spawning gain Rush. Rushing enemies gain %s speed for %s seconds." % [initial_window_duration, str(speed_percent_increase) + "%", speed_increase_duration]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_Adrenaline_Icon.png")


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_enemy_spawned"):
		game_elements.enemy_manager.connect("enemy_spawned", self, "_enemy_spawned", [], CONNECT_PERSIST)
	
	if speed_decrease_effect == null:
		var toughness_loss_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.RED_ADRENALINE_TOUGHNESS_DECREASE)
		toughness_loss_modi.flat_modifier = toughness_flat_decrease
		toughness_loss_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, toughness_loss_modi, StoreOfEnemyEffectsUUID.RED_ADRENALINE_TOUGHNESS_DECREASE)
		toughness_loss_effect.is_timebound = true
		toughness_loss_effect.time_in_seconds = debuff_duration
		toughness_loss_effect.respect_scale = false
		
		var speed_dec_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.RED_ADRENALINE_SPEED_DECREASE)
		speed_dec_modi.percent_amount = speed_percent_decrease
		speed_dec_modi.percent_based_on = PercentType.BASE
		speed_decrease_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, speed_dec_modi, StoreOfEnemyEffectsUUID.RED_ADRENALINE_SPEED_DECREASE)
		speed_decrease_effect.is_timebound = true
		speed_decrease_effect.time_in_seconds = debuff_duration
		speed_decrease_effect.respect_scale = false
		
		var speed_inc_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.RED_ADRENALINE_SPEED_INCREASE)
		speed_inc_modi.percent_amount = speed_percent_increase
		speed_inc_modi.percent_based_on = PercentType.BASE
		speed_increase_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, speed_inc_modi, StoreOfEnemyEffectsUUID.RED_ADRENALINE_SPEED_INCREASE)
		speed_increase_effect.is_timebound = true
		speed_increase_effect.time_in_seconds = speed_increase_duration
		speed_increase_effect.respect_scale = false
		
		adrenaline_initial_marker_effect = EnemyStackEffect.new(null, 1, 999, StoreOfEnemyEffectsUUID.RED_ADRENALINE_MARKER, false, false)
		adrenaline_initial_marker_effect.time_in_seconds = initial_window_duration
		adrenaline_initial_marker_effect.is_timebound = true
		adrenaline_initial_marker_effect.respect_scale = false


func _enemy_spawned(enemy):
	if is_instance_valid(enemy):
		enemy._add_effect(adrenaline_initial_marker_effect)
		enemy.connect("on_hit", self, "_on_enemy_with_marker_hit")
		enemy.connect("effect_removed", self, "_enemy_lost_marker_effect")


func _on_enemy_with_marker_hit(enemy, damage_reg_id, damage_instance):
	if enemy.is_connected("on_hit", self, "_on_enemy_with_marker_hit"):
		enemy.disconnect("on_hit", self, "_on_enemy_with_marker_hit")
	
	enemy._add_effect(speed_increase_effect)
	enemy.connect("effect_removed", self, "_enemy_lost_speed_inc_effect")
	enemy._remove_effect(adrenaline_initial_marker_effect)


func _enemy_lost_marker_effect(effect, enemy):
	if effect.effect_uuid == StoreOfEnemyEffectsUUID.RED_ADRENALINE_MARKER:
		enemy.disconnect("effect_removed", self, "_enemy_lost_marker_effect")
		
		if enemy.is_connected("on_hit", self, "_on_enemy_with_marker_hit"):
			enemy.disconnect("on_hit", self, "_on_enemy_with_marker_hit")


func _enemy_lost_speed_inc_effect(effect, enemy):
	if effect.effect_uuid == StoreOfEnemyEffectsUUID.RED_ADRENALINE_SPEED_INCREASE:
		enemy._add_effect(speed_decrease_effect)
		enemy._add_effect(toughness_loss_effect)
		enemy.disconnect("effect_removed", self, "_enemy_lost_speed_inc_effect")

#

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.enemy_manager.is_connected("enemy_spawned", self, "_enemy_spawned"):
		game_elements.enemy_manager.disconnect("enemy_spawned", self, "_enemy_spawned")


##########

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return true
