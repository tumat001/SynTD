extends "res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Skillsets/AbstractMorphSkillset.gd"


const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

##

var first_health_breakpoint : float = 0.7
var first_breakpoint_speed_percent : float = 15.0

var second_health_breakpoint : float = 0.2
var second_breakpoint_speed_percent : float = 30.0

#

var _enemy

##


func _construct_first_speed_effect():
	var speed_bonus_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.BARE__FOOTWORK_FIRST_SPEED)
	speed_bonus_modi.percent_amount = first_breakpoint_speed_percent
	speed_bonus_modi.percent_based_on = PercentType.BASE
	
	var speed_bonus_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, speed_bonus_modi, StoreOfEnemyEffectsUUID.BARE__FOOTWORK_FIRST_SPEED)
	speed_bonus_effect.respect_scale = false
	speed_bonus_effect.is_timebound = false
	speed_bonus_effect.is_from_enemy = true
	
	return speed_bonus_effect

func _construct_second_speed_effect():
	var speed_bonus_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.BARE__FOOTWORK_SECOND_SPEED)
	speed_bonus_modi.percent_amount = second_breakpoint_speed_percent
	speed_bonus_modi.percent_based_on = PercentType.BASE
	
	var speed_bonus_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, speed_bonus_modi, StoreOfEnemyEffectsUUID.BARE__FOOTWORK_SECOND_SPEED)
	speed_bonus_effect.respect_scale = false
	speed_bonus_effect.is_timebound = false
	speed_bonus_effect.is_from_enemy = true
	
	return speed_bonus_effect

####

func _apply_morph_skillset(arg_enemy, arg_game_elements, arg_faction_passive):
	._apply_morph_skillset(arg_enemy, arg_game_elements, arg_faction_passive)
	_enemy = arg_enemy
	
	_listen_for_current_health_changed__for_first_bp()

func _apply_morph_skillset__to_wildcard(arg_enemy, arg_game_elements, arg_faction_passive):
	._apply_morph_skillset__to_wildcard(arg_enemy, arg_game_elements, arg_faction_passive)
	_enemy = arg_enemy
	
	_listen_for_current_health_changed__for_first_bp()


####

func _listen_for_current_health_changed__for_first_bp():
	_enemy.connect("on_current_health_changed", self, "_on_current_health_changed__for_first_bp")
	

func _on_current_health_changed__for_first_bp(arg_current_health):
	var ratio = _enemy.current_health / _enemy._last_calculated_max_health
	if ratio <= first_health_breakpoint:
		_give_first_speed_boost()
		_unlisten_for_current_health_changed__for_first_bp()
		_listen_for_current_health_changed__for_second_bp()
		



func _give_first_speed_boost():
	var effect = _construct_first_speed_effect()
	_enemy._add_effect__use_provided_effect(effect)
	

func _unlisten_for_current_health_changed__for_first_bp():
	_enemy.disconnect("on_current_health_changed", self, "_on_current_health_changed__for_first_bp")
	

func _listen_for_current_health_changed__for_second_bp():
	_enemy.connect("on_current_health_changed", self, "_on_current_health_changed__for_second_bp")
	



func _on_current_health_changed__for_second_bp(arg_current_health):
	var ratio = _enemy.current_health / _enemy._last_calculated_max_health
	if ratio <= second_health_breakpoint:
		_give_second_speed_boost()
		_unlisten_for_current_health_changed__for_second_bp()


func _give_second_speed_boost():
	var effect = _construct_first_speed_effect()
	_enemy._add_effect__use_provided_effect(effect)
	

func _unlisten_for_current_health_changed__for_second_bp():
	_enemy.disconnect("on_current_health_changed", self, "_on_current_health_changed__for_second_bp")
	


