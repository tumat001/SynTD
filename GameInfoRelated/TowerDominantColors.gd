extends Node

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

const tier_bronze_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Bronze.png")
const tier_silver_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Silver.png")
const tier_gold_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Gold.png")
const tier_dia_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Diamond.png")

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

var inst_domsyn_yellow_energybattery : DomSyn_Yellow_EnergyBattery


func _init():
	inst_domsyn_yellow_energybattery = DomSyn_Yellow_EnergyBattery.new()
	
	synergies = {
	"Red" : ColorSynergy.new("Red", [TowerColors.RED], [6, 4, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_dom_red,
	["RED description"]),
	
	"Orange" : ColorSynergy.new("Orange", [TowerColors.ORANGE], [12, 9, 6, 3],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_orange,
	[
		"Orange towers gain Heat Modules. Heat Module gains heat per main attack of a tower. The heat per attack depends on the tower.",
		"Heat Modules give an effect, which scale depending on the current heat. A maximum of 75 heat can be gained per round. Not attacking in a round reduces the current heat by 50.",
		"Upon reaching 100 heat, the tower becomes Overheated. At the end of the round, Overheated towers undergo Cooling, where they are unable to attack for the round. Cooling towers lose all heat at the end of the round.",
		"",
		"Synergy level increases the effectiveness of the effect.",
		"",
	],
	[DomSyn_Orange.new()],
	[
		"340% effectiveness",
		"220% effectiveness",
		"150% effectiveness",
		"100% effectiveness",
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"Yellow" : ColorSynergy.new("Yellow", [TowerColors.YELLOW], [7, 5, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_yellow,
	[
		"ENERGIZE: Creates an Energy Battery with 1 energy if one is not present. All yellow towers gain an energy module during the round.",
		"",
		"Energy Battery allows storage of energy.",
		"Energy Modules allow a tower to spend 1 energy to gain special effects.",
		"",
		"Energy Battery and Modules (and module's effects) persist even when the synergy is lost. The Energy Module of a tower persists even when the tower is benched.",
		"",
	],
	[DomSyn_Yellow_GoldIncome.new(), inst_domsyn_yellow_energybattery],
	[
		"Activates ENERGIZE. Battery has 5 energy capacity. Battery recharges for 2 energy per turn.",
		"Activates ENERGIZE. Battery has 2 energy capacity. Battery recharges for 1 energy per turn.",
		"+1 gold per round."
	],
	ColorSynergy.HighlightDeterminer.CUSTOM,
	{
		1: [2, 0],
		2: [2, 1],
		3: [2],
		0: [],
	}
	),
	
	"Green" : ColorSynergy.new("Green", [TowerColors.GREEN], [3],
	[tier_bronze_pic],
	syn_dom_green,
	["GREEN description"]),
	
	"Blue" : ColorSynergy.new("Blue", [TowerColors.BLUE], [9, 7, 5, 3],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_dom_blue,
	["BLUE description"]),
	
	"Violet" : ColorSynergy.new("Violet", [TowerColors.VIOLET], [5, 4, 3, 2],
	[tier_silver_pic, tier_bronze_pic, tier_gold_pic, tier_dia_pic],
	syn_dom_violet,
	[
		"Violet towers can absorb more ingredients. This synergy applies only when there are a certain amount of towers or less in the map. Getting duplicate violet towers also disables the effects of this synergy.",
		"",
	],
	[DomSyn_Violet.new()],
	[
		"+9 ingredients, 13 tower limit",
		"+8 ingredients, 9 tower limit",
		"+12 ingredients, 6 tower limit",
		"+40 ingredients, 3 tower limit",
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"White" : ColorSynergy.new("White", [TowerColors.WHITE], [1],
	[tier_dia_pic],
	syn_dom_white,
	["WHITE description"]),
	
	"Black" : ColorSynergy.new("Black", [TowerColors.BLACK], [1],
	[tier_dia_pic],
	syn_dom_black,
	["BLACK description"])
}

var synergies : Dictionary
