extends "res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd"


const anim_name_for__line := "line"
const anim_name_for__square := "square"


var dmg_num_for__very_small : float
var dmg_num_for__small : float
var dmg_num_for__medium : float

var rng_to_use : RandomNumberGenerator

#

func _ready():
	z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
	z_as_relative = false
	
	queue_free_at_end_of_lifetime = false
	
	min_starting_distance_from_center = 12
	max_starting_distance_from_center = 15


func randomize_texture_properties():
	var i = rng_to_use.randi_range(0, 1)
	
	if i == 0:
		play(anim_name_for__line)
	else:
		play(anim_name_for__square)

##



