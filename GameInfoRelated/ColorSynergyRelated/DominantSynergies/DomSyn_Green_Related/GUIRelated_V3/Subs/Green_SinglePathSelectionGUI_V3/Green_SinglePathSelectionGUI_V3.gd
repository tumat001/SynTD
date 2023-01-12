extends MarginContainer

const TierDecor_01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/TierDecors/DomSynGreen_TierDecor_Tier01.png")
const TierDecor_02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/TierDecors/DomSynGreen_TierDecor_Tier02.png")
const TierDecor_03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/TierDecors/DomSynGreen_TierDecor_Tier03.png")
const TierDecor_04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/TierDecors/DomSynGreen_TierDecor_Tier04.png")

const GreenOuterBorder_4x4_Normal = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/GreenOuterBorder_4x4_Normal.png")
const GreenOuterBorder_4x4_Highlighted = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/GreenOuterBorder_4x4_Highlighted.png")
const GreenInnerBorder_4x4_Normal = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/GreenInnerBorder_4x4_Normal.png")
const GreenInnerBorder_4x4_Highlighted = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/GreenInnerBorder_4x4_Highlighted.png")


signal path_activated(arg_path)

var _current_path
var _dom_syn_green

#

onready var border_outer_left = $OuterBorder_Left
onready var border_outer_right = $OuterBorder_Right
onready var border_outer_top = $OuterBorder_Top
onready var border_outer_bottom = $OuterBorder_Bottom

onready var border_inner_left = $MarginContainer/InnerBorder_Left
onready var border_inner_right = $MarginContainer/InnerBorder_Right
onready var border_inner_top = $MarginContainer/InnerBorder_Top
onready var border_inner_bottom = $MarginContainer/InnerBorder_Bottom

onready var decor_topleft = $MarginContainer/Decor_TopLeft
onready var decor_topright = $MarginContainer/Decor_TopRight
onready var decor_bottomleft = $MarginContainer/Decor_BottomLeft
onready var decor_bottomright = $MarginContainer/Decor_BottomRight

onready var path_texture_rect = $MarginContainer/ContentMarginer/VBoxContainer/PathIcon
onready var path_label = $MarginContainer/ContentMarginer/VBoxContainer/PathLabel
onready var path_description_tooltip = $MarginContainer/ContentMarginer/VBoxContainer/PathDescriptions

var _all_outer_borders : Array = []
var _all_inner_borders : Array = []
var _all_decors : Array

func _ready():
	_all_outer_borders.append(border_outer_left)
	_all_outer_borders.append(border_outer_right)
	_all_outer_borders.append(border_outer_top)
	_all_outer_borders.append(border_outer_bottom)
	
	_all_inner_borders.append(border_inner_left)
	_all_inner_borders.append(border_inner_right)
	_all_inner_borders.append(border_inner_top)
	_all_inner_borders.append(border_inner_bottom)
	
	_all_decors.append(decor_topleft)
	_all_decors.append(decor_topright)
	_all_decors.append(decor_bottomleft)
	_all_decors.append(decor_bottomright)


func set_green_path(arg_path, arg_dom_syn_green):
	_current_path = arg_path
	_dom_syn_green = arg_dom_syn_green
	
	_set_appropriate_decor_texture_based_on_path()
	path_texture_rect.texture = _current_path.green_path_icon
	path_label.text = _current_path.green_path_name
	path_description_tooltip.descriptions = _current_path.green_path_descriptions
	path_description_tooltip.update_display()

#

func _set_appropriate_decor_texture_based_on_path():
	if _current_path.green_path_tier == 1:
		_set_all_decor_texture(TierDecor_01)
	elif _current_path.green_path_tier == 2:
		_set_all_decor_texture(TierDecor_02)
	elif _current_path.green_path_tier == 3:
		_set_all_decor_texture(TierDecor_03)
	elif _current_path.green_path_tier == 4:
		_set_all_decor_texture(TierDecor_04)


func _set_all_decor_texture(arg_texture):
	for decor in _all_decors:
		decor.texture = arg_texture

#

func _on_AdvancedButton_released_mouse_event(event : InputEventMouseButton):
	if event.button_index == BUTTON_LEFT:
		_current_path.activate_path_with_green_syn(_dom_syn_green)
		emit_signal("path_activated")

#

func _on_AdvancedButton_mouse_entered():
	_set_borders_to_highlighted()

func _on_AdvancedButton_mouse_exited():
	_set_borders_to_normal()

func _on_Green_SinglePathSelectionGUI_V3_visibility_changed():
	_set_borders_to_normal()


func _set_borders_to_normal():
	for border in _all_outer_borders:
		border.texture = GreenOuterBorder_4x4_Normal
	
	for border in _all_inner_borders:
		border.texture = GreenInnerBorder_4x4_Normal
	

func _set_borders_to_highlighted():
	for border in _all_outer_borders:
		border.texture = GreenOuterBorder_4x4_Highlighted
	
	for border in _all_inner_borders:
		border.texture = GreenInnerBorder_4x4_Highlighted
	




