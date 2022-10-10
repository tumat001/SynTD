extends Node2D

const BaseTowerDetectingAOE = preload("res://EnemyRelated/TowerInteractingRelated/Spawnables/BaseTowerDetectingAOE.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

enum SpawnLocationAndChange {
	NO_CHANGE,
	CENTERED_TO_ORIGIN,
	CENTERED_TO_SECOND,
	STRECHED_AS_BEAM,
}

signal before_aoe_is_added_as_child(aoe)


var spawn_location_and_change : int = SpawnLocationAndChange.NO_CHANGE

var base_aoe_scene : PackedScene


var damage_repeat_count : int = 1
var duration : float
var initial_delay : float = 0.05
var is_decrease_duration : bool = true
var pierce : int = -1  # no limit

var aoe_texture : Texture
var aoe_sprite_frames : SpriteFrames
var sprite_frames_only_play_once : bool

var aoe_default_coll_shape : int = BaseTowerDetectingAOE.BaseAOEDefaultShapes.CIRCLE
var shift_x : bool = false

var absolute_z_index_of_aoe : int = ZIndexStore.PARTICLE_EFFECTS

# constants

const td_aoe_group_tag : String = "TDAOEGroupTag"


# Construction of AOE

func construct_aoe(arg_origin_pos : Vector2, arg_enemy_pos : Vector2) -> BaseTowerDetectingAOE:
	var base_aoe : BaseTowerDetectingAOE = base_aoe_scene.instance()
	
	base_aoe.damage_repeat_count = damage_repeat_count
	base_aoe.duration = duration
	base_aoe.decrease_duration = is_decrease_duration
	base_aoe.pierce = pierce
	base_aoe.initial_delay = initial_delay
	
	base_aoe.aoe_default_coll_shape = aoe_default_coll_shape
	
	if aoe_sprite_frames != null:
		base_aoe.aoe_sprite_frames = aoe_sprite_frames
	elif aoe_texture != null:
		base_aoe.aoe_texture = aoe_texture
	
	base_aoe.sprite_frames_play_only_once = sprite_frames_only_play_once
	base_aoe.shift_x = shift_x
	
	base_aoe.add_to_group(td_aoe_group_tag)
	
	base_aoe.z_as_relative = false
	base_aoe.z_index = absolute_z_index_of_aoe
	
	_modify_center_pos_and_sizeshape_of_aoe(arg_origin_pos, arg_enemy_pos, base_aoe)
	
	return base_aoe


# Center pos, explosion scale, and beam stretching

func _modify_center_pos_and_sizeshape_of_aoe(original_pos : Vector2, next_pos : Vector2, aoe : BaseTowerDetectingAOE):
	var center_pos : Vector2
	var final_scale : Vector2 = Vector2(1, 1)
	
	if spawn_location_and_change == SpawnLocationAndChange.CENTERED_TO_SECOND:
		center_pos = next_pos
		aoe.aoe_scale_of_initial_scale = final_scale
		
	elif spawn_location_and_change == SpawnLocationAndChange.CENTERED_TO_ORIGIN:
		center_pos = original_pos
		aoe.aoe_scale_of_initial_scale = final_scale
		
	elif spawn_location_and_change == SpawnLocationAndChange.STRECHED_AS_BEAM:
		center_pos = (original_pos + next_pos) / 2
		aoe.aoe_scale_of_initial_scale = Vector2(1, final_scale.y)
		_update_destination_position(aoe, original_pos, next_pos)
	
	aoe.global_position = center_pos
	
	return aoe

func _update_destination_position(aoe, origin_pos : Vector2, destination_pos : Vector2):
	if destination_pos != null and aoe is BaseTowerDetectingAOE:
		
		aoe.scale.x = _get_needed_x_scaling(origin_pos, destination_pos, aoe)
		aoe.rotation_degrees = _get_angle(origin_pos, destination_pos)
		#aoe.set_offset_of_coll_area(Vector2(0, -(_get_current_size(aoe).y / 2)))


func _get_angle(origin_pos : Vector2, destination_pos : Vector2):
	var dx = destination_pos.x - origin_pos.x
	var dy = destination_pos.y - origin_pos.y
	
	return rad2deg(atan2(dy, dx))

func _get_needed_x_scaling(origin_pos : Vector2, destination_pos : Vector2, aoe):
	var distance_from_origin = _get_origin_distance(origin_pos, destination_pos)
	var size = _get_current_size(aoe).x
	
	return distance_from_origin / size

func _get_current_size(aoe):
	var sprite = aoe.aoe_sprite_frames
	return sprite.get_frame("default", 1).get_size()

func _get_origin_distance(origin_pos : Vector2, destination_pos : Vector2):
	var dx = abs(destination_pos.x - origin_pos.x)
	var dy = abs(destination_pos.y - origin_pos.y)
	
	return sqrt((dx * dx) + (dy * dy))


#

func on_round_end():
	.on_round_end()
	
	kill_all_created_aoe()

func kill_all_created_aoe():
	for aoe in get_tree().get_nodes_in_group(td_aoe_group_tag):
		if is_instance_valid(aoe):
			aoe.queue_free()

func queue_free():
	kill_all_created_aoe()
	
	.queue_free()
