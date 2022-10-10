extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"

const BlueMagnetPic = preload("res://TowerRelated/Color_Yellow/Magnetizer/BlueMagnet.png")
const RedMagnetPic = preload("res://TowerRelated/Color_Yellow/Magnetizer/RedMagnet.png")

signal on_curr_distance_expired_after_setup()


enum {
	BLUE, # SOUTH
	RED, # NORTH btw
}

var offset_from_enemy : Vector2
var enemy_stuck_to
var eligible_for_beam_formation : bool = false

var type : int


#onready var bullet_sprite = $BulletSprite

var beam_formation_triggered : bool = false
var lifetime_after_beam_formation : float
var _current_lifetime_after : float = 0

var current_uses_left : int


func _ready():
	destroy_self_after_zero_life_distance = false
	connect("on_current_life_distance_expire", self, "_on_self_curr_distance_expired", [], CONNECT_ONESHOT)
	
	_set_sprite_frames_to_use()


func _set_sprite_frames_to_use():
	var sf : SpriteFrames = SpriteFrames.new()
	if type == RED:
		sf.add_frame("default", RedMagnetPic)
	else:
		sf.add_frame("default", BlueMagnetPic)
	
	bullet_sprite.frames = sf


func _on_self_curr_distance_expired():
	_set_self_up_for_no_movement()
	call_deferred("emit_signal", "on_curr_distance_expired_after_setup")

func _set_self_up_for_no_movement():
	eligible_for_beam_formation = true
	decrease_life_distance = false
	current_life_distance = 500
	direction_as_relative_location = Vector2(0, 0)
	speed = 0
	
	collision_layer = 0
	collision_mask = 0



# Enemy hit and pos related

func hit_by_enemy(enemy):
	
	if !eligible_for_beam_formation:
		offset_from_enemy = global_position - enemy.global_position
		
		enemy_stuck_to = enemy
		
		_set_self_up_for_no_movement()
		
		call_deferred("emit_signal", "hit_an_enemy", self)


func decrease_pierce(amount):
	pass # Do nothing: prevent queue freeing from parent func


func _process(delta):
	if is_instance_valid(enemy_stuck_to):
		var curr_enemy_pos = enemy_stuck_to.global_position
		global_position = curr_enemy_pos + offset_from_enemy
	
	
	if beam_formation_triggered:
		_current_lifetime_after += delta
		
		if _current_lifetime_after >= lifetime_after_beam_formation:
			_decrease_use_count_and_check()


# Beam formation

func used_in_beam_formation():
	current_uses_left -= 1 #new
	
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

#

func _decrease_use_count_and_check():
	#current_uses_left -= 1
	
	beam_formation_triggered = false
	_current_lifetime_after = 0
	
	if _if_ready_for_freeing_from_no_use_left():
		queue_free()

func _if_ready_for_freeing_from_no_use_left():
	return current_uses_left <= 0
