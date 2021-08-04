extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const berry_bush_gold_per_round : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BERRY_BUSH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	
	connect("on_round_end", self, "_bb_on_round_end", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _bb_on_round_end():
	if is_current_placable_in_map():
		call_deferred("emit_signal", "tower_give_gold", berry_bush_gold_per_round, GoldManager.IncreaseGoldSource.TOWER_GOLD_INCOME)
