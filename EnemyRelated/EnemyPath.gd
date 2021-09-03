extends Path2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

signal on_enemy_death(enemy)
signal on_enemy_reached_end(enemy)

var path_length : float

func _ready():
	path_length = curve.get_baked_length()

func add_child(node : Node, legible_unique_name : bool = false):
	.add_child(node, legible_unique_name)
	
	if node is AbstractEnemy:
		node.distance_to_exit = path_length - node.offset
		node.current_path_length = path_length
		node.current_path = self
		
		node.connect("on_death_by_any_cause", self, "_emit_enemy_on_death", [node])
		node.connect("reached_end_of_path", self, "_emit_enemy_reached_end")


func _emit_enemy_on_death(enemy):
	emit_signal("on_enemy_death", enemy)

func _emit_enemy_reached_end(enemy):
	emit_signal("on_enemy_reached_end", enemy)
