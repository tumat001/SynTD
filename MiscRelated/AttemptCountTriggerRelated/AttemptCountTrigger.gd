extends Reference


signal on_reached_trigger_count()


var count_for_trigger : int = 3
var duration_for_count_reset : float = 5.0
var ignore_game_speed_for_trigger_duration_reset : bool = true


var _timer_for_trigger_count_reset : Timer
var _current_count : int
var _node_to_carry_timer


func _init(arg_node_to_carry_timer : Node):
	_node_to_carry_timer = arg_node_to_carry_timer
	
	_timer_for_trigger_count_reset = Timer.new()
	_timer_for_trigger_count_reset.one_shot = true
	_timer_for_trigger_count_reset.connect("timeout", self, "_on_timer_for_trigger_count_reset", [], CONNECT_PERSIST)
	_node_to_carry_timer.add_child(_timer_for_trigger_count_reset)


func _on_timer_for_trigger_count_reset():
	_reset_count()

func _reset_count():
	_current_count = 0

#

func get_current_count_of_attempt_trigger():
	return _current_count

#

func add_attempt_to_trigger(arg_trigger_count : int = 1):
	_current_count += 1
	var wait_duration = duration_for_count_reset
	
	if ignore_game_speed_for_trigger_duration_reset:
		var game_speed = Engine.time_scale
		wait_duration *= game_speed
	
	_timer_for_trigger_count_reset.start(wait_duration)
	
	if _current_count >= count_for_trigger:
		_on_reached_trigger_count()


func _on_reached_trigger_count():
	emit_signal("on_reached_trigger_count")
	_reset_count()


