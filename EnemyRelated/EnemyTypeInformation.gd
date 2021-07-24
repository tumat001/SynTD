

# Random Info
var enemy_id : int
var faction

# For random generation -> soon
var value
var requirement_value


# Stats
var base_health : float = 5
var base_movement_speed : float = 0
var base_armor : float = 0
var base_toughness : float = 0
var base_resistance : float = 0


func _init(arg_id : int, arg_faction):
	enemy_id = arg_id
	faction = arg_faction
