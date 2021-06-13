const GameElements = preload("res://GameElementsRelated/GameElements.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

signal synergy_applied()
signal synergy_removed()


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	emit_signal("synergy_applied")


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	emit_signal("synergy_removed")
