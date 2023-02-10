extends "res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd"


signal reached_final_destination()
signal request_beam_attachment()
#signal request_beam_detachment()

const animation_name__big = "big"
const animation_name__medium = "medium"
const animation_name__small = "small"
const animation_name__very_small = "very_small"


var dmg_num_for__very_small : float
var dmg_num_for__small : float
var dmg_num_for__medium : float


enum TextureToUseId {
	SMALL = 0,
	MEDIUM = 1,
	BIG = 2,
	VERY_SMALL = 3,
}

var _finished_with_first_center : bool = false
var _can_auto_change_to_secondary_center : bool = true
var _is_doing_angle_change : bool = false
var _request_beam_attachment_on_center_change : bool = false

var beam_length : int
var beam_width : int

#var _lifetime_from_zero : float
#var _lifetime_from_z__to_start_center_change : float

#var _delta_passed_on_zero_speed : float
#var _delta_passed_for_center_change : float

var secondary_center : Vector2
var secondary_speed_accel_towards_center : float
var secondary_initial_speed_towards_center : float

#

var _angle_to_secondary_center : float
var _angle_per_sec : float

var _angle_per_sec_val_mag_sign : int
var _angle_magnitude_min : float
var _angle_magnitude_max : float

var _angle_modi

var _current_total_angle_turn_amount : float
var _target_total_angle_turn_amount : float

#

var _dmg_amount : float
var dmg_source_id : int

var cause_damage_at_destination_reach : bool

#

func _ready():
	z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
	z_as_relative = false
	
	has_lifetime = false
	queue_free_at_end_of_lifetime = false
	
	min_starting_distance_from_center = 8
	max_starting_distance_from_center = 15


func reset_for_another_use():
	.reset_for_another_use()
	
	#_lifetime_from_zero = 0
	max_speed_towards_center = 0
	min_speed_towards_center = -9999
	
	_dmg_amount = 0
	dmg_source_id = 0
	_angle_modi = 0
	
	secondary_initial_speed_towards_center = 0
	secondary_speed_accel_towards_center = 0
	#_can_auto_change_to_secondary_center = true
	
	#_delta_passed_on_zero_speed = 0
	
	#current_speed_towards_center = 1
	#_finished_with_first_center = false
	_can_auto_change_to_secondary_center = true
	_is_doing_angle_change = false
	
	is_enabled_mov_toward_center = true
	
	beam_length = 0
	beam_width = 0
	_request_beam_attachment_on_center_change = false



func _process(delta):
	if !_finished_with_first_center and current_speed_towards_center == 0:
		if _can_auto_change_to_secondary_center:
			_configure_self_to_change_to_secondary_center()
			
		else:
			_do_prep_on_finished_with_first_center()
		
		_finished_with_first_center = true
	
	if _is_doing_angle_change:
		var turn_amount = _angle_per_sec * delta
		rotation += turn_amount
		_current_total_angle_turn_amount += abs(turn_amount)
		
		if _current_total_angle_turn_amount >= _target_total_angle_turn_amount:
			rotation = _angle_to_secondary_center
			_is_doing_angle_change = false
			_configure_self_to_change_to_secondary_center()
	
#	_lifetime_from_zero += delta
#
#	if _lifetime_from_z__to_start_center_change >= _lifetime_from_zero and !_finished_with_first_center:
#		_finished_with_first_center = true
#
#		center_pos_of_basis = secondary_center
#		emit_signal("center_pos_of_basis_changed")
#

func _configure_self_to_change_to_secondary_center():
	_is_doing_angle_change = false
	center_pos_of_basis = secondary_center
	
	max_speed_towards_center = 9999
	min_speed_towards_center = 0
	
	rotation = global_position.angle_to_point(center_pos_of_basis) + _angle_modi
	
	current_speed_towards_center = secondary_initial_speed_towards_center
	speed_accel_towards_center = secondary_speed_accel_towards_center
	
	if !is_connected("reached_center_pos_of_basis", self, "_on_reached_center_pos_of_basis"):
		call_deferred("_connect_reached_to_center_deferred")
	
	if _request_beam_attachment_on_center_change:
		emit_signal("request_beam_attachment")


func _connect_reached_to_center_deferred():
	connect("reached_center_pos_of_basis", self, "_on_reached_center_pos_of_basis", [], CONNECT_ONESHOT)
	_emitted_reached_center_pos_of_basis = false

#

func set_properties_to_use_based_on_dmg_amount(arg_dmg_amount : float):
	if dmg_num_for__very_small >= arg_dmg_amount:
		_set_properties_for__very_small()
	elif dmg_num_for__small >= arg_dmg_amount:
		_set_properties_for__small()
	elif dmg_num_for__medium >= arg_dmg_amount:
		_set_properties_for__medium()
	#elif dmg_num_for__big >= arg_dmg_amount:
	else:
		_set_properties_for__big()
	
	_dmg_amount = arg_dmg_amount
	
	current_speed_towards_center = initial_speed_towards_center
	_finished_with_first_center = false

