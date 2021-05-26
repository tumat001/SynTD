extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"

const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")

var aoe_scene : PackedScene
var aoe_damage_instance : DamageInstance

var aoe_damage_repeat_count : int = 1
var aoe_duration : float
var aoe_pierce : int = -1

var aoe_texture : Texture
var aoe_sprite_frames : SpriteFrames
var aoe_sprite_frames_play_only_once : bool = true
var aoe_default_coll_shape : int

var aoe_damage_register_id : int

#

var spawn_aoe_at_death : bool = true

func trigger_on_death_events():
	if spawn_aoe_at_death:
		_spawn_aoe()
	
	.trigger_on_death_events()

func _spawn_aoe():
	var aoe_instance : BaseAOE = aoe_scene.instance()
	
	aoe_instance.damage_repeat_count = aoe_damage_repeat_count
	aoe_instance.duration = aoe_duration
	aoe_instance.pierce = aoe_pierce
	aoe_instance.aoe_texture = aoe_texture
	aoe_instance.aoe_sprite_frames = aoe_sprite_frames
	aoe_instance.sprite_frames_play_only_once = aoe_sprite_frames_play_only_once
	aoe_instance.aoe_default_coll_shape = aoe_default_coll_shape
	aoe_instance.attack_module_source = attack_module_source
	aoe_instance.damage_register_id = aoe_damage_register_id
	
	get_tree().get_root().add_child(aoe_instance)
