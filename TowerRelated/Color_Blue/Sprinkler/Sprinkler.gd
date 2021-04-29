extends "res://TowerRelated/AbstractTower.gd"

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SPRINKLER)
	
	tower_id = Towers.SPRINKLER
	base_damage = info.base_damage
	base_damage_type = info.base_damage_type
	base_attack_speed = info.base_attk_speed
	base_range_radius = info.base_range
	base_pierce = info.base_pierce
	base_proj_speed = 350
	base_on_hit_damage_internal_name = "sprinkler_base_damage"
	
	$TowerBase.z_index = 1
	
	tower_highlight_sprite = info.tower_image_in_buy_card
	
	_post_inherit_ready()

