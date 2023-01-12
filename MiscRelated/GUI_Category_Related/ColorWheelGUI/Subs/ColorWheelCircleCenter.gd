extends Control


var _main_radius : float
var _inner_circle_fill_radius : float

var _main_radius_color
var _inner_circle_fill_radius_color

var _center : Vector2


func set_circle_properties(arg_main_radius : float, arg_inner_circle_fill_radius : float,
		arg_main_radius_color : Color, arg_inner_circle_fill_radius_color : Color,
		arg_center : Vector2):
	
	_main_radius = arg_main_radius
	_inner_circle_fill_radius = arg_inner_circle_fill_radius
	_main_radius_color = arg_main_radius_color
	_inner_circle_fill_radius_color = arg_inner_circle_fill_radius_color
	
	_center = arg_center
	
	update()


func _draw():
	draw_circle(_center, _main_radius, _main_radius_color)
	
	if _main_radius_color != _inner_circle_fill_radius_color:
		draw_circle(_center, _inner_circle_fill_radius, _inner_circle_fill_radius_color)

