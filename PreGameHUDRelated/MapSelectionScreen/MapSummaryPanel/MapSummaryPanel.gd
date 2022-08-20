extends MarginContainer

signal play_button_released()

onready var map_name_label = $Container/VBoxContainer/MapNameLabel
onready var difficulty_name_label = $Container/VBoxContainer/DifficultyLabel
onready var play_button = $Container/VBoxContainer/PlayButton

func _ready():
	set_map_name("")
	set_difficulty_name("")
	set_is_enabled(false)


func set_map_name(arg_name):
	map_name_label.text = "Map: %s" % arg_name

func set_difficulty_name(arg_diff):
	difficulty_name_label.text = "Difficulty: %s" % arg_diff

func set_is_enabled(arg_val):
	play_button.set_is_button_enabled(arg_val)

#

func _on_PlayButton_on_button_released_with_button_left():
	emit_signal("play_button_released")
