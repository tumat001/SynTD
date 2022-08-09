extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"


const bronze_coin_pic = preload("res://TowerRelated/Color_Yellow/Coin/Coin_Bronze.png")
const silver_coin_pic = preload("res://TowerRelated/Color_Yellow/Coin/Coin_Silver.png")
const gold_coin_pic = preload("res://TowerRelated/Color_Yellow/Coin/Coin_Gold.png")

signal on_gold_coin_rng


var ratio_coin_bronze : int
var ratio_coin_silver : int
var ratio_coin_gold : int


func _ready():
	var coin_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.COIN)
	
	var total_of_ratio : int = ratio_coin_bronze + ratio_coin_gold + ratio_coin_silver
	
	
	var upper_limit_bronze = ratio_coin_bronze
	var upper_limit_silver = upper_limit_bronze + ratio_coin_silver
	var upper_limit_gold = upper_limit_silver + ratio_coin_gold
	
	var chosen_num = coin_rng.randi_range(1, total_of_ratio)
	
	bullet_sprite.frames = SpriteFrames.new()
	if chosen_num <= upper_limit_bronze:
		bullet_sprite.frames.add_frame("default", bronze_coin_pic)
	elif chosen_num <= upper_limit_silver:
		bullet_sprite.frames.add_frame("default", silver_coin_pic)
	elif chosen_num <= upper_limit_gold:
		bullet_sprite.frames.add_frame("default", gold_coin_pic) 
		call_deferred("emit_signal", "on_gold_coin_rng")
	else:
		print("ayayayayyayya " + str(chosen_num) + " " + str(total_of_ratio))

func _process(delta):
	rotation_degrees += 60 * delta


func decrease_pierce(amount):
	direction_as_relative_location = direction_as_relative_location.rotated(deg2rad(270))
	current_life_distance = life_distance
	
	.decrease_pierce(amount)
