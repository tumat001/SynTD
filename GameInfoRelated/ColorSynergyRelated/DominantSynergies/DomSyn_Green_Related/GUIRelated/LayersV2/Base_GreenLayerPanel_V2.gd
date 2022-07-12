
extends MarginContainer

const BaseGreenLayer = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenLayer.gd")
const Base_GreenPathSelectionButton_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/OtherGUI/Base_GreenPathSelectionButton.tscn")

const dim_modulate_color = Color(0.4, 0.4, 0.4, 1)
const normal_modulate_color = Color(1, 1, 1, 1)

var base_green_layer : BaseGreenLayer setget set_green_layer

onready var adapt_layer_name_label = $HBoxContainer/TitleContainer/LabelMarginer/AdaptLayerNameLabel
#onready var layer_background = $HBoxContainer/ContentContainer/LayerBackground
onready var chosen_path_name_label = $HBoxContainer/ActiveDescContainer/VBoxContainer/TitleMarginer/ChosenPathNameLabel
onready var chosen_path_descriptions_gui = $HBoxContainer/ActiveDescContainer/VBoxContainer/HBoxContainer/PathDescriptions
onready var chosen_path_texture_rect = $HBoxContainer/ActiveDescContainer/VBoxContainer/HBoxContainer/ChosenPathTextureRect

onready var path_container = $HBoxContainer/ContentContainer/BackgroundHBox/ContentMargin/MarginContainer/ButtonHBox


func set_green_layer(arg_layer : BaseGreenLayer):
	if base_green_layer != null:
		base_green_layer.disconnect("on_available_green_paths_changed", self, "_on_available_paths_changed")
		base_green_layer.disconnect("on_current_active_green_paths_changed", self, "_on_current_paths_changed")
	
	base_green_layer = arg_layer
	
	if base_green_layer != null:
		base_green_layer.connect("on_available_green_paths_changed", self, "_on_available_paths_changed", [], CONNECT_PERSIST)
		base_green_layer.connect("on_current_active_green_paths_changed", self, "_on_current_paths_changed", [], CONNECT_PERSIST)
		base_green_layer.connect("on_tier_of_syn_changed", self, "_on_tier_of_syn_changed", [], CONNECT_PERSIST)
		
		adapt_layer_name_label.text = base_green_layer.green_layer_name
		_on_current_paths_changed(base_green_layer._current_active_green_paths)
		_on_tier_of_syn_changed(base_green_layer.dom_syn_green.curr_tier)
		_set_up_button_frames()

#

func _set_up_button_frames():
	var paths = base_green_layer._original_green_paths
	
	for path in paths:
		var path_selection_button = Base_GreenPathSelectionButton_Scene.instance()
		path_container.add_child(path_selection_button)
		
		path_selection_button.set_green_path_and_layer(path, base_green_layer)


#

func _on_current_paths_changed(curr_paths):
	# Right now, only one path can be chosen, so change this only when needed
	if curr_paths.size() >= 1:
		var path = curr_paths[0]
		chosen_path_name_label.text = path.green_path_name
		chosen_path_texture_rect.texture = path.green_path_icon
		chosen_path_descriptions_gui.descriptions = path.green_path_descriptions.duplicate(false)
		chosen_path_descriptions_gui.update_display()
	else:
		chosen_path_name_label.text = ""
		chosen_path_texture_rect.texture = null
		chosen_path_descriptions_gui.descriptions = []
		chosen_path_descriptions_gui.update_display()

#

func _on_tier_of_syn_changed(new_tier):
	if base_green_layer.if_meets_tier_and_other_requirements(new_tier):
		modulate = normal_modulate_color
	else:
		modulate = dim_modulate_color

#

# TO BE OVERRIDEN if needed
func _on_available_paths_changed(paths):
	pass

