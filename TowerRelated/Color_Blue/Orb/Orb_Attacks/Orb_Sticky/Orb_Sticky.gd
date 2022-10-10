extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"

signal sticky_time_reached()

const Orb_StickyPic01 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_Sticky01.png")
const Orb_StickyPic02 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_Sticky02.png")
const Orb_StickyPic03 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_Sticky03.png")
const Orb_StickyPic04 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_Sticky04.png")
const Orb_StickyPic05 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_Sticky05.png")
const Orb_StickyPic06 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_Sticky06.png")


const max_sticky_time : float = 2.0

var enemy_stuck_to
var activated : bool = false
var current_sticky_time_left : float = max_sticky_time

var current_explosion_count : int = 0


onready var bulletsprite : AnimatedSprite = $BulletSprite

# Enemy hit and pos related

func _ready():
	bulletsprite.frames = SpriteFrames.new()
	bulletsprite.frames.add_frame("default", Orb_StickyPic01)
	bulletsprite.frames.add_frame("default", Orb_StickyPic02)
	bulletsprite.frames.add_frame("default", Orb_StickyPic03)
	bulletsprite.frames.add_frame("default", Orb_StickyPic04)
	bulletsprite.frames.add_frame("default", Orb_StickyPic05)
	bulletsprite.frames.add_frame("default", Orb_StickyPic06)


func hit_by_enemy(enemy):
	enemy_stuck_to = enemy
	enemy.connect("on_death_by_any_cause", self, "_enemy_died", [], CONNECT_ONESHOT)
	
	decrease_life_distance = false
	current_life_distance = 500
	direction_as_relative_location = Vector2(0, 0)
	speed = 0
	activated = true
	
	#current_sticky_time_left = max_sticky_time
	
	collision_layer = 0
	collision_mask = 0
	
	call_deferred("emit_signal", "hit_an_enemy", self)

func _enemy_died():
	emit_signal("sticky_time_reached")

func decrease_pierce(amount):
	pass # Do nothing: prevent queue freeing from parent func


func _process(delta):
	if is_instance_valid(enemy_stuck_to):
		global_position = enemy_stuck_to.global_position
	
	if activated:
		current_sticky_time_left -= delta
		_change_texture_based_on_time_left()
		if current_sticky_time_left <= 0:
			emit_signal("sticky_time_reached")



func _change_texture_based_on_time_left():
	var ratio = max_sticky_time / 6
	
	if current_sticky_time_left > 5 * ratio:
		bulletsprite.frame = 0
	elif current_sticky_time_left > 4 * ratio:
		bulletsprite.frame = 1
	elif current_sticky_time_left > 3 * ratio:
		bulletsprite.frame = 2
	elif current_sticky_time_left > 2 * ratio:
		bulletsprite.frame = 3
	elif current_sticky_time_left > 1 * ratio:
		bulletsprite.frame = 4
	elif current_sticky_time_left > 0:
		bulletsprite.frame = 5
		
	
	
