extends MarginContainer

onready var multiple_tower_damage_stats_container = $MarginContainer/VBoxContainer/MarginContainer/MultipleTowerRoundDamageStatsPanel


func set_tower_manager(arg_manager):
	multiple_tower_damage_stats_container.tower_manager = arg_manager

func set_stage_round_manager(arg_manager):
	multiple_tower_damage_stats_container.stage_round_manager = arg_manager

#
