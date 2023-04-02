extends "res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Skillsets/AbstractMorphSkillset.gd"

const EnemyShieldEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyShieldEffect.gd")


var pass_shield_range : float #= 50.0
var shield_health_ratio : float #= 15.0  # based on self health


var _enemy

#

var game_elements

#

func _init().(StoreOfMorphSkillsets.MorpherSkillsetIds.BARE__PASSED_PLATE):
	pass

#

#func _can_apply_to_enemy(arg_enemy) -> bool:
#	return arg_enemy.enemy_id == EnemyConstants.Enemies.BARE or arg_enemy.enemy_id == EnemyConstants.Enemies.WILDCARD

#

func _apply_morph_skillset(arg_enemy, arg_game_elements, arg_faction_passive):
	._apply_morph_skillset(arg_enemy, arg_game_elements, arg_faction_passive)
	
	_enemy = arg_enemy
	game_elements = arg_game_elements
	_listen_for_death_with_no_revives_left()

func _apply_morph_skillset__to_wildcard(arg_enemy, arg_game_elements, arg_faction_passive):
	._apply_morph_skillset__to_wildcard(arg_enemy, arg_game_elements, arg_faction_passive)
	
	_enemy = arg_enemy
	game_elements = arg_game_elements
	
	_listen_for_death_with_no_revives_left()

#

func _listen_for_death_with_no_revives_left():
	_enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_death_with_no_revives", [], CONNECT_ONESHOT)


#


func _on_enemy_death_with_no_revives(damage_instance_report, enemy):
	call_deferred("_deferred_give_passed_shield", _enemy.global_position)
	

func _deferred_give_passed_shield(arg_pos):
	var closest_enemies_within_range = game_elements.enemy_manager.get_enemies_within_distance_of_position__with_count(arg_pos, pass_shield_range, 1, true)
	if closest_enemies_within_range.size() != 0:
		var closest_enemy = closest_enemies_within_range[0]
		
		_give_or_increase_shield_of_enemy(closest_enemy)


func _give_or_increase_shield_of_enemy(arg_enemy):
	var effect = arg_enemy.get_effect_with_uuid(StoreOfEnemyEffectsUUID.BARE__PASSED_PLATE_SHIELD_EFFECT)
	
	if effect != null:
		effect._current_shield += _calculate_shield_amount_to_give()
		arg_enemy.calculate_current_shield()
	else:
		arg_enemy._add_effect__use_provided_effect(_construct_shield_effect())


#

func _construct_shield_effect():
	var shield_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.BARE__PASSED_PLATE_SHIELD_EFFECT)
	shield_modi.flat_modifier = _calculate_shield_amount_to_give()
	
	var shield_effect = EnemyShieldEffect.new(shield_modi, StoreOfEnemyEffectsUUID.BARE__PASSED_PLATE_SHIELD_EFFECT)
	shield_effect.is_timebound = false
	shield_effect.is_from_enemy = true

func _calculate_shield_amount_to_give():
	return _enemy._last_calculated_max_health * (shield_health_ratio / 100)

