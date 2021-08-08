const GameElements = preload("res://GameElementsRelated/GameElements.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")


signal on_path_activated()

var green_path_name : String
var green_path_descriptions : Array
var green_path_icon : Texture

var dom_syn_green

#

func _init(arg_name : String, arg_descs : Array, arg_icon : Texture):
	green_path_name = arg_name
	green_path_descriptions = arg_descs
	green_path_icon = arg_icon

#

func activate_path_with_green_syn(arg_dom_syn_green):
	dom_syn_green = arg_dom_syn_green
	
	dom_syn_green.connect("synergy_applied", self, "_dom_syn_green_applied", [dom_syn_green.game_elements], CONNECT_PERSIST)
	dom_syn_green.connect("synergy_removed", self, "_remove_path_from_game_elements", [dom_syn_green.game_elements], CONNECT_PERSIST)
	
	if dom_syn_green.curr_tier != dom_syn_green.SYN_INACTIVE:
		_apply_path_tier_to_game_elements(dom_syn_green.curr_tier, dom_syn_green.game_elements)
	else:
		pass
		#_remove_path_from_game_elements(dom_syn_green.curr_tier, dom_syn_green.game_elements)
	
	emit_signal("on_path_activated")


#

func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	pass

func _remove_path_from_game_elements(tier : int, arg_game_elements : GameElements):
	pass
