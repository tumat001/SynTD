extends Reference


var descriptions : Array
var obj_source_for_descriptions : Object
var obj_method_for_descriptions : String 
var obj_method_for_duplicate_of_descriptions : String

var header_left_text : String


#####
var button_texture_normal : Texture
var button_texture_highlighted : Texture

#
var obj_source_for_on_click : Object
var obj_method_for_on_click : String  # expects return of bool (true if success, false otherwise)

#
var relic_count_requirement : int = 1


func _init(arg_obj_source_for_on_click : Object,
		arg_obj_method_for_on_click : String,
		arg_button_texture_normal : Texture,
		arg_button_texture_highlighted : Texture):
	
	obj_source_for_on_click = arg_obj_source_for_on_click
	obj_method_for_on_click = arg_obj_method_for_on_click
	
	button_texture_normal = arg_button_texture_normal
	button_texture_highlighted = arg_button_texture_highlighted


func get_descriptions_to_use() -> Array:
	if descriptions != null:
		return descriptions
	elif obj_source_for_descriptions != null:
		return obj_source_for_descriptions.call(obj_method_for_descriptions)
	
	return []

func get_descriptions_to_use__duplicate() -> Array:
	if descriptions != null:
		return descriptions.duplicate(true)
	elif obj_source_for_descriptions != null:
		return obj_source_for_descriptions.call(obj_method_for_duplicate_of_descriptions)
	
	return []

func get_left_header_text_to_use() -> String:
	return header_left_text
