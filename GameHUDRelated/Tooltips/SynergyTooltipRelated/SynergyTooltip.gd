extends "res://GameHUDRelated/Tooltips/BaseTooltip.gd"

const ColorSynergyCheckResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

var result : ColorSynergyCheckResults

func _ready():
	update_display()

func update_display():
	if result != null:
		var synergy : ColorSynergy = result.synergy
		
		$VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynNameIconNumberContainer/SynIcon.texture = synergy.synergy_picture
		$VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynNameIconNumberContainer/Marginer/SynName.text = synergy.synergy_name
		$VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynNameIconNumberContainer/Marginer/NumOfTowers.text = _get_number_of_towers_per_color_text()
		
		$VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynTierAndProg/Marginer/SynTowersInTier.text = _get_needed_towers_per_tier_text(synergy)
		$VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynTierAndProg/MarginContainer/SynTier.texture = result.tier_pic
		$VBoxContainer/MainContentContainer/Marginer/VBoxContainer/SynTierAndProg/MarginContainer/Marginer/SynTierLabel.text = _convert_number_to_roman_numeral(result.synergy_tier)
		


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
