extends "res://GameHUDRelated/Tooltips/BaseTooltip.gd"

const TooltipBody = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipBody.gd")

export(String) var header_left_text : String
export(Color) var header_left_color : Color = Color(1, 1, 1, 1)

export(String) var header_middle_text : String
export(Color) var header_middle_color : Color = Color(1, 1, 1, 1)

export(String) var header_right_text : String
export(Color) var header_right_color : Color = Color(1, 1, 1, 1)

export(Array, String) var simple_descriptions : Array = []
export(bool) var use_simple_descriptions : bool = false
var descriptions : Array = []
export(Color) var body_color : Color = Color(1, 1, 1, 1)

onready var tooltip_body : TooltipBody = $VBoxContainer/BodyMarginer/TooltipBody
onready var left_label : Label = $VBoxContainer/HeaderMarginer/LabelMarginer/LeftLabel
onready var middle_label : Label = $VBoxContainer/HeaderMarginer/LabelMarginer/MiddleLabel
onready var right_label : Label = $VBoxContainer/HeaderMarginer/LabelMarginer/RightLabel

var tower_associated_with_ability
var game_settings_manager

func update_display():
	rect_min_size.y = 0
	rect_size.y = 0
	
	var desc_to_use : Array = _get_descriptions_to_use()
	
	tooltip_body.default_font_color = body_color
	tooltip_body.descriptions = desc_to_use
	tooltip_body.tower_for_text_fragment_interpreter = tower_associated_with_ability 
	tooltip_body.update_display()
	
	_set_label_properties(left_label, header_left_text, header_left_color)
	_set_label_properties(middle_label, header_middle_text, header_middle_color)
	_set_label_properties(right_label, header_right_text, header_right_color)


func _get_descriptions_to_use() -> Array:
	if use_simple_descriptions:
		return simple_descriptions
	else:
		return descriptions


func _set_label_properties(label : Label, text : String, color : Color):
	if text == null:
		text = ""
	
	label.text = text
	label.add_color_override("font_color", color)
