extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"


signal on_returning()

var original_max_pierce : int
var original_speed : float
var original_life_dist : float
var is_returning

func _ready():
	original_max_pierce = pierce
	original_speed = speed
	original_life_dist = life_distance
	
	destroy_self_after_zero_life_distance = false
	is_returning = false
	
	connect("on_current_life_distance_expire", self, "_on_zero_life_distance", [], CONNECT_ONESHOT)


func reduce_damage_by_beyond_first_multiplier():
	if _first_hit:
		speed = original_speed / 4
	
	.reduce_damage_by_beyond_first_multiplier()


func _on_zero_life_distance():
	if !is_returning:
		is_returning = true
		emit_signal("on_returning")
		speed = original_speed
		pierce = original_max_pierce
		current_life_distance = original_life_dist
		
		direction_as_relative_location *= -1
		
		call_deferred("_set_destory_self_on")

func _set_destory_self_on():
	destroy_self_after_zero_life_distance = true
