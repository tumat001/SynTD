extends KinematicBody2D

signal hit_a_tower(me, tower)
signal on_zero_pierce(me)
signal on_current_life_distance_expire()

var pierce
var direction_as_relative_location : Vector2
var speed
var life_distance
var decrease_life_distance : bool = true

var current_life_distance

var rotation_per_second : float = 0

var coll_source_layer : int = CollidableSourceAndDest.Source.FROM_ENEMY
var coll_destination_mask : int = CollidableSourceAndDest.Destination.TO_TOWER


func _ready():
	current_life_distance = life_distance
	
	CollidableSourceAndDest.set_coll_layer_source(self, coll_source_layer)
	CollidableSourceAndDest.set_coll_mask_destination(self, coll_destination_mask)
	


func _process(delta):
	if decrease_life_distance:
		current_life_distance -= delta * speed
	
	if current_life_distance <= 0:
		emit_signal("on_current_life_distance_expire")
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



func hit_by_tower(tower):
	emit_signal("hit_a_tower", self, tower)

func decrease_pierce(amount):
	pierce -= amount
	if pierce <= 0:
		emit_signal("on_zero_pierce", self)
		trigger_on_death_events()


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
