extends "res://EnemyRelated/AbstractEnemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	base_health = 52
	current_health = 52
	pierce_consumed_per_hit = 1
	base_movement_speed = 16
	
	distance_to_exit = 2000 - offset
	
	_post_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
