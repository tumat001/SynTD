extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")

const Tier01_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier01.png")
const Tier02_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier02.png")
const Tier03_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier03.png")
const Tier04_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier04.png")
const Tier05_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier05.png")
const Tier06_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier06.png")

signal show_extra_tower_info()


var tower : AbstractTower

onready var name_label : Label = $VBoxContainer/NameMarginer/Marginer/Name
onready var tower_pic : TextureRect = $VBoxContainer/PicMarginer/Marginer/TowerPic
onready var extra_info_button = $VBoxContainer/PicMarginer/TowerExtraInfoButton/TextureButton

onready var tier_texture_rect = $VBoxContainer/PicMarginer/MarginContainer/VBoxContainer/TierIcon
onready var ing_icon_panel = $VBoxContainer/PicMarginer/MarginContainer/VBoxContainer/IngIcon


func update_display():
	if is_instance_valid(tower):
		#Towers.get_tower_info(tower.tower_id)
		
		var tower_type_info = tower.tower_type_info
		
		name_label.text = tower_type_info.tower_name
		tower_pic.texture = tower.tower_highlight_sprite
		if tower.ingredient_of_self != null:
			ing_icon_panel.tower_base_effect = tower.ingredient_of_self.tower_base_effect
		else:
			ing_icon_panel.tower_base_effect = null
		
		ing_icon_panel.update_display()
		tier_texture_rect.texture = _get_tier_icon_to_use(tower_type_info.tower_tier)
		
	else:
		name_label.text = ""
		tower_pic.texture = null
		ing_icon_panel.tower_base_effect = null
		ing_icon_panel.update_display()
		tier_texture_rect.texture = null

func _get_tier_icon_to_use(arg_tier : int):
	if arg_tier == 1:
		return Tier01_Icon
	elif arg_tier == 2:
		return Tier02_Icon
	elif arg_tier == 3:
		return Tier03_Icon
	elif arg_tier == 4:
		return Tier04_Icon
	elif arg_tier == 5:
		return Tier05_Icon
	elif arg_tier == 6:
		return Tier06_Icon
	else:
		return null


func _on_TextureButton_pressed():
	emit_signal("show_extra_tower_info")
