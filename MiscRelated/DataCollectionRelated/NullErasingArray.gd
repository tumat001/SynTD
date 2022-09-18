extends Reference

# can be accessed and used normally, except for appending
var array_of_nodes : Array


func append_node_and_listen_for_tree_exiting(arg_node : Node):
	array_of_nodes.append(arg_node)
	
	if !arg_node.is_connected("tree_exiting", self, "_on_node_tree_exiting"):
		arg_node.connect("tree_exiting", self, "_on_node_tree_exiting", [arg_node], CONNECT_PERSIST)

#

func _on_node_tree_exiting(arg_node):
	array_of_nodes.erase(arg_node)
