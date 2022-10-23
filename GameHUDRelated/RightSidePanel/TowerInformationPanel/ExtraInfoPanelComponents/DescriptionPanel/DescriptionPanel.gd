extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TooltipBody = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipBody.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const GameSettingsManager = preload("res://GameElementsRelated/GameSettingsManager.gd")


# In extra info

var tower : AbstractTower
var game_settings_manager : GameSettingsManager


onready var tooltip_body : TooltipBody = $VBoxContainer/BodyMarginer/TooltipBody

func _ready():
	pass
	#tooltip_body.default_font_color = Color(1, 1, 1, 1)


func update_display():
	if is_instance_valid(tower):
		#var tower_type_info =  Towers.get_tower_info(tower.tower_id)
		var tower_type_info = tower.tower_type_info
		
		tooltip_body.descriptions = GameSettingsManager.get_descriptions_to_use_based_on_tower_type_info(tower_type_info, game_settings_manager)
		tooltip_body.tower_for_text_fragment_interpreter = tower
	else:
		tooltip_body.descriptions = [""]
	
	tooltip_body.update_display()
	
