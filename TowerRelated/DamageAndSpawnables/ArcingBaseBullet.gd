extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"


signal on_final_location_reached(arg_final_location, me)

var original_location : Vector2
var final_location : Vector2
var max_height : float
# speed = the time it takes to reach final_location
# current_life_distance = current timeline of speed 
# 						  from 0 to speed

var collide_with_any : bool



var _midpoint : float
var _x_speed : float
var _y_speed : float

onready var coll_shape_2d = $CollisionShape2D

func _ready():
	original_location = global_position
	decrease_life_distance = false
	_x_speed = _calculate_constant_x_speed()
	_y_speed = _calculate_constant_y_speed()
	current_life_distance = speed
	_midpoint = speed / 2
	
	_set_collide_with_any(collide_with_any)


# setters

func _set_collide_with_any(value : bool):
	collide_with_any = value
	
	if coll_shape_2d != null:
		coll_shape_2d.set_deferred("disabled", collide_with_any)


# movement

func _calculate_constant_x_speed() -> float:
	var diff = final_location.x - original_location.x
	return diff / speed

func _calculate_constant_y_speed() -> float:
	var diff = final_location.y - original_location.y
	return diff / speed

func _calculate_current_y_speed(delta) -> float:
	return delta * ((max_height) * ((current_life_distance - _midpoint) / speed))

func _calculate_scale():
	# 0.5 -> 0 -> 0.5
	var timebased_shrink = (0.25 + ((abs(current_life_distance - _midpoint) / speed) / 2))
	# 1 -> 0.5 -> 1
	var diff = 0.5 + timebased_shrink
	# 0 -> 0.1 -> 0
	var n = (diff - 1) / -5
	
	# 
	var heightbased_shrink = (1 - ((max_height / 1200) * n))
	
	return (heightbased_shrink * diff)


func _move(delta):
	current_life_distance -= delta
	
	if current_life_distance <= 0:
		emit_signal("on_final_location_reached", final_location, self)
		.trigger_on_death_events()
	else:
		var movement : Vector2 = Vector2(0, 0)
		var final_y_mov = _y_speed * delta
		final_y_mov -= _calculate_current_y_speed(delta)
		
		movement.y = final_y_mov
		movement.x = _x_speed * delta
		
		var sc = _calculate_scale()
		scale = Vector2(sc, sc)
		
		move_and_collide(movement)
	

