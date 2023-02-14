extends Reference

const GameElements = preload("res://GameElementsRelated/GameElements.gd")

enum BreakpointActivation {
	BEFORE_GAME_START = 0,
	BEFORE_MAIN_INIT = 1,
}

var modifier_id
var modifier_name : String
var modifier_icon : Texture

var can_be_viewed_by_player : bool
var breakpoint_activation : int

var game_elements : GameElements


func _init(arg_id, arg_breakpoint_activation : int, 
		arg_modi_name : String):
	modifier_id = arg_id
	breakpoint_activation = arg_breakpoint_activation
	modifier_name = arg_modi_name


##

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	game_elements = arg_elements
	


func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	game_elements = arg_elements
	

