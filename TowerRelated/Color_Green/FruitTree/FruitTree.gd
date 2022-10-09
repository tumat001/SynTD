extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const base_round_count : int = 3
var current_round_count : int = base_round_count
var fruit_cost : int

var _is_in_map_at_start_of_round : bool

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.FRUIT_TREE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	fruit_cost = Towers.get_tower_info(Towers.FRUIT_TREE_FRUIT).tower_cost
	
	connect("on_round_end", self, "_ftree_on_round_end", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_ftree_on_round_start", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _ftree_on_round_start():
	_is_in_map_at_start_of_round = is_current_placable_in_map()

func _ftree_on_round_end():
	if is_current_placable_in_map() and _is_in_map_at_start_of_round:
		current_round_count -= 1
		
		if current_round_count <= 0:
			_give_fruit()
			current_round_count = base_round_count


func _give_fruit():
	if !tower_inventory_bench.is_bench_full():
		tower_inventory_bench.connect("before_tower_is_added", self, "_modify_fruit_before_adding", [], CONNECT_ONESHOT)
		tower_inventory_bench.insert_tower_from_last(Towers.FRUIT_TREE_FRUIT)
		
	else:
		emit_signal("tower_give_gold", fruit_cost, GoldManager.IncreaseGoldSource.TOWER_SELLBACK)
		game_elements.display_gold_particles(global_position, fruit_cost)

func _modify_fruit_before_adding(tower):
	var fruit_type_rng : int = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.FRUIT_TREE).randi_range(0, 5)
	
	tower.fruit_type = fruit_type_rng
