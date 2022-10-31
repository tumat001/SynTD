extends "res://GameInfoRelated/Modifier.gd"

var PercentType = preload("res://GameInfoRelated/PercentType.gd")

signal on_values_changed()

var percent_amount : float setget _set_percent_amount
var flat_minimum : float
var flat_maximum : float
var ignore_flat_limits
var percent_based_on

#

func _set_percent_amount(arg_val):
	percent_amount = arg_val
	emit_signal("on_values_changed")
	


#

func _init(arg_internal_id : int).(arg_internal_id):
	percent_amount = 100
	flat_maximum = 0
	flat_minimum = 0
	ignore_flat_limits = true
	percent_based_on = PercentType.MAX

func get_modification_to_value(value):
	var modification = value * percent_amount / 100
	if !ignore_flat_limits:
		if modification < flat_minimum:
			modification = flat_minimum
		elif modification > flat_maximum:
			modification = flat_maximum
	
	return modification

func get_value(): # used for comparison checks (range), but could be for others
	return percent_amount

# ex: 10% max ___ from lowerlimit up to upperlimit
func get_description() -> Array:
	var descriptions : Array = []
	
	descriptions.append(str(percent_amount) + "% " + PercentType.get_description_of(percent_based_on))
	var description02 : String = ""
	if !ignore_flat_limits:
		if flat_minimum != 0:
			description02 += "from " + str(flat_minimum) + " "
		
		description02 += "up to " + str(flat_maximum)
		descriptions.append(description02)
	
	return descriptions

func get_description_scaled(scale : float) -> Array:
	var descriptions : Array = []
	
	descriptions.append(str(percent_amount * scale) + "% " + PercentType.get_description_of(percent_based_on))
	var description02 : String = ""
	if !ignore_flat_limits:
		if flat_minimum != 0:
			description02 += "from " + str(flat_minimum * scale) + " "
		
		description02 += "up to " + str(flat_maximum * scale)
		descriptions.append(description02)
	
	return descriptions


#

func get_copy_scaled_by(scale_factor : float):
	var copy = get_script().new(internal_id)
	#copy.scale_by(scale_factor)
	copy.percent_amount = percent_amount * scale_factor
	copy.flat_minimum = flat_minimum * scale_factor
	copy.flat_maximum = flat_maximum * scale_factor
	
	copy.ignore_flat_limits = ignore_flat_limits
	copy.percent_based_on = percent_based_on
	
	return copy

func scale_by(scale_factor : float):
	percent_amount *= scale_factor
	flat_minimum *= scale_factor
	flat_maximum *= scale_factor
	
	emit_signal("on_values_changed")
	

