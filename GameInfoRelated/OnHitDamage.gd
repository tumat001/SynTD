
const Modifier = preload("res://GameInfoRelated/Modifier.gd")

var damage_as_modifier : Modifier
var damage_type : int
var internal_name : String

var armor_pierce_modifiers = {}
var toughness_pierce_modifiers = {}
var resistance_pierce_modifiers = {}

func _init(arg_internal_name: String, arg_damage_as_modifier, arg_damage_type):
	damage_as_modifier = arg_damage_as_modifier
	damage_type = arg_damage_type
	internal_name = arg_internal_name
