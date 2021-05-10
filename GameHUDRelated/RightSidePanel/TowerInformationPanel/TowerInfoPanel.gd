extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")


var tower : AbstractTower

func _ready():
	pass

func update_display():
	
	# Active Ingredients display related
	
	$VBoxContainer/ActiveIngredientsPanel.tower = tower
	$VBoxContainer/ActiveIngredientsPanel.update_display()
