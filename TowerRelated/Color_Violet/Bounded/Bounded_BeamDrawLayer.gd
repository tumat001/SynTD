extends Node2D


var source_pos
var dest_pos
var width
var color

var show_beam : bool

func _ready():
	z_as_relative = false
	z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	

func update_draw():
	update()

func _draw():
	if show_beam:
		draw_line(source_pos - global_position, dest_pos - global_position, color, width)
		
