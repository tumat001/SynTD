const Modifier = preload("res://GameInfoRelated/Modifier.gd")

enum {
	FLAT_BASE_DAMAGE_BONUS,
	PERCENT_BASE_DAMAGE_BONUS,
	
	FLAT_ON_HIT_DAMAGE,
	PERCENT_ENEMY_HEALTH_ON_HIT_DAMAGE,
	
	FLAT_ATTACK_SPEED,
	PERCENT_BASE_ATTACK_SPEED,
	
	FLAT_PIERCE,
	PERCENT_BASE_PIERCE,
	
	FLAT_RANGE,
	PERCENT_BASE_RANGE,
	
	FLAT_PROJ_SPEED,
	PERCENT_BASE_PROJ_SPEED,
	
	# PUT OTHER CUSTOM THINGS HERE
}

var buff_name_source : String
var buff_type : int
var modifier : Modifier
var description = null

func _init(arg_buff_name_source : String, arg_buff_type : int,
		 arg_modifier : Modifier, arg_description : String):
	
	buff_name_source = arg_buff_name_source
	buff_type = arg_buff_type
	modifier = arg_modifier
	description = arg_description

func get_description() -> String:
	if description != null:
		return description
	
	if buff_type == FLAT_BASE_DAMAGE_BONUS:
		return _generate_flat_description("base dmg")
	elif buff_type == PERCENT_BASE_DAMAGE_BONUS:
		return _generate_percent_description("of base dmg")
	elif buff_type == FLAT_ON_HIT_DAMAGE:
		return _generate_flat_description("on hit dmg")
	elif buff_type == PERCENT_ENEMY_HEALTH_ON_HIT_DAMAGE:
		return _generate_percent_description("enemy health on hit dmg")
	elif buff_type == FLAT_ATTACK_SPEED:
		return _generate_flat_description("bonus attk speed")
	elif buff_type == PERCENT_BASE_ATTACK_SPEED:
		return _generate_percent_description("of base attk speed")
	elif buff_type == FLAT_PIERCE:
		return _generate_flat_description("bonus pierce")
	elif buff_type == PERCENT_BASE_PIERCE:
		return _generate_percent_description("of base pierce")
	elif buff_type == FLAT_RANGE:
		return _generate_flat_description("bonus range")
	elif buff_type == PERCENT_BASE_RANGE:
		return _generate_percent_description("of base range")
	
	return "Err"


func _generate_flat_description(descriptor : String) -> String:
	return "+" + modifier.get_description() + " " + descriptor

func _generate_percent_description(descriptor : String) -> String:
	var descriptions : Array = modifier.get_description()
	var desc01 = descriptions[0]
	var desc02 = ""
	
	if descriptions.size() == 2:
		desc02 = descriptions[1]
	
	return "+" + desc01 + " " + descriptor + " " + desc02
