extends Reference

const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")

const StoreOfMorphSkillsets = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Skillsets/StoreOfEnemyMorphSkillsets.gd")

#

var id

func _init(arg_id):
	id = arg_id

#


#func _can_apply_to_enemy(arg_enemy) -> bool:
#	return false

func _apply_morph_skillset(arg_enemy, arg_game_elements, arg_faction_passive):
	arg_enemy.apply_skillset(self)
	

func _apply_morph_skillset__to_wildcard(arg_enemy, arg_game_elements, arg_faction_passive):
	arg_enemy.apply_skillset(self)
	

