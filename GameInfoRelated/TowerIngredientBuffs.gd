enum {
	FLAT_DAMAGE,
	ENEMY_PERCENT_OF_MAX_HP_DAMAGE,
	ENEMY_PERCENT_OF_CURRENT_HP_DAMAGE,
	ENEMY_PERCENT_OF_MISSING_HP_DAMAGE,
	ENEMY_PERCENT_OF_BASE_HP_DAMAGE,
	
	FLAT_ATTACK_SPEED,
	PERCENT_BASE_ATTACK_SPEED,
	
	FLAT_PIERCE,
	PERCENT_BASE_PIERCE,
	
	FLAT_RANGE,
	PERCENT_BASE_RANGE,
	
	FLAT_PROJ_SPEED,
	PERCENT_BASE_PROJ_SPEED,
	
	FLAT_PROJ_TIME,
	PERCENT_BASE_PROJ_TIME,
	
	# PUT OTHER CUSTOM THINGS HERE
}

var buff_name_source : String
var buff_type : int
var modifier : Modifier
var display_text : String

func _init(arg_buff_name_source : String, arg_buff_type : int,
		 arg_modifier : Modifier, arg_display_text):
	
	buff_name_source = arg_buff_name_source
	buff_type = arg_buff_type
	modifier = arg_modifier
	display_text = arg_display_text
