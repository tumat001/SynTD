extends Node2D

signal fully_invisible_and_done()  # if changing this name, change signal name in ColorSplatterDrawer as well


var current_color : Color
var initial_radius : float

var current_radius_expand_per_sec : float
var radius_expand_change_per_sec : float

var _current_radius : float

#var lifetime : float
var _current_lifetime : float

var lifetime_to_start_modulate_a : float
var modulate_a_per_sec : float

#

var lifetime_to_show_ripple : float
var current_ripple_color : Color
var ripple_initial_radius : float

var current_ripple_radius_expand_per_sec : float
var ripple_radius_expand_change_per_sec : float

var _ripple_current_radius : float

var ripple_lifetime_to_start_modulate_a : float
var ripple_modulate_a_per_sec : float

var ripple_line_width : int

#

func _ready():
	z_as_relative = false
	z_index = ZIndexStore.ABOVE_ABOVE_MAP_ENVIRONMENT
	
	set_process(false)

#

func _process(delta):
	_current_lifetime += delta
	
	_current_radius += current_radius_expand_per_sec * delta
	current_radius_expand_per_sec += radius_expand_change_per_sec * delta
	if current_radius_expand_per_sec < 0:
		current_radius_expand_per_sec = 0
	
	#
	
	if lifetime_to_show_ripple <= _current_lifetime:
		if _ripple_current_radius == 0:
			_ripple_current_radius = initial_radius
		
		_ripple_current_radius += current_ripple_radius_expand_per_sec * delta
		current_ripple_radius_expand_per_sec += ripple_radius_expand_change_per_sec * delta
	
	#
	
	if lifetime_to_start_modulate_a <= _current_lifetime:
		current_color.a += modulate_a_per_sec * delta
		if current_color.a <= 0:
			current_color.a = 0
	
	if ripple_lifetime_to_start_modulate_a <= _current_lifetime:
		current_ripple_color.a += ripple_modulate_a_per_sec * delta
		if current_ripple_color.a <= 0:
			current_ripple_color.a = 0
	
	if current_color.a == 0 and current_ripple_color.a == 0:
		emit_signal("fully_invisible_and_done")
		end_display()
	
	
	update()



func _draw():
	draw_circle(Vector2(0, 0), _current_radius, current_color)
	
	if _ripple_current_radius > 0:
		draw_arc(Vector2(0, 0), _ripple_current_radius, 0, 2*PI, _ripple_current_radius / 4.0, current_ripple_color, ripple_line_width)


#

func start_display():
	_reset_for_new_display()
	
	set_process(true)

func _reset_for_new_display():
	_current_lifetime = 0
	_current_radius = initial_radius
	
	_ripple_current_radius = 0
	_current_radius = initial_radius
	#_current_lifetime = lifetime
	


func end_display():
	set_process(false)
	
