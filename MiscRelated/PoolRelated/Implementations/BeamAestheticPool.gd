extends "res://MiscRelated/PoolRelated/GenericPool.gd"

const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")


func _init():
	connect("resource_created", self, "_on_beam_created", [], CONNECT_PERSIST)

func _on_beam_created(arg_beam : BeamAesthetic):
	arg_beam.connect("time_visible_is_over", self, "_on_beam_turned_invisible", [arg_beam], CONNECT_PERSIST)

func _on_beam_turned_invisible(arg_beam : BeamAesthetic):
	declare_resource_as_available(arg_beam)

