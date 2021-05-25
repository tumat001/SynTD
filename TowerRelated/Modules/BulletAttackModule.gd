extends "res://TowerRelated/Modules/AbstractAttackModule.gd"

const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

signal before_bullet_is_shot(bullet)


var bullet_scene : PackedScene
var bullet_sprite_frames : SpriteFrames
var bullet_shape : Shape2D

var benefits_from_bonus_pierce : bool = true
var benefits_from_bonus_proj_speed : bool = true

var base_pierce : float = 1
var flat_pierce_effects = {}
var percent_pierce_effects = {}

var base_proj_speed : float = 500
var flat_proj_speed_effects = {}
var percent_proj_speed_effects = {}

var projectile_life_distance : float = 100 setget _set_life_distance
const _life_distance_bonus : float = 50.0

# signal related

var damage_register_id : int 

# setgets

func _set_life_distance(life_distance : float):
	projectile_life_distance = life_distance + _life_distance_bonus


# Time related

func time_passed(delta):
	.time_passed(delta)
	

#func decrease_time_of_timebounds(delta):
#	.decrease_time_of_timebounded(delta)
#
#	var bucket = []
#
#	#For percent pierce eff
#	for effect_uuid in percent_pierce_effects.keys():
#		if percent_pierce_effects[effect_uuid].is_timebound:
#			percent_pierce_effects[effect_uuid].time_in_seconds -= delta
#			var time_left = percent_pierce_effects[effect_uuid].time_in_seconds
#			if time_left <= 0:
#				bucket.append(effect_uuid)
#
#	for key_to_delete in bucket:
#		percent_pierce_effects.erase(key_to_delete)
#
#	bucket.clear()
#
#	#For flat pierce eff
#	for effect_uuid in flat_pierce_effects.keys():
#		if flat_pierce_effects[effect_uuid].is_timebound:
#			flat_pierce_effects[effect_uuid].time_in_seconds -= delta
#			var time_left = flat_pierce_effects[effect_uuid].time_in_seconds
#			if time_left <= 0:
#				bucket.append(effect_uuid)
#
#	for key_to_delete in bucket:
#		flat_pierce_effects.erase(key_to_delete)
#
#	bucket.clear()
#
#
#	#For percent proj speed eff
#	for effect_uuid in percent_proj_speed_effects.keys():
#		if percent_proj_speed_effects[effect_uuid].is_timebound:
#			percent_proj_speed_effects[effect_uuid].time_in_seconds -= delta
#			var time_left = percent_proj_speed_effects[effect_uuid].time_in_seconds
#			if time_left <= 0:
#				bucket.append(effect_uuid)
#
#	for key_to_delete in bucket:
#		percent_proj_speed_effects.erase(key_to_delete)
#
#	bucket.clear()
#
#	#For flat proj speed eff
#	for effect_uuid in flat_proj_speed_effects.keys():
#		if flat_proj_speed_effects[effect_uuid].is_timebound:
#			flat_proj_speed_effects[effect_uuid].time_in_seconds -= delta
#			var time_left = flat_proj_speed_effects[effect_uuid].time_in_seconds
#			if time_left <= 0:
#				bucket.append(effect_uuid)
#
#	for key_to_delete in bucket:
#		flat_proj_speed_effects.erase(key_to_delete)
#
#	bucket.clear()


# Calculations of final values

func calculate_final_pierce():
	#All percent modifiers here are to BASE pierce only
	var final_pierce = base_pierce
	
	if benefits_from_bonus_pierce:
		for effect in percent_pierce_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_pierce += effect.attribute_as_modifier.get_modification_to_value(base_pierce)
		
		for effect in flat_pierce_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_pierce += effect.attribute_as_modifier.get_modification_to_value(base_pierce)
	
	return final_pierce

func calculate_final_proj_speed():
	#All percent modifiers here are to BASE proj speed only
	var final_proj_speed = base_proj_speed
	
	if benefits_from_bonus_proj_speed:
		for effect in percent_proj_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_proj_speed += effect.attribute_as_modifier.get_modification_to_value(base_proj_speed)
		
		for effect in flat_proj_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_proj_speed += effect.attribute_as_modifier.get_modification_to_value(base_proj_speed)
	
	return final_proj_speed


# On Attack Related


func _attack_enemy(enemy : AbstractEnemy):
	if enemy != null:
		_attack_at_position(enemy.position)


func _attack_at_position(arg_pos : Vector2):
	var bullet : BaseBullet = bullet_scene.instance()
	
	if bullet_sprite_frames != null:
		bullet.set_sprite_frames(bullet_sprite_frames)
	if bullet_shape != null:
		bullet.set_shape(bullet_shape)
	
	var damage_instance : DamageInstance = DamageInstance.new()
	damage_instance.on_hit_damages = _get_all_scaled_on_hit_damages()
	damage_instance.on_hit_effects = _get_all_scaled_on_hit_effects()
	
	bullet.damage_instance = damage_instance
	bullet.pierce = calculate_final_pierce()
	bullet.direction_as_relative_location = Vector2(arg_pos.x - global_position.x, arg_pos.y - global_position.y).normalized()
	bullet.speed = calculate_final_proj_speed()
	bullet.life_distance = projectile_life_distance
	bullet.current_life_distance = bullet.life_distance
	bullet.rotation_degrees = _get_angle(arg_pos)
	
	bullet.attack_module_source = self
	bullet.damage_register_id = damage_register_id
	
	bullet.position.x = global_position.x
	bullet.position.y = global_position.y
	
	_modify_attack(bullet)
	emit_signal("before_bullet_is_shot", bullet)
	get_tree().get_root().add_child(bullet)


func _get_angle(destination_pos : Vector2):
	var dx = destination_pos.x - global_position.x
	var dy = destination_pos.y - global_position.y
	
	return rad2deg(atan2(dy, dx))


func _attack_enemies(enemies : Array):
	._attack_enemies(enemies)
	
	var poses : Array = []
	
	for enemy in enemies:
		if enemy != null:
			poses.append(enemy.position)
	
	_attack_at_positions(poses)

func _attack_at_positions(arg_poses : Array):
	
	for pos in arg_poses:
		_attack_at_position(pos)

# Bullet Set properties related

func set_texture_as_sprite_frame(texture : Texture, anim_name : String = "default"):
	var sprite_frames = SpriteFrames.new()
	
	if !sprite_frames.has_animation(anim_name):
		sprite_frames.add_animation(anim_name)
	sprite_frames.add_frame(anim_name, texture)
	
	bullet_sprite_frames = sprite_frames
