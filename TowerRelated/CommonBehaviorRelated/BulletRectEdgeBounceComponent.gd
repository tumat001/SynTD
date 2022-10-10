extends Reference


const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")


signal on_bullet_tree_exiting()

var bullet : BaseBullet setget set_bullet
var up_y : float
var down_y : float
var left_x : float
var right_x : float

func set_bullet(arg_bullet):
	if is_instance_valid(bullet):
		if bullet.is_connected("tree_exiting", self, "_on_bullet_queue_free"):
			bullet.disconnect("tree_exiting", self, "_on_bullet_queue_free")
			bullet.disconnect("before_mov_is_executed", self, "_on_bullet_before_mov_is_executed")
	
	bullet = arg_bullet
	
	if is_instance_valid(bullet):
		if !bullet.is_connected("tree_exiting", self, "_on_bullet_queue_free"):
			bullet.connect("tree_exiting", self, "_on_bullet_queue_free", [bullet])
			bullet.connect("before_mov_is_executed", self, "_on_bullet_before_mov_is_executed")

func _on_bullet_queue_free(arg_bullet):
	emit_signal("on_bullet_tree_exiting")


func set_bounds_based_on_game_elements(arg_game_elements):
	up_y = arg_game_elements.top_left_coord_of_map.global_position.y
	down_y = arg_game_elements.bottom_right_coord_of_map.global_position.y
	left_x = arg_game_elements.top_left_coord_of_map.global_position.x
	right_x = arg_game_elements.bottom_right_coord_of_map.global_position.x

#

func _on_bullet_before_mov_is_executed(arg_bullet : BaseBullet, arg_delta):
	if arg_bullet.global_position.x <= left_x and arg_bullet.direction_as_relative_location.x < 0:
		arg_bullet.bounce_off_left()
	if arg_bullet.global_position.x >= right_x and arg_bullet.direction_as_relative_location.x > 0:
		arg_bullet.bounce_off_right()
	if arg_bullet.global_position.y <= up_y and arg_bullet.direction_as_relative_location.y < 0:
		arg_bullet.bounce_off_top()
	if arg_bullet.global_position.y >= down_y and arg_bullet.direction_as_relative_location.y > 0:
		arg_bullet.bounce_off_bottom()

