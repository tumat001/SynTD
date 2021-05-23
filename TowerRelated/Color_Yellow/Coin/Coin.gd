extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const CoinAttackModule = preload("res://TowerRelated/Color_Yellow/Coin/CoinAttackModule.gd")
const CoinAttackModule_Scene = preload("res://TowerRelated/Color_Yellow/Coin/CoinAttackModule.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.COIN)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : CoinAttackModule = CoinAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_name = "coin_base_damage"
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 300
	attack_module.projectile_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_modules_and_target_num[attack_module] = 1
	
	attack_module.connect("generated_gold", self, "_gold_generated")
	attack_module.ratio_bronze_coin = 27
	attack_module.ratio_silver_coin = 22
	attack_module.ratio_gold_coin = 1
	
	_post_inherit_ready()


func _gold_generated(amount):
	call_deferred("emit_signal", "tower_give_gold", amount, GoldManager.IncreaseGoldSource.TOWER_GOLD_INCOME)
