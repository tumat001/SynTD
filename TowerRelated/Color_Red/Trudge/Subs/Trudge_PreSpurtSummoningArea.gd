extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


func _ready():
	z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	queue_free_at_end_of_lifetime = false
	
	deactivate()

func activate():
	frame = 0
	playing = true
	has_lifetime = true

func deactivate():
	playing = false
	has_lifetime = false
	frame = 0
