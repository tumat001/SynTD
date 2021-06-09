extends MarginContainer

const TooltipPlainTextDescription = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipPlainTextDescription.gd")
const TooltipPlainTextDescriptionScene = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipPlainTextDescription.tscn")
const TooltipWithTextIndicatorDescription = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithTextIndicatorDescription.gd")
const TooltipWithTextIndicatorDescriptionScene = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithTextIndicatorDescription.tscn")
const TooltipWithImageIndicatorDescription = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithImageIndicatorDescription.gd")
const TooltipWithImageIndicatorDescriptionScene = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithImageIndicatorDescription.tscn")

var descriptions : Array = []

var specific_font_colors : Array = []
export(Color) var default_font_color : Color

func _ready():
	update_display()

func update_display():
	rect_min_size.y = 0
	rect_size.y = 0
	
	_kill_all_desc()
	var index = 0
	
	for desc in descriptions:
		var desc_instance
		
		if desc is String:
			desc_instance = TooltipPlainTextDescriptionScene.instance()
			desc_instance.description = desc
#		elif desc is TooltipPlainTextDescription:
#			desc_instance = TooltipPlainTextDescriptionScene.instance()
#		elif desc is TooltipWithTextIndicatorDescription:
#			desc_instance = TooltipWithTextIndicatorDescriptionScene.instance()
#		elif desc is TooltipWithImageIndicatorDescription:
#			desc_instance = TooltipWithImageIndicatorDescriptionScene.instance()
#
#		if !(desc is String):
#			desc_instance.get_info_from_self_class(desc)
#
		else:
			desc_instance = desc
		
		
		if specific_font_colors.size() > index:
			if specific_font_colors[index] != null:
				desc_instance.color = specific_font_colors[index]
			else:
				desc_instance.color = default_font_color
		else:
			desc_instance.color = default_font_color
		
		
		$RowContainer.add_child(desc_instance)
		index += 1
	

func _kill_all_desc():
	for ch in $RowContainer.get_children():
		ch.queue_free()




func _queue_free():
	clear_descriptions_in_array()
	
	.queue_free()

func clear_descriptions_in_array():
	for desc in descriptions:
		if !desc is String:
			desc.queue_free()
