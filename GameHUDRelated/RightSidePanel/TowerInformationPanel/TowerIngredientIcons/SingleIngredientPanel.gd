extends MarginContainer

const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")
const TowerBaseEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd")


#const collapsed_label_lines_amount : int = 2
const collapsed_label_character_limit : int = 32

var ingredient_effect : IngredientEffect
var tower_base_effect : TowerBaseEffect

export(bool) var use_dynamic_description : bool = false
var collapsed : bool setget set_collapsed

onready var ingredient_label = $HBoxContainer/Marginer/IngredientLabel
onready var ingredient_icon = $HBoxContainer/IngredientIcon

#

func _ready():
	update_display()

func update_display():
	#if ingredient_effect != null:
	#	_update_panel(ingredient_effect.tower_base_effect)
	#	
	#elif tower_base_effect != null:
	#	_update_panel(tower_base_effect)
	
	set_collapsed(collapsed)


func _update_panel(arg_tower_base_effect):
	ingredient_icon.texture = arg_tower_base_effect.effect_icon
	
	var desc_to_use : String
	if use_dynamic_description:
		desc_to_use = arg_tower_base_effect._get_description()
	else:
		desc_to_use = arg_tower_base_effect.description
	
	if collapsed:
		if desc_to_use.length() > collapsed_label_character_limit:
			desc_to_use = desc_to_use.substr(0, collapsed_label_character_limit)
			desc_to_use += " ..."
	
	ingredient_label.text = desc_to_use


# collapse related

func set_collapsed(val : bool):
	collapsed = val
	
	if ingredient_effect != null:
		_update_panel(ingredient_effect.tower_base_effect)
		
	elif tower_base_effect != null:
		_update_panel(tower_base_effect)

#	if ingredient_label != null:
#		if collapsed:
#			ingredient_label.max_lines_visible = collapsed_label_lines_amount
#		else:
#			ingredient_label.max_lines_visible = -1
#
#		ingredient_label.rect_min_size.y = 0
#		ingredient_label.rect_size.y = 0



func _on_SingleIngredientPanel_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			set_collapsed(!collapsed)




