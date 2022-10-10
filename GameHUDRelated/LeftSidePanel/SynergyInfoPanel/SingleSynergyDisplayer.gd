extends MarginContainer

const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergyCheckResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")
const SynergyTooltipScene = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynergyTooltip.tscn")
const SynergyTooltip = preload("res://GameHUDRelated/Tooltips/SynergyTooltipRelated/SynergyTooltip.gd")

signal on_single_syn_tooltip_displayed(synergy)
signal on_single_syn_tooltip_hidden(synergy)

signal on_single_syn_displayer_pressed(input_mouse_event, syn_check_result)


var result : ColorSynergyCheckResults
var current_tooltip : SynergyTooltip
var game_settings_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()

func update_display():
	$HBoxContainer/TierIconPanel/TierIcon.texture = result.tier_pic
	#$HBoxContainer/TierIconPanel/SpecialMarginer/TierNumberLabel.text = _convert_number_to_roman_numeral(result.synergy_tier)
	
	if result.synergy_tier != 0:
		$HBoxContainer/TierIconPanel/SpecialMarginer/TierNumberLabel.text = str(result.synergy.number_of_towers_in_tier[result.synergy_tier - 1])
	else:
		$HBoxContainer/TierIconPanel/SpecialMarginer/TierNumberLabel.text = ""
	
	$HBoxContainer/SynergyIconPanel/SynergyIcon.texture = result.synergy.synergy_picture
	$HBoxContainer/SynergyInfoLabelPanel/SynergyInfoLabel.text = _generate_synergy_info_to_display()

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

func _generate_synergy_info_to_display() -> String:
	var synergy : ColorSynergy = result.synergy
	
	return _get_needed_towers_per_tier_text(synergy)

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
	
	var num_of_towers_per_tier_text : String = PoolStringArray(num_of_towers_in_tier).join(text_attachment)
	var display_text =  synergy.synergy_name + "\n- " + num_of_towers_per_tier_text
	return display_text


func _on_SingleSynergyDisplayer_mouse_entered():
	var tooltip = SynergyTooltipScene.instance()
	current_tooltip = tooltip
	current_tooltip.result = result
	current_tooltip.tooltip_owner = self
	current_tooltip.game_settings_manager = game_settings_manager
	
	emit_signal("on_single_syn_tooltip_displayed", result.synergy)
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(current_tooltip)

#func _on_SingleSynergyDisplayer_mouse_exited():
#	if current_tooltip != null:
#
#		emit_signal("on_single_syn_tooltip_hidden", result.synergy)
#		current_tooltip.queue_free()

func _on_SingleSynergyDisplayer_mouse_exited():
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()
	
	emit_signal("on_single_syn_tooltip_hidden", result.synergy)

func _on_SingleSynergyDisplayer_gui_input(event):
	if event is InputEventMouseButton:
		emit_signal("on_single_syn_displayer_pressed", event, result)

#

func get_synergy_name() -> String:
	return result.synergy.synergy_name
