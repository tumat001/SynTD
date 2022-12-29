extends MarginContainer

const PathDescriptionPanel_5x5_Green_Off = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathDescriptionPanel/PathDescriptionPanel_5x5_Green_Off.png")
const PathDescriptionPanel_5x5_Green_On = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathDescriptionPanel/PathDescriptionPanel_5x5_Green_On.png")

onready var left = $Left
onready var right = $Right
onready var top = $Top
onready var bottom = $Bottom

onready var background = $Background

onready var tooltip_body = $MarginContainer/TooltipBody

var panel_on_state : bool setget set_panel_on_state


func set_panel_on_state(arg_val):
	panel_on_state = arg_val
	
	if panel_on_state:
		background.texture = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathDescriptionPanel/PathDescriptionPanel_5x5_Brown_On.png")
		_set_texture_of_borders(PathDescriptionPanel_5x5_Green_On)
	else:
		background.texture = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathDescriptionPanel/PathDescriptionPanel_5x5_Brown_Off.png")
		_set_texture_of_borders(PathDescriptionPanel_5x5_Green_Off)
	
	tooltip_body.visible = panel_on_state

func _set_texture_of_borders(arg_texture):
	left.texture = arg_texture
	right.texture = arg_texture
	top.texture = arg_texture
	bottom.texture = arg_texture


func set_descriptions_of_tooltip(arg_descs : Array):
	tooltip_body.descriptions = arg_descs
	tooltip_body.update_display()
