extends "res://MiscRelated/BeamRelated/BeamAesthetic.gd"

const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")


var base_aoe : BaseAOE

func _ready():
	var rect = RectangleShape2D.new()
	rect.extents = _get_current_size()
	
	base_aoe.set_coll_shape(rect)
	add_child(base_aoe)


func queue_free():
	if base_aoe != null:
		base_aoe.queue_free()
	
	.queue_free()
