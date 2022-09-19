extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"


func _ready():
	show_as_unactive()


func show_as_active():
	rotation_per_second = 270
	bullet_sprite.frame = 0

func show_as_unactive():
	rotation_per_second = 0
	bullet_sprite.frame = 1


