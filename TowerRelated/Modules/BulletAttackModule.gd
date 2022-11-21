extends "res://TowerRelated/Modules/AbstractAttackModule.gd"

const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")


signal before_bullet_is_shot(bullet)
signal after_bullet_is_shot(bullet) # after bullet is added to scene
signal kill_all_spawned_bullets()
signal bullet_on_zero_pierce(bullet)


var bullet_scene : PackedScene
var bullet_script : Reference

var bullet_sprite_frames : SpriteFrames
var bullet_shape : Shape2D

var benefits_from_bonus_pierce : bool = true
var benefits_from_bonus_proj_speed : bool = true

var base_pierce : float = 1
var flat_pierce_effects = {}
var percent_pierce_effects = {}
var last_calculated_final_pierce : float

const default_proj_speed : float = 500.0
var base_proj_speed : float = default_proj_speed
var flat_proj_speed_effects = {}
var percent_proj_speed_effects = {}
var last_calculated_final_proj_speed : float

var base_proj_life_distance : float setget _set_life_distance
var base_proj_life_distance_scale : float = 1.0 setget _set_life_distance_scale
const _life_distance_bonus : float = 75.0  # so that bullets don't despawn immedately when outside of range.
var last_calculated_final_proj_life_distance : float

var base_proj_inaccuracy : float = 0
var flat_proj_inaccuracy_effects = {}
var percent_proj_inaccuracy_effects = {}
var last_calculated_final_proj_inaccuracy : float

var absolute_z_index_of_bullet : int = ZIndexStore.PARTICLE_EFFECTS

var bullet_rotation_per_second : float = 0
var bullet_play_animation : bool = false

var kill_bullets_at_end_of_round : bool = true

#

const bullet_group_tag : String = "BulletGroupTag"


# Init


func _ready():
	calculate_final_pierce()
	calculate_final_proj_speed()
	calculate_final_proj_life_distance()
	calculate_final_proj_inaccuracy()


# setgets

func _set_life_distance_scale(scale : float):
	base_proj_life_distance_scale = scale
	calculate_final_proj_life_distance()

func _set_life_distance(life_distance : float):
	base_proj_life_distance = life_distance
	calculate_final_proj_life_distance()

func calculate_final_proj_life_distance():
	last_calculated_final_proj_life_distance = (base_proj_life_distance * base_proj_life_distance_scale) + _life_distance_bonus


func _set_range_module(new_module):
	if is_instance_valid(range_module):
		if range_module.is_connected("final_range_changed", self, "_range_of_range_module_changed"):
			range_module.disconnect("final_range_changed", self, "_range_of_range_module_changed")
	
	._set_range_module(new_module)
	
	if is_instance_valid(range_module):
		if !range_module.is_connected("final_range_changed", self, "_range_of_range_module_changed"):
			range_module.connect("final_range_changed", self, "_range_of_range_module_changed")

func _range_of_range_module_changed():
	_set_life_distance(range_module.last_calculated_final_range)


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
	
	last_calculated_final_pierce = final_pierce
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
	
	last_calculated_final_proj_speed = final_proj_speed
	return final_proj_speed


func calculate_final_proj_inaccuracy():
	#All percent modifiers here are to BASE proj speed only
	var final_proj_inaccuracy = base_proj_inaccuracy
	
	for effect in percent_proj_inaccuracy_effects.values():
		final_proj_inaccuracy += effect.attribute_as_modifier.get_modification_to_value(base_proj_inaccuracy)
	
	for effect in flat_proj_inaccuracy_effects.values():
		final_proj_inaccuracy += effect.attribute_as_modifier.get_modification_to_value(base_proj_inaccuracy)
		
	last_calculated_final_proj_inaccuracy = final_proj_inaccuracy
	return final_proj_inaccuracy


# On Attack Related


func _attack_enemy(enemy : AbstractEnemy):
	if is_instance_valid(enemy):
		_attack_at_position(enemy.position)


func _attack_at_position(arg_pos : Vector2):
	var bullet = construct_bullet(arg_pos)
	
	set_up_bullet__add_child_and_emit_signals(bullet)

# use this when adding bullet through custom ways (other means) of spawning bullets
func set_up_bullet__add_child_and_emit_signals(bullet) -> BaseBullet:
	emit_signal("before_bullet_is_shot", bullet)
	#get_tree().get_root().call_deferred("add_child", bullet)
	CommsForBetweenScenes.deferred_ge_add_child_to_proj_hoster(bullet)
	emit_signal("after_bullet_is_shot", bullet)
	
	return bullet



