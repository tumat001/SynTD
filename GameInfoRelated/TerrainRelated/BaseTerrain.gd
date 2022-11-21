extends Area2D

const TerrainFuncs = preload("res://GameInfoRelated/TerrainRelated/TerrainFuncs.gd")

signal global_position_changed(arg_old_pos, arg_new_pos)
signal terrain_layer_changed(arg_old_layer, arg_new_layer)


export(int) var terrain_layer : int setget set_terrain_layer

var can_change_pos : bool setget set_can_change_pos
var _old_global_pos : Vector2

##

func set_terrain_layer(arg_val):
	var old_layer = terrain_layer
	terrain_layer = arg_val
	
	emit_signal("terrain_layer_changed", old_layer, terrain_layer)

func set_can_change_pos(arg_val):
	can_change_pos = arg_val
	
	set_process(can_change_pos)

#

func _process(delta):
	if global_position != _old_global_pos:
		emit_signal("global_position_changed", _old_global_pos, global_position)
	
	_old_global_pos = global_position

############ Helper stuffs

func should_block_vision_on_terrain_layer(arg_layer):
	#return terrain_layer > arg_layer
	return !TerrainFuncs.is_layer_in_sight_to(terrain_layer, arg_layer)

