extends "res://TowerRelated/DamageAndSpawnables/BaseAOE.gd"

var total_time : float

func _ready():
	anim_sprite.scale = Vector2(0.5, 0.5)

func _process(delta):
	anim_sprite.scale *= (1.25 + delta) - total_time
	total_time += delta
