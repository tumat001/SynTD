extends Node2D

# TWO PARTS:
# 1) Line from rotation point to base
# 2) Base. Never changing.

signal fully_invisible_and_done()
signal started_display()

#
var component_id : int
#

var ray_main_color : Color
var ray_edge_color : Color = Color(1,1,1,0)

var ray_upper_ray_total_width : float
var ray_lower_ray_total_width : float

var ray_length : float

#var rotation_point : Vector2
var destination_point : Vector2 setget set_destination_point

#

var initial_mod_a_val_at_start : float
var initial_mod_a_inc_per_sec_at_start : float
var initial_mod_a_inc_lifetime_to_start : float
var initial_mod_a_inc_lifetime_to_end : float

var mod_a_dec_lifetime_to_start : float
var mod_a_dec_per_sec : float

#

var _ray_main_polygon : PoolVector2Array
#var _ray_color_polygon : PoolColorArray
var _ray_edge_left_angle : float
var _ray_edge_right_angle : float

var _is_displaying : bool

#

var _current_lifetime : float


#

var relative_pos_of_ray_start : Vector2
var angle_of_rel_pos_to_bottom_left : float
var angle_of_rel_pos_to_bottom_right : float

#

func set_destination_point(arg_pos):
	destination_point = arg_pos
	global_position = arg_pos


func _ready():
	z_as_relative = false
	z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_TOWERS
	
	set_process(false)


func update_ray_properties_based_on_properies():
	var main_polygon = []
	main_polygon.append(Vector2(ray_lower_ray_total_width / 2.0, 0))
	main_polygon.append(Vector2(ray_upper_ray_total_width / 2.0, -ray_length))
	main_polygon.append(Vector2(-ray_upper_ray_total_width / 2.0, -ray_length))
	main_polygon.append(Vector2(-ray_lower_ray_total_width / 2.0, 0))
	_ray_main_polygon = PoolVector2Array(main_polygon)
	
	#
	relative_pos_of_ray_start = Vector2(0, -ray_length)
	
	#angle_of_rel_pos_to_bottom_right = relative_pos_of_ray_start.angle_to_point(Vector2(ray_lower_ray_total_width / 2.0, 0))
	#angle_of_rel_pos_to_bottom_left = relative_pos_of_ray_start.angle_to_point(Vector2(-ray_lower_ray_total_width / 2.0, 0))
	
	angle_of_rel_pos_to_bottom_right = Vector2(ray_lower_ray_total_width / 2.0, 0).angle_to_point(relative_pos_of_ray_start)
	angle_of_rel_pos_to_bottom_left = Vector2(-ray_lower_ray_total_width / 2.0, 0).angle_to_point(relative_pos_of_ray_start)
	
#	var color_polygon = []
#	for i in main_polygon:
#		color_polygon.append(ray_main_color)
#	_ray_color_polygon = PoolColorArray(color_polygon)
#


func _draw():
	if _is_displaying:
	#draw_polygon(_ray_main_polygon, _ray_color_polygon)
		draw_colored_polygon(_ray_main_polygon, ray_main_color)
		draw_line(Vector2(ray_lower_ray_total_width / 2.0, 0), Vector2(ray_upper_ray_total_width / 2.0, -ray_length), ray_edge_color, 1)
		draw_line(Vector2(-ray_lower_ray_total_width / 2.0, 0), Vector2(-ray_upper_ray_total_width / 2.0, -ray_length), ray_edge_color, 1)
		
		draw_set_transform(Vector2(0, 0), 0, Vector2(2, 1))
		draw_circle(Vector2(0, 0), ray_lower_ray_total_width / 2.0, ray_main_color)
	

##

func start_display():
	_current_lifetime = 0
	_is_displaying = true
	modulate.a = initial_mod_a_val_at_start
	
	visible = true
	
	emit_signal("started_display")
	set_process(true)
	
	update()

func end_display():
	_is_displaying = false
	
	visible = false
	
	set_process(false)
	
	update()


func _process(delta):
	_current_lifetime += delta
	
	if initial_mod_a_inc_lifetime_to_start <= _current_lifetime and initial_mod_a_inc_lifetime_to_end >= _current_lifetime:
		modulate.a += initial_mod_a_inc_per_sec_at_start * delta
	
	if mod_a_dec_lifetime_to_start <= _current_lifetime:
		modulate.a -= mod_a_dec_per_sec * delta
		
		if modulate.a <= 0:
			end_display()
			emit_signal("fully_invisible_and_done")
	
	#update()
