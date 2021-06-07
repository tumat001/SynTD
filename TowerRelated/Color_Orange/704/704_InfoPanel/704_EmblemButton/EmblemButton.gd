extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButton.gd"

signal emblem_button_left_pressed()
signal emblem_button_right_pressed()

enum {
	FIRE,
	EXPLOSIVE,
	TOUGHNESS_PIERCE,
}

onready var level_background : TextureRect = $LevelBackground
onready var emblem_icon : TextureRect = $MarginContainer/EmblemIcon

var emblem_level : int
var emblem_type : int


func _on_EmblemButton_pressed_mouse_event(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			emit_signal("emblem_button_left_pressed")
		elif event.button_index == BUTTON_RIGHT:
			emit_signal("emblem_button_right_pressed")


func update_level():
	if emblem_level == 0:
		level_background.texture = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/704_ButtonBackground_Lvl0.png")
	elif emblem_level == 1:
		level_background.texture = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/704_ButtonBackground_Lvl1.png")
	elif emblem_level == 2:
		level_background.texture = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/704_ButtonBackground_Lvl2.png")
	elif emblem_level == 3:
		level_background.texture = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/704_ButtonBackground_Lvl3.png")
	elif emblem_level == 4:
		level_background.texture = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/704_ButtonBackground_Lvl4.png")
	

func update_type():
	if emblem_type == FIRE:
		emblem_icon.texture = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/704_FireIcon.png")
	elif emblem_type == EXPLOSIVE:
		emblem_icon.texture = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/704_ExplosionIcon.png")
	elif emblem_type == TOUGHNESS_PIERCE:
		emblem_icon.texture = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/704_ToughnessPierce.png")
