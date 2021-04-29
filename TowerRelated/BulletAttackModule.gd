extends "res://TowerRelated/AbstractAttackModule.gd"

const AbstractBullet = preload("res://TowerRelated/AbstractBullet.gd")


var bullet_scene

var base_pierce : float
var flat_pierce_modifiers = {}
var percent_pierce_modifiers = {}

var base_proj_speed : float
var flat_proj_speed_modifiers = {}
var percent_proj_speed_modifiers = {}

var projectile_life_distance : float

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

func calculate_final_life_distance():
	return .calculate_final_range_radius()

# On Attack Related


func _attack_enemy(enemy : AbstractEnemy):
	_attack_at_position(_get_angle(enemy.position.x, enemy.position.y))

func _get_angle(xPos, yPos):
	var dx = xPos - position.x
	var dy = yPos - position.y
	
	return rad2deg(atan2(dy, dx))

func _attack_at_position(pos : Vector2):
	var bullet = bullet_scene.instance()
	#TODO SET STUFFS HERE


