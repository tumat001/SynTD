extends MarginContainer


const Tier01_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier01.png")
const Tier02_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier02.png")
const Tier03_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier03.png")
const Tier04_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier04.png")
const Tier05_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier05.png")
const Tier06_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerNameAndPicPanel/TierIcons/TierIcons_Tier06.png")

const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")



var tower_type_info

var _is_hovered : bool
var _current_tooltip

onready var tier_icon = $MarginContainer/VBoxContainer/TierIcon
onready var ingredient_icon_panel = $MarginContainer/VBoxContainer/IngredientIconPanel


func update_display():
	var effect = null
	
	if tower_type_info.ingredient_effect != null:
		effect = tower_type_info.ingredient_effect.tower_base_effect
	
	ingredient_icon_panel.tower_base_effect = effect
	ingredient_icon_panel.update_display()
	
	###
	
	if tower_type_info.tower_tier == 1:
		tier_icon.texture = Tier01_Icon
	elif tower_type_info.tower_tier == 2:
		tier_icon.texture = Tier02_Icon
	elif tower_type_info.tower_tier == 3:
		tier_icon.texture = Tier03_Icon
	elif tower_type_info.tower_tier == 4:
		tier_icon.texture = Tier04_Icon
	elif tower_type_info.tower_tier == 5:
		tier_icon.texture = Tier05_Icon
	elif tower_type_info.tower_tier == 6:
		tier_icon.texture = Tier06_Icon


func _on_IngredientIconPanel_mouse_entered():
	_is_hovered = true
	_create_or_destroy_tooltip()


func _on_IngredientIconPanel_mouse_exited():
	_is_hovered = false


func _on_Almanac_TowerTypeInfoPanel_TierAndIngPanel_visibility_changed():
	_is_hovered = false

#


func _create_or_destroy_tooltip():
	if !is_instance_valid(_current_tooltip):
		_current_tooltip = _construct_about_tooltip()
		_current_tooltip.visible = true
		_current_tooltip.tooltip_owner = ingredient_icon_panel
		#CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_current_tooltip)
		AlmanacManager.almanac_page_gui.tooltip_container.add_child(_current_tooltip)
		_current_tooltip.update_display()
		
	else:
		_current_tooltip.queue_free()
		_current_tooltip = null

func _construct_about_tooltip():
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	
	a_tooltip.descriptions = [tower_type_info.ingredient_effect.tower_base_effect.description]
	
	return a_tooltip

