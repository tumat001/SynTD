extends MarginContainer

const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTooltip = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.gd")
const TowerTooltipScene = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.tscn")

const tier01_crown = preload("res://GameHUDRelated/BuySellPanel/Tier01_Crown.png")
const tier02_crown = preload("res://GameHUDRelated/BuySellPanel/Tier02_Crown.png")
const tier03_crown = preload("res://GameHUDRelated/BuySellPanel/Tier03_Crown.png")
const tier04_crown = preload("res://GameHUDRelated/BuySellPanel/Tier04_Crown.png")
const tier05_crown = preload("res://GameHUDRelated/BuySellPanel/Tier05_Crown.png")
const tier06_crown = preload("res://GameHUDRelated/BuySellPanel/Tier06_Crown.png")

signal tower_bought(tower_type_id, tower_cost)

const can_afford_modulate : Color = Color(1, 1, 1, 1)
const cannot_afford_modulate : Color = Color(0.4, 0.4, 0.4, 1)

var tower_information : TowerTypeInformation
var disabled : bool = false
var current_tooltip : TowerTooltip

var current_gold : int

onready var ingredient_icon_rect = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/IngredientInfo/HBoxContainer/IngredientIcon
onready var tower_name_label = $MarginContainer/VBoxContainer/MarginerLower/Lower/TowerNameLabel
onready var tower_cost_label = $MarginContainer/VBoxContainer/MarginerLower/Lower/TowerCostLabel

onready var color_icon_01 = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Color01Icon
onready var color_label_01 = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Marginer/Color01Label
onready var color_icon_02 = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Color02Icon
onready var color_label_02 = $MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Marginer/Color02Label

onready var tower_image_rect = $MarginContainer/VBoxContainer/MarginerUpper/Upper/Marginer/TowerImage
onready var tier_crown_rect = $MarginContainer/VBoxContainer/TierCrownPanel/TierCrown


func _ready():
	update_display()

func update_display():
	tower_name_label.text = tower_information.tower_name
	tower_cost_label.text = str(tower_information.tower_cost)
	
	# Color related
	var color01
	var color02
	
	if tower_information.colors.size() > 0:
		color01 = tower_information.colors[0]
	if tower_information.colors.size() > 1:
		color02 = tower_information.colors[1]
	
	if color01 != null:
		color_icon_01.texture = TowerColors.get_color_symbol_on_card(color01)
		color_label_01.text = TowerColors.get_color_name_on_card(color01)
	else:
		color_icon_01.self_modulate.a = 0
		color_label_01.self_modulate.a = 0
	
	if color02 != null:
		color_icon_02.texture = TowerColors.get_color_symbol_on_card(color02)
		color_label_02.text = TowerColors.get_color_name_on_card(color02)
	else:
		color_icon_02.self_modulate.a = 0
		color_label_02.self_modulate.a = 0
	
	# Ingredient Related
	if tower_information.ingredient_effect != null:
		ingredient_icon_rect.texture = tower_information.ingredient_effect.tower_base_effect.effect_icon
	else:
		ingredient_icon_rect.self_modulate.a = 0
	
	# TowerImageRelated
	if tower_information.tower_image_in_buy_card != null:
		tower_image_rect.texture = tower_information.tower_image_in_buy_card
		tower_image_rect.visible = true
	else:
		tower_image_rect.visible = false
	
	# Tier Crown Related
	if tower_information.tower_tier == 1:
		tier_crown_rect.texture = tier01_crown
	elif tower_information.tower_tier == 2:
		tier_crown_rect.texture = tier02_crown
	elif tower_information.tower_tier == 3:
		tier_crown_rect.texture = tier03_crown
	elif tower_information.tower_tier == 4:
		tier_crown_rect.texture = tier04_crown
	elif tower_information.tower_tier == 5:
		tier_crown_rect.texture = tier05_crown
	elif tower_information.tower_tier == 6:
		tier_crown_rect.texture = tier06_crown
	
	# Gold related
	_update_display_based_on_gold(current_gold)


func create_energy_display(energy_array : Array) -> String:
	return PoolStringArray(energy_array).join(" / ")


func _on_BuyCard_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				 _on_BuyCard_pressed()
			BUTTON_RIGHT:
				if current_tooltip == null:
					_free_old_and_create_tooltip_for_tower()
				else:
					current_tooltip.queue_free()

func _on_BuyCard_pressed():
	if !disabled and _can_afford():
		disabled = true
		emit_signal("tower_bought", tower_information)
		
		if current_tooltip != null:
			current_tooltip.queue_free()
		
		queue_free()
	

func _free_old_and_create_tooltip_for_tower():
	if current_tooltip != null:
		current_tooltip.queue_free()
	
	if !disabled:
		current_tooltip = TowerTooltipScene.instance()
		current_tooltip.tower_info = tower_information
		
		get_tree().get_root().add_child(current_tooltip)

func _on_BuyCard_mouse_exited():
	kill_current_tooltip()

func kill_current_tooltip():
	if current_tooltip != null:
		current_tooltip.queue_free()


# Gold related

func _update_display_based_on_gold(arg_current_gold):
	current_gold = arg_current_gold
	
	if _can_afford():
		modulate = can_afford_modulate
	else:
		modulate = cannot_afford_modulate

func _can_afford() -> bool:
	return current_gold >= tower_information.tower_cost
