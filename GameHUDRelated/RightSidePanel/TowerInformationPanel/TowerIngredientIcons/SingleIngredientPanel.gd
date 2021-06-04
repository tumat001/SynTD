extends MarginContainer

const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")
const TowerBaseEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd")


var ingredient_effect : IngredientEffect
var tower_base_effect : TowerBaseEffect

func _ready():
	update_display()

func update_display():
	if ingredient_effect != null:
		_update_panel(ingredient_effect.tower_base_effect)
		
	elif tower_base_effect != null:
		_update_panel(tower_base_effect)

func _update_panel(arg_tower_base_effect):
	$HBoxContainer/IngredientIcon.texture = arg_tower_base_effect.effect_icon
	$HBoxContainer/Marginer/IngredientLabel.text = arg_tower_base_effect.description
