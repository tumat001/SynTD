extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")


var tower : AbstractTower

func _ready():
	update_display()


func update_display():
	
	var ing_effects : Array = []
	var count_display : String = ""
	var ing_limit : int = 2
	
	if tower != null:
		ing_effects = tower.ingredients_absorbed.values()
		count_display = str(tower.ingredient_active_limit - tower.ingredients_absorbed.size())
		ing_limit = tower.ingredient_active_limit
	
	$VBoxContainer/MultiIngredientPanel.ingredient_effect_limit = ing_limit
	$VBoxContainer/MultiIngredientPanel.ingredient_effects = ing_effects
	$VBoxContainer/HeaderWholeMarginer/TowerCountMarginer/Marginer/CountLabel.text = count_display
	
	$VBoxContainer/MultiIngredientPanel.update_display()
