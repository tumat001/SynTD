extends MarginContainer

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const AbstractTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/AbstractTextFragment.gd")



var description : String
var img_indicator : Resource
var color : Color = Color(0, 0, 0, 1)
var uses_bbcode : bool

var font_size : int = 8

#

var _tower
var _tower_info

var _text_fragment_interpreters : Array

var _use_color_for_dark_background : bool

#

onready var label = $ColumnContainer/MarginContainer/Label

func _init(arg_img_indicator : Resource = null, arg_description : String = ""):
	description = arg_description
	img_indicator = arg_img_indicator

func _ready():
	$ColumnContainer/ImageIndicator.texture = img_indicator
	
	label.add_font_override("normal_font", StoreOfFonts.get_font_with_size(StoreOfFonts.FontTypes.CONSOLA, font_size))
	
	label.bbcode_enabled = uses_bbcode
	
	if (!uses_bbcode):
		label.set("custom_colors/font_color", color)
		label.text = description
		
	else:
		
		label.bbcode_text = _get_bbc_modified_description(description)#description
	

func get_info_from_self_class(self_class):
	description = self_class.description
	img_indicator = self_class.img_indicator

#

func _get_bbc_modified_description(arg_desc : String) -> String:
	var index = 0
	
	for interpreter in _text_fragment_interpreters:
		interpreter.use_color_for_dark_background = _use_color_for_dark_background
		
		if interpreter.tower_to_use_for_tower_stat_fragments == null:
			interpreter.tower_to_use_for_tower_stat_fragments = _tower
		
		if interpreter.tower_info_to_use_for_tower_stat_fragments == null:
			interpreter.tower_info_to_use_for_tower_stat_fragments = _tower_info
		
		
		var interpreted_text = interpreter.interpret_array_of_instructions_to_final_text()
		arg_desc = arg_desc.replace("|%s|" % str(index), interpreted_text)
		
		index += 1
	
	arg_desc = arg_desc.replace(AbstractTextFragment.width_img_val_placeholder, str(font_size / 2))
	
	
	return "[color=#%s]%s[/color]" % [color.to_html(false), arg_desc]
