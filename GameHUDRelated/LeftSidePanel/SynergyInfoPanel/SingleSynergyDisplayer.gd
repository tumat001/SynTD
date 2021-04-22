extends MarginContainer

const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

var synergy : ColorSynergy
var result : ColorSynergy.CheckResults

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO REMOVE THIS EVENTUALLY
	synergy = ColorSynergy.new("RedGreen", [TowerColors.RED, TowerColors.GREEN], [6, 4, 2], 
			[ColorSynergy.tier_gold_pic, ColorSynergy.tier_silver_pic, ColorSynergy.tier_bronze_pic], ColorSynergy.syn_compo_comple_redgreen)
	
	var colors_active = [TowerColors.RED, TowerColors.RED, 
			TowerColors.RED, TowerColors.GREEN, TowerColors.GREEN, TowerColors.BLUE, TowerColors.GREEN,
			TowerColors.GREEN]
	result = synergy.check_if_color_requirements_met(colors_active)
	
	update_display()

func update_display():
	$HBoxContainer/TierIconPanel/TierIcon.texture = result.tier_pic
	$HBoxContainer/TierIconPanel/SpecialMarginer/TierNumberLabel.text = _convert_number_to_roman_numeral(result.synergy_tier)
	$HBoxContainer/SynergyIconPanel/SynergyIcon.texture = synergy.synergy_picture
	$HBoxContainer/SynergyInfoLabelPanel/SynergyInfoLabel.text = _generate_synergy_info_to_display()

func _convert_number_to_roman_numeral(number : int) -> String:
	var return_val : String = "nan"
	if number == 0:
		return_val = "0"
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
	var synergy_name = synergy.synergy_name
	var colors_required : Array = synergy.colors_required
	
	var numbers_per_color_string : String = _arrange_numbers_by_colors_required(colors_required, result)
	return numbers_per_color_string + " - " + synergy_name

func _arrange_numbers_by_colors_required(colors_required : Array, result : ColorSynergy.CheckResults) -> String:
	var num_bucket : Array = []
	
	for color_req in colors_required:
		num_bucket.append(result.count_per_color[0][result.count_per_color[1].find(color_req)])
	
	return PoolStringArray(num_bucket).join("/")
