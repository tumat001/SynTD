extends "res://EnemyRelated/AbstractEnemy.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	base_health = 1
	current_health = 1
	pierce_consumed_per_hit = 1
	base_movement_speed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_CollisionArea_body_entered(body):
	if body is BaseBullet:
		hit_by_bullet(body)

