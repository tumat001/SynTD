extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"

const BlueMagnetPic = preload("res://TowerRelated/Color_Yellow/Magnetizer/BlueMagnet.png")
const RedMagnetPic = preload("res://TowerRelated/Color_Yellow/Magnetizer/RedMagnet.png")

enum {
	BLUE, # SOUTH
	RED, # NORTH btw
}

signal hit_an_enemy(me)

var previous_enemy_pos : Vector2
var enemy_stuck_to
var eligible_for_beam_formation : bool = false

var type : int


onready var bullet_sprite = $BulletSprite

var beam_formation_triggered : bool = false
var lifetime_after_beam_formation : float = 0.5
var _current_lifetime_after : float = 0

func _ready():
	_set_sprite_frames_to_use()


func _set_sprite_frames_to_use():
	var sf : SpriteFrames = SpriteFrames.new()
	if type == RED:
		sf.add_frame("default", RedMagnetPic)
	else:
		sf.add_frame("default", BlueMagnetPic)
	
	bullet_sprite.frames = sf


# Enemy hit and pos related

func hit_by_enemy(enemy):
	
	if !eligible_for_beam_formation:
		enemy_stuck_to = enemy
		eligible_for_beam_formation = true
		decrease_life_distance = false
		direction_as_relative_location = Vector2(0, 0)
		speed = 0
		
		call_deferred("emit_signal", "hit_an_enemy", self)


func decrease_pierce(amount):
	pass # Do nothing: prevent queue freeing from parent func


func _process(delta):
	if enemy_stuck_to != null:
		if previous_enemy_pos != null:
			var curr_enemy_pos = enemy_stuck_to.global_position
			var shift_pos : Vector2 = curr_enemy_pos - previous_enemy_pos
			
			position += shift_pos
			
		
		previous_enemy_pos = enemy_stuck_to.global_position
	
	
	if beam_formation_triggered:
		_current_lifetime_after += delta
		
		if _current_lifetime_after >= lifetime_after_beam_formation:
			queue_free()


# Beam formation

func used_in_beam_formation():
	beam_formation_triggered = true



#	var created_beam : BaseBeamWithAOE = beam_scene.instance()
#
#	created_beam.base_aoe = created_aoe
#	created_beam.time_visible = 0.5
#	created_beam.is_timebound = true
#	created_beam.queue_free_if_time_over = true
#
#	created_beam.set_sprite_frames(beam_sprite_frames)
#	created_beam.set_frame_rate_based_on_lifetime()
#

