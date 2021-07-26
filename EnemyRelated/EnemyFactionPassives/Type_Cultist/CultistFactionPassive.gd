extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"


var game_elements : GameElements

func _apply_faction_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
	
	._apply_faction_to_game_elements(arg_game_elements)


func _remove_faction_from_game_elements(arg_game_elements : GameElements):
	
	
	._remove_faction_from_game_elements(arg_game_elements)
