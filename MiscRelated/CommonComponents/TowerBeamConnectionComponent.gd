

const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")


signal showing_connection_mode_changed(is_showing)

# IN THIS CLASS, node is abstracttowers
var owning_node : Node2D setget set_owning_node
var _node_beam_map : Dictionary = {}
var _is_showing_beam_connections : bool = false

var texture_for_beam : Texture
var sprite_frames_for_beam : SpriteFrames


# setters

func set_owning_node(node : Node2D):
	if is_instance_valid(owning_node):
		if owning_node.is_connected("global_position_changed", self, "_owner_node_global_pos_changed"):
			owning_node.disconnect("global_position_changed", self, "_owner_node_global_pos_changed")
			owning_node.disconnect("tree_exiting", self, "_owning_node_tree_exiting")
	
	owning_node = node
	
	if is_instance_valid(owning_node):
		if !owning_node.is_connected("global_position_changed", self, "_owner_node_global_pos_changed"):
			owning_node.connect("global_position_changed", self, "_owner_node_global_pos_changed", [], CONNECT_PERSIST)
			owning_node.connect("tree_exiting", self, "_owning_node_tree_exiting", [], CONNECT_PERSIST)


#

func show_beam_connections():
	_is_showing_beam_connections = true
	emit_signal("showing_connection_mode_changed", true)
	
	for node in _node_beam_map.keys():
		if _node_beam_map[node] == null or !is_instance_valid(_node_beam_map[node]):
			_node_beam_map[node] = _construct_beam()
		
		var beam = _node_beam_map[node]
		beam.visible = true
		beam.update_destination_position(node.global_position)
		beam.global_position = owning_node.global_position
	
	_owner_node_global_pos_changed(owning_node.old_global_position, owning_node.global_position)


func _construct_beam():
	var beam = BeamAesthetic_Scene.instance()
	beam.time_visible = 0
	beam.is_timebound = false
	if texture_for_beam != null:
		beam.set_texture_as_default_anim(texture_for_beam)
	elif sprite_frames_for_beam != null:
		beam.set_sprite_frames(sprite_frames_for_beam)
	
	beam.global_position = owning_node.global_position
	
	owning_node.get_tree().get_root().add_child(beam)
	return beam


#

func hide_beam_connections():
	_is_showing_beam_connections = false
	emit_signal("showing_connection_mode_changed", false)
	
	for beam in _node_beam_map.values():
		beam.visible = false


#

func _node_global_pos_changed(old_position, new_position, node):
	if _node_beam_map.has(node) and node.is_current_placable_in_map():
		var beam = _node_beam_map[node]
		
		if is_instance_valid(beam) and beam.visible:
			beam.update_destination_position(node.global_position)


func _owner_node_global_pos_changed(_old_pos, new_pos):
	for node in _node_beam_map.keys():
		if _is_showing_beam_connections:
			var beam = _node_beam_map[node]
			beam.global_position = owning_node.global_position
			beam.update_destination_position(node.global_position)

#

func attempt_add_connection_to_node(node):
	if !_node_beam_map.has(node) and node.is_current_placable_in_map():
		_node_beam_map[node] = null
		node.connect("tower_not_in_active_map", self, "remove_connection_of_node", [node], CONNECT_PERSIST)
		node.connect("tree_exiting", self, "remove_connection_of_node", [node], CONNECT_PERSIST)
		node.connect("global_position_changed", self, "_node_global_pos_changed", [node], CONNECT_PERSIST)
		
		if _is_showing_beam_connections:
			var beam = _construct_beam()
			_node_beam_map[node] = beam
			beam.visible = true
			beam.update_destination_position(node.global_position)


func remove_connection_of_node(node):
	if _node_beam_map.has(node):
		if is_instance_valid(_node_beam_map[node]):
			_node_beam_map[node].queue_free()
		
		_node_beam_map.erase(node)
		node.disconnect("tower_not_in_active_map", self, "remove_connection_of_node")
		node.disconnect("tree_exiting", self, "remove_connection_of_node")
		node.disconnect("global_position_changed", self, "_node_global_pos_changed")

func remove_all_connections_of_nodes():
	for node in _node_beam_map.keys():
		remove_connection_of_node(node)


#

func _owning_node_tree_exiting():
	remove_all_connections_of_nodes()
