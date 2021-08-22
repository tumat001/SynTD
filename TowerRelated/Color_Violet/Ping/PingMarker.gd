extends "res://TowerRelated/DamageAndSpawnables/BaseAOE.gd"

var total_time : float

func _ready():
	anim_sprite.scale = Vector2(0.5, 0.5)

func _process(delta):
	var inc = 12 * delta
	anim_sprite.scale += Vector2(inc, inc)
	total_time += delta
	
	modulate.a -= delta * 2.5
