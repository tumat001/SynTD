extends "res://GameHUDRelated/Tooltips/BaseTooltip.gd"


onready var tooltip_body = $VBoxContainer/Body/BodyContainer/TooltipBody
onready var header_label = $VBoxContainer/Header/HeaderContainer/HeaderLabel


var tooltip_descriptions : Array
var header_text : String


func ready():
	pass


func _update_tooltip_body_desc(arg_descs):
	tooltip_body.descriptions = arg_descs
	tooltip_body.update_display()

func _update_header_label(arg_text):
	header_label.text = arg_text



func update_display():
	_update_tooltip_body_desc(tooltip_descriptions)
	_update_header_label(header_text)
