extends "res://MiscRelated/PoolRelated/GenericPool.gd"


func _init():
	connect("resource_created", self, "_on_color_aesthetic_created", [], CONNECT_PERSIST)

func _on_color_aesthetic_created(arg_drawer):
	node_to_parent.add_child(arg_drawer)
	arg_drawer.connect("fully_invisible_and_done", self, "_on_drawer_fully_invisible_and_done", [arg_drawer], CONNECT_PERSIST)

func _on_drawer_fully_invisible_and_done(arg_drawer):
	declare_resource_as_available(arg_drawer)

