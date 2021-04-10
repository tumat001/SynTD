extends Node2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")

# This spawner is responsible for spawning enemies
# at a spawn point, and making them follow a path.
# 
# This spawner should also be responsible for
# determining which enemies should spawn (depends on
# round).

enum MapType {
	TEST_MAP
}

class SpawnDetails:
	var path : Path2D
	var spawn_point : Vector2
	
	func _init(arg_path : Path2D, arg_spawn_point : Vector2):
		path = arg_path
		spawn_point = arg_spawn_point

var spawn_details = {}
export var map_type : int

# Called when the node enters the scene tree for the first time.
func _ready():
	var path = {}
	var spawn_point = {}
	
	if map_type == 0:
		path["01"] = get_parent().get_node("EnemyPath01")
		var first_point_pos = get_parent().get_node("EnemyPath01").curve.get_point_position(0)
		spawn_point["01"] = Vector2(first_point_pos.x, first_point_pos.y)
		spawn_details["01"] = SpawnDetails.new(path["01"], spawn_point["01"])
		
		spawn_enemy()

func spawn_enemy():
	var enemy = EnemyConstants.test_enemy_scene.instance()
	enemy.position.x = spawn_details["01"].spawn_point.x
	enemy.position.y = spawn_details["01"].spawn_point.y
	enemy.distance_to_exit = get_parent().get_node("EnemyPath01").curve.get_baked_length()
	
	get_parent().get_node("EnemyPath01").add_child(enemy)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_TestTimer_timeout():
	spawn_enemy()
