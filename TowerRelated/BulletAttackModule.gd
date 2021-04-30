extends "res://TowerRelated/AbstractAttackModule.gd"

const BaseBullet = preload("res://TowerRelated/BaseBullet.gd")


var bullet_scene
var bullet_sprite_frames : SpriteFrames

var benefits_from_bonus_pierce : bool = true
var benefits_from_bonus_proj_speed : bool = true

var base_pierce : float = 1
var flat_pierce_modifiers = {}
var percent_pierce_modifiers = {}

var base_proj_speed : float = 500
var flat_proj_speed_modifiers = {}
var percent_proj_speed_modifiers = {}

var projectile_life_distance : float = 100

func time_passed(delta):
	.time_passed(delta)
	

func decrease_time_of_timebounds(delta):
	.decrease_time_of_timebounded(delta)
	
	var bucket = []
	
	#For percent pierce mods
	for key in percent_pierce_modifiers.keys():
		if percent_pierce_modifiers[key].is_timebound:
			percent_pierce_modifiers[key].time_in_seconds -= delta
			var time_left = percent_pierce_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		percent_pierce_modifiers.erase(key_to_delete)
	
	bucket.clear()
	
	#For flat pierce mods
	for key in flat_pierce_modifiers.keys():
		if flat_pierce_modifiers[key].is_timebound:
			flat_pierce_modifiers[key].time_in_seconds -= delta
			var time_left = flat_pierce_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		flat_pierce_modifiers.erase(key_to_delete)
	
	bucket.clear()
	
	
	#For percent proj speed mods
	for key in percent_proj_speed_modifiers.keys():
		if percent_proj_speed_modifiers[key].is_timebound:
			percent_proj_speed_modifiers[key].time_in_seconds -= delta
			var time_left = percent_proj_speed_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		percent_proj_speed_modifiers.erase(key_to_delete)
	
	bucket.clear()
	
	#For flat proj speed mods
	for key in flat_proj_speed_modifiers.keys():
		if flat_proj_speed_modifiers[key].is_timebound:
			flat_proj_speed_modifiers[key].time_in_seconds -= delta
			var time_left = flat_proj_speed_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		flat_proj_speed_modifiers.erase(key_to_delete)
	
	bucket.clear()


# Calculations of final values

func calculate_final_pierce():
	#All percent modifiers here are to BASE pierce only
	var final_pierce = base_pierce
	for modifier in percent_pierce_modifiers.values():
		final_pierce += modifier.get_modification_to_value(base_pierce)
	
	for flat in flat_pierce_modifiers.values():
		final_pierce += flat.get_modification_to_value(base_pierce)
	
	return final_pierce

func calculate_final_proj_speed():
	#All percent modifiers here are to BASE proj speed only
	var final_proj_speed = base_proj_speed
	for modifier in percent_proj_speed_modifiers.values():
		final_proj_speed += modifier.get_modification_to_value(base_proj_speed)
	
	for flat in flat_proj_speed_modifiers.values():
		final_proj_speed += flat.get_modification_to_value(base_proj_speed)
	
	return final_proj_speed


# On Attack Related


func _attack_enemy(enemy : AbstractEnemy):
	if enemy != null:
		_attack_at_position(enemy.position)


func _attack_at_position(arg_pos : Vector2):
	var bullet : BaseBullet = bullet_scene.instance()
	
	bullet.set_sprite_frames(bullet_sprite_frames)
	
	bullet.on_hit_damages = _get_all_scaled_on_hit_damages()
	bullet.on_hit_effects = _get_all_scaled_on_hit_effects()
	bullet.pierce = calculate_final_pierce()
	bullet.direction_as_relative_location = Vector2(arg_pos.x - global_position.x, arg_pos.y - global_position.y).normalized()
	bullet.speed = calculate_final_proj_speed()
	bullet.life_distance = projectile_life_distance
	bullet.current_life_distance = bullet.life_distance
	
	bullet.position.x = global_position.x
	bullet.position.y = global_position.y
	get_tree().get_root().add_child(bullet)
	


#func _get_angle(xPos, yPos):
#	var dx = xPos - position.x
#	var dy = yPos - position.y
#
#	return rad2deg(atan2(dy, dx))


func _attack_enemies(enemies : Array):
	var poses : Array = []
	
	for enemy in enemies:
		if enemy != null:
			poses.append(enemy.position)
	
	_attack_at_positions(poses)

func _attack_at_positions(arg_poses : Array):
	
	for pos in arg_poses:
		_attack_at_position(pos)

#

func set_texture_as_sprite_frame(texture : Texture, anim_name : String = "default"):
	var sprite_frames = SpriteFrames.new()
	
	sprite_frames.add_animation(anim_name)
	sprite_frames.add_frame(anim_name, texture)
	
	bullet_sprite_frames = sprite_frames
