extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


var center_pos_of_basis : Vector2

export(float) var initial_speed_towards_center : float
export(float) var speed_accel_towards_center : float
var current_speed_towards_center : float

export(float) var min_starting_distance_from_center : float
export(float) var max_starting_distance_from_center : float

var non_essential_rng : RandomNumberGenerator



func _ready():
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	reset_for_another_use()


func reset_for_another_use():
	current_speed_towards_center = initial_speed_towards_center
	
	randomize_position_based_on_properties()

func randomize_position_based_on_properties():
	var starting_distance : float = non_essential_rng.randi_range(min_starting_distance_from_center, max_starting_distance_from_center)
	var angle = non_essential_rng.randi_range(0, 360)
	
	var rand_vector := Vector2(starting_distance, 0).rotated(deg2rad(angle))
	
	global_position = center_pos_of_basis + rand_vector



#

func _process(delta):
	global_position = global_position.move_toward(center_pos_of_basis, delta * current_speed_towards_center)
	
	current_speed_towards_center += speed_accel_towards_center * delta
	
