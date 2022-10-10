extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const MultiIngredientPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/MultiIngredientPanel.gd")


var tower : AbstractTower

onready var ingredient_self_panel : MultiIngredientPanel = $VBoxContainer/BodyMargin/MultiIngredientPanel


func update_display():
	ingredient_self_panel.ingredient_effect_limit = 100
	
	if is_instance_valid(tower) and tower.ingredient_of_self != null:
		ingredient_self_panel.ingredient_effects = [tower.ingredient_of_self]
	else:
		ingredient_self_panel.ingredient_effects = []
	
	ingredient_self_panel.update_display()
