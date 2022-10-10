extends Sprite


var distance_from_node_to_point : float = 10.0
var node_to_point_at : Node setget set_node_to_point_at
var queue_free_at_transcript_index : int
var adapt_ratio : float = 1.0

var _texture_size_y
var _texture_size_x

var _increase_mod_y_per_sec : float = 1.5

#


func set_node_to_point_at(arg_node):
	node_to_point_at = arg_node
	
	node_to_point_at.connect("tree_exiting", self, "_on_node_pointing_at_queue_free", [], CONNECT_PERSIST)
	node_to_point_at.connect("visibility_changed", self, "_on_node_pointing_at_visibility_changed", [], CONNECT_PERSIST)
	

func _resize_self_to_node(arg_node):
	var size = _get_self_anim_size()
	_texture_size_y = size.y
	_texture_size_x = size.x
	
	
	var curr_ratio = _get_self_anim_size() / _get_adapting_to_anim_size()
	var final_ratio : Vector2
	
	final_ratio = curr_ratio * _get_adjustment_of_ratio_to_second_ratio(curr_ratio.x, curr_ratio.y)
	
	scale.x /= (final_ratio.x / 1.5)
	scale.y /= (final_ratio.y / 1.5)
	
	if scale.x < 0.8:
		scale.x = 0.8
	
	if scale.y < 0.8:
		scale.y = 0.8

func _get_adjustment_of_ratio_to_second_ratio(ratio_x : float, ratio_y : float) -> Vector2:
	var base_ratio : float
	var adjusting_ratio : float
	
	if ratio_x > ratio_y:
		base_ratio = ratio_x
		adjusting_ratio = ratio_y
	else:
		base_ratio = ratio_y
		adjusting_ratio = ratio_x
	
	var multiplier = (1 / adapt_ratio) / base_ratio
	
	if ratio_x < ratio_y:
		return Vector2(1 / adapt_ratio, adjusting_ratio * multiplier)
	else:
		return Vector2(adjusting_ratio * multiplier, 1 / adapt_ratio)


func _get_self_anim_size() -> Vector2:
	return texture.get_size()

func _get_adapting_to_anim_size() -> Vector2:
	if node_to_point_at is Node2D:
		return Vector2(40, 40)
	elif node_to_point_at is Control:
		return node_to_point_at.rect_size
	
	return Vector2(0, 0)


#

func _ready():
	if node_to_point_at.get("z_index"):
		z_index = node_to_point_at.z_index + 1
	else:
		z_index = ZIndexStore.WHOLE_SCREEN_GUI
	
	z_as_relative = false
	_on_node_pointing_at_visibility_changed()
	_resize_self_to_node(node_to_point_at)


func _process(delta):
	if is_instance_valid(node_to_point_at):
		var new_position : Vector2
		if node_to_point_at.get("global_position"):
			new_position = node_to_point_at.global_position
		elif node_to_point_at.get("rect_global_position"):
			new_position = node_to_point_at.rect_global_position
			new_position += node_to_point_at.rect_size / 2
		
#		if new_position.y + _texture_size_y + 20 > get_viewport().get_visible_rect().size.y:
#			var new_y_pos = new_position.y - _texture_size_y
#
#			if new_y_pos < 0:
#				new_y_pos = new_position.y
#
#				# if newly adjusted position makes tooltip dip below
#				if new_y_pos + _texture_size_y + 20 > get_viewport().get_visible_rect().size.y:
#					new_y_pos = new_position.y + _texture_size_y
#					flip_v = true
#				else:
#					flip_v = false
#
#			new_position.y = new_y_pos
#
#
#		if new_position.x + _texture_size_x + 20 > get_viewport().get_visible_rect().size.x:
#			var new_x_pos = new_position.x - _texture_size_x
#
#			if new_x_pos < 0:
#				new_x_pos = new_position.x
#
#				# if newly adjusted position makes tooltip dip below
#				if new_x_pos + _texture_size_x + 20 > get_viewport().get_visible_rect().size.x:
#					new_x_pos = new_position.x + _texture_size_x
#					flip_h = true
#				else:
#					flip_h = false
#
#			new_position.x = new_x_pos
		
		
		global_position = new_position
	
	_process_modulate(delta)

#

func _on_node_pointing_at_queue_free():
	queue_free()

func _on_node_pointing_at_visibility_changed():
	visible = node_to_point_at.visible

func _on_current_transcript_index_changed__for_white_arrow_monitor(arg_index, arg_message):
	if arg_index == queue_free_at_transcript_index:
		queue_free()

#

func _process_modulate(delta):
	modulate.b += _increase_mod_y_per_sec * delta
	
	if modulate.b > 1 and sign(_increase_mod_y_per_sec) == 1:
		_increase_mod_y_per_sec *= -1
	elif modulate.b <= 0.2 and sign(_increase_mod_y_per_sec) == -1:
		_increase_mod_y_per_sec *= -1

