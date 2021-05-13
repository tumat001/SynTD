extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")


var tower : AbstractTower

onready var active_ing_panel = $VBoxContainer/ActiveIngredientsPanel
onready var tower_name_and_pic_panel = $VBoxContainer/TowerNameAndPicPanel
onready var targeting_panel = $VBoxContainer/TargetingPanel
onready var description_panel = $VBoxContainer/DescriptionPanel

onready var tower_colors_panel = $VBoxContainer/TowerColorsPanel
onready var tower_stats_panel = $VBoxContainer/TowerStatsPanel
onready var ingredient_of_self_panel = $VBoxContainer/IngredientOfSelfPanel


func _ready():
	pass

func update_display():
	
	# Tower name and pic display related
	tower_name_and_pic_panel.tower = tower
	tower_name_and_pic_panel.update_display()
	
	# Targeting panel related
	targeting_panel.tower = tower
	targeting_panel.update_display()
	
	# Description panel
	description_panel.tower = tower
	description_panel.update_display()
	
	# Self Ingredient panel
	ingredient_of_self_panel.tower = tower
	ingredient_of_self_panel.update_display()
	
	
	# Colors panel
	tower_colors_panel.tower = tower
	tower_colors_panel.update_display()
	
	# Stats panel
	tower_stats_panel.tower = tower
	tower_stats_panel.update_display()
	
	# Active Ingredients display related
	active_ing_panel.tower = tower
	active_ing_panel.update_display()
