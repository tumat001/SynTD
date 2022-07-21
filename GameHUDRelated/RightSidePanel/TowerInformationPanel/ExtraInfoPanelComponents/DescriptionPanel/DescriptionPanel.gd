extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TooltipBody = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipBody.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")

# In extra info

var tower : AbstractTower

onready var tooltip_body : TooltipBody = $VBoxContainer/BodyMarginer/TooltipBody

func _ready():
	tooltip_body.default_font_color = Color(1, 1, 1, 1)


func update_display():
	
	if tower != null:
		tooltip_body.descriptions = Towers.get_tower_info(tower.tower_id).tower_descriptions
		tooltip_body.tower_for_text_fragment_interpreter = tower
	else:
		tooltip_body.descriptions = [""]
	
	tooltip_body.update_display()
	
