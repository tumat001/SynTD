extends Reference


var min_sv_value : int = 1 setget set_min_sv_value
var max_sv_value : int = 4 setget set_max_sv_value

var middle_sv_value : float


func set_min_sv_value(arg_val):
	min_sv_value = arg_val
	_update_middle_sv_value()

func set_max_sv_value(arg_val):
	max_sv_value = arg_val
	_update_middle_sv_value()

func _update_middle_sv_value():
	middle_sv_value = (min_sv_value + max_sv_value) / 2.0

##

func _init():
	_update_middle_sv_value()

#




