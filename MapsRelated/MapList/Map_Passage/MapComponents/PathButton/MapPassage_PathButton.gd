extends MarginContainer

const PathToggleButton_Border_Activatable = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathButton/PathToggleButton_Border_Activatable.png")
const PathToggleButton_Border_Unactivatable = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathButton/PathToggleButton_Border_Unactivatable.png")
const PathToggleButton_Border_Hovered = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathButton/PathToggleButton_Border_Hovered.png")

const PathToggleButton_Pic_Offstate = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathButton/PathToggleButton_Pic_OffState.png")
const PathToggleButton_Pic_Onstate = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathButton/PathToggleButton_Pic_OnState.png")

signal button_on_state_changed(arg_val)


var button_on_state : bool setget set_button_on_state
var button_border_activatable_state : bool setget set_button_border_activatable_state
var _is_button_hovered : bool


onready var button_icon = $ButtonIcon
onready var left = $Left
onready var right = $Right
onready var top = $Top
onready var bottom = $Bottom

func _on_Button_released_mouse_event(event):
	if button_border_activatable_state:
		set_button_on_state(!button_on_state)


func set_button_on_state(arg_val):
	button_on_state = arg_val
	
	_update_button_display()
	
	emit_signal("button_on_state_changed", button_on_state)

func _update_button_display():
	if button_on_state:
		button_icon.texture = PathToggleButton_Pic_Onstate
	else:
		button_icon.texture = PathToggleButton_Pic_Offstate

#

func set_button_border_activatable_state(arg_val):
	button_border_activatable_state = arg_val
	
	_update_border_display_based_on_activatable_and_hovered()


func _on_Button_mouse_entered():
	_set_button_hovered(true)

func _on_Button_mouse_exited():
	_set_button_hovered(false)


func _set_button_hovered(arg_val : bool):
	_is_button_hovered = arg_val
	
	_update_border_display_based_on_activatable_and_hovered()

func _set_texture_of_borders(arg_texture):
	left.texture = arg_texture
	right.texture = arg_texture
	top.texture = arg_texture
	bottom.texture = arg_texture


func _update_border_display_based_on_activatable_and_hovered():
	if button_border_activatable_state:
		if _is_button_hovered:
			_set_texture_of_borders(PathToggleButton_Border_Hovered)
		else:
			_set_texture_of_borders(PathToggleButton_Border_Activatable)
	else:
		
		_set_texture_of_borders(PathToggleButton_Border_Unactivatable)


