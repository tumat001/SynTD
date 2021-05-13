extends MarginContainer

const TooltipPlainTextDescription = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipPlainTextDescription.gd")
const TooltipPlainTextDescriptionScene = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipPlainTextDescription.tscn")
const TooltipWithTextIndicatorDescription = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithTextIndicatorDescription.gd")
const TooltipWithTextIndicatorDescriptionScene = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithTextIndicatorDescription.tscn")
const TooltipWithImageIndicatorDescription = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithImageIndicatorDescription.gd")
const TooltipWithImageIndicatorDescriptionScene = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithImageIndicatorDescription.tscn")

var descriptions : Array = []
var children : Array = []

var specific_font_colors : Array = []
var default_font_color : Color

func _ready():
	update_display()

func update_display():
	_kill_all_desc()
	var index = 0
	
	for desc in descriptions:
		var desc_instance
		
		if desc is String:
			desc_instance = TooltipPlainTextDescriptionScene.instance()
			desc_instance.description = desc
		elif desc is TooltipPlainTextDescription:
			desc_instance = TooltipPlainTextDescriptionScene.instance()
		elif desc is TooltipWithTextIndicatorDescription:
			desc_instance = TooltipWithTextIndicatorDescriptionScene.instance()
		elif desc is TooltipWithImageIndicatorDescription:
			desc_instance = TooltipWithImageIndicatorDescriptionScene.instance()
		
		if !(desc is String):
			desc_instance.get_info_from_self_class(desc)
		
		
		if specific_font_colors.size() > index:
			if specific_font_colors[index] != null:
				desc_instance.color = specific_font_colors[index]
			else:
				desc_instance.color = default_font_color
		else:
			desc_instance.color = default_font_color
		
		
		children.append(desc_instance)
		
		$RowContainer.add_child(desc_instance)
		index += 1
	

func _kill_all_desc():
	for ch in children:
		ch.queue_free()
	
	children.clear()

func queue_free():
	_kill_all_desc()
