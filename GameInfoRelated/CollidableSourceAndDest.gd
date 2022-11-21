extends Node

enum Source {
	FROM_TOWER = 10
	FROM_ENEMY = 11
}

enum Destination {
	TO_TOWER = 10
	TO_ENEMY = 11
}


const tower_base_area_mask : int = 1
const enemy_ground_mask : int = 32
const enemy_air_mask : int = 64

const enemy_bullets_layer : int = 128
const tower_bullets_layer : int = 4

const terrain_layer : int = 1024


func set_coll_layer_source(coll, source : int):
	var final_layer : int
	if source == Source.FROM_TOWER:
		final_layer = tower_bullets_layer
	elif source == Source.FROM_ENEMY:
		final_layer = enemy_bullets_layer
	
	coll.collision_layer = final_layer


func set_coll_mask_destination(coll, destination : int):
	var final_mask : int
	if destination == Destination.TO_TOWER:
		final_mask = tower_base_area_mask
	elif destination == Destination.TO_ENEMY:
		final_mask = enemy_ground_mask + enemy_air_mask
	
	coll.collision_mask = final_mask
