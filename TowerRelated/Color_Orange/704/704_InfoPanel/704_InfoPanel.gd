extends MarginContainer

const EmblemButton = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/EmblemButton.gd")
const _704 = preload("res://TowerRelated/Color_Orange/704/704.gd")

onready var emblem_fire_button : EmblemButton = $VBoxContainer/BodyMarginer/BodyContainer/EmblemButtonFire
onready var emblem_explosive_button : EmblemButton = $VBoxContainer/BodyMarginer/BodyContainer/EmblemButtonExplosive
onready var emblem_toughness_pierce_button : EmblemButton = $VBoxContainer/BodyMarginer/BodyContainer/EmblemButtonToughnessPierce
onready var available_points_label : Label = $VBoxContainer/BodyMarginer/BodyContainer/MarginContainer/PointsMarginer/PointsLabel


var tower_704 : _704 setget set_tower


# setters and connects (and updates)

func set_tower(tower : _704):
	pass


func _update_available_points():
	pass

func _update_fire_level():
	pass

func _update_explosive_level():
	pass

func _update_toughness_pierce_level():
	pass

# ready

func _ready():
	emblem_fire_button.emblem_type = EmblemButton.FIRE
	emblem_explosive_button.emblem_type = EmblemButton.EXPLOSIVE
	emblem_toughness_pierce_button.emblem_type = EmblemButton.TOUGHNESS_PIERCE
	
	emblem_fire_button.update_type()
	emblem_explosive_button.update_type()
	emblem_toughness_pierce_button.update_type()
	

