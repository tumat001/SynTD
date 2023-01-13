extends "res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd"


const mod_a : float = 0.8
const tier_1_color := Color(0.4, 0.4, 0.4, mod_a)
const tier_2_color := Color(31/255.0, 227/255.0, 2/255.0, mod_a)
const tier_3_color := Color(2/255.0, 139/255.0, 218/255.0, mod_a)
const tier_4_color := Color(165/255.0, 78/255.0, 253/255.0, mod_a)
const tier_5_color := Color(253/255.0, 73/255.0, 76/255.0, mod_a)
const tier_6_color := Color(253/255.0, 207/255.0, 68/255.0, mod_a)

const tier_to_color_map : Dictionary = {
	1 : tier_1_color,
	2 : tier_2_color,
	3 : tier_3_color,
	4 : tier_4_color,
	5 : tier_5_color,
	6 : tier_6_color
}

var tier : int setget set_tier__to_set_particle_color

onready var beam_drawer = $FirstTimeAbsorbParticle_BeamDrawer

#

func _ready():
	is_enabled_mov_toward_center = false



func set_tier__to_set_particle_color(arg_tier):
	tier = arg_tier
	modulate = tier_to_color_map[arg_tier]
	frame = arg_tier - 1
	
	beam_drawer.color_to_use = modulate


func set_beam_target(arg_target):
	beam_drawer.beam_target = arg_target
	

#

func start_beam_display():
	beam_drawer.start_beam_display()

func end_beam_display():
	beam_drawer.end_beam_display()
	


#

func _on_FirstTimeAbsorbParticle_visibility_changed():
	if !visible:
		end_beam_display()

