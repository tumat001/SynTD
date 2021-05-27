extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"

const BlueMagnetPic = preload("res://TowerRelated/Color_Yellow/Magnetizer/BlueMagnet.png")
const RedMagnetPic = preload("res://TowerRelated/Color_Yellow/Magnetizer/RedMagnet.png")

enum {
	BLUE, # SOUTH
	RED, # NORTH btw
}

var offset_from_enemy : Vector2
var enemy_stuck_to
var eligible_for_beam_formation : bool = false

var type : int


onready var bullet_sprite = $BulletSprite

var beam_formation_triggered : bool = false
var lifetime_after_beam_formation : float
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
		offset_from_enemy = global_position - enemy.global_position
		
		enemy_stuck_to = enemy
		eligible_for_beam_formation = true
		decrease_life_distance = false
		current_life_distance = 500
		direction_as_relative_location = Vector2(0, 0)
		speed = 0
		
		collision_layer = 0
		collision_mask = 0
		
		call_deferred("emit_signal", "hit_an_enemy", self)


func decrease_pierce(amount):
	pass # Do nothing: prevent queue freeing from parent func


func _process(delta):
	if enemy_stuck_to != null:
		
		var curr_enemy_pos = enemy_stuck_to.global_position
		
		global_position = curr_enemy_pos + offset_from_enemy
	
	
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

