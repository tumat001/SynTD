extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"

const slowdown_threshold_trigger : float = 200.0
const min_speed : float = 150.0

func _ready():
	pass


func _process(delta):
	if current_life_distance <= slowdown_threshold_trigger:
		if speed >= min_speed:
			speed -= 1400 * delta
