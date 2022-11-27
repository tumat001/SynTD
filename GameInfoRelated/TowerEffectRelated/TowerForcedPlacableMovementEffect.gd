extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const TowerStunEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerStunEffect.gd")

signal halfway_point_reached()
signal end_reached(arg_ended_from_replaced)


const TIME_BASED_MOVEMENT_SPEED : float = -1.0

const REVERSE_DIRECTION : int = 0
const IMMEDIATE_SNAP_BACK : int = 1

const default_mov_speed : float = 50.0

#

var action_on_destination_occupied : int = REVERSE_DIRECTION

var destination_placable
var destination_placable_backup

var mov_speed : float

var current_movement_speed : float
#var current_direction : Vector2
var _current_placable_to_mov_to

var _total_distance_from_source_to_destination : float
var _current_distance_travelled : float

var _current_tower

var _halfway_point_reached : bool

var _stun_effect_applied

#

func _init(arg_destination_placable,
		arg_2nd_destination_placable, # if first not found
		arg_mov_speed : float,
		arg_effect_uuid : int).(EffectType.FORCED_PLACABLE_MOV_EFFECT, arg_effect_uuid):
	
	destination_placable = arg_destination_placable
	destination_placable_backup = arg_2nd_destination_placable
	
	mov_speed = arg_mov_speed
	
	is_timebound = false
	should_respect_attack_module_scale = false
	should_map_in_all_effects_map = false


func _get_copy_scaled_by(scale : float):
	scale = 1   # does not matter
	
	var copy = get_script().new(destination_placable, destination_placable_backup, mov_speed, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	copy.scale_movements(scale)
	
	return copy


func scale_movements(mov_scale : float):
	if mov_speed != TIME_BASED_MOVEMENT_SPEED:
		mov_speed *= mov_scale
	
	current_movement_speed *= mov_scale

#

func _shallow_duplicate():
	var copy = get_script().new(destination_placable, destination_placable_backup, mov_speed, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy

#

func can_initialize_mov() -> bool:
	return (is_instance_valid(destination_placable) or is_instance_valid(destination_placable_backup))

func initialize_mov(arg_tower):
	_current_tower = arg_tower
	if is_instance_valid(destination_placable):
		_current_placable_to_mov_to = destination_placable
	elif is_instance_valid(destination_placable_backup):
		_current_placable_to_mov_to = destination_placable_backup
	
	var curr_pos : Vector2 = arg_tower.global_position
	#current_direction = curr_pos.direction_to(_current_placable_to_mov_to.global_position)
	
	_total_distance_from_source_to_destination = _current_placable_to_mov_to.global_position.distance_to(arg_tower.global_position)
	
	if mov_speed == TIME_BASED_MOVEMENT_SPEED:
		mov_speed = _total_distance_from_source_to_destination / time_in_seconds
	
	_current_distance_travelled = 0
	
	#
	_stun_effect_applied = _current_tower.add_tower_effect(generate_stun_effect_from_self())


func mov_process(delta : float):
	var delta_mov_speed = mov_speed * delta
	
	if is_instance_valid(_current_tower) and is_instance_valid(_current_placable_to_mov_to):
		_current_tower.global_position = _current_tower.global_position.move_toward(_current_placable_to_mov_to.global_position, delta_mov_speed)
		
		_current_distance_travelled += delta_mov_speed
		
		# halfway point
		if !_halfway_point_reached and _current_distance_travelled / _total_distance_from_source_to_destination <= 0.5:
			_halfway_point_reached = true
			var success = _attempt_change_tower_placable_to_destination()
			if !success:
				if action_on_destination_occupied == REVERSE_DIRECTION:
					_current_placable_to_mov_to = _current_tower.current_placable
				elif action_on_destination_occupied == IMMEDIATE_SNAP_BACK:
					_current_tower.global_position = _current_tower.current_placable
					_end_mov()
			
			emit_signal("halfway_point_reached")
		
		# end point
		if _current_tower.global_position == _current_placable_to_mov_to.global_position:
			_end_mov()

func _attempt_change_tower_placable_to_destination() -> bool:
	if _current_placable_to_mov_to.last_calculated_can_be_occupied:
		return _current_tower.transfer_to_placable(_current_placable_to_mov_to, false, false, false, false, false)
	else:
		return false



#

func end_mov_due_to_replace():
	_end_mov(true)

func _end_mov(arg_ended_from_replaced = false):
	mov_speed = 0
	if is_instance_valid(_current_tower) and _stun_effect_applied != null:
		_current_tower.remove_tower_effect(_stun_effect_applied)
	
	emit_signal("end_reached", arg_ended_from_replaced)

#

func generate_stun_effect_from_self() -> TowerStunEffect:
	var stun_effect = TowerStunEffect.new(1, effect_uuid)
	stun_effect.is_from_enemy = is_from_enemy
	
	stun_effect.is_timebound = false
	
	return stun_effect



