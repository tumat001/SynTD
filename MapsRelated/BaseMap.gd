extends Node


const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")


var all_in_map_placables : Array = []
var all_enemy_paths : Array = []

onready var _in_map_placables = $InMapPlacables
onready var _enemy_paths = $EnemyPaths
onready var _environment = $Environment


func _ready():
	_environment.z_index = ZIndexStore.MAP_ENVIRONMENT
	
	for placables in _in_map_placables.get_children():
		if placables is InMapAreaPlacable:
			all_in_map_placables.append(placables)
	
	for path in _enemy_paths.get_children():
		all_enemy_paths.append(path)


# glow related

func make_all_placables_glow():
	for placables in all_in_map_placables:
		placables.set_area_texture_to_glow()

func make_all_placables_not_glow():
	for placables in all_in_map_placables:
		placables.set_area_texture_to_not_glow()

func make_all_placables_with_towers_glow():
	for placables in all_in_map_placables:
		if placables.tower_occupying != null:
			placables.set_area_texture_to_glow()

func make_all_placables_with_no_towers_glow():
	for placables in all_in_map_placables:
		if placables.tower_occupying == null:
			placables.set_area_texture_to_glow()


func make_all_placables_with_tower_colors_glow(tower_colors : Array):
	for placables in all_in_map_placables:
		if placables.tower_occupying != null:
			for color in tower_colors:
				if placables.tower_occupying._tower_colors.has(color):
					placables.set_area_texture_to_glow()
					break


# hidden related

func make_all_placables_hidden():
	for placables in all_in_map_placables:
		placables.set_hidden(true)

func make_all_placables_not_hidden():
	for placables in all_in_map_placables:
		placables.set_hidden(false)
