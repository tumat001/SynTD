extends Path2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

signal on_enemy_death(enemy)
signal on_enemy_reached_end(enemy)

enum MarkerIds {
	SKIRMISHER_CLONE_OF_BASE_PATH = 1,
	SKIRMISHER_BASE_PATH_ALREADY_CLONED = 2,
}



var path_length : float

var marker_id_to_value_map : Dictionary = {}


func _ready():
	path_length = curve.get_baked_length()
	

func add_child(node : Node, legible_unique_name : bool = false):
	.add_child(node, legible_unique_name)
	
	if node is AbstractEnemy:
		node.distance_to_exit = path_length - node.offset
		node.unit_distance_to_exit = 1
		node.current_path_length = path_length
		node.current_path = self
		
		node.connect("on_death_by_any_cause", self, "_emit_enemy_on_death", [node])
		node.connect("reached_end_of_path", self, "_emit_enemy_reached_end")

func _emit_enemy_on_death(enemy):
	emit_signal("on_enemy_death", enemy)

func _emit_enemy_reached_end(enemy):
	emit_signal("on_enemy_reached_end", enemy)


#

func get_copy_of_path(reversed : bool):
	var copy = self.duplicate()
	
	copy.curve = curve.duplicate()
	copy.curve.clear_points()
	
	
	var pos_index = -1
	if reversed:
		pos_index = 0
	
	for point in curve.get_baked_points():
		copy.curve.add_point(point, Vector2(0, 0), Vector2(0, 0), pos_index)
	
	#
	
	copy.marker_id_to_value_map = marker_id_to_value_map.duplicate(true)
	
	return copy


