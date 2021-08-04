extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

var new_tier : int
var red_syn

func _init(arg_tier : int).(StoreOfPactUUID.FUTURE_SIGHT, "Future Sight", arg_tier):
	
	if tier == 0:
		new_tier = 0
	elif tier == 1:
		new_tier = 0
	elif tier == 2:
		new_tier = 1
	elif tier == 3:
		new_tier = 2
	
	
	good_descriptions = [
		"When this pact is discarded, a new unsworn tier %s pact will be created." % new_tier
	]
	
	bad_descriptions = [
		""
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_FutureSight_Icon.png")


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	var pact
	
	if new_tier == 0:
		pact = red_syn._generate_random_untaken_tier_0_pact()
	elif new_tier == 1:
		pact = red_syn._generate_random_untaken_tier_1_pact()
	elif new_tier == 2:
		pact = red_syn._generate_random_untaken_tier_2_pact()
	elif new_tier == 3:
		pact = red_syn._generate_random_untaken_tier_3_pact()
	
	if pact != null:
		red_syn.red_pact_whole_panel.unsworn_pact_list.add_pact(pact)
	
	._remove_pact_from_game_elements(arg_game_elements)