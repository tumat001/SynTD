extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const DescriptionPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/ExtraInfoPanelComponents/DescriptionPanel/DescriptionPanel.gd")

const GameSettingsManager = preload("res://GameElementsRelated/GameSettingsManager.gd")

var tower : AbstractTower
var game_settings_manager : GameSettingsManager

onready var description_panel : DescriptionPanel = $VBoxContainer/Body/ContentMarginer/VBoxContainer/DescriptionPanel
onready var self_ing_panel = $VBoxContainer/Body/ContentMarginer/VBoxContainer/SelfIngredientPanel
onready var tower_colors_panel = $VBoxContainer/Body/ContentMarginer/VBoxContainer/TowerColorsPanel

onready var vbox = $VBoxContainer
onready var inner_vbox = $VBoxContainer/Body/ContentMarginer/VBoxContainer

func _ready():
	pass


func _update_display():
	
	inner_vbox.rect_min_size.y = 0
	vbox.rect_min_size.y = 0
	rect_min_size.y = 0
	
	inner_vbox.rect_size.y = 0
	vbox.rect_size.y = 0
	rect_size.y = 0
	
	description_panel.tower = tower
	description_panel.game_settings_manager = game_settings_manager
	description_panel.update_display()
	
	# Colors panel
	tower_colors_panel.tower = tower
	tower_colors_panel.update_display()
	
	self_ing_panel.tower = tower
	self_ing_panel.update_display()
	