func construct_bullet(arg_enemy_pos : Vector2, arg_self_pos : Vector2 = global_position) -> BaseBullet:
	var bullet : BaseBullet = bullet_scene.instance()
	if bullet_script != null:
		bullet.set_script(bullet_script)
	
	if bullet_sprite_frames != null:
		bullet.set_sprite_frames(bullet_sprite_frames)
		
		bullet.is_animated_sprite_playing = bullet_play_animation
	if bullet_shape != null:
		bullet.set_shape(bullet_shape)
	
	var damage_instance : DamageInstance = construct_damage_instance()
	if damage_instance != null:
		emit_signal("on_damage_instance_constructed", damage_instance, self)
	
	bullet.damage_instance = damage_instance
	
	bullet.pierce = last_calculated_final_pierce
	
	bullet.attack_module_source = self
	bullet.damage_register_id = damage_register_id
	
	bullet.position.x = arg_self_pos.x
	bullet.position.y = arg_self_pos.y
	
	_adjust_bullet_physics_settings(bullet, arg_enemy_pos, arg_self_pos)
	
	bullet.add_to_group(bullet_group_tag)
	
	bullet.z_as_relative = false
	bullet.z_index = absolute_z_index_of_bullet
	
	connect("kill_all_spawned_bullets", bullet, "queue_free", [], CONNECT_ONESHOT)
	
	bullet.connect("on_zero_pierce", self, "_on_bullet_reached_zero_pierce")
	
	return bullet


func _adjust_bullet_physics_settings(bullet : BaseBullet, arg_enemy_pos : Vector2, reference_location : Vector2 = global_position):
	var dir : Vector2 = Vector2(arg_enemy_pos.x - reference_location.x, arg_enemy_pos.y - reference_location.y)
	var rand_x = 0
	var rand_y = 0
	var ratio = 1
	
	if last_calculated_final_proj_inaccuracy != 0:
		var rand_gen = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.INACCURACY)
		rand_x = rand_gen.randf_range(-last_calculated_final_proj_inaccuracy, last_calculated_final_proj_inaccuracy)
		rand_y = rand_gen.randf_range(-last_calculated_final_proj_inaccuracy, last_calculated_final_proj_inaccuracy)
		
		var self_enemy_distance = reference_location.distance_to(arg_enemy_pos)
		
		if self_enemy_distance != 0:
			ratio = range_module.base_range_radius / self_enemy_distance
		
	dir += Vector2(rand_x / ratio, rand_y / ratio)
	
	bullet.direction_as_relative_location = dir.normalized()
	bullet.speed = last_calculated_final_proj_speed
	bullet.life_distance = last_calculated_final_proj_life_distance
	bullet.current_life_distance = bullet.life_distance
	bullet.rotation_degrees = _get_angle(arg_enemy_pos, reference_location)
	
	bullet.rotation_per_second = bullet_rotation_per_second


func _get_angle(destination_pos : Vector2, reference_location : Vector2 = global_position):
	var dx = destination_pos.x - reference_location.x
	var dy = destination_pos.y - reference_location.y
	
	return rad2deg(atan2(dy, dx))


func _attack_enemies(enemies : Array):
	._attack_enemies(enemies)
	
	for enemy in enemies:
		if is_instance_valid(enemy):
			_attack_at_position(enemy.position)

func _attack_at_positions(arg_poses : Array):
	._attack_at_positions(arg_poses)
	
	for pos in arg_poses:
		_attack_at_position(pos)

# Bullet Set properties related

func set_texture_as_sprite_frame(texture : Texture, anim_name : String = "default"):
	var sprite_frames = SpriteFrames.new()
	
	if !sprite_frames.has_animation(anim_name):
		sprite_frames.add_animation(anim_name)
	sprite_frames.add_frame(anim_name, texture)
	
	bullet_sprite_frames = sprite_frames


#

func _on_bullet_reached_zero_pierce(arg_bullet):
	emit_signal("bullet_on_zero_pierce", arg_bullet)

#

func on_round_end():
	.on_round_end()
	
	if kill_bullets_at_end_of_round:
		kill_all_created_bullets()

func kill_all_created_bullets():
	emit_signal("kill_all_spawned_bullets")
#	for bullet in get_tree().get_nodes_in_group(bullet_group_tag):
#		if bullet != null:
#			bullet.queue_free()

func queue_free():
	kill_all_created_bullets()
	
	.queue_free()

#

static func get_life_distance_bonus_allowance():
	return _life_distance_bonus
