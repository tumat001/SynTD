extends "res://GameInfoRelated/Modifier.gd"

var PercentType = preload("res://GameInfoRelated/PercentType.gd")

var percent_amount : float
var flat_minimum : float
var flat_maximum : float
var ignore_flat_limits
var percent_based_on

func _init(arg_internal_name : String).(arg_internal_name):
	internal_name = arg_internal_name
	percent_amount = 100
	flat_maximum = 10000
	flat_minimum = 0
	ignore_flat_limits = true
	percent_based_on = PercentType.MAX

func get_modification_to_value(value):
	var modification = value * percent_amount / 100
	if !ignore_flat_limits:
		if modification < flat_minimum:
			modification = flat_minimum
		if modification > flat_maximum:
			modification = flat_maximum
	
	return modification

func get_description() -> Array:
	var descriptions : Array = []
	
	descriptions[0] = str(percent_amount) + "% " + PercentType.get_description_of(percent_based_on)
	var description02 : String = ""
	if !ignore_flat_limits:
		if flat_minimum != 0:
			description02 += "from " + str(flat_minimum) + " "
		
		description02 += "up to " + str(flat_maximum)
		descriptions[1] = description02
	
	return descriptions
