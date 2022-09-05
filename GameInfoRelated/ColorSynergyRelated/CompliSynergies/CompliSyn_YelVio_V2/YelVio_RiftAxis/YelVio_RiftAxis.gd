extends "res://TowerRelated/AbstractTower.gd"



const yellow_rift_modulate := Color(233/255.0, 1, 0, 0.6)
const violet_rift_modulate := Color(111/255.0, 2/255.0, 222/255.0)


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.YELVIO_RIFT_AXIS)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = 0
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	
	tower_limit_slots_taken = 0
	is_a_summoned_tower = true
	
	_post_inherit_ready()


#



