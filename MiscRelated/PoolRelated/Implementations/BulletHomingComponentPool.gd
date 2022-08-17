extends "res://MiscRelated/PoolRelated/GenericPool.gd"



func _init():
	connect("resource_created", self, "_on_component_created", [], CONNECT_PERSIST)

func _on_component_created(arg_component):
	arg_component.connect("on_bullet_tree_exiting", self, "_on_component_bullet_tree_exiting", [arg_component], CONNECT_PERSIST)


func _on_component_bullet_tree_exiting(arg_component):
	declare_resource_as_available(arg_component)

