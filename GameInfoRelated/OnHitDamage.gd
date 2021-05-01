
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

func duplicate():
	var clone = get_script().new(internal_name, damage_as_modifier, damage_type)
	clone.armor_pierce_modifiers = armor_pierce_modifiers.duplicate(true)
	clone.toughness_pierce_modifiers = toughness_pierce_modifiers.duplicate(true)
	clone.resistance_pierce_modifiers = resistance_pierce_modifiers.duplicate(true)
	
	return clone
