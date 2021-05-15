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

var tower_information : TowerTypeInformation
var disabled : bool = false
var current_tooltip : TowerTooltip

var current_gold : int


signal tower_bought(tower_type_id, tower_cost)

func _ready():
	update_display()

func update_display():
	$MarginContainer/VBoxContainer/MarginerLower/Lower/TowerNameLabel.text = tower_information.tower_name
	$MarginContainer/VBoxContainer/MarginerLower/Lower/TowerCostLabel.text = str(tower_information.tower_cost)
	
	# Color related
	var color01
	var color02
	
	if tower_information.colors.size() > 0:
		color01 = tower_information.colors[0]
	if tower_information.colors.size() > 1:
		color02 = tower_information.colors[1]
	
	if color01 != null:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Color01Icon.texture = TowerColors.get_color_symbol_on_card(color01)
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Marginer/Color01Label.text = TowerColors.get_color_name_on_card(color01)
	else:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Color01Icon.self_modulate.a = 0
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Marginer/Color01Label.self_modulate.a = 0
	
	if color02 != null:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Color02Icon.texture = TowerColors.get_color_symbol_on_card(color02)
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Marginer/Color02Label.text = TowerColors.get_color_name_on_card(color02)
	else:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Color02Icon.self_modulate.a = 0
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Marginer/Color02Label.self_modulate.a = 0
	
	# Energy Related
	if tower_information.energy_consumption_levels.size() > 0:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/EnergyInfo/HBoxContainer/Marginer/EnergyLabel.text = create_energy_display(tower_information.energy_consumption_levels)
	else:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/EnergyInfo/HBoxContainer/Marginer/EnergyLabel.self_modulate.a = 0
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/EnergyInfo/HBoxContainer/EnergyIcon.self_modulate.a = 0
	
	# Ingredient Related
	if tower_information.ingredient_effect != null:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/IngredientInfo/HBoxContainer/Marginer/IngredientLabel.text = tower_information.ingredient_effect_simple_description
	else:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/IngredientInfo/HBoxContainer/IngredientIcon.self_modulate.a = 0
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerAttrContainer/IngredientInfo/HBoxContainer/Marginer/IngredientLabel.self_modulate.a = 0
	
	# TowerImageRelated
	if tower_information.tower_image_in_buy_card != null:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerImage.texture = tower_information.tower_image_in_buy_card
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerImage.visible = true
	else:
		$MarginContainer/VBoxContainer/MarginerUpper/Upper/TowerImage.visible = false
	
	# Tier Crown Related
	if tower_information.tower_tier == 1:
		$MarginContainer/VBoxContainer/TierCrownPanel/TierCrown.texture = tier01_crown
	elif tower_information.tower_tier == 2:
		$MarginContainer/VBoxContainer/TierCrownPanel/TierCrown.texture = tier02_crown
	elif tower_information.tower_tier == 3:
		$MarginContainer/VBoxContainer/TierCrownPanel/TierCrown.texture = tier03_crown
	elif tower_information.tower_tier == 4:
		$MarginContainer/VBoxContainer/TierCrownPanel/TierCrown.texture = tier04_crown
	elif tower_information.tower_tier == 5:
		$MarginContainer/VBoxContainer/TierCrownPanel/TierCrown.texture = tier05_crown
	elif tower_information.tower_tier == 6:
		$MarginContainer/VBoxContainer/TierCrownPanel/TierCrown.texture = tier06_crown
	
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
		modulate = Color(1, 1, 1, 1)
	else:
		modulate = Color(0.3, 0.3, 0.3, 1)

func _can_afford() -> bool:
	return current_gold >= tower_information.tower_cost
