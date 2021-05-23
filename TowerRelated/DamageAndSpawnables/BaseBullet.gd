extends KinematicBody2D

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

var attack_module_source
var damage_register_id : int

var damage_instance : DamageInstance
var pierce
var direction_as_relative_location : Vector2
var speed
var life_distance

var current_life_distance

var modifications : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	current_life_distance = life_distance



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !current_life_distance == null:
		current_life_distance -= delta * speed
		if current_life_distance <= 0:
			trigger_on_death_events()


func _physics_process(delta):
	if direction_as_relative_location != null:
		var vector_mov = direction_as_relative_location
		vector_mov.x *= delta
		vector_mov.y *= delta
		
		vector_mov.x *= speed
		vector_mov.y *= speed
		move_and_collide(vector_mov)


func decrease_pierce(amount):
	pierce -= amount
	if pierce <= 0:
		trigger_on_death_events()

func trigger_on_death_events():
	_inactivate()
	
	if modifications != null:
		for modification in modifications:
			if modification.trigger_on_death:
				modification._finalize_bullet(self)
	
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

func set_shape(shape : Shape2D):
	$CollisionShape2D.shape = shape
