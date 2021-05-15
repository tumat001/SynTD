extends Node

const RoundStatusPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStatusPanel.gd")


signal stage_round_changed(stage_num, round_num)
signal round_started()
signal round_ended()


var round_status_panel : RoundStatusPanel setget _set_round_status_panel

var stage_num : int
var round_num : int

var round_started : bool
var round_fast_forwarded : bool

func _set_round_status_panel(panel : RoundStatusPanel):
	round_status_panel = panel
	
	round_status_panel.connect("round_start_pressed", self, "start_round")
	round_status_panel.connect("round_ended_pressed", self, "end_round")


# Round start related

func start_round():
	_before_round_start()
	_at_round_start()
	_after_round_start()
	
	emit_signal("round_started")
	round_started = true


func _before_round_start():
	pass

func _at_round_start():
	pass

func _after_round_start():
	pass


# Round end related

func end_round():
	_before_round_end()
	_at_round_end()
	_after_round_end()
	
	emit_signal("round_ended")
	round_started = false


func _before_round_end():
	pass

func _at_round_end():
	pass

func _after_round_end():
	pass
