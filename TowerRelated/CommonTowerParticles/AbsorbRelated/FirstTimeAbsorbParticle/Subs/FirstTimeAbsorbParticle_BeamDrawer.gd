extends Node2D


var beam_target : Node2D setget set_beam_target
var color_to_use : Color

var is_beam_for_display : bool

#

func _ready():
	set_process(false)
	is_beam_for_display = false
	
	z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_PARTICLE_EFFECTS


func set_beam_target(arg_target):
	beam_target = arg_target
	

#

func start_beam_display():
	is_beam_for_display = true
	set_process(true)

func end_beam_display():
	is_beam_for_display = false
	set_process(false)
	


#

func _process(delta):
	update()


func _draw():
	if is_beam_for_display:
		draw_line(Vector2(0, 0), beam_target.global_position - global_position, color_to_use, 3)



