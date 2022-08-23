extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")

signal show_extra_tower_info()


var tower : AbstractTower

onready var name_label : Label = $VBoxContainer/NameMarginer/Marginer/Name
onready var tower_pic : TextureRect = $VBoxContainer/PicMarginer/Marginer/TowerPic
onready var extra_info_button = $VBoxContainer/PicMarginer/TowerExtraInfoButton/TextureButton


func update_display():
	
	if tower != null:
		name_label.text = Towers.get_tower_info(tower.tower_id).tower_name
		tower_pic.texture = tower.tower_highlight_sprite
	else:
		name_label.text = ""
		tower_pic.texture = null



func _on_TextureButton_pressed():
	emit_signal("show_extra_tower_info")
