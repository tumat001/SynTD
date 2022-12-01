extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

var new_tier : int
var red_syn

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.FUTURE_SIGHT, "Future Sight", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		new_tier = 0
	elif tier == 1:
		new_tier = 0
	elif tier == 2:
		new_tier = 1
	elif tier == 3:
		new_tier = 2
	
	
	good_descriptions = [
		"When this pact is unsworn, a new unsworn tier %s pact will be created." % new_tier
	]
	
	bad_descriptions = [
		""
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_FutureSight_Icon.png")


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)


func pact_unsworn(arg_replacing_pact):
	.pact_unsworn(arg_replacing_pact)
	
	_generate_random_higher_pact(arg_replacing_pact)

func _generate_random_higher_pact(arg_replacing_pact):
	var pact
	
	if new_tier == 0:
		pact = red_syn._generate_random_untaken_tier_0_pact(1, [arg_replacing_pact.pact_uuid])
	elif new_tier == 1:
		pact = red_syn._generate_random_untaken_tier_1_pact(2, [arg_replacing_pact.pact_uuid])
	elif new_tier == 2:
		pact = red_syn._generate_random_untaken_tier_2_pact(3, [arg_replacing_pact.pact_uuid])
	elif new_tier == 3:
		pact = red_syn._generate_random_untaken_tier_3_pact(3, [arg_replacing_pact.pact_uuid])
	
	if pact != null:
		red_syn.red_pact_whole_panel.unsworn_pact_list.add_pact(pact)


#########

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_tier_to_be_offered != 0
