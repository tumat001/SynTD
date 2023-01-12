extends Control

signal color_wheel_left_mouse_released()

#

enum ColorWheelColorSlices {
	NN = 1,
	NW = 2,
	SW = 3,
	SS = 4,
	SE = 5,
	NE = 6,
}

#
const default_color_slice_angles : Dictionary = {
	ColorWheelColorSlices.NN : 0, #
	ColorWheelColorSlices.NE : PI / 3,   #
	
	ColorWheelColorSlices.SE : 2 * PI / 3, #
	ColorWheelColorSlices.SS : 3 * PI / 3,
	ColorWheelColorSlices.SW : 4 * PI / 3,
	ColorWheelColorSlices.NW : 5 * PI / 3,
}

const color_wheel_slice_radius : float = 53.0

const inner_circle_radius : float = 15.0
const inner_circle_inner_fill_radius : float = 10.0

const slice_border_thickness : float = 3.0
const outer_border_thickness : float = 4.0

const slice_rad_size : float = PI / 6
const slice_mid_angle_rot_for_borders : float = PI / 6

#

const red_slice_modulate : Color = Color(217 / 255.0, 2/255.0, 6/255.0)
const orange_slice_modulate : Color = Color(1, 128/255.0, 0)
const yellow_slice_modulate : Color = Color(232/255.0, 253/255.0, 0)
const green_slice_modulate : Color = Color(30/255.0, 218/255.0, 2/255.0)
const blue_slice_modulate : Color = Color(2/255.0, 58/255.0, 218/255.0)
const violet_slice_modulate : Color = Color(163/255.0, 77/255.0, 253/255.0)
const slice_modulate_highlight_multiplier : float = 1.3


#

var _color_slice_radius : float

var _total_color_wheel_radius : float
var _center_pos_modifier : Vector2

#

onready var red_slice_gui = $RedSliceGUI
onready var orange_slice_gui = $OrangeSliceGUI
onready var yellow_slice_gui = $YellowSliceGUI
onready var green_slice_gui = $GreenSliceGUI
onready var blue_slice_gui = $BlueSliceGUI
onready var violet_slice_gui = $VioletSliceGUI

onready var wheel_border_gui = $ColorWheelBordersGUI
onready var wheel_circle_center_gui = $ColorWheelCircleCenter

onready var advanced_button = $AdvancedButton

var all_slice_gui : Array

#

func _ready():
	red_slice_gui.slice_id = ColorWheelColorSlices.NN
	orange_slice_gui.slice_id = ColorWheelColorSlices.NW
	yellow_slice_gui.slice_id = ColorWheelColorSlices.SW
	green_slice_gui.slice_id = ColorWheelColorSlices.SS
	blue_slice_gui.slice_id = ColorWheelColorSlices.SE
	violet_slice_gui.slice_id = ColorWheelColorSlices.NE
	
	all_slice_gui.append(red_slice_gui)
	all_slice_gui.append(orange_slice_gui)
	all_slice_gui.append(yellow_slice_gui)
	all_slice_gui.append(green_slice_gui)
	all_slice_gui.append(blue_slice_gui)
	all_slice_gui.append(violet_slice_gui)
	
	
	set_color_wheel_properties(color_wheel_slice_radius, slice_border_thickness, outer_border_thickness, inner_circle_radius)
	
	red_slice_gui.set_slice_modulate(red_slice_modulate)
	orange_slice_gui.set_slice_modulate(orange_slice_modulate)
	yellow_slice_gui.set_slice_modulate(yellow_slice_modulate)
	green_slice_gui.set_slice_modulate(green_slice_modulate)
	blue_slice_gui.set_slice_modulate(blue_slice_modulate)
	violet_slice_gui.set_slice_modulate(violet_slice_modulate)
	
	wheel_border_gui.set_border_properties(slice_border_thickness, outer_border_thickness, _center_pos_modifier, _total_color_wheel_radius, default_color_slice_angles.values(), slice_mid_angle_rot_for_borders)
	
	var color_black = Color(0, 0, 0)
	#var color_white = Color(1, 1, 1)
	wheel_circle_center_gui.set_circle_properties(inner_circle_radius, inner_circle_inner_fill_radius, color_black, color_black, _center_pos_modifier)

#


func set_color_wheel_properties(arg_color_slice_radius, arg_slice_border_thickness, arg_outer_border_thickness, arg_inner_black_circle_radius):
	_total_color_wheel_radius = (arg_color_slice_radius - arg_inner_black_circle_radius) + arg_outer_border_thickness
	
	var size_vector = (Vector2(_total_color_wheel_radius * 2, _total_color_wheel_radius * 2))
	rect_min_size = size_vector
	rect_size = size_vector
	advanced_button.rect_min_size = size_vector
	advanced_button.rect_size = size_vector
	
	
	_center_pos_modifier = Vector2(_total_color_wheel_radius, _total_color_wheel_radius)
	
	for slice_gui in all_slice_gui:
		slice_gui.set_slice_properties__using_angle_mid(_center_pos_modifier, _total_color_wheel_radius, default_color_slice_angles[slice_gui.slice_id], slice_rad_size)
	
#



func _on_AdvancedButton_released_mouse_event(event : InputEventMouseButton):
	if event.button_index == BUTTON_LEFT:
		emit_signal("color_wheel_left_mouse_released")


