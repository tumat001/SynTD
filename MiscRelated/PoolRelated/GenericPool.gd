extends Reference

signal resource_created(arg_res)
signal before_resource_is_taken_from_pool(arg_res)


var node_to_parent : Node
var node_to_listen_for_queue_free : Node setget set_node_to_listen_for_queue_free  # if this node queue frees, so must this (all the attack sprites)

var _resource_to_available_state_map : Dictionary = {}

var source_of_create_resource : Object
var func_name_for_create_resource : String

#

func get_or_create_resource_from_pool():
	var res : Object = _get_available_resource_in_pool()
	
	if res == null:
		res = _create_resource()
	
	_resource_to_available_state_map[res] = false
	
	emit_signal("before_resource_is_taken_from_pool", res)
	
	return res


func if_available_resource_in_pool():
	return _get_available_resource_in_pool() != null

func _get_available_resource_in_pool():
	for res in _resource_to_available_state_map.keys():
		if _resource_to_available_state_map[res] == true:
			return res
	
	return null


func _create_resource() -> Object:
	var res = source_of_create_resource.call(func_name_for_create_resource)
	
	if res is Node:
		res.connect("tree_exiting", self, "_on_res_tree_exiting", [], CONNECT_PERSIST)
	
	emit_signal("resource_created", res)
	
	return res

#

func declare_resource_as_available(arg_res):
	if _resource_to_available_state_map.has(arg_res):
		_resource_to_available_state_map[arg_res] = true

#

func _on_res_tree_exiting(arg_res):
	_resource_to_available_state_map.erase(arg_res)


#

func set_node_to_listen_for_queue_free(arg_node):
	if node_to_listen_for_queue_free != null:
		node_to_listen_for_queue_free.disconnect("tree_exiting", self, "_on_node_to_listen_for_queue_free__tree_exited")
	
	node_to_listen_for_queue_free = arg_node
	
	if node_to_listen_for_queue_free != null:
		node_to_listen_for_queue_free.connect("tree_exiting", self, "_on_node_to_listen_for_queue_free__tree_exited", [], CONNECT_PERSIST)


func _on_node_to_listen_for_queue_free__tree_exited():
	queue_free_all_from_pool()


func queue_free_all_from_pool():
	for res in _resource_to_available_state_map:
		if res != null and res is Node and !res.is_queued_for_deletion():
			res.queue_free()
	
	_resource_to_available_state_map.clear()