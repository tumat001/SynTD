extends Node

const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const StageRoundManager = preload("res://GameElementsRelated/StageRoundManager.gd")
const AbilityPanel = preload("res://GameHUDRelated/AbilityPanel/AbilityPanel.gd")

signal time_decreased(delta)
signal round_ended()
signal round_started()

var stage_round_manager : StageRoundManager setget set_stage_round_manager
var ability_panel : AbilityPanel setget set_ability_panel


# adding removing connections

func add_ability(ability : BaseAbility):
	if !is_connected("time_decreased", ability, "time_decreased"):
		if stage_round_manager.round_started:
			ability.round_started()
		else:
			ability.round_ended()
		
		connect("time_decreased", ability, "time_decreased", [], CONNECT_PERSIST)
		connect("round_ended", ability, "round_ended", [], CONNECT_PERSIST)
		connect("round_started", ability, "round_started", [], CONNECT_PERSIST)
		
		if ability_panel != null:
			ability_panel.add_ability(ability)


#func remove_ability(ability : BaseAbility):
#	if is_connected("time_decreased", ability, "time_decreased"):
#		disconnect("time_decreased", ability, "time_decreased")
#		disconnect("round_ended", ability, "round_ended")
#		disconnect("round_started", ability, "round_started")


# setters

func set_stage_round_manager(arg_manager : StageRoundManager):
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
	if stage_round_manager.round_started:
		emit_signal("time_decreased", delta)
