extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const DescriptionPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/ExtraInfoPanelComponents/DescriptionPanel/DescriptionPanel.gd")

var tower : AbstractTower

onready var description_panel : DescriptionPanel = $VBoxContainer/Body/ContentMarginer/VBoxContainer/DescriptionPanel
onready var self_ing_panel = $VBoxContainer/Body/ContentMarginer/VBoxContainer/SelfIngredientPanel

func _ready():
	pass


func _update_display():
	
	description_panel.tower = tower
	description_panel.update_display()
	
	self_ing_panel.tower = tower
	self_ing_panel.update_display()
	

