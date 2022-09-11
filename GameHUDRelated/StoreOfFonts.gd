extends Node

enum FontTypes {
	CONSOLA = 1,
	CONSOLA_BOLD = 2,
	CHIVO_REGULAR = 3,
}

var _consola_font_size_to_font_map : Dictionary = {}
var _consola_bold_font_size_to_font_map : Dictionary = {}
var _chivo_regular_font_size_to_font_map : Dictionary = {}

func get_font_with_size(font_type : int, font_size : int) -> DynamicFont:
	if font_type == FontTypes.CONSOLA:
		return get_consola_font_with_size(font_size)
	elif font_type == FontTypes.CONSOLA_BOLD:
		return get_consola_bold_font_with_size(font_size)
	elif font_type == FontTypes.CHIVO_REGULAR:
		return get_chivo_regular_font_with_size(font_size)
	
	return null

#

func get_consola_font_with_size(font_size : int) -> DynamicFont:
	if _consola_font_size_to_font_map.has(font_size):
		return _consola_font_size_to_font_map[font_size]
	else:
		return _add_consola_font_with_size_to_map(font_size)

func _add_consola_font_with_size_to_map(font_size : int) -> DynamicFont:
	var font_data = DynamicFontData.new()
	font_data.font_path = "res://Fonts/consolas/CONSOLA.TTF"
	
	var consola_font = DynamicFont.new()
	consola_font.font_data = font_data
	consola_font.size = font_size
	
	_consola_font_size_to_font_map[font_size] = consola_font
	return consola_font

#

func get_consola_bold_font_with_size(font_size : int) -> DynamicFont:
	if _consola_bold_font_size_to_font_map.has(font_size):
		return _consola_bold_font_size_to_font_map[font_size]
	else:
		return _add_consola_bold_font_with_size_to_map(font_size)

func _add_consola_bold_font_with_size_to_map(font_size : int) -> DynamicFont:
	var font_data = DynamicFontData.new()
	font_data.font_path = "res://Fonts/consolas/consolas-bold.ttf"
	
	var consola_font = DynamicFont.new()
	consola_font.font_data = font_data
	consola_font.size = font_size
	
	_consola_bold_font_size_to_font_map[font_size] = consola_font
	return consola_font

#

func get_chivo_regular_font_with_size(font_size : int) -> DynamicFont:
	if _chivo_regular_font_size_to_font_map.has(font_size):
		return _chivo_regular_font_size_to_font_map[font_size]
	else:
		return _add_chivo_regular_font_with_size_to_map(font_size)

func _add_chivo_regular_font_with_size_to_map(font_size : int) -> DynamicFont:
	var font_data = DynamicFontData.new()
	font_data.font_path = "res://Fonts/chivo/chivo.regular.ttf"
	
	var font = DynamicFont.new()
	font.font_data = font_data
	font.size = font_size
	
	_chivo_regular_font_size_to_font_map[font_size] = font
	return font
