extends KinematicBody2D

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")


signal hit_an_enemy(me, enemy)
signal on_zero_pierce(me)
signal on_current_life_distance_expire()
signal on_current_life_duration_expire()

signal hit_a_tower(me, tower)
signal before_mov_is_executed(me, arg_delta)

var attack_module_source
var damage_register_id : int

var damage_instance : DamageInstance
var pierce : float
var direction_as_relative_location : Vector2
var speed
var speed_inc_per_sec : float = 0
var speed_max : float = 10000
var speed_min : float = 0

var life_distance
var decrease_life_distance : bool = true
var decrease_pierce : bool = true
var current_life_distance

var life_duration : float = 1.0
var decrease_life_duration : bool = false
var current_life_duration : float

var _first_hit : bool = true
var beyond_first_hit_multiplier : float = 0.25#0.5
var apply_damage_instance_on_hit : bool = true # if false, does not apply dmg instance to enemy, and _first_hit does not become false

var rotation_per_second : float = 0

var enemies_ignored : Array = []
var enemies_to_hit_only : Array = [] # ignore all except these

var destroy_self_after_zero_pierce : bool = true
var destroy_self_after_zero_life_distance : bool = true

var coll_source_layer : int = CollidableSourceAndDest.Source.FROM_TOWER
var coll_destination_mask : int = CollidableSourceAndDest.Destination.TO_ENEMY

var is_animated_sprite_playing : bool

#

var can_hit_towers : bool = false setget set_can_hit_towers
var reduce_pierce_if_hit_towers : bool = false

# includes hitting the same enemy
var num_of_non_unique_enemy_hits : int = 0

var _is_in_queue_free : bool

#

onready var bullet_sprite = $BulletSprite
onready var coll_shape = $CollisionShape2D

func _ready():
	current_life_distance = life_distance
	current_life_duration = life_duration
	
	CollidableSourceAndDest.set_coll_layer_source(self, coll_source_layer)
	CollidableSourceAndDest.set_coll_mask_destination(self, coll_destination_mask)
	
	bullet_sprite.playing = is_animated_sprite_playing
	set_can_hit_towers(can_hit_towers)


func _process(delta):
	rotation_degrees += rotation_per_second * delta
	
	if !_is_in_queue_free:
		_move(delta)
		
		# dont put this in _move, or it wont work for ArcingBaseBullet class
		if decrease_life_duration:
			current_life_duration -= delta
		if current_life_duration <= 0:
			emit_signal("on_current_life_duration_expire")
			trigger_on_death_events()

# Movement

#func _physics_process(delta):
#	_move(delta)

func _move(delta):
	emit_signal("before_mov_is_executed", self, delta)
	
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
	
	speed += speed_inc_per_sec * delta
	
	if speed < speed_min:
		speed = 0
	if speed > speed_max:
		speed = speed_max



func hit_by_enemy(enemy):
	num_of_non_unique_enemy_hits += 1
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

func queue_free():
	_is_in_queue_free = true
	.queue_free()

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
	if is_instance_valid(arg_tower) and !arg_tower.is_queued_for_deletion() and arg_tower.is_current_placable_in_map():
		emit_signal("hit_a_tower", self, arg_tower)
		
		if reduce_pierce_if_hit_towers:
			decrease_pierce(1)


func set_can_hit_towers(arg_val):
	can_hit_towers = arg_val
	
	set_collision_mask_bit(0, can_hit_towers)


#

func can_hit_enemy(arg_enemy):
	return !enemies_ignored.has(arg_enemy) and (enemies_to_hit_only.size() == 0 or enemies_to_hit_only.has(arg_enemy) or _if_enemies_to_hit_only_has_only_nulls())

func _if_enemies_to_hit_only_has_only_nulls():
	for enemy in enemies_to_hit_only:
		if is_instance_valid(enemy) and !enemy.is_queued_for_deletion():
			return false
	
	return true


### bounce related

func bounce_off_left():
	bounce(Vector2.LEFT)

func bounce_off_right():
	bounce(Vector2.RIGHT)

func bounce_off_top():
	bounce(Vector2.UP)

func bounce_off_bottom():
	bounce(Vector2.DOWN)

func bounce(arg_normalized_vector : Vector2):
	direction_as_relative_location = direction_as_relative_location.bounce(arg_normalized_vector)
	rotation = direction_as_relative_location.angle()
