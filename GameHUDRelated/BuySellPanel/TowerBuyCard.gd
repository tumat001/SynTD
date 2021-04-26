extends MarginContainer

const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTooltip = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.gd")
const TowerTooltipScene = preload("res://GameHUDRelated/Tooltips/TowerTooltipRelated/TowerTooltip.tscn")

var tower_information : TowerTypeInformation
var disabled : bool = false
var current_tooltip : TowerTooltip

signal tower_bought(tower_id)

func _ready():
	update_display()

func update_display():
	$BuyCard/Lower/TowerNameLabel.text = tower_information.tower_name
	$BuyCard/Lower/TowerCostLabel.text = str(tower_information.tower_cost)
	
	#Color related
	var color01
	var color02
	
	if tower_information.colors.size() > 0:
		color01 = tower_information.colors[0]
	if tower_information.colors.size() > 1:
		color02 = tower_information.colors[1]
	
	if color01 != null:
		$BuyCard/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Color01Icon.texture = TowerColors.get_color_symbol_on_card(color01)
		$BuyCard/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Color01Label.text = TowerColors.get_color_name_on_card(color01)
	else:
		$BuyCard/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Color01Icon.visible = false
		$BuyCard/Upper/TowerAttrContainer/ColorInfo1/HBoxContainer/Color01Label.visible = false
	
	if color02 != null:
		$BuyCard/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Color02Icon.texture = TowerColors.get_color_symbol_on_card(color02)
		$BuyCard/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Color02Label.text = TowerColors.get_color_name_on_card(color02)
	else:
		$BuyCard/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Color02Icon.visible = false
		$BuyCard/Upper/TowerAttrContainer/ColorInfo2/HBoxContainer/Color02Label.visible = false
	
	#Energy Related
	if tower_information.energy_consumption_levels.size() > 0:
		$BuyCard/Upper/TowerAttrContainer/EnergyInfo/HBoxContainer/EnergyLabel.text = create_energy_display(tower_information.energy_consumption_levels)
	else:
		$BuyCard/Upper/TowerAttrContainer/EnergyInfo/HBoxContainer/EnergyLabel.visible = false
		$BuyCard/Upper/TowerAttrContainer/EnergyInfo/HBoxContainer/EnergyIcon.visible = false
	
	#Ingredient Related
	if tower_information.ingredient_buffs.size() > 0:
		$BuyCard/Upper/TowerAttrContainer/IngredientInfo/HBoxContainer/IngredientLabel.text = tower_information.ingredient_buff_description
	else:
		$BuyCard/Upper/TowerAttrContainer/IngredientInfo/HBoxContainer/IngredientIcon.visible = false
		$BuyCard/Upper/TowerAttrContainer/IngredientInfo/HBoxContainer/IngredientLabel.visible = false
	
	#TowerImageRelated
	if tower_information.tower_image_in_buy_card != null:
		$BuyCard/Upper/TowerImage.texture = tower_information.tower_image_in_buy_card
	else:
		$BuyCard/Upper/TowerImage.visible = false
	

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
	if !disabled :
		disabled = true
		emit_signal("tower_bought", tower_information.tower_type_id)
		
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
	if current_tooltip != null:
		current_tooltip.queue_free()

