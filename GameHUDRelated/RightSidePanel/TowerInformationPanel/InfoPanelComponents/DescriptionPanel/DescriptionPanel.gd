extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TooltipBody = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipBody.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")

var tower : AbstractTower

onready var tooltip_body = $VBoxContainer/BodyMarginer/Marginer/ScrollContainer/TooltipBody

func _ready():
	tooltip_body.default_font_color = Color(1, 1, 1, 1)

func update_display():
	
	if tower != null:
		tooltip_body.descriptions = Towers.get_tower_info(tower.tower_id).tower_descriptions
	else:
		tooltip_body.descriptions = [""]
	
	tooltip_body.update_display()
