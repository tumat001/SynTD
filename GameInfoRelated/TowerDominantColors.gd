extends Node

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")


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

var inst_domsyn_yellow_energybattery : DomSyn_Yellow_EnergyBattery

var synergies : Dictionary

func _init():
	inst_domsyn_yellow_energybattery = DomSyn_Yellow_EnergyBattery.new()
	
	#
	
	var interpreter_for_blue_ap_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_blue_ap_tier_1.display_body = false
	
	var ins_for_blue_ap_tier_1 = []
	ins_for_blue_ap_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", 0.25, false))
	
	interpreter_for_blue_ap_tier_1.array_of_instructions = ins_for_blue_ap_tier_1
	
	
	var interpreter_for_blue_ap_tier_2 : TextFragmentInterpreter = interpreter_for_blue_ap_tier_1.get_deep_copy()
	interpreter_for_blue_ap_tier_2.array_of_instructions[0].num_val = 0.25
	
	var interpreter_for_blue_ap_tier_3 : TextFragmentInterpreter = interpreter_for_blue_ap_tier_1.get_deep_copy()
	interpreter_for_blue_ap_tier_3.array_of_instructions[0].num_val = 0.25
	
	
	
	var blue_syn = ColorSynergy.new("Blue", [TowerColors.BLUE], [8, 5, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_blue,
	[
		"Gain access to Blue Abilities.",
		"Additionally, all Blue towers gain ability potency.",
		""
	],
	[DomSyn_Blue.new()],
	[
		["Renew & Empower : Multi purpose abilities. +|0|.", [interpreter_for_blue_ap_tier_1]],
		["Mana Blast: Big AOE damage, and AOE ability potency buff. +|0|.", [interpreter_for_blue_ap_tier_2]],
		["Sea Breeze : Slow and minor damage to all enemies. +|0|.", [interpreter_for_blue_ap_tier_3]]
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	)
	
	
	
	
	var interpreter_for_black_attk_speed_give = TextFragmentInterpreter.new()
	interpreter_for_black_attk_speed_give.display_body = false
	
	var ins_for_black_attk_speed_give = []
	ins_for_black_attk_speed_give.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 20, true))
	
	interpreter_for_black_attk_speed_give.array_of_instructions = ins_for_black_attk_speed_give
	
	
	var interpreter_for_black_bonus_dmg = TextFragmentInterpreter.new()
	interpreter_for_black_bonus_dmg.display_body = false
	
	var ins_for_black_bonus_dmg = []
	ins_for_black_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "", 10, true))
	
	interpreter_for_black_bonus_dmg.array_of_instructions = ins_for_black_bonus_dmg
	
	
	var black_syn = ColorSynergy.new("Black", [TowerColors.BLACK], [11, 8, 6, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_black,
	[
		"Black towers gain bonus stats and effects."
	],
	[DomSyn_Black.new()],
	[
		"The chosen dark path is upgraded.",
		"Choose one of the four dark paths to take.",
		["Main attacks on hit causes the attacking tower to give a random black tower |0| for 6 attacks for 5 seconds. This effect has a 3 second cooldown.", [interpreter_for_black_attk_speed_give]],
		["Damage is increased by |0|.", [interpreter_for_black_bonus_dmg]]
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	)
	
	
	#
	
	
	# ------------------------------------------------------
	
	synergies = {
	"Red" : ColorSynergy.new("Red", [TowerColors.RED], [9, 6, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_dom_red,
	[
		"Opens the Pact shop, which shows a list of up to three unsworn pacts. At the end of each round, a new unsworn pact is added.",
		"Swearing a Pact activates its buffs and debuffs. Up to 3 pacts can be sworn at a time. Swearing a pact at the limit will remove the oldest sworn pact along with its effects unless stated otherwise.",
		"Synergy level requirements must be met for a pact to take effect.",
		"",
		"Synergy level affects the quality and types of unsworn pacts that appear in the shop.",
	],
	[DomSyn_Red.new()],
	[
		"Advanced Shop",
		"Intermediate Shop",
		"Basic shop"
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"Orange" : ColorSynergy.new("Orange", [TowerColors.ORANGE], [12, 9, 6, 3],
	[tier_prestigeW_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_orange,
	[
		"Orange towers gain Heat Modules. Heat Modules gain heat per main attack of a tower. The heat gained per attack depends on the tower.",
		"Heat Modules give an effect, which scale depending on the current heat. A maximum of 74 heat can be gained per round. Not attacking in a round reduces the current heat by 50.",
		#"Upon reaching 100 heat, the tower becomes Overheated. At the end of the round, Overheated towers undergo Cooling, where they are unable to attack for the round. Cooling towers lose all heat at the end of the round.",
		"Towers that reach 100 heat lose all heat by the end of the round.",
		"",
		"Gain abilities that give some control over Heat Modules.",
		"",
		"Synergy level increases the effectiveness of the effect.",
		"",
	],
	[DomSyn_Orange.new()],
	[
		"6000% effectiveness", # reachable only by green tier 1
		"500% effectiveness",
		"300% effectiveness",
		"100% effectiveness",
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"Yellow" : ColorSynergy.new("Yellow", [TowerColors.YELLOW], [10, 8, 5, 3],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_yellow,
	[
		"ENERGIZE: Creates an Energy Battery with 1 energy.",
		"Energy Battery stores energy, up to a limit. Energy is gained per end of round.",
		"",
		"All yellow towers gain an Energy Module. Energy Modules allow a tower to consume 1 energy to gain special effects.",
		"",
		"Energy Battery and attached Modules (and Module's effects) persist even when the synergy is lost.",
		"",
	],
	[DomSyn_Yellow_GoldIncome.new(), inst_domsyn_yellow_energybattery],
	[
		"Activates ENERGIZE. Battery has 9 energy capacity. Gain 3 energy per turn.",
		"Activates ENERGIZE. Battery has 6 energy capacity. Gain 2 energy per turn.",
		"Activates ENERGIZE. Battery has 4 energy capacity. Gain 1 energy per turn.",
		"+1 gold per round."
	],
	ColorSynergy.HighlightDeterminer.CUSTOM,
	{
		1: [3, 0],
		2: [3, 1],
		3: [3, 2],
		4: [3],
		0: [],
	}
	),
	
	"Green" : ColorSynergy.new("Green", [TowerColors.GREEN], [12, 8, 5, 3],
	[tier_prestigeW_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_green,
	[
		"Gain access to Adaptations, which grant various effects.",
		"New Adaptations are available per tier. Only one Adaptation can be selected per tier.",
		"",
		"Adaptations are active only when their tier requirement is met, unless otherwise stated.",
		""
	],
	[DomSyn_Green.new()],
	[
		"Adapt: Beyond", # reachable only by fruit tree
		"Adapt: Triumph",
		"Adapt: Bloom",
		"Adapt: Foundation"
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	),
	
	"Blue" : blue_syn,
	
	"Violet" : ColorSynergy.new("Violet", [TowerColors.VIOLET], [5, 4, 3, 2],
	[tier_bronze_pic, tier_silver_pic, tier_gold_pic, tier_dia_pic],
	syn_dom_violet,
	[
		"Violet towers can absorb more ingredients.",
		"Violet towers can absorb ingredients regardless of color after being in the map for 1 round.",
		"",
		"These effects apply only when the limit of total and Violet towers in the map is satisfied.",
		""
	],
	[DomSyn_Violet.new()],
	[
		"+2 ingredients. 14 total tower limit, 6 violet tower limit",
		"+3 ingredients. 9 total tower limit, 4 violet tower limit",
		"+5 ingredients. 6 total tower limit, 3 violet tower limit",
		"+50 ingredients. 3 total tower limit, 2 violet tower limit.",
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"White" : ColorSynergy.new("White", [TowerColors.WHITE], [1],
	[tier_dia_pic],
	syn_dom_white,
	[
		"White towers rely on the White synergy to channel their powers.",
	]),
	
	"Black" : black_syn,
	
#	"Black" : ColorSynergy.new("Black", [TowerColors.BLACK], [11, 8, 6, 2],
#	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
#	syn_dom_black,
#	[
#		"Black tower's attacks give a stack of Corruption to enemies on hit. Black towers with base damages 5.5 or higher will apply 3 stacks instead.",
#		"Corruption stacks last for 15 seconds. Re-applications refresh all stacks.",
#		"Black towers that hit enemies with a certain number of stacks cause effects.",
#		"",
#	],
#	[DomSyn_Black.new()],
#	[
#		"10+ stacks: All attacks deal 10% of the enemy's missing health as elemental damage on hit, up to 7.",
#		"7+ stacks: Main attacks on hit cause a black beam to hit a random enemy in range. This can only be triggered every 0.1 seconds. The beam deals 1.5 physical damage, and benefits from base damage and on hit damage buffs at 25% efficiency. Also applies on hit effects.",
#		"5+ stacks: Main attacks on hit causes the attacking tower to give a random black tower 30% bonus attack speed for 6 attacks for 5 seconds. This effect has a 3 second cooldown.",
#		"2+ stacks: All attack's damage is increased by 10%."
#	],
#	ColorSynergy.HighlightDeterminer.ALL_BELOW
#	)
}
