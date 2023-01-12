const GameElements = preload("res://GameElementsRelated/GameElements.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")


signal on_path_activated()

signal applied_path_tier_to_game_elements()
signal removed_path_tier_from_game_elements()

var green_path_name : String
var green_path_descriptions : Array
var green_path_icon : Texture
var green_path_tier : int

var dom_syn_green

var is_currently_applied_to_game_elements__based_on_tier : bool
var is_activated : bool

#

func _init(arg_name : String, arg_descs : Array, arg_icon : Texture, arg_path_tier : int):
	green_path_name = arg_name
	green_path_descriptions = arg_descs
	green_path_icon = arg_icon
	green_path_tier = arg_path_tier

#

func activate_path_with_green_syn(arg_dom_syn_green):
	if !is_activated:
		is_activated = true
		
		dom_syn_green = arg_dom_syn_green
		
		dom_syn_green.connect("synergy_applied", self, "_apply_path_tier_to_game_elements", [dom_syn_green.game_elements], CONNECT_PERSIST)
		dom_syn_green.connect("synergy_removed", self, "_remove_path_from_game_elements", [dom_syn_green.game_elements], CONNECT_PERSIST)
		
		if dom_syn_green.curr_tier != dom_syn_green.SYN_INACTIVE:
			_apply_path_tier_to_game_elements(dom_syn_green.curr_tier, dom_syn_green.game_elements)
		else:
			pass
			#_remove_path_from_game_elements(dom_syn_green.curr_tier, dom_syn_green.game_elements)
		
		emit_signal("on_path_activated")


#

func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	if tier <= green_path_tier:
		is_currently_applied_to_game_elements__based_on_tier = true
		emit_signal("applied_path_tier_to_game_elements")


func _remove_path_from_game_elements(tier : int, arg_game_elements : GameElements):
	is_currently_applied_to_game_elements__based_on_tier = false
	emit_signal("removed_path_tier_from_game_elements")
	

