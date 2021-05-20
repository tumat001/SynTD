extends MarginContainer

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")


const color_over_limit = Color("#ffe21A00")
const color_normal = Color(1, 1, 1, 1)

var tower : AbstractTower

onready var count_label = $VBoxContainer/HeaderWholeMarginer/TowerCountMarginer/Marginer/CountLabel
onready var multi_ingredient_panel = $VBoxContainer/MultiIngredientPanel


func _ready():
	update_display()


func update_display():
	
	update_limit_count_label_only()
	
	var ing_effects : Array = []
	var ing_limit : int = 2
	
	if tower != null:
		ing_effects = tower.ingredients_absorbed.values()
		ing_limit = tower.ingredient_active_limit
		
		if tower.ingredients_absorbed.size() > ing_limit:
			count_label.set("custom_colors/font_color", color_over_limit)
		else:
			count_label.set("custom_colors/font_color", color_normal)
	else:
		count_label.set("custom_colors/font_color", color_normal)
	
	multi_ingredient_panel.ingredient_effect_limit = ing_limit
	multi_ingredient_panel.ingredient_effects = ing_effects
	
	multi_ingredient_panel.update_display()
	


func update_limit_count_label_only():
	var count_display : String = ""
	
	if tower != null:
		count_display = str(tower.ingredients_absorbed.size()) + "/" + str(tower.ingredient_active_limit)
	
	count_label.text = count_display