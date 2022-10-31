extends "res://GameInfoRelated/Modifier.gd"

signal on_values_changed()

var flat_modifier : float setget _set_flat_modifier

#

func _set_flat_modifier(arg_val):
	flat_modifier = arg_val
	emit_signal("on_values_changed")

#

func _init(arg_internal_id : int).(arg_internal_id):
	flat_modifier = 0

func get_modification_to_value(value):
	return flat_modifier

func get_value():
	return flat_modifier


func get_description():
	return str(flat_modifier)

func get_description_scaled(scale : float):
	return str(flat_modifier * scale)


func get_copy_scaled_by(scale_factor : float):
	var copy = get_script().new(internal_id)
	copy.flat_modifier = flat_modifier #* scale_factor
	copy.scale_by(scale_factor)
	
	return copy

func scale_by(scale_factor : float):
	flat_modifier *= scale_factor 
	emit_signal("on_values_changed")


