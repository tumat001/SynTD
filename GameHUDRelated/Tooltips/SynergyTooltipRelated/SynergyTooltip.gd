extends "res://GameHUDRelated/Tooltips/BaseTooltip.gd"

const ColorSynergyCheckResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const GameSettingsManager = preload("res://GameElementsRelated/GameSettingsManager.gd")

const TooltipWithTextIndicatorDescription = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithTextIndicatorDescription.gd")
const TooltipWithTextIndicatorDescriptionScene = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithTextIndicatorDescription.tscn")
const TooltipWithImageIndicatorDescription = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithImageIndicatorDescription.gd")
const TooltipWithImageIndicatorDescriptionScene = preload("res://GameHUDRelated/Tooltips/TooltipBodyConstructors/TooltipWithImageIndicatorDescription.tscn")

const Background_ForHighlighted = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynergyTooltipPic_background_ForHighlighted.png")

#const highlighted_color : Color = Color(0, 0, 0, 1)
#const not_highlighted_color : Color = Color(0.3, 0.3, 0.3, 1)

const text_color : Color = Color(1, 1, 1, 1)
const highlighted_modulate : Color = Color(1, 1, 1, 1)
const not_highlighted_modulate : Color = Color(1, 1, 1, 0.65)

var game_settings_manager : GameSettingsManager
var result : ColorSynergyCheckResults

onready var syn_icon_texture_rect = $VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynNameIconNumberContainer/SynIcon
onready var syn_name_label = $VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynNameIconNumberContainer/Marginer/SynName
onready var syn_num_of_towers_label = $VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynNameIconNumberContainer/Marginer/NumOfTowers

onready var syn_towers_in_tier_label = $VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynTierAndProg/Marginer/SynTowersInTier
onready var syn_tier_texture_rect = $VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynTierAndProg/MarginContainer/SynTier
onready var syn_tier_label = $VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynTierAndProg/MarginContainer/Marginer/SynTierLabel

onready var tooltip_body = $VBoxContainer/MainContentContainer/Marginer/VBoxContainer/DescContainer/VBoxContainer/TooltipBody
onready var synergy_difficulty_panel = $VBoxContainer/MainContentContainer/Marginer/VBoxContainer/DescContainer/VBoxContainer/SynergyDifficultyPanel


func _ready():
	tooltip_body.override_color_of_descs = true
	tooltip_body.use_color_for_dark_background = true
	
	update_display()

func update_display():
	if result != null:
		var synergy : ColorSynergy = result.synergy
		
		syn_icon_texture_rect.texture = synergy.synergy_picture
		syn_name_label.text = synergy.synergy_name
		syn_num_of_towers_label.text = _get_number_of_towers_per_color_text()
		
		syn_towers_in_tier_label.text = _get_needed_towers_per_tier_text(synergy)
		syn_tier_texture_rect.texture = result.tier_pic
		
		#syn_tier_label.text = _convert_number_to_roman_numeral(result.synergy_tier)
		
		if synergy.current_tier != 0:
			syn_tier_label.text = str(synergy.number_of_towers_in_tier[synergy.current_tier - 1])
		else:
			syn_tier_label.text = ""
		
		var final_descs : Array = []
		
#		for desc in synergy.synergy_descriptions:
#			final_descs.append(desc)
		
		for desc in GameSettingsManager.get_descriptions_to_use_based_on_color_synergy(synergy, game_settings_manager):
			final_descs.append(desc)
		
		for desc in construct_tooltips_descs_for_curr_effects(synergy, tooltip_body, false):
			final_descs.append(desc)
		
		tooltip_body.descriptions = final_descs
		tooltip_body.update_display()
		
		
		if game_settings_manager.show_synergy_difficulty_mode == GameSettingsManager.ShowSynergyDifficulty.SHOW:
			synergy_difficulty_panel.set_difficulty(synergy.synergy_difficulty_num)
			synergy_difficulty_panel.visible = true
		elif game_settings_manager.show_synergy_difficulty_mode == GameSettingsManager.ShowSynergyDifficulty.DONT_SHOW:
			synergy_difficulty_panel.visible = false


func _get_number_of_towers_per_color_text() -> String:
	return _arrange_numbers_by_colors_required(result.synergy.colors_required, result)
	

func _arrange_numbers_by_colors_required(colors_required : Array, arg_result : ColorSynergyCheckResults) -> String:
	var num_bucket : Array = []
	
	for color_req in colors_required:
		num_bucket.append(arg_result.count_per_color[0][arg_result.count_per_color[1].find(color_req)])
	
	return PoolStringArray(num_bucket).join("/")


func _get_needed_towers_per_tier_text(synergy : ColorSynergy) -> String:
	var num_of_towers_in_tier : Array = synergy.number_of_towers_in_tier.duplicate()
	num_of_towers_in_tier.append(0)
	
	var nums_to_remove : Array = []
	for num in num_of_towers_in_tier:
		if result.towers_in_tier > num:
			nums_to_remove.append(num)
	for num in nums_to_remove:
		num_of_towers_in_tier.erase(num)
	
	num_of_towers_in_tier.sort()
	num_of_towers_in_tier.resize(2)
	
	var text_attachment = " >> "
	if num_of_towers_in_tier[1] == null:
		num_of_towers_in_tier[1] = "MAX"
		text_attachment = " = "
	
	return PoolStringArray(num_of_towers_in_tier).join(text_attachment)

func _convert_number_to_roman_numeral(number : int) -> String:
	var return_val : String = ""
	if number == 0:
		return_val = ""
	elif number == 1:
		return_val = "I"
	elif number == 2:
		return_val = "II"
	elif number == 3:
		return_val = "III"
	elif number == 4:
		return_val = "IV"
	elif number == 5:
		return_val = "V"
	elif number == 6:
		return_val = "VI"
	
	return return_val


# ALSO USED by almanac manager in displaying syn effects.
static func construct_tooltips_descs_for_curr_effects(synergy : ColorSynergy, tooltip_body, always_use_highlighted_modulate : bool) -> Array:
	var descs : Array = []
	
	for desc_i in synergy.synergy_effects_descriptions.size():
		var text_desc = TooltipWithTextIndicatorDescriptionScene.instance()
		
		var provided_desc = synergy.synergy_effects_descriptions[desc_i]
		
		if provided_desc is Array:
			text_desc.description = provided_desc[0]
			text_desc._text_fragment_interpreters = provided_desc[1]
			text_desc.uses_bbcode = true
			
		else:
			text_desc.description = provided_desc
		
		text_desc._use_color_for_dark_background = tooltip_body.use_color_for_dark_background
		
		#text_desc.indicator = _convert_number_to_roman_numeral(desc_i + 1) + ")"
		#text_desc.indicator = str(result.synergy.number_of_towers_in_tier[desc_i]) + ")"
		text_desc.indicator = str(synergy.number_of_towers_in_tier[(synergy.number_of_towers_in_tier.size() - 1) - desc_i]) + ")"
		
		text_desc.color = text_color
		if synergy.current_highlighted_index_effects_descriptions.has(desc_i) or always_use_highlighted_modulate:
			text_desc.modulate = highlighted_modulate
			
			var highlighted_texturerect = TextureRect.new()
			highlighted_texturerect.texture = Background_ForHighlighted
			highlighted_texturerect.stretch_mode = TextureRect.STRETCH_TILE
			text_desc.add_child(highlighted_texturerect)
			text_desc.move_child(highlighted_texturerect, 0)
			
		else:
			text_desc.modulate = not_highlighted_modulate
		
		
		descs.append(text_desc)
	
	return descs



