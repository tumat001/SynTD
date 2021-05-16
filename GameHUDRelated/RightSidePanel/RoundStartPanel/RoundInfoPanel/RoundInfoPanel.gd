extends MarginContainer

const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")

onready var health_label = $MarginContainer/VBoxContainer/HealthPanel/HBoxContainer/MarginContainer2/HealthLabel
onready var health_icon = $MarginContainer/VBoxContainer/HealthPanel/HBoxContainer/MarginContainer/HealthIcon
onready var stage_num_label = $MarginContainer/VBoxContainer/StageRoundPanel/HBoxContainer/StageNumPanel/Body/MarginContainer2/StageNumLabel
onready var round_num_label = $MarginContainer/VBoxContainer/StageRoundPanel/HBoxContainer/RoundNumPanel/Body/MarginContainer2/RoundNumLabel

func set_health_display(health : float):
	health_label.text = str(health)


func set_stageround(stageround : StageRound):
	_set_stage_num_display(stageround.stage_num)
	_set_round_num_display(stageround.round_num)

func _set_stage_num_display(stage : int):
	stage_num_label.text = str(stage)

func _set_round_num_display(round_num : int):
	round_num_label.text = str(round_num)
