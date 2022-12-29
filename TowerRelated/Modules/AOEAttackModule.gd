extends "res://TowerRelated/Modules/AbstractAttackModule.gd"

const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")


enum SpawnLocationAndChange {
	NO_CHANGE,
	CENTERED_TO_ORIGIN,
	CENTERED_TO_ENEMY,
	STRECHED_AS_BEAM,
	
	TO_ENEMY_FACING_AWAY_FROM_ORIGIN,
}


signal before_aoe_is_added_as_child(aoe)
signal kill_all_spawned_aoe()

var spawn_location_and_change : int = SpawnLocationAndChange.NO_CHANGE

var base_aoe_scene : PackedScene


var benefits_from_bonus_explosion_scale : bool = true
var base_explosion_scale : float = 1
var flat_explosion_scale_effects : Dictionary = {}
var percent_explosion_scale_effects : Dictionary = {}
var last_calculated_explosion_scale : float

var damage_repeat_count : int = 1
var duration : float
var initial_delay : float = 0.05
var is_decrease_duration : bool = true
var pierce : int = -1  # no limit

var aoe_texture : Texture
var aoe_sprite_frames : SpriteFrames
var sprite_frames_only_play_once : bool

var aoe_default_coll_shape : int = BaseAOE.BaseAOEDefaultShapes.CIRCLE
var shift_x : bool = false

var absolute_z_index_of_aoe : int = ZIndexStore.PARTICLE_EFFECTS

var kill_all_created_aoe_at_round_end : bool = true

# constants

const aoe_group_tag : String = "AOEGroupTag"

# INIT

func _ready():
	calculate_final_explosion_scale()


# Construction of AOE

func construct_aoe(arg_origin_pos : Vector2, arg_enemy_pos : Vector2) -> BaseAOE:
	var base_aoe : BaseAOE = base_aoe_scene.instance()
	
	base_aoe.damage_register_id = damage_register_id
	base_aoe.attack_module_source = self
	
	var damage_instance : DamageInstance = construct_damage_instance()
	emit_signal("on_damage_instance_constructed", damage_instance, self)
	base_aoe.damage_instance = damage_instance
	
	base_aoe.damage_repeat_count = damage_repeat_count
	base_aoe.duration = duration
	base_aoe.collision_duration = duration
	base_aoe.decrease_duration = is_decrease_duration
	base_aoe.pierce = pierce
	base_aoe.initial_delay = initial_delay
	
	base_aoe.aoe_default_coll_shape = aoe_default_coll_shape
	
	base_aoe.sprite_frames_play_only_once = sprite_frames_only_play_once
	
	if aoe_sprite_frames != null:
		base_aoe.aoe_sprite_frames = aoe_sprite_frames
	elif aoe_texture != null:
		base_aoe.aoe_texture = aoe_texture
	
	base_aoe.shift_x = shift_x
	
	base_aoe.add_to_group(aoe_group_tag)
	
	base_aoe.z_as_relative = false
	base_aoe.z_index = absolute_z_index_of_aoe
	
	_modify_center_pos_and_sizeshape_of_aoe(arg_origin_pos, arg_enemy_pos, base_aoe)
	
	
	connect("kill_all_spawned_aoe", base_aoe, "queue_free", [], CONNECT_ONESHOT)
	
	return base_aoe


# Calculation of stuffs


func calculate_final_explosion_scale():
	var final_explosion_scale = base_explosion_scale
	
	if benefits_from_bonus_explosion_scale:
		var totals_bucket : Array = []
		
		for effect in percent_explosion_scale_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			
			if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
				final_explosion_scale += effect.attribute_as_modifier.get_modification_to_value(base_explosion_scale)
			else:
				totals_bucket.append(effect)
		
		for effect in flat_explosion_scale_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_explosion_scale += effect.attribute_as_modifier.get_modification_to_value(base_explosion_scale)
		
		var final_base_explosion_scale = final_explosion_scale
		for effect in totals_bucket:
			final_base_explosion_scale += effect.attribute_as_modifier.get_modification_to_value(final_explosion_scale)
		final_explosion_scale = final_base_explosion_scale
	
	last_calculated_explosion_scale = final_explosion_scale
	return final_explosion_scale


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


func _attack_at_position(enemy_pos : Vector2):
	var created_aoe = construct_aoe(global_position, enemy_pos)
	
	set_up_aoe__add_child_and_emit_signals(created_aoe)


# Center pos, explosion scale, and beam stretching

func _modify_center_pos_and_sizeshape_of_aoe(original_pos : Vector2, enemy_pos : Vector2, aoe : BaseAOE):
	var center_pos : Vector2
	var final_scale : Vector2 = Vector2(last_calculated_explosion_scale, last_calculated_explosion_scale)
	
	if spawn_location_and_change == SpawnLocationAndChange.CENTERED_TO_ENEMY:
		center_pos = enemy_pos
		aoe.aoe_scale_of_initial_scale = final_scale
		
	elif spawn_location_and_change == SpawnLocationAndChange.CENTERED_TO_ORIGIN:
		center_pos = original_pos
		aoe.aoe_scale_of_initial_scale = final_scale
		
	elif spawn_location_and_change == SpawnLocationAndChange.STRECHED_AS_BEAM:
		center_pos = (original_pos + enemy_pos) / 2
		aoe.aoe_scale_of_initial_scale = Vector2(1, final_scale.y)
		_update_destination_position(aoe, original_pos, enemy_pos)
		
	elif spawn_location_and_change == SpawnLocationAndChange.TO_ENEMY_FACING_AWAY_FROM_ORIGIN:
		center_pos = enemy_pos
		aoe.aoe_scale_of_initial_scale = final_scale
		
		aoe.rotation_degrees = rad2deg(enemy_pos.angle_to_point(original_pos))
	
	
	aoe.global_position = center_pos
	
	return aoe

func _update_destination_position(aoe, origin_pos : Vector2, destination_pos : Vector2):
	if destination_pos != null and aoe is BaseAOE:
		
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
	
	if kill_all_created_aoe_at_round_end:
		kill_all_created_aoe()

func kill_all_created_aoe():
	emit_signal("kill_all_spawned_aoe")

func queue_free():
	kill_all_created_aoe()
	
	.queue_free()

#

func set_up_aoe__add_child_and_emit_signals(aoe) -> BaseAOE:
	emit_signal("before_aoe_is_added_as_child", aoe)
	CommsForBetweenScenes.deferred_ge_add_child_to_proj_hoster(aoe)
	
	return aoe