func _set_properties_for__very_small():
	speed_accel_towards_center = non_essential_rng.randf_range(250, 350)
	initial_speed_towards_center = non_essential_rng.randf_range(-100, -150)
	
	secondary_speed_accel_towards_center = speed_accel_towards_center
	secondary_initial_speed_towards_center = 0
	
	_can_auto_change_to_secondary_center = true
	
	_set_texture_id_to_use(TextureToUseId.VERY_SMALL)
	
	_request_beam_attachment_on_center_change = false

func _set_properties_for__small():
	speed_accel_towards_center = non_essential_rng.randf_range(220, 280)
	initial_speed_towards_center = non_essential_rng.randf_range(-80, -120)
	
	secondary_speed_accel_towards_center = speed_accel_towards_center
	secondary_initial_speed_towards_center = 0
	
	_can_auto_change_to_secondary_center = true
	
	_set_texture_id_to_use(TextureToUseId.SMALL)
	
	_request_beam_attachment_on_center_change = false

func _set_properties_for__medium():
	speed_accel_towards_center = non_essential_rng.randf_range(220, 280)
	initial_speed_towards_center = non_essential_rng.randf_range(-80, -120)
	
	secondary_speed_accel_towards_center = speed_accel_towards_center
	secondary_initial_speed_towards_center = 0
	
	_can_auto_change_to_secondary_center = false
	rotation = global_position.angle_to_point(center_pos_of_basis)
	
	_randomize_angle_per_sec_sign_and_magnitude(2*PI, 4*PI)
	
	_set_texture_id_to_use(TextureToUseId.MEDIUM)
	
	_request_beam_attachment_on_center_change = true
	beam_length = 8
	beam_width = 3

func _set_properties_for__big():
	speed_accel_towards_center = non_essential_rng.randf_range(180, 240)
	initial_speed_towards_center = non_essential_rng.randf_range(-70, -100)
	
	secondary_speed_accel_towards_center = non_essential_rng.randf_range(10, 25)
	secondary_initial_speed_towards_center = 425
	
	_can_auto_change_to_secondary_center = false
	rotation = global_position.angle_to_point(center_pos_of_basis)
	
	_randomize_angle_per_sec_sign_and_magnitude(PI, 2*PI)
	
	_set_texture_id_to_use(TextureToUseId.BIG)
	
	_request_beam_attachment_on_center_change = true
	beam_length = 12
	beam_width = 5

func _randomize_angle_per_sec_sign_and_magnitude(arg_mag_min, arg_mag_max):
	var angle_per_sec_val_is_positive = non_essential_rng.randi_range(0, 1) == 1
	_angle_per_sec_val_mag_sign = 1
	
	if !angle_per_sec_val_is_positive:
		_angle_per_sec_val_mag_sign = -1
	
	_angle_magnitude_min = arg_mag_min * _angle_per_sec_val_mag_sign
	_angle_magnitude_max = arg_mag_max * _angle_per_sec_val_mag_sign

#

func _set_texture_id_to_use(arg_id):
	if arg_id == TextureToUseId.VERY_SMALL:
		play(animation_name__very_small)
	elif arg_id == TextureToUseId.SMALL:
		play(animation_name__small)
	elif arg_id == TextureToUseId.MEDIUM:
		play(animation_name__medium)
	elif arg_id == TextureToUseId.BIG:
		play(animation_name__big)


func _do_prep_on_finished_with_first_center():
	_angle_to_secondary_center = global_position.angle_to_point(secondary_center) + PI
	_angle_modi = PI
	
	_angle_per_sec = non_essential_rng.randf_range(_angle_magnitude_min, _angle_magnitude_max)
	var _curr_angle = rotation
	
	_current_total_angle_turn_amount = 0
	
	if _angle_per_sec_val_mag_sign == 1:  # clockwise
		_target_total_angle_turn_amount = _angle_to_secondary_center - _curr_angle
		
		if abs(_target_total_angle_turn_amount) > 2 * PI:
			_target_total_angle_turn_amount = fposmod(_target_total_angle_turn_amount, (2*PI))
		
		if _target_total_angle_turn_amount < 0:
			_target_total_angle_turn_amount += 2 * PI
		
	else:  # counter clockwise
		_target_total_angle_turn_amount = _curr_angle - _angle_to_secondary_center
		
		if abs(_target_total_angle_turn_amount) > 2 * PI:
			_target_total_angle_turn_amount = fposmod(_target_total_angle_turn_amount, (2*PI))
		
		if _target_total_angle_turn_amount < 0:
			_target_total_angle_turn_amount += 2 * PI
		
	
	#
	_is_doing_angle_change = true


##

func _on_reached_center_pos_of_basis():
	configure_self_on_reached_end_of_lifetime()
	is_enabled_mov_toward_center = false
	
	emit_signal("reached_final_destination")
#	if _request_beam_attachment_on_center_change:
#		emit_signal("request_beam_detachment")


func get_dmg_amount():
	return _dmg_amount

