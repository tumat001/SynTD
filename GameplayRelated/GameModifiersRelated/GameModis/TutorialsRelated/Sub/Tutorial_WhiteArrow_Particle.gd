extends Sprite


var distance_from_node_to_point : float = 10.0
var is_vertical : bool = false setget set_is_vertical
var node_to_point_at : Node setget set_node_to_point_at
var queue_free_at_transcript_index : int

var _texture_size_y
var _texture_size_x

#

func set_is_vertical(arg_val):
	is_vertical = arg_val
	
	if is_inside_tree():
		if !is_vertical:
			_texture_size_y = texture.get_size().y
			_texture_size_x = texture.get_size().x
		else:
			_texture_size_y = texture.get_size().x
			_texture_size_x = texture.get_size().y

#

func set_node_to_point_at(arg_node):
	node_to_point_at = arg_node
	
	node_to_point_at.connect("tree_exiting", self, "_on_node_pointing_at_queue_free", [], CONNECT_PERSIST)
	node_to_point_at.connect("visibility_changed", self, "_on_node_pointing_at_visibility_changed", [], CONNECT_PERSIST)

func _ready():
	z_index = node_to_point_at.z_index + 1
	z_as_relative = false
	set_is_vertical(is_vertical)
	_on_node_pointing_at_visibility_changed()



func _process(delta):
	if node_to_point_at != null:
		var new_position : Vector2 = node_to_point_at.global_position
		
		if new_position.y + _texture_size_y + 20 > get_viewport().get_visible_rect().size.y:
			var new_y_pos = new_position.y - _texture_size_y
			
			if new_y_pos < 0:
				new_y_pos = new_position.y
				
				# if newly adjusted position makes tooltip dip below
				if new_y_pos + _texture_size_y + 20 > get_viewport().get_visible_rect().size.y:
					new_y_pos = 20
			
			new_position.y = new_y_pos
		
		
		if new_position.x + _texture_size_x + 20 > get_viewport().get_visible_rect().size.x:
			var new_x_pos = new_position.x - _texture_size_x
			
			if new_x_pos < 0:
				new_x_pos = new_position.x
				
				# if newly adjusted position makes tooltip dip below
				if new_x_pos + _texture_size_x + 20 > get_viewport().get_visible_rect().size.x:
					new_x_pos = 20
			
			new_position.x = new_x_pos
		
		
		global_position = new_position

#

func _on_node_pointing_at_queue_free():
	queue_free()

func _on_node_pointing_at_visibility_changed():
	visible = node_to_point_at.visible

func _on_current_transcript_index_changed__for_white_arrow_monitor(arg_index, arg_message):
	if arg_index == queue_free_at_transcript_index:
		queue_free()


