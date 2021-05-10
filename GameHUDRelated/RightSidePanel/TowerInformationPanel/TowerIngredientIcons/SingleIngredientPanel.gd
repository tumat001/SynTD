extends MarginContainer

const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")
const TowerBaseEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd")


var ingredient_effect : IngredientEffect

func _ready():
	update_display()

func update_display():
	var tower_base_effect = ingredient_effect.tower_base_effect
	
	$HBoxContainer/IngredientIcon.texture = tower_base_effect.effect_icon
	$HBoxContainer/Marginer/IngredientLabel.text = tower_base_effect.description
