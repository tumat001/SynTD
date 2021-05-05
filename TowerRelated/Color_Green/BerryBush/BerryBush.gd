extends "res://TowerRelated/AbstractTower.gd"

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BERRY_BUSH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	
	_post_inherit_ready()