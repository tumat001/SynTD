extends MarginContainer

const BaseGreenPath = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd")
const ChosenBorder_Tier04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/ChosenPanel_Borders/DomSynGreen_ChosenBorder_Tier04.png")
const ChosenBorder_Tier03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/ChosenPanel_Borders/DomSynGreen_ChosenBorder_Tier03.png")
const ChosenBorder_Tier02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/ChosenPanel_Borders/DomSynGreen_ChosenBorder_Tier02.png")
const ChosenBorder_Tier01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/ChosenPanel_Borders/DomSynGreen_ChosenBorder_Tier01.png")

const Icon_Tier01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/TierIcons/DomSynGreen_Tier01_Icon.png")
const Icon_Tier02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/TierIcons/DomSynGreen_Tier02_Icon.png")
const Icon_Tier03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/TierIcons/DomSynGreen_Tier03_Icon.png")
const Icon_Tier04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated_V3/AssetsV3/TierIcons/DomSynGreen_Tier04_Icon.png")


var domsyn_green setget set_domsyn_green

var _current_green_path : BaseGreenPath

var _deferred_arg_signal_to_await_for_path_activation : String

#

onready var path_texture_rect = $MarginContainer/HBoxContainer/PathIcon
onready var title_label = $MarginContainer/HBoxContainer/TitleLabel
onready var tier_icon = $MarginContainer/HBoxContainer/TierIcon
onready var path_description_tooltip = $MarginContainer/HBoxContainer/PathDescriptionTooltip

onready var outerborder_left = $OuterBorder_Left
onready var outerborder_right = $OuterBorder_Right
onready var outerborder_top = $OuterBorder_Top
onready var outerborder_bottom = $OuterBorder_Bottom

var _all_outerborders : Array

#

func _ready():
	_all_outerborders.append(outerborder_left)
	_all_outerborders.append(outerborder_right)
	_all_outerborders.append(outerborder_top)
	_all_outerborders.append(outerborder_bottom)
	
	visible = false
	
	if !_deferred_arg_signal_to_await_for_path_activation.empty():
		domsyn_green.connect(_deferred_arg_signal_to_await_for_path_activation, self, "_on_path_awaiting_activated", [], CONNECT_PERSIST)


#

func set_domsyn_green(arg_syn):
	domsyn_green = arg_syn
	
	

func set_assigned_layer(arg_signal_to_await_for_path_activation : String):
	if is_inside_tree():
		domsyn_green.connect(arg_signal_to_await_for_path_activation, self, "_on_path_awaiting_activated", [], CONNECT_PERSIST)
		
	else:
		_deferred_arg_signal_to_await_for_path_activation = arg_signal_to_await_for_path_activation
	


#

func _on_path_awaiting_activated(arg_path : BaseGreenPath):
	_current_green_path = arg_path
	
	if _current_green_path != null:
		_set_properties_based_on_curr_path()
		
		_current_green_path.connect("applied_path_tier_to_game_elements", self, "_on_applied_path_tier_to_game_elements", [], CONNECT_PERSIST)
		_current_green_path.connect("removed_path_tier_from_game_elements", self, "_on_remove_path_from_game_elements", [], CONNECT_PERSIST)
		
		visible = true
	
	call_deferred("_update_modulate_based_on_path_is_applied")


func _set_properties_based_on_curr_path():
	if _current_green_path != null:
		var border_texture_to_use : Texture
		var tier_icon_to_use : Texture
		
		if _current_green_path.green_path_tier == 4:
			border_texture_to_use = ChosenBorder_Tier04
			tier_icon_to_use = Icon_Tier04
		elif _current_green_path.green_path_tier == 3:
			border_texture_to_use = ChosenBorder_Tier03
			tier_icon_to_use = Icon_Tier03
		elif _current_green_path.green_path_tier == 2:
			border_texture_to_use = ChosenBorder_Tier02
			tier_icon_to_use = Icon_Tier02
		elif _current_green_path.green_path_tier == 1:
			border_texture_to_use = ChosenBorder_Tier01
			tier_icon_to_use = Icon_Tier01
		
		
		#
		set_border_visibility_and_texture(true, border_texture_to_use)
		
		tier_icon.texture = tier_icon_to_use
		title_label.text = _current_green_path.green_path_name
		path_texture_rect.texture = _current_green_path.green_path_icon
		
		path_description_tooltip.descriptions = _current_green_path.green_path_descriptions
		path_description_tooltip.update_display()
		
	else:
		set_border_visibility_and_texture(false, null)
		

func set_border_visibility_and_texture(arg_vis, arg_texture):
	for border in _all_outerborders:
		if arg_texture != null:
			border.texture = arg_texture
		border.visible = arg_vis
		



#

func _on_applied_path_tier_to_game_elements():
	_update_modulate_based_on_path_is_applied()

func _on_remove_path_from_game_elements():
	_update_modulate_based_on_path_is_applied()

func _update_modulate_based_on_path_is_applied():
	if _current_green_path != null:
		if _current_green_path.is_currently_applied_to_game_elements__based_on_tier:
			modulate = Color(1, 1, 1)
		else:
			modulate = Color(0.6, 0.6, 0.6)
		
		
	else:
		modulate = Color(0.6, 0.6, 0.6)


