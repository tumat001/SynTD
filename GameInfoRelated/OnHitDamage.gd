
const Modifier = preload("res://GameInfoRelated/Modifier.gd")

signal on_damage_as_modifier_values_changed()


var damage_as_modifier : Modifier setget _set_dmg_modifier
var damage_type : int
var internal_id : int

var armor_pierce_modifiers = {}
var toughness_pierce_modifiers = {}
var resistance_pierce_modifiers = {}

#

func _init(arg_internal_id: int, 
	arg_damage_as_modifier, 
	arg_damage_type):
	
	damage_as_modifier = arg_damage_as_modifier
	damage_type = arg_damage_type
	internal_id = arg_internal_id
	
	damage_as_modifier.connect("on_values_changed", self, "_on_dmg_as_modi_vals_changed", [], CONNECT_PERSIST)


func _on_dmg_as_modi_vals_changed():
	emit_signal("on_damage_as_modifier_values_changed")

#

func _set_dmg_modifier(arg_new_val):
	if damage_as_modifier != null:
		damage_as_modifier.disconnect("on_values_changed", self, "_on_dmg_as_modi_vals_changed")
	
	damage_as_modifier = arg_new_val
	
	if damage_as_modifier != null:
		damage_as_modifier.connect("on_values_changed", self, "_on_dmg_as_modi_vals_changed", [], CONNECT_PERSIST)

#

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

func scale_by(scale : float):
	damage_as_modifier.scale_by(scale)
	


