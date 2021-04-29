extends Node

var internal_name : String
var time_in_seconds : float
var is_timebound : bool

func get_modification_to_value(value):
	pass

func _init(arg_internal_name : String):
	internal_name = arg_internal_name
	time_in_seconds = 5
	is_timebound = false

func get_description():
	pass

func get_copy_scaled_by(scale_factor : float):
	pass
