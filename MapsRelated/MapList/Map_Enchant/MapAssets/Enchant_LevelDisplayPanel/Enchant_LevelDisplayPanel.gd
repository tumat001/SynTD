extends MarginContainer


const level_label_string = "%s/%s"


var map_enchant setget set_map_enchant

onready var level_label = $MarginContainer/VBoxContainer/LevelLabel


func set_map_enchant(arg_map):
	map_enchant = arg_map
	
	map_enchant.connect("current_upgrade_phase_changed", self, "_on_map_current_upgrade_phase_changed", [], CONNECT_PERSIST)
	
	_update_display()

func _on_map_current_upgrade_phase_changed(arg_val):
	_update_display()

func _update_display():
	level_label.text = level_label_string % [map_enchant.get_upgrade_phase(), map_enchant.max_upgrade_phase]
	
	visible = map_enchant.get_upgrade_phase() > 0


