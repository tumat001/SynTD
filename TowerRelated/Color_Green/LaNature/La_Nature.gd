extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const LaNature_SharedPassive = preload("res://TowerRelated/Color_Green/LaNature/SharedPassive/LaNature_SharedPassive.gd")

# ADD Quality of life auto cast that alternates between
# the two abilities every x (3) casts.
# Add this as a tower specific info panel

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.LA_NATURE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	#
	
	if !_if_shared_passive_is_active():
		var la_nature_shared_passive = LaNature_SharedPassive.new()
		
		game_elements.shared_passive_manager.attempt_apply_shared_passive(la_nature_shared_passive)
	
	#
	
	_post_inherit_ready()


func _if_shared_passive_is_active():
	return game_elements.shared_passive_manager.if_shared_passive_id_exists(StoreOfSharedPassiveUuid.LA_NATURE_ABILITIES)

