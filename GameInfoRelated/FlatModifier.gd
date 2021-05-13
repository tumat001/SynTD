extends "res://GameInfoRelated/Modifier.gd"

var flat_modifier : float

func _init(arg_internal_name : String).(arg_internal_name):
	internal_name = arg_internal_name
	flat_modifier = 0

func get_modification_to_value(value):
	return flat_modifier

func get_description():
	return str(flat_modifier)

func get_description_scaled(scale : float):
	return str(flat_modifier * scale)


func get_copy_scaled_by(scale_factor : float):
	var copy = get_script().new(internal_name)
	copy.flat_modifier = flat_modifier * scale_factor
	
	return copy
