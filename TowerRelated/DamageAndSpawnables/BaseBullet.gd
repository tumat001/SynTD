extends KinematicBody2D

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

signal hit_an_enemy(me, enemy)
signal on_zero_pierce(me)

var attack_module_source
var damage_register_id : int

var damage_instance : DamageInstance
var pierce
var direction_as_relative_location : Vector2
var speed
var life_distance
var decrease_life_distance : bool = true

var current_life_distance

var _first_hit : bool = true
var beyond_first_hit_multiplier : float = 0.5

var rotation_per_second : float = 0

var enemies_ignored : Array = []

func _ready():
	current_life_distance = life_distance


func _process(delta):
	if decrease_life_distance:
		current_life_distance -= delta * speed
	
	if current_life_distance <= 0:
		trigger_on_death_events()
	
	rotation_degrees += rotation_per_second * delta


# Movement

func _physics_process(delta):
	_move(delta)

func _move(delta):
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
	pierce -= amount
	if pierce <= 0:
		emit_signal("on_zero_pierce", self)
		trigger_on_death_events()

func reduce_damage_by_beyond_first_multiplier():
	if _first_hit:
		_first_hit = false
		for dmg_id in damage_instance.on_hit_damages.keys():
			damage_instance.on_hit_damages[dmg_id].damage_as_modifier = damage_instance.on_hit_damages[dmg_id].damage_as_modifier.get_copy_scaled_by(beyond_first_hit_multiplier)



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


func set_shape(shape : Shape2D):
	$CollisionShape2D.shape = shape


