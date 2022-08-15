extends KinematicBody2D

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

signal hit_an_enemy(me, enemy)
signal on_zero_pierce(me)
signal on_current_life_distance_expire()

signal hit_a_tower(me, tower)


var attack_module_source
var damage_register_id : int

var damage_instance : DamageInstance
var pierce : float
var direction_as_relative_location : Vector2
var speed
var life_distance
var decrease_life_distance : bool = true
var decrease_pierce : bool = true

var current_life_distance

var _first_hit : bool = true
var beyond_first_hit_multiplier : float = 0.25#0.5

var rotation_per_second : float = 0

var enemies_ignored : Array = []

var destroy_self_after_zero_pierce : bool = true
var destroy_self_after_zero_life_distance : bool = true

var coll_source_layer : int = CollidableSourceAndDest.Source.FROM_TOWER
var coll_destination_mask : int = CollidableSourceAndDest.Destination.TO_ENEMY

var is_animated_sprite_playing : bool

#

var can_hit_towers : bool = false setget set_can_hit_towers
var reduce_pierce_if_hit_towers : bool = false


#

onready var bullet_sprite = $BulletSprite

func _ready():
	current_life_distance = life_distance
	
	CollidableSourceAndDest.set_coll_layer_source(self, coll_source_layer)
	CollidableSourceAndDest.set_coll_mask_destination(self, coll_destination_mask)
	
	bullet_sprite.playing = is_animated_sprite_playing
	
	set_can_hit_towers(can_hit_towers)


func _process(delta):
	rotation_degrees += rotation_per_second * delta


# Movement

func _physics_process(delta):
	_move(delta)

func _move(delta):
	if decrease_life_distance:
		current_life_distance -= delta * speed
	
	if current_life_distance <= 0:
		emit_signal("on_current_life_distance_expire")
		if destroy_self_after_zero_life_distance:
			trigger_on_death_events()
	
	if direction_as_relative_location != null:
		var vector_mov = direction_as_relative_location
		vector_mov.x *= delta
		vector_mov.y *= delta
		
		vector_mov.x *= speed
		vector_mov.y *= speed
		move_and_collide(vector_mov)



func hit_by_enemy(enemy):
	emit_signal("hit_an_enemy", self, enemy)

func decrease_pierce(amount):
	if decrease_pierce:
		pierce -= amount
	
	if pierce <= 0:
		emit_signal("on_zero_pierce", self)
		
		if destroy_self_after_zero_pierce:
			trigger_on_death_events()
		else:
			collision_mask = 0
			collision_layer = 0


func reduce_damage_by_beyond_first_multiplier():
	if _first_hit:
		_first_hit = false
		#for dmg_id in damage_instance.on_hit_damages.keys():
		#	damage_instance.on_hit_damages[dmg_id].damage_as_modifier = damage_instance.on_hit_damages[dmg_id].damage_as_modifier.get_copy_scaled_by(beyond_first_hit_multiplier)
		damage_instance.scale_only_damage_by(beyond_first_hit_multiplier)


func trigger_on_death_events():
	_inactivate()
	
	true_destroy()


func _inactivate():
	visible = false
	collision_mask = 0
	collision_layer = 0


func true_destroy():
	queue_free()


#

func get_sprite_frames():
	return $BulletSprite.frames

func set_sprite_frames(sprite_frames : SpriteFrames):
	$BulletSprite.frames = sprite_frames

func set_texture_as_sprite_frames(arg_texture : Texture):
	var sp : SpriteFrames = SpriteFrames.new()
	sp.add_frame("default", arg_texture)
	
	set_sprite_frames(sp)

func set_current_frame(frame : int):
	$BulletSprite.frame = frame


func set_shape(shape : Shape2D):
	$CollisionShape2D.shape = shape


#

func hit_by_tower(arg_tower):
	if arg_tower != null and !arg_tower.is_queued_for_deletion() and arg_tower.is_current_placable_in_map():
		emit_signal("hit_a_tower", self, arg_tower)
		
		if reduce_pierce_if_hit_towers:
			decrease_pierce(1)


func set_can_hit_towers(arg_val):
	can_hit_towers = arg_val
	
	set_collision_mask_bit(0, can_hit_towers)



