extends Sprite


var distance_from_node_to_point : float = 10.0
var is_vertical : bool = false setget set_is_vertical
var node_to_point_at : Node setget set_node_to_point_at
var queue_free_at_transcript_index : int

var _texture_size_y
var _texture_size_x

var _increase_mod_y_per_sec : float = 1.5

var y_offset : float = 0.0
var x_offset : float = 0.0

#

func set_is_vertical(arg_val):
	is_vertical = arg_val
	
	if is_inside_tree():
		if !is_vertical:
			_texture_size_y = texture.get_size().y
			_texture_size_x = texture.get_size().x
			rotation_degrees = 0
		else:
			_texture_size_y = texture.get_size().x
			_texture_size_x = texture.get_size().y
			rotation_degrees = 90

func _get_adapting_to_anim_size() -> Vector2:
	if node_to_point_at is Node2D:
		return Vector2(40, 40)
		
	elif node_to_point_at is Control:
		return node_to_point_at.rect_size
	
	
	
	return Vector2(0, 0)



#

func set_node_to_point_at(arg_node):
	node_to_point_at = arg_node
	
	node_to_point_at.connect("tree_exiting", self, "_on_node_pointing_at_queue_free", [], CONNECT_PERSIST)
	node_to_point_at.connect("visibility_changed", self, "_on_node_pointing_at_visibility_changed", [], CONNECT_PERSIST)

func _ready():
	if node_to_point_at.get("z_index"):
		z_index = node_to_point_at.z_index + 1
	else:
		z_index = ZIndexStore.WHOLE_SCREEN_GUI
	
	z_as_relative = false
	set_is_vertical(is_vertical)
	_on_node_pointing_at_visibility_changed()



func _process(delta):
	if is_instance_valid(node_to_point_at):
		var new_position : Vector2
		if node_to_point_at.get("global_position"):
			new_position = node_to_point_at.global_position
			new_position -= _get_adapting_to_anim_size() / 2
			
			if !is_vertical:
				new_position.y += _get_adapting_to_anim_size().y
			else:
				new_position.x += _get_adapting_to_anim_size().x
			
			new_position.y += y_offset
			new_position.x += x_offset
			
		elif node_to_point_at.get("rect_global_position"):
			new_position = node_to_point_at.rect_global_position
			new_position -= _get_adapting_to_anim_size() / 2
			
			if !is_vertical:
				new_position.y += _get_adapting_to_anim_size().y
			else:
				new_position.x += _get_adapting_to_anim_size().x
			
			new_position.y += y_offset
			new_position.x += x_offset
		
		if is_vertical:
			if new_position.y + _texture_size_y + 20 > get_viewport().get_visible_rect().size.y:
				var new_y_pos = new_position.y - _texture_size_y
				
				if new_y_pos < 0:
					new_y_pos = new_position.y
					
					# if newly adjusted position makes tooltip dip below
					if new_y_pos + _texture_size_y + 20 > get_viewport().get_visible_rect().size.y:
						new_y_pos = new_position.y + _texture_size_y
						flip_v = true
					else:
						new_y_pos = new_position.y - _texture_size_y
						flip_v = false
				
				new_position.y = new_y_pos
#
#
#		if new_position.x + _texture_size_x + 20 > get_viewport().get_visible_rect().size.x:
#			var new_x_pos = new_position.x - (_texture_size_x)
#
#			if new_x_pos < 0:
#				new_x_pos = new_position.x
#
#				# if newly adjusted position makes tooltip dip below
#				if new_x_pos + _texture_size_x + 20 > get_viewport().get_visible_rect().size.x:
#					new_x_pos = new_position.x + _texture_size_x
#					flip_h = true
#				else:
#					new_x_pos = new_position.x - _texture_size_x
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



