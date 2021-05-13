extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")

var tower : AbstractTower

onready var name_label : Label = $VBoxContainer/NameMarginer/Marginer/Name
onready var tower_pic : TextureRect = $VBoxContainer/PicMarginer/Marginer/TowerPic

func update_display():
	
	if tower != null:
		name_label.text = Towers.get_tower_info(tower.tower_id).tower_name
		tower_pic.texture = tower.tower_highlight_sprite
	else:
		name_label.text = ""
		tower_pic.texture = null

