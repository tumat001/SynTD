extends MarginContainer

const Border_Tier01 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier01.png")
const Border_Tier02 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier02.png")
const Border_Tier03 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier03.png")
const Border_Tier04 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier04.png")
const Border_Tier05 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier05.png")
const Border_Tier06 = preload("res://GameHUDRelated/TowerIconPanel/BorderAssets/Border_Tier06.png")

#var tower setget set_tower
var tower_type_info setget set_tower_type_info


onready var tower_icon = $TowerIcon
onready var tower_border = $TowerBorder


#func set_tower(arg_tower):
#	tower = arg_tower
#	
#	_update_display()

func set_tower_type_info(arg_type_info):
	tower_type_info = arg_type_info
	
	_update_display()


func _ready():
	_update_display()


#

func _update_display():
	if is_inside_tree():
		if tower_type_info != null:
			var tower_tier = tower_type_info.tower_tier
			
			tower_border.texture = _get_border_to_use(tower_tier)
			tower_icon.texture = tower_type_info.tower_atlased_image
		


func _get_border_to_use(tower_tier : int) -> Texture:
	if tower_tier == 1:
		return Border_Tier01
	elif tower_tier == 2:
		return Border_Tier02
	elif tower_tier == 3:
		return Border_Tier03
	elif tower_tier == 4:
		return Border_Tier04
	elif tower_tier == 5:
		return Border_Tier05
	elif tower_tier == 6:
		return Border_Tier06
	
	return null


