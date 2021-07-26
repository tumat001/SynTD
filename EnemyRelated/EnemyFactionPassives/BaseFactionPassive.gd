const GameElements = preload("res://GameElementsRelated/GameElements.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

signal faction_passive_applied()
signal faction_passive_removed()


func _apply_faction_to_game_elements(arg_game_elements):
	emit_signal("faction_passive_applied")


func _remove_faction_from_game_elements(arg_game_elements):
	emit_signal("faction_passive_removed")
