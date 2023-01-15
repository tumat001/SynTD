extends MarginContainer

const HealthManager = preload("res://GameElementsRelated/HealthManager.gd")
const HealthBar_Fill_Green = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/PlayerHealthPanel/Assets/PlayerHealthBar_BarFill_Green.png")
const HealthBar_Fill_Yellow = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/PlayerHealthPanel/Assets/PlayerHealthBar_BarFill_Yellow.png")
const HealthBar_Fill_Red = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel_V2/PlayerHealthPanel/Assets/PlayerHealthBar_BarFill_Red.png")


const health_ratio_to_pic_map : Dictionary = {
	0.66 : HealthBar_Fill_Green,
	0.33 : HealthBar_Fill_Yellow,
	0 : HealthBar_Fill_Red
}

var health_manager : HealthManager setget set_health_manager

onready var health_bar = $HealthBar
onready var health_label = $LabelAndImgContainer/HBoxContainer/MarginContainer/HealthLabel

onready var heart_icon = $LabelAndImgContainer/HBoxContainer/HeartIcon

#

func set_health_manager(arg_manager):
	health_manager = arg_manager
	
	health_manager.connect("current_health_changed", self, "_current_player_health_changed", [], CONNECT_PERSIST)
	health_manager.connect("starting_health_changed", self, "_starting_player_health_changed", [], CONNECT_PERSIST)
	
	#_starting_player_health_changed(health_manager.starting_health)
	#_current_player_health_changed(health_manager.current_health)

#

func _starting_player_health_changed(arg_val):
	health_bar.max_value = health_manager.starting_health

func _current_player_health_changed(arg_val):
	var curr_health = health_manager.current_health
	var starting_health = health_manager.starting_health
	
	health_bar.current_value = curr_health
	health_label.text = str(curr_health)
	
	for ratio in health_ratio_to_pic_map.keys():
		if curr_health / starting_health > ratio:
			health_bar.fill_foreground_pic = health_ratio_to_pic_map[ratio]
			break

#

func get_heart_icon_global_pos():
	return heart_icon.rect_global_position + (heart_icon.rect_size / 2)


