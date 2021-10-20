extends Node

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

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
	
	synergies = {
	"Red" : ColorSynergy.new("Red", [TowerColors.RED], [9, 6, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_dom_red,
	[
		"Opens the Pact shop, which shows a list of up to three unsworn pacts. At the end of each round, a new unsworn pact is added.",
		"The Pact shop also allows the swearing of a Pact, during which the Pact's buffs and debuffs take effect. Only up to 3 pacts can be sworn at a time. Attempting to swear another pact will remove the oldest sworn pact.",
		"",
		"Synergy level affects the quality and types of unsworn pacts that appear in the shop.",
		"",
		"Not having the Red synergy active while having sworn pacts will cause you to take 10 damage at the end of each round. Also, no new unsworn pacts will be added."
	],
	[DomSyn_Red.new()]
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
		"450% effectiveness",
		"250% effectiveness",
		"100% effectiveness",
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"Yellow" : ColorSynergy.new("Yellow", [TowerColors.YELLOW], [10, 8, 6, 4],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_yellow,
	[
		"ENERGIZE: Creates an Energy Battery with 1 energy if one is not present. All yellow towers gain an energy module.",
		"",
		"Energy Battery allows storage of energy.",
		"Energy Modules allow a tower to absorb 1 energy to gain special effects.",
		"",
		"Energy Battery and attached Modules (and Module's effects) persist even when the synergy is lost. The Energy Module of a tower persists even when the tower is benched.",
		"",
	],
	[DomSyn_Yellow_GoldIncome.new(), inst_domsyn_yellow_energybattery],
	[
		"Activates ENERGIZE. Battery has 9 energy capacity. Battery recharges for 3 energy per turn.",
		"Activates ENERGIZE. Battery has 6 energy capacity. Battery recharges for 2 energy per turn.",
		"Activates ENERGIZE. Battery has 4 energy capacity. Battery recharges for 1 energy per turn.",
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
	
	"Green" : ColorSynergy.new("Green", [TowerColors.GREEN], [12, 8, 6, 3],
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
	
	"Blue" : ColorSynergy.new("Blue", [TowerColors.BLUE], [8, 6, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_blue,
	[
		"Gain access to Blue Abilities.",
		"Additionally, all Blue towers gain bonus ability potency.",
		""
	],
	[DomSyn_Blue.new()],
	[
		"Renew & Empower : Multi purpose abilities. +0.25 Ability Potency.",
		"Mana Blast: Big AOE damage, and AOE Ability Potency buff. +0.25 Ability Potency.",
		"Sea Breeze : Slow and minor damage to all enemies. +0.25 Ability Potency."
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	),
	
	"Violet" : ColorSynergy.new("Violet", [TowerColors.VIOLET], [5, 4, 3, 2],
	[tier_bronze_pic, tier_silver_pic, tier_gold_pic, tier_dia_pic],
	syn_dom_violet,
	[
		"Violet towers can absorb more ingredients. This effect applies only when the limit of total and Violet towers in the map is satisfied.",
		"",
		"Violet towers can absorb ingredients regardless of color after being in the map for 1 round.",
		"",
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
		"Hero relies on the color White to channel its powers.",
	]),
	
	"Black" : ColorSynergy.new("Black", [TowerColors.BLACK], [11, 8, 6, 3],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_black,
	[
		"Black tower's attacks give a stack of Corruption to enemies on hit. Black towers with base damages 5.5 or higher will apply 5 stacks instead.",
		"Corruption stacks last for 15 seconds. Re-applications refresh all stacks.",
		"Black towers that hit enemies with a certain number of stacks cause effects.",
		"",
	],
	[DomSyn_Black.new()],
	[
		"10+ stacks: All attacks deal 10% of the enemy's missing health as elemental damage on hit, up to 7.",
		"7+ stacks: Main attacks on hit cause a black beam to hit a random enemy in range. This can only be triggered every 0.1 seconds. The beam deals 1.5 physical damage, and benefits from base damage and on hit damage buffs at 30% efficiency. Also applies on hit effects.",
		"5+ stacks: Main attacks on hit causes the attacking tower to give a random black tower 40% bonus attack speed for 6 attacks for 8 seconds. This effect has a 3 second cooldown.",
		"2+ stacks: All attack's damage is increased by 15%."
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	)
}
