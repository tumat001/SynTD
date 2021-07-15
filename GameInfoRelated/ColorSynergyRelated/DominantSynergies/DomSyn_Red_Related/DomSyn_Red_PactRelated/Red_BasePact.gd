
const GameElements = preload("res://GameElementsRelated/GameElements.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")


var game_elements : GameElements

var pact_icon : Texture
var pact_name : String
var pact_uuid : int

var good_descriptions : Array
var bad_descriptions : Array

var tier : int

var pact_mag_rng : RandomNumberGenerator

func _init(arg_uuid : int, arg_name : String, arg_tier : int):
	pact_uuid = arg_uuid
	tier = arg_tier
	pact_name = arg_name
	
	pact_mag_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.DOMSYN_RED_PACT_MAGNITUDE)


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	pass



