extends Path2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

signal on_enemy_death(enemy)
signal on_enemy_reached_end(enemy)


func add_child(node : Node, legible_unique_name : bool = false):
	.add_child(node, legible_unique_name)
	
	if node is AbstractEnemy:
		node.connect("on_death", self, "_emit_enemy_on_death", [node])
		node.connect("reached_end_of_path", self, "_emit_enemy_reached_end", [node])


func _emit_enemy_on_death(enemy):
	emit_signal("on_enemy_death", enemy)

func _emit_enemy_reached_end(enemy):
	emit_signal("on_enemy_reached_end", enemy)
