extends KinematicBody2D

var bullet_type

var on_hit_damages = {}
var on_hit_effects = {}
var pierce
var direction_as_relative_location
var speed
var lifetime

var current_lifetime

# Called when the node enters the scene tree for the first time.
func _ready():
	current_lifetime = lifetime

func _enter_tree():
	#current_lifetime = lifetime
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !current_lifetime == null:
		current_lifetime -= delta
		
		if current_lifetime <= 0:
			inactivate()

func _physics_process(delta):
	if !(bullet_type == "bullet_inactive" or direction_as_relative_location == null):
			var vector_mov = direction_as_relative_location
			vector_mov.x *= delta
			vector_mov.y *= delta
			
			vector_mov.x *= speed
			vector_mov.y *= speed
			move_and_collide(vector_mov)

func set_bullet_type(type):
	bullet_type = type
	$BulletSprite.frames = SpriteFrames.new()
	
	if type == "bullet_inactive":
		$CollisionShape2D.set_deferred("disabled", true)
		set_collision_layer_bit(2, false)
		set_collision_mask_bit(5, false)
		set_collision_mask_bit(6, false)
	elif type == "bullet_mono":
		#$BulletSprite.frames.add_animation("default")
		$BulletSprite.frames.add_frame("default", BulletMetadata.mono_bullet_default_sprite)
		$CollisionShape2D.set_deferred("disabled", false)
		$BulletSprite.animation = "default"
		
		var circleCollision = CircleShape2D.new()
		circleCollision.radius = 5
		$CollisionShape2D.set_deferred("shape", circleCollision)
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(5, true)
		set_collision_mask_bit(6, true)

func inactivate():
	set_bullet_type("bullet_inactive")
	direction_as_relative_location = Vector2(0, 0)
	speed = 0
	# TODO Make it go back to queue space
	true_destroy()
	# TODO remove true_destroy() once pooling is completed


func true_destroy():
	queue_free()


func decrease_pierce(amount):
	pierce -= amount
	if pierce <= 0:
		inactivate()
