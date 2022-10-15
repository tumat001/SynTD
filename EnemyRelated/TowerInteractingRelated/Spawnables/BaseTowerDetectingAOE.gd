extends Node2D

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

signal on_tower_hit(tower)


var damage_repeat_count : int = 1
var duration : float
var decrease_duration : bool = true
var pierce : int = -1

var towers_to_ignore : Array = []

var aoe_texture : Texture
var aoe_sprite_frames : SpriteFrames
var sprite_frames_play_only_once : bool = true

var aoe_default_coll_shape : int = BaseAOEDefaultShapes.CIRCLE
var shift_x : bool = false

var aoe_scale_of_initial_scale : Vector2 = Vector2(1, 1)

var initial_delay : float = 0.05

var offset : Vector2 setget set_offset_of_coll_area

var coll_source_layer : int = CollidableSourceAndDest.Source.FROM_ENEMY
var coll_destination_mask : int = CollidableSourceAndDest.Destination.TO_TOWER

# internal stuffs

var _delay_in_between_repeats : float
var _current_pierce_refresh_delay : float = 0.05
var _current_damage_delay : float = 0.05
var _current_duration : float
#var _current_damage_repeat_count : int = 0
var _towers_inside_damage_cd_map : Dictionary = {}
var _pierce_available : int

onready var aoe_area : Area2D = $AOEArea
onready var anim_sprite : AnimatedSprite = $AOEArea/AnimatedSprite
onready var collision_shape : CollisionShape2D = $AOEArea/Shape

#

func _on_AOEArea_area_shape_entered(area_id, area, area_shape, self_shape):
	if is_instance_valid(area):
		if area is AbstractTower:
			if !towers_to_ignore.has(area):
				_towers_inside_damage_cd_map[area] = 0


func _on_AOEArea_area_shape_exited(area_id, area, area_shape, self_shape):
	if is_instance_valid(area):
		if area is AbstractTower:
			_towers_inside_damage_cd_map.erase(area)

#

func _ready():
	_current_pierce_refresh_delay = initial_delay
	_current_damage_delay = initial_delay
	_delay_in_between_repeats = _calculate_delay_in_between_repeats()
	
	CollidableSourceAndDest.set_coll_layer_source(get_aoe_area(), coll_source_layer)
	CollidableSourceAndDest.set_coll_mask_destination(get_aoe_area(), coll_destination_mask)
	
	if offset != null:
		aoe_area.position += offset
	
	if !_animated_sprite_has_animation():
		if aoe_texture != null:
			_set_texture_as_sprite()
		elif aoe_sprite_frames != null:
			_set_sprite_frames()
	
	
	if collision_shape.shape == null:
		if aoe_default_coll_shape == BaseAOEDefaultShapes.CIRCLE:
			_set_default_circle_shape()
		elif aoe_default_coll_shape == BaseAOEDefaultShapes.RECTANGLE:
			_set_default_rectangle_shape()
	
	if shift_x:
		position.x += _get_first_anim_size().x
	
	
	scale *= aoe_scale_of_initial_scale

func _process(delta):
	if _current_duration < duration:
		
		if decrease_duration:
			_current_duration += delta
		
		if _current_pierce_refresh_delay <= 0:
			_pierce_available = pierce
			_current_pierce_refresh_delay = _delay_in_between_repeats
		else:
			_current_pierce_refresh_delay -= delta
		
		
		if _current_damage_delay > 0:
			_current_damage_delay -= delta
		else:
			if _towers_inside_damage_cd_map.size() != 0:
				#_current_damage_repeat_count += 1
				_attempt_damage_entities_inside(delta)
		
	else:
		queue_free()



# Expose methods

func set_coll_shape(shape):
	#collision_shape.shape = shape
	collision_shape.set_deferred("shape", shape)

func set_offset_of_coll_area(arg_offset : Vector2):
	offset = arg_offset

#

func _calculate_delay_in_between_repeats() -> float:
	return duration / damage_repeat_count

func _set_texture_as_sprite():
	var sprite_frames : SpriteFrames = SpriteFrames.new()
	sprite_frames.add_frame("default", aoe_texture)
	
	anim_sprite.frames = sprite_frames

func _set_sprite_frames():
	anim_sprite.frames = aoe_sprite_frames
	anim_sprite.playing = true
	
	if sprite_frames_play_only_once:
		anim_sprite.frames.set_animation_speed("default", _calculate_fps_of_sprite_frames(aoe_sprite_frames.get_frame_count("default")))
		aoe_sprite_frames.set_animation_loop("default", false)

func _animated_sprite_has_animation() -> bool:
	return anim_sprite.frames != null

func _calculate_fps_of_sprite_frames(frame_count : int) -> int:
	return int(ceil(frame_count / duration))



# Shape Related

func _set_coll_shape_to(arg_shape):
	collision_shape.shape = arg_shape

func _set_default_circle_shape():
	if anim_sprite.frames != null:
		var size_of_sprite = _get_first_anim_size()
		var coll_shape = CircleShape2D.new()
		coll_shape.radius = size_of_sprite.x / 2.0
		
		collision_shape.shape = coll_shape

func _get_first_anim_size() -> Vector2:
	return anim_sprite.frames.get_frame(anim_sprite.animation, anim_sprite.frame).get_size()


func _set_default_rectangle_shape():
	if anim_sprite.frames != null:
		var size_of_sprite = _get_first_anim_size()
		var coll_shape = RectangleShape2D.new()
		coll_shape.extents.x = size_of_sprite.x / 2
		coll_shape.extents.y = size_of_sprite.y / 2
		
		collision_shape.shape = coll_shape

#

func _attempt_damage_entities_inside(delta):
	#if _current_damage_repeat_count < damage_repeat_count:
	for entity in _towers_inside_damage_cd_map.keys():
		if _towers_inside_damage_cd_map[entity] <= 0:
			_attempt_damage_entity(entity)
		else:
			_towers_inside_damage_cd_map[entity] -= delta
	
	_towers_inside_damage_cd_map.erase(null)


func _attempt_damage_entity(entity):
	var successful = _pierce_available > 0 or pierce == -1
	
	if successful:
		_towers_inside_damage_cd_map[entity] = _delay_in_between_repeats
		_pierce_available -= 1
		emit_signal("on_tower_hit", entity)
	
	return successful


func queue_free():
	.queue_free()

#

func get_aoe_area() -> Area2D:
	return $AOEArea as Area2D
