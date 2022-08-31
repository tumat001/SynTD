extends Timer


var _current_tower

func set_tower_and_properties(arg_tower):
	_current_tower = arg_tower
	
	_current_tower.connect("on_tower_no_health", self, "_on_tower_lost_all_health", [], CONNECT_PERSIST)
	_current_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
	_current_tower.connect("on_last_calculated_disabled_from_attacking_changed", self, "_on_last_calculated_disabled_from_attacking_changed", [], CONNECT_PERSIST)

#

func _on_tower_lost_all_health():
	stop()

func _on_round_end():
	stop()

func _on_last_calculated_disabled_from_attacking_changed(arg_val):
	stop()

#

func stop():
	.stop()

