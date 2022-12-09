extends MarginContainer


var relic_manager setget set_relic_manager

onready var relic_count_label = $ContentMargin/VBoxContainer/HBoxContainer/MarginContainer/RelicCountLabel

func set_relic_manager(arg_manager):
	relic_manager = arg_manager
	
	arg_manager.connect("current_relic_count_changed", self, "_on_relic_count_changed", [], CONNECT_PERSIST)
	if is_inside_tree():
		_update_relic_count()

func _on_relic_count_changed(arg_new_count):
	_update_relic_count()



func _ready():
	if relic_manager != null:
		_update_relic_count()

func _update_relic_count():
	relic_count_label.text = str(relic_manager.current_relic_count)

