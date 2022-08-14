extends Line2D


signal on_idle_and_available_state_changed(arg_val)

var node_to_trail : Node2D setget set_node_to_trail
var max_trail_length : int
var trail_color : Color = Color(0.4, 0.5, 1, 1) setget set_trail_color

var is_idle_and_available : bool = true


func set_node_to_trail(arg_node : Node2D):
	if node_to_trail != null:
		node_to_trail.disconnect("tree_exiting", self, "_on_node_tree_exiting")
	
	node_to_trail = arg_node
	
	if node_to_trail != null:
		node_to_trail.connect("tree_exiting", self, "_on_node_tree_exiting", [], CONNECT_ONESHOT)
		set_process(true)
		is_idle_and_available = false
		emit_signal("on_idle_and_available_state_changed", is_idle_and_available)
	
	z_as_relative = false
	z_index = node_to_trail.z_index - 1
	


func _on_node_tree_exiting():
	node_to_trail = null
	


#

func set_trail_color(arg_color : Color):
	trail_color = arg_color
	
	default_color = trail_color

#

func _process(delta):
	if node_to_trail != null:
		if node_to_trail.is_inside_tree():
			var pos_of_point = node_to_trail.global_position
			global_rotation = 0
			
			add_point(pos_of_point)
			if get_point_count() > max_trail_length:
				remove_point(0)
	else:
		if get_point_count() > 0:
			remove_point(0)
		else:
			set_process(false)
			is_idle_and_available = true
			emit_signal("on_idle_and_available_state_changed", is_idle_and_available)