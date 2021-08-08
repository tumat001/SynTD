extends MarginContainer

const BaseGreenLayer = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenLayer.gd")


signal on_available_green_paths_changed(available_paths)

var base_green_layer : BaseGreenLayer setget set_green_layer

onready var adapt_layer_name_label = $HBoxContainer/TitleContainer/LabelMarginer/AdaptLayerNameLabel
onready var layer_background = $HBoxContainer/ContentContainer/LayerBackground
onready var chosen_path_name_label = $HBoxContainer/ActiveDescContainer/VBoxContainer/TitleMarginer/ChosenPathNameLabel
onready var chosen_path_descriptions_gui = $HBoxContainer/ActiveDescContainer/VBoxContainer/HBoxContainer/PathDescriptions
onready var chosen_path_texture_rect = $HBoxContainer/ActiveDescContainer/VBoxContainer/HBoxContainer/ChosenPathTextureRect


func set_green_layer(arg_layer : BaseGreenLayer):
	if base_green_layer != null:
		base_green_layer.disconnect("on_available_green_paths_changed", self, "_on_available_paths_changed")
		base_green_layer.disconnect("on_current_active_green_paths_changed", self, "_on_current_paths_changed")
	
	base_green_layer = arg_layer
	
	if base_green_layer != null:
		base_green_layer.connect("on_available_green_paths_changed", self, "_on_available_paths_changed", [], CONNECT_PERSIST)
		base_green_layer.connect("on_current_active_green_paths_changed", self, "_on_current_paths_changed", [], CONNECT_PERSIST)
		
		adapt_layer_name_label.text = base_green_layer.green_layer_name
		_on_current_paths_changed(base_green_layer._current_active_green_paths)

#

func _on_available_paths_changed(paths):
	emit_signal("on_available_green_paths_changed", paths)

func _on_current_paths_changed(curr_paths):
	# Right now, only one path can be chosen, so change this only when needed
	if curr_paths.size() > 1:
		var path = curr_paths[0]
		chosen_path_name_label.text = path.green_path_name
		chosen_path_texture_rect = path.green_path_icon
		chosen_path_descriptions_gui.descriptions = curr_paths.duplicate(false)
		chosen_path_descriptions_gui.update_display()


