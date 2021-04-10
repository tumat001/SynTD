extends "res://GameInfoRelated/Modifier.gd"

var flat_modifier : float

func _init(arg_internal_name : String).(arg_internal_name):
	internal_name = arg_internal_name
	flat_modifier = 0

func get_modification_to_value(value):
	return flat_modifier
