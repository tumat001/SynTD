extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const starting_round_count : int = 4
var current_round_count : int = starting_round_count
var fruit_cost : int

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.FRUIT_TREE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	
	fruit_cost = Towers.get_tower_info(Towers.FRUIT_TREE_FRUIT).tower_cost
	
	connect("on_round_end", self, "_ftree_on_round_end", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _ftree_on_round_end():
	if is_current_placable_in_map():
		current_round_count -= 1
		
		if current_round_count <= 0:
			_give_fruit()
			current_round_count = starting_round_count


func _give_fruit():
	if !tower_inventory_bench.is_bench_full():
		tower_inventory_bench.connect("before_tower_is_added", self, "_modify_fruit_before_adding", [], CONNECT_ONESHOT)
		tower_inventory_bench.insert_tower_from_last(Towers.FRUIT_TREE_FRUIT)
		
	else:
		emit_signal("tower_give_gold", fruit_cost, GoldManager.IncreaseGoldSource.TOWER_SELLBACK)


func _modify_fruit_before_adding(tower):
	var fruit_type_rng : int = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.FRUIT_TREE).randi_range(0, 5)
	
	tower.fruit_type = fruit_type_rng
