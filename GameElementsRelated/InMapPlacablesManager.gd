extends Node

const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")

var all_in_map_placables : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for placables in get_children():
		if placables is InMapAreaPlacable:
			all_in_map_placables.append(placables)


func make_all_placables_glow():
	for placables in all_in_map_placables:
		placables.set_area_texture_to_glow()

func make_all_placables_not_glow():
	for placables in all_in_map_placables:
		placables.set_area_texture_to_not_glow()

func make_all_placables_hidden():
	for placables in all_in_map_placables:
		placables.set_hidden(true)

func make_all_placables_not_hidden():
	for placables in all_in_map_placables:
		placables.set_hidden(false)
