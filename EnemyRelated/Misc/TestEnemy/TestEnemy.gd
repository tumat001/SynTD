extends "res://EnemyRelated/AbstractEnemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	_post_ready()

func _init():
	base_health = 52
	current_health = 52
	pierce_consumed_per_hit = 1
	base_movement_speed = 22
	
