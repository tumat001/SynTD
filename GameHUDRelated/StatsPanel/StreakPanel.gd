extends MarginContainer

const StageRoundManager = preload("res://GameElementsRelated/StageRoundManager.gd")
const WinIcon = preload("res://GameHUDRelated/StatsPanel/Assets/StreakIndicator_WinIcon.png")
const LoseIcon = preload("res://GameHUDRelated/StatsPanel/Assets/StreakIndicator_LoseIcon.png")
const NoneIcon = preload("res://GameHUDRelated/StatsPanel/Assets/StreakIndicator_NoneIcon.png")

var stage_round_manager : StageRoundManager setget set_stage_round_manager

onready var streak_label = $MarginContainer/HBoxContainer/MarginContainer/StreakLabel
onready var streak_icon = $MarginContainer/HBoxContainer/StreakIcon

# setters

func set_stage_round_manager(arg_manager : StageRoundManager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)
	
	_update_display()


#

func _on_round_ended(curr_stageround):
	_update_display()

func _update_display():
	var win_streak = stage_round_manager.current_win_streak
	var lose_streak = stage_round_manager.current_lose_streak
	
	if win_streak >= 1:
		streak_label.text = str(win_streak)
		streak_icon.texture = WinIcon
	elif lose_streak >= 1:
		streak_label.text = str(lose_streak)
		streak_icon.texture = LoseIcon
	else:
		streak_label.text = "0"
		streak_icon.texture = NoneIcon

