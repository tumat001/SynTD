extends Node

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const tier_bronze_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Bronze.png")
const tier_silver_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Silver.png")
const tier_gold_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Gold.png")
const tier_dia_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Diamond.png")
const tier_prestigeW_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Prestige_White.png")

const syn_dom_red = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Red.png")
const syn_dom_orange = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Orange.png")
const syn_dom_yellow = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Yellow.png")
const syn_dom_green = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Green.png")
const syn_dom_blue = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Blue.png")
const syn_dom_violet = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Violet.png")
const syn_dom_white = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_White.png")
const syn_dom_black = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Dom_Black.png")

const DomSyn_Violet = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Violet_Related/DomSyn_Violet.gd")
const DomSyn_Yellow_GoldIncome = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/DomSyn_Yellow_GoldIncome.gd")
const DomSyn_Yellow_EnergyBattery = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/DomSyn_Yellow_EnergyBattery.gd")
const DomSyn_Orange = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/DomSyn_Orange.gd")
const DomSyn_Blue = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/DomSyn_Blue.gd")
const DomSyn_Red = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red.gd")
const DomSyn_Black = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Black_Related/DomSyn_Black.gd")
const DomSyn_Green = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/DomSyn_Green.gd")


const SynTD_HeaderIDName = "SynTD_"

const SynergyID__Blue = "%s%s" % [SynTD_HeaderIDName, "Blue"]
const SynergyID__Black = "%s%s" % [SynTD_HeaderIDName, "Black"]
const SynergyID__Red = "%s%s" % [SynTD_HeaderIDName, "Red"]
const SynergyID__Orange = "%s%s" % [SynTD_HeaderIDName, "Orange"]
const SynergyID__Yellow = "%s%s" % [SynTD_HeaderIDName, "Yellow"]
const SynergyID__Green = "%s%s" % [SynTD_HeaderIDName, "Green"]
const SynergyID__White = "%s%s" % [SynTD_HeaderIDName, "White"]
const SynergyID__Violet = "%s%s" % [SynTD_HeaderIDName, "Violet"]

const all_dom_synergy_ids_from_Syn_TD_base_game : Array = [
	SynergyID__Blue,
	SynergyID__Black,
	SynergyID__Red,
	#SynergyID__Orange,
	#SynergyID__Yellow,
	SynergyID__Green,
	#SynergyID__White,
	#SynergyID__Violet,
]

#enum SynergyId {
#	BLUE = 100,
#	BLACK = 101,
#	RED = 102,
#	ORANGE = 103,
#	YELLOW = 104,
#	GREEN = 105,
#	WHITE = 106,
#	VIOLET = 107
#}

const synergy_id_to_syn_name_dictionary := {
	SynergyID__Blue : "Blue",
	SynergyID__Black : "Black",
	SynergyID__Red : "Red",
	SynergyID__Orange : "Orange",
	SynergyID__Yellow : "Yellow",
	SynergyID__Green : "Green",
	SynergyID__White : "White",
	SynergyID__Violet : "Violet",
}

var synergy_id_to_pic_map__big : Dictionary = {
	SynergyID__Red : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Red_30x30.png"),
	SynergyID__Orange : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Orange_30x30.png"),
	SynergyID__Yellow : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Yellow_30x30.png"),
	SynergyID__Green : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Green_30x30.png"),
	SynergyID__Blue : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Blue_30x30.png"),
	SynergyID__Violet : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Violet_30x30.png"),
	SynergyID__White : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_White_30x30.png"),
	SynergyID__Black : preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/SynergyIcons_Big/SynIcon_Dom_Black_30x30.png"),
	
}

##

var all_syn_id_tier_compos : Array


# Can be used as the official list of ALL synergies, even if hidden.
# Where modded synergies should be added (via appropriate method) on PreGameModifiers (BreakpointActivation.BEFORE_SINGLETONS_INIT)
var synergies : Dictionary

#

# Can be used as the official list of active synergies (the ones displayable in Almanac).
# Can be modified during PreGameModifiers (BreakpointActivation.BEFORE_SINGLETONS_INIT).
var available_synergy_ids : Array = []



var _banned_syn_ids : Array = [
	SynergyID__White
]

####

