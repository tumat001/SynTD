extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButtonWithTooltip.gd"

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
const BaseGreenPath = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd")
const BaseGreenLayer = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenLayer.gd")


onready var path_icon = $PathIconContainer/PathIcon

var _green_path : BaseGreenPath
var _green_layer : BaseGreenLayer

#

func set_green_path_and_layer(arg_path : BaseGreenPath, arg_layer: BaseGreenLayer):
	_green_path = arg_path
	_green_layer = arg_layer
	
	_green_layer.connect("on_available_green_paths_changed", self, "_on_available_green_paths_changed", [], CONNECT_PERSIST)
	_on_available_green_paths_changed(_green_layer.available_green_paths)
	
	if path_icon != null:
		path_icon.texture = _green_path.green_path_icon


#

func _construct_about_tooltip() -> BaseTooltip:
	var tooltip : BaseTowerSpecificTooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = _green_path.green_path_name
	tooltip.descriptions = _green_path.green_path_descriptions
	
	return tooltip

#

func _on_available_green_paths_changed(available_paths):
	if _green_layer.available_green_paths.has(_green_path):
		disabled = false
		visible = true
	else:
		disabled = true
		visible = false


#

func _on_Base_GreenPathSelectionButton_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		_green_layer.attempt_activate_available_green_path(_green_path)
