extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"


const time_for_arrival : float = 0.75
var _distance_to_travel_before_stop : float
var _pos_to_travel_to
var _settled : bool = false

func send_to_position(arg_pos, initial_trap_placement_speed):
	var distance = global_position.distance_to(arg_pos)
	_distance_to_travel_before_stop = distance
	_pos_to_travel_to = arg_pos
	
	var accel = -initial_trap_placement_speed / time_for_arrival
	
	speed_inc_per_sec = accel

func _process(delta):
	if !_settled:
		_distance_to_travel_before_stop -= delta * speed
		
		if _distance_to_travel_before_stop <= 0:
			speed = 0
			global_position = _pos_to_travel_to
			_settled = true

