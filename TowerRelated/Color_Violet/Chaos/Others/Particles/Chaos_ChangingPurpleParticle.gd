extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"



var particle_y_per_sec : float
var particle_lifetime : float
var particle_time_before_mov : float

var particle_modulate_a : float
var particle_z_index : int

var _lifetime_for_color_shift : float


func _ready():
	modulate.a = particle_modulate_a
	z_index = particle_z_index
	z_as_relative = false
	
	stop_process_at_invisible = true
	
	y_displacement_per_sec = particle_y_per_sec
	
	reset_states()

func reset_states():
	frame = 0
	lifetime = particle_lifetime
	
	_lifetime_for_color_shift = (particle_lifetime - particle_time_before_mov) / 2.0
	


func _process(delta):
	_lifetime_for_color_shift -= delta
	
	if _lifetime_for_color_shift < 0:
		frame = 1


