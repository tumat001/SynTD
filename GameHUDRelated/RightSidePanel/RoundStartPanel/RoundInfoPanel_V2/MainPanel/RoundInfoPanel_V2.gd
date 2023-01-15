extends MarginContainer


onready var player_health_panel = $ContentPanel/VBoxContainer/PlayerHealthPanel
onready var round_indicator_panel = $ContentPanel/VBoxContainer/RoundIndicatorPanel


func set_stage_round_manager(arg_manager):
	round_indicator_panel.stage_round_manager = arg_manager

func set_heath_manager(arg_manager):
	player_health_panel.health_manager = arg_manager

func set_enemy_manager(arg_manager):
	round_indicator_panel.enemy_manager = arg_manager

#

func _ready():
	pass


func get_heart_icon_global_pos():
	return player_health_panel.get_heart_icon_global_pos()
