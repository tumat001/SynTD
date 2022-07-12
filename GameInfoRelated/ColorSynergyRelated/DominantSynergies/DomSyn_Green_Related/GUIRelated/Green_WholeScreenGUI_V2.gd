extends MarginContainer

const Base_GreenLayerPanel_V2_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/LayersV2/Base_GreenLayerPanel_V2.tscn")

var domsyn_green setget set_domsyn_green

onready var layers_container = $LayersContainer


#

func set_domsyn_green(arg_syn):
	domsyn_green = arg_syn


func _ready():
	for layer in domsyn_green._all_layers:
		var layer_panel = Base_GreenLayerPanel_V2_Scene.instance()
		layers_container.add_child(layer_panel)
		
		layer_panel.set_green_layer(layer)
		#layer_panel.call_deferred("set_green_layer", layer)
