extends MarginContainer

const Mesa_ChoiceDetails = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/Subs/Mesa_ChoiceDetails.gd")

const Choice_Frame_Normal_Pic = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/ChoiceFrame_Pic.png")
const Choice_Frame_Highlighted_Pic = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/ChoiceFrame_Pic_Highlighted.png")

var mesa_choice_details : Mesa_ChoiceDetails setget set_mesa_choice_details


onready var icon_texture_rect = $ContentMarginer/VBoxContainer/MarginContainer/ChoiceIcon
onready var frame_texture_rect = $ContentMarginer/VBoxContainer/MarginContainer/Frame

onready var left_border = $Left
onready var right_border = $Right
onready var up_border = $Up
onready var down_border = $Down

onready var choice_name_label = $ContentMarginer/VBoxContainer/Content02/MarginContainer/VBoxContainer/NameLabel
onready var tooltip_body = $ContentMarginer/VBoxContainer/Content02/MarginContainer/VBoxContainer/TooltipBody


#

func set_mesa_choice_details(arg_details : Mesa_ChoiceDetails):
	mesa_choice_details = arg_details
	
	if is_inside_tree():
		_update_display_base_on_choice_details()

#

func _ready():
	if mesa_choice_details != null:
		_update_display_base_on_choice_details()


func _update_display_base_on_choice_details():
	icon_texture_rect.texture = mesa_choice_details.icon
	_update_border_texture(mesa_choice_details.border_texture_normal)
	
	choice_name_label.text = mesa_choice_details.choice_name
	tooltip_body.descriptions = mesa_choice_details.descriptions
	
	tooltip_body.update_display()

func _update_border_texture(arg_texture):
	left_border.texture = arg_texture
	right_border.texture = arg_texture
	up_border.texture = arg_texture
	down_border.texture = arg_texture

##



func _on_Button_mouse_entered():
	_update_border_texture(mesa_choice_details.border_texture_highlighted)
	frame_texture_rect.texture = Choice_Frame_Highlighted_Pic

func _on_Button_mouse_exited():
	_update_border_texture(mesa_choice_details.border_texture_normal)
	frame_texture_rect.texture = Choice_Frame_Normal_Pic


#

func _on_Button_released_mouse_event(event):
	mesa_choice_details.choice_selected()
	

