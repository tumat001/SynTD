extends Reference

const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")


signal on_target_tree_exiting()
signal on_bullet_tree_exiting()


var max_deg_angle_turn_amount_per_sec : float

var target_node_to_home_to : Node2D setget set_target_node_to_home_to
var bullet : BaseBullet setget set_bullet

#

func set_target_node_to_home_to(arg_node):
	if is_instance_valid(target_node_to_home_to):
		if target_node_to_home_to.is_connected("tree_exiting", self, "_on_target_node_tree_exiting"):
			target_node_to_home_to.disconnect("tree_exiting", self, "_on_target_node_tree_exiting")
	
	target_node_to_home_to = arg_node
	
	if is_instance_valid(target_node_to_home_to):
		if !target_node_to_home_to.is_connected("tree_exiting", self, "_on_target_node_tree_exiting"):
			target_node_to_home_to.connect("tree_exiting", self, "_on_target_node_tree_exiting")

func _on_target_node_tree_exiting():
	target_node_to_home_to = null
	emit_signal("on_target_tree_exiting")



func set_bullet(arg_bullet):
	if is_instance_valid(bullet):
		if bullet.is_connected("before_mov_is_executed", self, "_on_bullet_before_mov_is_executed"):
			bullet.disconnect("before_mov_is_executed", self, "_on_bullet_before_mov_is_executed")
			bullet.disconnect("tree_exiting", self, "_on_bullet_queue_free")
	
	bullet = arg_bullet
	
	if is_instance_valid(bullet):
		if !bullet.is_connected("before_mov_is_executed", self, "_on_bullet_before_mov_is_executed"):
			bullet.connect("before_mov_is_executed", self, "_on_bullet_before_mov_is_executed")
			bullet.connect("tree_exiting", self, "_on_bullet_queue_free", [bullet])


func _on_bullet_before_mov_is_executed(arg_bullet, arg_delta):
	if !arg_bullet.is_queued_for_deletion():
		update_bullet_curr_relative_norm_dir(arg_delta, arg_bullet)

func _on_bullet_queue_free(arg_bullet):
	emit_signal("on_bullet_tree_exiting")

#

func update_bullet_curr_relative_norm_dir(arg_delta : float, arg_bullet : BaseBullet = bullet):
	if is_instance_valid(target_node_to_home_to):
		arg_bullet.direction_as_relative_location = get_relative_normalized_direction_for_homing(target_node_to_home_to.global_position, arg_bullet.global_position, arg_bullet.direction_as_relative_location, arg_delta)
		arg_bullet.rotation = arg_bullet.direction_as_relative_location.angle()


#

func get_relative_normalized_direction_for_homing(
		arg_target_pos : Vector2,
		arg_bullet_pos : Vector2, 
		arg_curr_relative_norm_dir : Vector2, delta : float):
	
	var angle_for_alignment = arg_bullet_pos.angle_to_point(arg_target_pos)
	var curr_angle = arg_curr_relative_norm_dir.angle()
	
	#
	
	var angle = _get_rotation_for_steer(arg_bullet_pos, arg_target_pos, curr_angle, deg2rad(max_deg_angle_turn_amount_per_sec), delta)
	return arg_curr_relative_norm_dir.rotated(angle)



static func _convert_angle_to_1to360(arg_angle):
	arg_angle = fmod(arg_angle, 360)
	if arg_angle > 0:
		return arg_angle
	else:
		return arg_angle + 360


#######


func _get_rotation_for_steer(arg_bullet_pos, arg_enemy_pos, arg_current_angle, arg_max_rot_per_sec, delta) -> float:
	var angle_to_enemy = arg_bullet_pos.angle_to_point(arg_enemy_pos)
	
	var steer_angle : float = 0
	
	angle_to_enemy = _conv_angle_to_positive_val(angle_to_enemy)
	arg_current_angle = _conv_angle_to_positive_val(arg_current_angle)
	
	
	var rotation_per_sec = arg_max_rot_per_sec
	
	if angle_to_enemy > arg_current_angle:
		var diff = angle_to_enemy - arg_current_angle
		if diff < rotation_per_sec:
			rotation_per_sec = diff * 3
		
		if abs(arg_current_angle - angle_to_enemy) > PI:
			steer_angle = delta * rotation_per_sec * 1
		else:
			steer_angle = delta * rotation_per_sec * -1
		
	elif angle_to_enemy < arg_current_angle:
		var diff = arg_current_angle - angle_to_enemy
		if diff < rotation_per_sec:
			rotation_per_sec = diff * 3
		
		if abs(arg_current_angle - angle_to_enemy) > PI:
			steer_angle = delta * rotation_per_sec * -1
		else:
			steer_angle = delta * rotation_per_sec * 1
	
	return steer_angle


func _conv_angle_to_positive_val(arg_angle):
	if arg_angle < 0:
		return (2*PI) + arg_angle
	else:
		if arg_angle < 2 * PI:
			return arg_angle
		else:
			return arg_angle - (2 * PI)

