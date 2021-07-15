extends "res://TowerRelated/Modules/BulletAttackModule.gd"

const CoinProjectile_Scene = preload("res://TowerRelated/Color_Yellow/Coin/CoinProjectile.tscn")
const CoinProjectile = preload("res://TowerRelated/Color_Yellow/Coin/CoinProjectile.gd")


const kill_two_enemies_gold_amount = 1
const gold_coin_roll_gold_amount = 1

signal generated_gold(gold_amount)

var ratio_bronze_coin
var ratio_silver_coin
var ratio_gold_coin

var _coin_id_time_left_map : Dictionary = {}
var _coin_id_to_use : int


func _ready():
	bullet_scene = CoinProjectile_Scene
	_coin_id_to_use = 0
	
	connect("before_bullet_is_shot", self, "_before_bullet_is_shot_a", [], CONNECT_PERSIST)

func _process(delta):
	for coin_id in _coin_id_time_left_map.keys():
		_coin_id_time_left_map[coin_id] -= delta
		
		if _coin_id_time_left_map[coin_id] <= 0:
			_coin_id_time_left_map.erase(coin_id)


func _before_bullet_is_shot_a(bullet):
	bullet.connect("on_gold_coin_rng", self, "_generate_gold", [gold_coin_roll_gold_amount], CONNECT_ONESHOT)
	bullet.damage_register_id = _coin_id_to_use
	_coin_id_to_use += 1
	
	bullet.ratio_coin_bronze = ratio_bronze_coin
	bullet.ratio_coin_silver = ratio_silver_coin
	bullet.ratio_coin_gold = ratio_gold_coin


func _generate_gold(amount : int):
	call_deferred("emit_signal", "generated_gold", amount)



func on_post_mitigation_damage_dealt(damage_report, killed_enemy : bool, enemy, damage_register_id : int):
	if killed_enemy:
		if !_coin_id_time_left_map.has(damage_register_id):
			_coin_id_time_left_map[damage_register_id] = 8 # Seconds before this gets deleted
		else:
			_coin_id_time_left_map.erase(damage_register_id)
			_generate_gold(kill_two_enemies_gold_amount)
	
	emit_signal("on_post_mitigation_damage_dealt", damage_report, killed_enemy, enemy, damage_register_id, self)
	
