
var damage : float
var damage_type : int

var internal_id : int

func _init(arg_damage : float, 
		arg_damage_type : int, 
		arg_internal_id : int):
	
	damage = arg_damage
	damage_type = arg_damage_type
	internal_id = arg_internal_id


func duplicate():
	return get_script().new(damage, damage_type, internal_id)
