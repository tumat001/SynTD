const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")

var tower_name : String
var tower_type_id : int
var tower_cost : int
var tower_tier : int
var energy_consumption_levels : Array = []
var energy_consumption_level_buffs : Array = []
var colors : Array = []
var ingredient_effect : IngredientEffect
var ingredient_effect_simple_description : String = ""
var tower_image_in_buy_card
var tower_descriptions : Array = []

var base_damage : float
var base_damage_type : int
var base_attk_speed : float
var base_range : float
var base_pierce : float
var on_hit_multiplier : float = 1

func _init(arg_tower_name : String, arg_tower_type_id : int):
	tower_name = arg_tower_name
	tower_type_id = arg_tower_type_id
	tower_cost = 0
