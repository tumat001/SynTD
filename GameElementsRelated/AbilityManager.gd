extends Node

const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const AbilityPanel = preload("res://GameHUDRelated/AbilityPanel/AbilityPanel.gd")

signal time_decreased(delta)
signal round_ended()
signal round_started()

signal add_ability_effect(effect)
signal remove_ability_effect(effect)

var stage_round_manager setget set_stage_round_manager
var ability_panel : AbilityPanel setget set_ability_panel


var all_effects : Dictionary = {}
var all_abilities : Array


# adding removing connections

func add_ability(ability : BaseAbility, add_ability_to_panel : bool = true):
	if !is_connected("time_decreased", ability, "time_decreased"):
		if stage_round_manager.round_started:
			ability.round_started()
		else:
			ability.round_ended()
		
		connect("time_decreased", ability, "time_decreased", [], CONNECT_PERSIST)
		connect("round_ended", ability, "round_ended", [], CONNECT_PERSIST)
		connect("round_started", ability, "round_started", [], CONNECT_PERSIST)
		connect("add_ability_effect", ability, "add_ability_effect_from_manager", [], CONNECT_PERSIST)
		connect("remove_ability_effect", ability, "remove_ability_effect_from_manager", [], CONNECT_PERSIST)
		
		for effect in all_effects.values():
			ability.add_ability_effect(effect)
		
		if ability_panel != null and add_ability_to_panel:
			ability_panel.add_ability(ability)
		
		all_abilities.append(ability)

# Use base ability's destroy_self func
#func remove_ability(ability : BaseAbility):
#	if is_connected("time_decreased", ability, "time_decreased"):
#		disconnect("time_decreased", ability, "time_decreased")
#		disconnect("round_ended", ability, "round_ended")
#		disconnect("round_started", ability, "round_started")
#		disconnect("add_ability_effect", ability, "add_ability_effect_from_manager")
#		disconnect("remove_ability_effect", ability, "remove_ability_effect_from_manager")
#
#		for effect in all_effects.values():
#			ability.remove_ability_effect(effect)
#
#		ability_panel.remove_ability(ability)



# setters

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended", self, "on_round_ended", [], CONNECT_PERSIST)
	stage_round_manager.connect("round_started", self, "on_round_started", [], CONNECT_PERSIST)


func set_ability_panel(arg_panel : AbilityPanel):
	ability_panel = arg_panel


# signals related

func on_round_ended(curr_stageround):
	emit_signal("round_ended")

func on_round_started(curr_staground):
	emit_signal("round_started")


func _process(delta):
	_decrease_time_cooldown_of_all_abilities(delta)

func _decrease_time_cooldown_of_all_abilities(delta : float):
	if stage_round_manager.round_started:
		emit_signal("time_decreased", delta)

func add_effect_to_all_abilities(effect, register_to_all_effects_map : bool = true):
	all_effects[effect.effect_uuid] = effect
	emit_signal("add_ability_effect", effect)

func remove_effect_to_all_abilities(effect, register_to_all_effects_map : bool = true):
	all_effects.erase(effect.effect_uuid)
	emit_signal("remove_ability_effect", effect)
