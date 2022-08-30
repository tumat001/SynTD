extends MarginContainer

onready var desc_tooltip_body = $ContentContainer/DescTooltipBody


func set_descriptions(arg_descs : Array):
	desc_tooltip_body.descriptions = arg_descs
	desc_tooltip_body.update_display()
	

