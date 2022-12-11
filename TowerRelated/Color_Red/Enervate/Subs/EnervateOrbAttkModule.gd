extends "res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd"

signal request_for_new_target_to_acquire()
signal hid_and_deactivated()
signal shown_and_activated()

onready var orb_sprite = $OrbSprite


const orb_cannot_be_commanded_clause__not_yet_summoned : int = -10
const orb_cannot_be_commanded_clause__in_flight_to_new_target : int = -11


const distance_to_current_target_for_reposition : float = 90.0
const speed_deceleration_for_reposition : float = 50.0
#const time_for_reposition : float = 1.5
#var speed_deceleration_for_reposition : float
const speed_to_consider_reposition_ratio_to_current = 0.25
var _speed_to_consider_reposition : float = 0
var _current_speed_for_reposition : float = 0

var min_distance_from_target_on_reposition : float = 20.0
var max_distance_from_target_on_reposition : float = 60.0

var enervate_orb_reposition_rng : RandomNumberGenerator

var _current_pos_of_reposition : Vector2
var assigned_target

var parent_enervate_tower setget set_parent_enervate_tower

#

func set_parent_enervate_tower(arg_tower):
	parent_enervate_tower = arg_tower
	
	range_module.mirror_tower_main_range_module_targeting_changes(arg_tower)
	arg_tower.connect("on_round_end", self, "_on_round_end_eo", [], CONNECT_PERSIST)
	_on_round_end_eo()
	
	range_module.connect("current_enemy_left_range", self, "_on_curr_target_left_range", [], CONNECT_PERSIST)

#

func _ready():
	enervate_orb_reposition_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.ENERVATE_REPOSITION)


#

# used when first summoned, and when no enemies are in range anymore.
func assign_new_target_to_follow(arg_target):
	if !is_instance_valid(assigned_target) and is_instance_valid(arg_target):
		_set_assigned_target__and_connect_signals_with_target(arg_target)
		_move_towards_target(arg_target)


func _move_towards_target(arg_target):
	_current_pos_of_reposition = _get_postion_of_reposition(arg_target.global_position)
	_current_speed_for_reposition = _get_speed_for_reposition(arg_target.global_position)
	_speed_to_consider_reposition = _current_speed_for_reposition * speed_to_consider_reposition_ratio_to_current
	#print("speed to consider repo: %s" % _speed_to_consider_reposition)


func _set_assigned_target__and_connect_signals_with_target(arg_target):
	assigned_target = arg_target
	
	if !assigned_target.is_connected("cancel_all_lockons", self, "_on_assigned_target_cancel_all_lockons"):
		assigned_target.connect("cancel_all_lockons", self, "_on_assigned_target_cancel_all_lockons")
		assigned_target.connect("on_killed_by_damage", self, "_on_assigned_target_killed")
		assigned_target.connect("tree_exiting", self, "_on_assigned_target_queue_freed")

func _on_assigned_target_cancel_all_lockons():
	_drop_assigned_target___and_request_for_new()

func _on_assigned_target_killed(dmg_instance_report, arg_enemy):
	_drop_assigned_target___and_request_for_new()

func _on_assigned_target_queue_freed():
	_drop_assigned_target___and_request_for_new()

func _drop_assigned_target___and_request_for_new():
	if is_instance_valid(assigned_target):
		if assigned_target.is_connected("cancel_all_lockons", self, "_on_assigned_target_cancel_all_lockons"):
			assigned_target.disconnect("cancel_all_lockons", self, "_on_assigned_target_cancel_all_lockons")
			assigned_target.disconnect("on_killed_by_damage", self, "_on_assigned_target_killed")
			assigned_target.disconnect("tree_exiting", self, "_on_assigned_target_queue_freed")
	
	assigned_target = null
	emit_signal("request_for_new_target_to_acquire")



#

func _get_speed_for_reposition(arg_repos_pos : Vector2):
	var distance = global_position.distance_to(arg_repos_pos)
	return sqrt((_current_speed_for_reposition * _current_speed_for_reposition) + (2 * speed_deceleration_for_reposition * distance))
	
#	var speed = (2 * distance / time_for_reposition) - _current_speed_for_reposition
#	speed_deceleration_for_reposition = (_current_speed_for_reposition - speed) / time_for_reposition
#	print("speed: %s, speed decel: %s" % [str(speed), str(speed_deceleration_for_reposition)])
#	return speed

func _get_postion_of_reposition(arg_target_pos):
	var rand_deg_angle = enervate_orb_reposition_rng.randi_range(0, 359)
	var rand_dist = enervate_orb_reposition_rng.randi_range(min_distance_from_target_on_reposition, max_distance_from_target_on_reposition)
	
	return arg_target_pos + Vector2(rand_dist, 0).rotated(deg2rad(rand_deg_angle))

#

func _process(delta):
	if _current_pos_of_reposition != null:
		global_position = global_position.move_toward(_current_pos_of_reposition, delta * _current_speed_for_reposition)
		_current_speed_for_reposition -= speed_deceleration_for_reposition * delta
		if _current_speed_for_reposition < 0:
			_current_speed_for_reposition = 0
		
		
		#update()

#func _draw():
#	draw_circle(_current_pos_of_reposition - global_position, 7, Color(1, 0, 0, 1))
#

func _physics_process(delta):
	if is_instance_valid(assigned_target) and _current_speed_for_reposition <= _speed_to_consider_reposition:
		var dist = global_position.distance_to(assigned_target.global_position)
		if dist >= distance_to_current_target_for_reposition:
			_move_towards_target(assigned_target)
		
	

#

func _on_round_end_eo():
	hide_and_deactivate__as_not_yet_summoned()
	global_position = parent_enervate_tower.global_position + parent_enervate_tower.initial_position_for_orb_attk_mod_spawn


func hide_and_deactivate__as_not_yet_summoned():
	visible = false
	can_be_commanded_by_tower_other_clauses.attempt_insert_clause(orb_cannot_be_commanded_clause__not_yet_summoned)
	emit_signal("hid_and_deactivated")

func show_and_activate__as_summoned():
	visible = true
	can_be_commanded_by_tower_other_clauses.remove_clause(orb_cannot_be_commanded_clause__not_yet_summoned)
	emit_signal("shown_and_activated")

#

func _on_curr_target_left_range(arg_enemy):
	_drop_assigned_target___and_request_for_new()

