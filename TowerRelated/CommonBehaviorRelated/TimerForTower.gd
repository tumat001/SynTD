extends Timer


signal timer_stopped()


var _current_tower

var stop_on_round_end_instead_of_pause : bool = true

var stop_on_disabled_from_attacking : bool = true



func set_tower_and_properties(arg_tower):
	_current_tower = arg_tower
	
	_current_tower.connect("on_tower_no_health", self, "_on_tower_lost_all_health", [], CONNECT_PERSIST)
	_current_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
	_current_tower.connect("on_last_calculated_disabled_from_attacking_changed", self, "_on_last_calculated_disabled_from_attacking_changed", [], CONNECT_PERSIST)
	_current_tower.connect("on_round_start", self, "_on_round_start", [], CONNECT_PERSIST)
	
	
	_on_last_calculated_disabled_from_attacking_changed(_current_tower.last_calculated_disabled_from_attacking)
#	if _current_tower.is_round_started:
#		_on_round_start()
#	else:
#		_on_round_end()
	

#

func _on_tower_lost_all_health():
	stop()

func _on_round_end():
	if stop_on_round_end_instead_of_pause:
		stop()
	else:
		paused = true

func _on_round_start():
	if paused:
		paused = false

func _on_last_calculated_disabled_from_attacking_changed(arg_val):
	if stop_on_disabled_from_attacking:
		paused = arg_val
#	if arg_val:
#		stop()

#

func stop():
	.stop()
	
	emit_signal("timer_stopped")