func _on_singleton_initialize():
	for syn_id in all_dom_synergy_ids_from_Syn_TD_base_game:
		if !_banned_syn_ids.has(syn_id):
			available_synergy_ids.append(syn_id)
	
	####
	
	#
	var plain_fragment__violet_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_VIOLET, "Violet towers")
	var plain_fragment__orange_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_ORANGE, "Orange towers")
	var plain_fragment__orange_towers_apo = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_ORANGE, "Orange tower's")
	var plain_fragment__yellow_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_YELLOW, "Yellow towers")
	var plain_fragment__green_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_GREEN, "Green towers")
	var plain_fragment__blue_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_BLUE, "Blue towers")
	
	
	var interpreter_for_blue_ap_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_blue_ap_tier_1.display_body = false
	
	var ins_for_blue_ap_tier_1 = []
	ins_for_blue_ap_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", 0.25, false))
	
	interpreter_for_blue_ap_tier_1.array_of_instructions = ins_for_blue_ap_tier_1
	
	
	var interpreter_for_blue_ap_tier_2 : TextFragmentInterpreter = interpreter_for_blue_ap_tier_1.get_deep_copy()
	interpreter_for_blue_ap_tier_2.array_of_instructions[0].num_val = 0.25
	
	var interpreter_for_blue_ap_tier_3 : TextFragmentInterpreter = interpreter_for_blue_ap_tier_1.get_deep_copy()
	interpreter_for_blue_ap_tier_3.array_of_instructions[0].num_val = 0.25
	
	var plain_fragment__blue_abilities = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Blue Abilities")
	
	
	var blue_syn = ColorSynergy.new(SynergyID__Blue, synergy_id_to_syn_name_dictionary[SynergyID__Blue], [TowerColors.BLUE], [8, 5, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_blue, synergy_id_to_pic_map__big[SynergyID__Blue],
	[
		["Gain access to |0|.", [plain_fragment__blue_abilities]],
		["Additionally, all |0| gain ability potency.", [plain_fragment__blue_towers]],
		""
	],
	[DomSyn_Blue],
	[
		["Sea Breeze : Slow and minor damage to all enemies. +|0|.", [interpreter_for_blue_ap_tier_3]],
		["Mana Blast: Big AOE damage, and AOE ability potency buff. +|0|.", [interpreter_for_blue_ap_tier_2]],
		["Renew & Empower : Multi purpose abilities. +|0|.", [interpreter_for_blue_ap_tier_1]],
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW,
	{},
	[],
	ColorSynergy.Difficulty.CHALLENGING
	)
	
	
	
	
	var interpreter_for_black_attk_speed_give = TextFragmentInterpreter.new()
	interpreter_for_black_attk_speed_give.display_body = false
	
	var ins_for_black_attk_speed_give = []
	ins_for_black_attk_speed_give.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 30, true))
	
	interpreter_for_black_attk_speed_give.array_of_instructions = ins_for_black_attk_speed_give
	
	
	var interpreter_for_black_bonus_dmg = TextFragmentInterpreter.new()
	interpreter_for_black_bonus_dmg.display_body = false
	
	var ins_for_black_bonus_dmg = []
	ins_for_black_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "", 15, true))
	
	interpreter_for_black_bonus_dmg.array_of_instructions = ins_for_black_bonus_dmg
	
	
	var black_syn = ColorSynergy.new(SynergyID__Black, synergy_id_to_syn_name_dictionary[SynergyID__Black], [TowerColors.BLACK], [10, 8, 6, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_black, synergy_id_to_pic_map__big[SynergyID__Black],
	[
		"Black towers gain bonus stats and effects."
	],
	[DomSyn_Black],
	[
		["Damage is increased by |0|.", [interpreter_for_black_bonus_dmg]],
		["Main attacks on hit causes the attacking tower to give a random black tower |0| for 6 attacks for 5 seconds. This effect has a 3 second cooldown.", [interpreter_for_black_attk_speed_give]],
		"Choose one of the four dark paths to take.",
		"The chosen dark path is upgraded.",
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW,
	{},
	[],
	ColorSynergy.Difficulty.COMPLEX
	)
	
	
	#
	
	var plain_fragment__red_on_round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
	var plain_fragment__orange_abilities = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "abilities")
	var plain_fragment__yellow_on_round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
	var plain_fragment__yellow_gold_gain = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "gain 1 gold")
	var plain_fragment__violet_ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredients")
	
	
	# ------------------------------------------------------
	
	synergies = {
	synergy_id_to_syn_name_dictionary[SynergyID__Red] : ColorSynergy.new(SynergyID__Red, synergy_id_to_syn_name_dictionary[SynergyID__Red], [TowerColors.RED], [9, 6, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_dom_red, synergy_id_to_pic_map__big[SynergyID__Red],
	[
		["Opens the Pact shop, which shows a list of up to three unsworn pacts. |0|: a new unsworn pact is offered.", [plain_fragment__red_on_round_end]],
		"Swearing a Pact activates its buffs and debuffs. Up to 3 pacts can be sworn at a time. Swearing a pact at the limit will remove the oldest sworn pact along with its effects unless stated otherwise.",
		"Synergy level requirements must be met for a pact to take effect.",
		"",
		"Synergy level affects the quality and types of unsworn pacts that appear in the shop.",
		"",
		"-----------------------------",
		"Red towers change every game.",
		"",
	],
	[DomSyn_Red],
	[
		"Basic shop",
		"Intermediate Shop",
		"Advanced Shop",
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[
		["Opens the Pact shop, which shows a list of up to three unsworn pacts. |0|: a new unsworn pact is offered.", [plain_fragment__red_on_round_end]],
		"Swearing a Pact activates its buffs and debuffs. Up to 3 pacts can be sworn at a time.",
		"",
	],
	ColorSynergy.Difficulty.COMPLEX
	),
	
	synergy_id_to_syn_name_dictionary[SynergyID__Orange] : ColorSynergy.new(SynergyID__Orange, synergy_id_to_syn_name_dictionary[SynergyID__Orange], [TowerColors.ORANGE], [12, 9, 6, 3],
	[tier_prestigeW_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_orange, synergy_id_to_pic_map__big[SynergyID__Orange],
	[
		["|0| gain Heat Modules. Main attacks increase the heat of Heat Modules by an amount (amount varies per tower).", [plain_fragment__orange_towers]],
		"Heat Modules give an effect, which scale depending on the current heat. A maximum of 74 heat can be gained per round. Not attacking in a round reduces the current heat by 50.",
		#"Upon reaching 100 heat, the tower becomes Overheated. At the end of the round, Overheated towers undergo Cooling, where they are unable to attack for the round. Cooling towers lose all heat at the end of the round.",
		"Towers that reach 100 heat lose all heat by the end of the round.",
		"",
		["Gain |0| that give some control over Heat Modules.", [plain_fragment__orange_abilities]],
		"",
		"Synergy level increases the effectiveness of the effect.",
		"",
	],
	[DomSyn_Orange],
	[
		"100% effectiveness.",
		"300% effectiveness.",
		"500% effectiveness.",
		"6000% effectiveness.", # reachable only by green tier 1
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[
		["|0| main attacks increases its heat. |1| gain bonus stats that increase in power the more heat they have.", [plain_fragment__orange_towers_apo, plain_fragment__orange_towers]],
		"Towers that reach max heat lose all heat by the end of the round.",
		""
	],
	ColorSynergy.Difficulty.EASY
	),
	
	synergy_id_to_syn_name_dictionary[SynergyID__Yellow] : ColorSynergy.new(SynergyID__Yellow, synergy_id_to_syn_name_dictionary[SynergyID__Yellow], [TowerColors.YELLOW], [11, 8, 5, 3],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_yellow, synergy_id_to_pic_map__big[SynergyID__Yellow],
	[
		"ENERGIZE: Create an Energy Battery with 1 energy.",
		["Energy Battery stores energy, up to a limit. |0|: gain energy based on synergy tier.", [plain_fragment__yellow_on_round_end]],
		"",
		["All |0| gain an Energy Module. Energy Modules allow a tower to consume 1 energy to gain special effects.", [plain_fragment__yellow_towers]],
		"",
		"Energy Battery and attached Modules (and Module's effects) persist even when the synergy is lost.",
		"",
	],
	[DomSyn_Yellow_GoldIncome, DomSyn_Yellow_EnergyBattery],
	[
		["|0|: |1|.", [plain_fragment__yellow_on_round_end, plain_fragment__yellow_gold_gain]],
		"Activates ENERGIZE. Battery has 2 energy capacity. Gain 1 energy per round.",
		"Activates ENERGIZE. Battery has 4 energy capacity. Gain 2 energy per round.",
		"Activates ENERGIZE. Battery has 9 energy capacity. Gain 3 energy per round.",
	],
	ColorSynergy.HighlightDeterminer.CUSTOM,
	{
		1: [0, 3],
		2: [0, 2],
		3: [0, 1],
		4: [0],
		0: [],
	},
	[
		"ENERGIZE: Create an Energy Battery with 1 energy.",
		["|0| can consume 1 energy to gain special effects.", [plain_fragment__yellow_towers]],
		""
	],
	ColorSynergy.Difficulty.EASY
	),
	
	synergy_id_to_syn_name_dictionary[SynergyID__Green] : ColorSynergy.new(SynergyID__Green, synergy_id_to_syn_name_dictionary[SynergyID__Green], [TowerColors.GREEN], [12, 8, 5, 3],
	[tier_prestigeW_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_green, synergy_id_to_pic_map__big[SynergyID__Green],
	[
		["Gain access to Adaptations, which grant various effects to |0|.", [plain_fragment__green_towers]],
		"New Adaptations are available per tier. Only one Adaptation can be selected per tier.",
		"",
		"Adaptations are active only when their tier requirement is met, unless otherwise stated.",
		""
	],
	[DomSyn_Green],
	[
		"Adapt: Foundation.",
		"Adapt: Bloom.",
		"Adapt: Triumph.",
		"Adapt: Beyond.", # reachable only by fruit tree
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW,
	{},
	[
		["Gain access to Adaptations, which grant various effects to |0|.", [plain_fragment__green_towers]],
		"New Adaptations are available per tier. Only one Adaptation can be selected per tier.",
		"",
	],
	ColorSynergy.Difficulty.EASY
	),
	
	synergy_id_to_syn_name_dictionary[SynergyID__Blue] : blue_syn,
	
	synergy_id_to_syn_name_dictionary[SynergyID__Violet] : ColorSynergy.new(SynergyID__Violet, synergy_id_to_syn_name_dictionary[SynergyID__Violet], [TowerColors.VIOLET], [5, 4, 3, 2],
	[tier_bronze_pic, tier_silver_pic, tier_gold_pic, tier_dia_pic],
	syn_dom_violet, synergy_id_to_pic_map__big[SynergyID__Violet],
	[
		["|0| can absorb more |1|.", [plain_fragment__violet_towers, plain_fragment__violet_ingredients]],
		["|0| can absorb ingredients regardless of color after being in the map for 1 round.", [plain_fragment__violet_towers]],
		"",
		"These effects apply only when the limit of total and Violet towers in the map is satisfied.",
		""
	],
	[DomSyn_Violet],
	[
		"+50 ingredients. 3 total tower limit, 2 violet tower limit.",
		"+5 ingredients. 6 total tower limit, 3 violet tower limit.",
		"+2 ingredients. 9 total tower limit, 4 violet tower limit.",
		"+1 ingredient. 14 total tower limit, 6 violet tower limit.",
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[],
	ColorSynergy.Difficulty.CHALLENGING
	),
	
	synergy_id_to_syn_name_dictionary[SynergyID__White] : ColorSynergy.new(SynergyID__White, synergy_id_to_syn_name_dictionary[SynergyID__White], [TowerColors.WHITE], [1],
	[tier_dia_pic],
	syn_dom_white, synergy_id_to_pic_map__big[SynergyID__White],
	[
		"White towers rely on the White synergy to channel their powers.",
	],
	[],
	[
		
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[],
	ColorSynergy.Difficulty.DIFFICULT
	),
	
	synergy_id_to_syn_name_dictionary[SynergyID__Black] : black_syn,
	
	}
	
	########
	
	for syn in synergies.values():
		for syn_id_tier_compo in syn.construct_all_possible_synergy_tier_ids():
			all_syn_id_tier_compos.append(syn_id_tier_compo)



func reset_synergies_instances_and_curr_tier():
	for syn in synergies.values():
		syn.reset_synergy_effects_instances_and_curr_tier()


func get_synergy_with_id(arg_id):
	if synergy_id_to_syn_name_dictionary.has(arg_id):
		var syn_name = synergy_id_to_syn_name_dictionary[arg_id]
		
		if synergies.has(syn_name):
			return synergies[syn_name]
	
	return null


#######

# must be done ON PreGameModifiers (BreakpointActivation.BEFORE_SINGLETONS_INIT). Not at any other time
func add_color_synergy(arg_synergy_id : String, arg_synergy_name : String, arg_big_pic : Texture, arg_synergy : ColorSynergy, arg_is_available : bool):
	synergy_id_to_syn_name_dictionary[arg_synergy_id] = arg_synergy_id
	synergy_id_to_pic_map__big[arg_synergy_id] = arg_big_pic
	
	for syn_id_tier_compo in arg_synergy.construct_all_possible_synergy_tier_ids():
		all_syn_id_tier_compos.append(syn_id_tier_compo)
	
	synergies[arg_synergy_name] = arg_synergy
	
	if arg_is_available and !available_synergy_ids.has(arg_synergy_id):
		available_synergy_ids.append(arg_synergy_id)

# must be done NOT during a GameElements playthrough
func set_color_synergy_is_available(arg_synergy_id : String, arg_is_available : bool):
	if arg_is_available and !available_synergy_ids.has(arg_synergy_id):
		available_synergy_ids.append(arg_synergy_id)
		
	elif !arg_is_available and available_synergy_ids.has(arg_synergy_id):
		available_synergy_ids.erase(arg_synergy_id)
	

# must be done ON PreGameModifiers (BreakpointActivation.BEFORE_SINGLETONS_INIT). Not at any other time
func set_color_synergy_banned_status(arg_synergy_id : String, arg_is_banned):
	_banned_syn_ids.append(arg_synergy_id)

