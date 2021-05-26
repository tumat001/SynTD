extends "res://TowerRelated/Modules/AbstractAttackModule.gd"

const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

enum SpawnLocation {
	CENTERED_TO_MODULE,
	CENTERED_TO_ENEMY,
	STRETCH_AS_BEAM,
}

signal before_aoe_is_added_as_child(aoe)


var spawn_location : int = SpawnLocation.CENTERED_TO_ENEMY

var base_aoe_scene : PackedScene

var damage_repeat_count : int = 1
var duration : float
var initial_delay : float = 0.05
var is_decrease_duration : bool = true
var pierce : int = -1  # no limit

var aoe_texture : Texture
var aoe_sprite_frames : SpriteFrames
var sprite_frames_only_play_once : bool

var shift_x : bool = false

func construct_aoe() -> BaseAOE:
	var base_aoe : BaseAOE = base_aoe_scene.instance()
	
	base_aoe.damage_register_id = damage_register_id
	
	var damage_instance : DamageInstance = DamageInstance.new()
	damage_instance.on_hit_damages = _get_all_scaled_on_hit_damages()
	damage_instance.on_hit_effects = _get_all_scaled_on_hit_effects()
	base_aoe.damage_instance = damage_instance
	
	base_aoe.damage_repeat_count = damage_repeat_count
	base_aoe.duration = duration
	base_aoe.decrease_duration = is_decrease_duration
	base_aoe.pierce = pierce
	base_aoe.initial_delay = initial_delay
	
	base_aoe.global_position = global_position
	
	if !base_aoe._animated_sprite_has_animation():
		if aoe_sprite_frames != null:
			base_aoe.aoe_sprite_frames = aoe_sprite_frames
		elif aoe_texture != null:
			base_aoe.aoe_texture = aoe_texture
	
	base_aoe.sprite_frames_play_only_once = sprite_frames_only_play_once
	base_aoe.shift_x = shift_x
	
	return base_aoe


# Attack related

func _attack_enemies(enemies : Array):
	._attack_enemies(enemies)
	
	for enemy in enemies:
		_attack_enemy(enemy)

func _attack_enemy(enemy : AbstractEnemy):
	_attack_at_position(enemy.position)



func _attack_at_positions(positions : Array):
	._attack_at_positions(positions)
	
	for pos in positions:
		_attack_at_position(pos)

func _attack_at_position(pos : Vector2):
	var created_aoe = construct_aoe()
	
	created_aoe.global_position = _get_center_pos_for_aoe(global_position, pos)
	
	._modify_attack(created_aoe)
	emit_signal("before_aoe_is_added_as_child", created_aoe)
	
	get_tree().get_root().add_child(created_aoe)


func _get_center_pos_for_aoe(original_pos : Vector2, enemy_pos : Vector2) -> Vector2:
	if spawn_location == SpawnLocation.CENTERED_TO_ENEMY:
		return enemy_pos
	elif spawn_location == SpawnLocation.CENTERED_TO_MODULE:
		return original_pos
	
	return Vector2(0, 0)

