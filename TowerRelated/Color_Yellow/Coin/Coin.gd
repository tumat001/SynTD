extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const CoinAttackModule = preload("res://TowerRelated/Color_Yellow/Coin/CoinAttackModule.gd")
const CoinAttackModule_Scene = preload("res://TowerRelated/Color_Yellow/Coin/CoinAttackModule.tscn")


const original_ratio_bronze_coin : int = 27
const original_ratio_silver_coin : int = 22
const original_ratio_gold_coin : int = 1

var coin_attack_module : CoinAttackModule
var info : TowerTypeInformation


# Called when the node enters the scene tree for the first time.
func _ready():
	info = Towers.get_tower_info(Towers.COIN)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var attack_module_y_shift : float = 4.0
	
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attack_module_y_shift
	
	var attack_module : CoinAttackModule = CoinAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 300
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attack_module_y_shift
	
	coin_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	attack_module.connect("generated_gold", self, "_gold_generated")
	attack_module.ratio_bronze_coin = original_ratio_bronze_coin
	attack_module.ratio_silver_coin = original_ratio_silver_coin
	attack_module.ratio_gold_coin = original_ratio_gold_coin
	
	_post_inherit_ready()


func _gold_generated(amount):
	call_deferred("emit_signal", "tower_give_gold", amount, GoldManager.IncreaseGoldSource.TOWER_GOLD_INCOME)
	game_elements.display_gold_particles(global_position, amount)

# energy module

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Coin's base pierce is increased to 777. Coin's base damage is also increased to 3.",
			"The chance of shooting a gold coin is increased to 1/15."
		]


func _module_turned_on(_first_time_per_round : bool):
	coin_attack_module.base_pierce = 777
	coin_attack_module.ratio_bronze_coin = 7
	coin_attack_module.ratio_silver_coin = 7
	coin_attack_module.ratio_gold_coin = 1
	coin_attack_module.base_damage = 3
	
	coin_attack_module.calculate_final_base_damage()
	coin_attack_module.calculate_final_pierce()


func _module_turned_off():
	coin_attack_module.base_pierce = info.base_pierce
	coin_attack_module.ratio_bronze_coin = original_ratio_bronze_coin
	coin_attack_module.ratio_silver_coin = original_ratio_silver_coin
	coin_attack_module.ratio_gold_coin = original_ratio_gold_coin
	coin_attack_module.base_damage = info.base_damage
	
	coin_attack_module.calculate_final_base_damage()
	coin_attack_module.calculate_final_pierce()
