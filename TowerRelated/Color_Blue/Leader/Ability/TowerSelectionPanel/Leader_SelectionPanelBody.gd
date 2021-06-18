extends MarginContainer

const Leader = preload("res://TowerRelated/Color_Blue/Leader/Leader.gd")


onready var add_tower_ability_button = $InnerMarginer/HBoxContainer/TowerAddButton
onready var remove_tower_ability_button = $InnerMarginer/HBoxContainer/TowerRemoveButton

var tower_leader : Leader setget set_tower_leader


func set_tower_leader(arg_leader : Leader):
	if tower_leader != null:
		add_tower_ability_button.ability = null
		remove_tower_ability_button.ability = null
	
	tower_leader = arg_leader
	
	if tower_leader != null:
		add_tower_ability_button.ability = tower_leader.add_tower_as_member_ability
		remove_tower_ability_button.ability = tower_leader.remove_tower_as_member_ability

