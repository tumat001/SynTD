extends Node

const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

var aoe_scene : PackedScene
var aoe_damage_instance : DamageInstance

var aoe_damage_repeat_count : int = 1
var aoe_duration : float
var aoe_pierce : int = -1

var aoe_texture : Texture
var aoe_sprite_frames : SpriteFrames
var aoe_sprite_frames_play_only_once : bool = true
var aoe_default_coll_shape : int
#

var spawn_aoe_at_death : bool = true
var tree


func _spawn_aoe(global_pos : Vector2):
	var aoe_instance : BaseAOE = aoe_scene.instance()
	
	aoe_instance.damage_repeat_count = aoe_damage_repeat_count
	aoe_instance.duration = aoe_duration
	aoe_instance.pierce = aoe_pierce
	aoe_instance.damage_instance = aoe_damage_instance
	
	aoe_instance.aoe_texture = aoe_texture
	aoe_instance.aoe_sprite_frames = aoe_sprite_frames
	aoe_instance.sprite_frames_play_only_once = aoe_sprite_frames_play_only_once
	aoe_instance.aoe_default_coll_shape = aoe_default_coll_shape
	
	aoe_instance.global_position = global_pos
	
	tree.get_root().add_child(aoe_instance)
