
const Modifier = preload("res://GameInfoRelated/Modifier.gd")

var damage_as_modifier : Modifier
var damage_type : int
var internal_id : int

var armor_pierce_modifiers = {}
var toughness_pierce_modifiers = {}
var resistance_pierce_modifiers = {}

func _init(arg_internal_id: int, 
	arg_damage_as_modifier, 
	arg_damage_type):
	
	damage_as_modifier = arg_damage_as_modifier
	damage_type = arg_damage_type
	internal_id = arg_internal_id


func duplicate():
	var clone = get_script().new(internal_id, damage_as_modifier.get_copy_scaled_by(1), damage_type)
	clone.armor_pierce_modifiers = armor_pierce_modifiers.duplicate(true)
	clone.toughness_pierce_modifiers = toughness_pierce_modifiers.duplicate(true)
	clone.resistance_pierce_modifiers = resistance_pierce_modifiers.duplicate(true)
	
	return clone

func get_copy_scaled_by(scale : float):
	var clone = get_script().new(internal_id, damage_as_modifier.get_copy_scaled_by(scale), damage_type)
	clone.armor_pierce_modifiers = armor_pierce_modifiers.duplicate(true)
	clone.toughness_pierce_modifiers = toughness_pierce_modifiers.duplicate(true)
	clone.resistance_pierce_modifiers = resistance_pierce_modifiers.duplicate(true)
	
	return clone
