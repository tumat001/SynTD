extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const berry_bush_gold_per_round : int = 1

var _is_in_map_at_start_of_round : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BERRY_BUSH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	connect("on_round_end", self, "_bb_on_round_end", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_bb_on_round_start", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _bb_on_round_start():
	_is_in_map_at_start_of_round = is_current_placable_in_map()

func _bb_on_round_end():
	if is_current_placable_in_map() and _is_in_map_at_start_of_round:
		call_deferred("emit_signal", "tower_give_gold", berry_bush_gold_per_round, GoldManager.IncreaseGoldSource.TOWER_GOLD_INCOME)
