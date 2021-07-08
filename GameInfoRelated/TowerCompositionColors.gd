extends Node

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")

const tier_bronze_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Bronze.png")
const tier_silver_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Silver.png")
const tier_gold_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Gold.png")
const tier_dia_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Diamond.png")
const tier_prestigeW_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Tier_Prestige_White.png")

const syn_compo_compli_redgreen = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Comple_RedGreen.png")
const syn_compo_compli_yellowviolet = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Comple_YellowViolet.png")
const syn_compo_compli_orangeblue = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Comple_OrangeBlue.png")

const syn_compo_ana_redOV = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Ana_RedOrangeViolet.png")
const syn_compo_ana_orangeYR = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Ana_OrangeYellowRed.png")
const syn_compo_ana_yellowGO = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Ana_YellowGreenOrange.png")
const syn_compo_ana_greenBY = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Ana_GreenBlueYellow.png")
const syn_compo_ana_blueVG = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Ana_BlueVioletGreen.png")
const syn_compo_ana_violetRB = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Ana_VioletRedBlue.png")

const syn_compo_tria_RYB = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Tria_RedYellowBlue.png")
const syn_compo_tria_OGV = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Tria_OrangeGreenViolet.png")

const syn_compo_special_RGB = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Special_RedGreenBlue.png")
const syn_compo_special_ROYGBV = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Special_ROYGBV.png")

# syns

const CompleSyn_YelVio_EnergyModule = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio/CompliSyn_YelVio_EnergyModule.gd")
const CompleSyn_YelVio_YellowIng = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio/CompliSyn_YelVio_YellowIng.gd")
const CompleSyn_OrangeBlue = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/CompliSyn_OrangeBlue.gd")

const AnaSyn_BlueVG = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_BlueVG/AnaSyn_BlueVG.gd")
const AnaSyn_VioletRB = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB/AnaSyn_VioletRB.gd")

var inst_complesyn_yelvio_energymodule : CompleSyn_YelVio_EnergyModule


func _init():
	inst_complesyn_yelvio_energymodule = CompleSyn_YelVio_EnergyModule.new(TowerDominantColors.inst_domsyn_yellow_energybattery)
	
	synergies = {
	# Comple
	"RedGreen" : ColorSynergy.new("RedGreen", [TowerColors.RED, TowerColors.GREEN], [9, 6, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_compo_compli_redgreen,
	["RedGreen description"]),
	
	"YellowViolet" : ColorSynergy.new("YellowViolet", [TowerColors.YELLOW, TowerColors.VIOLET], [5, 4, 3, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_compo_compli_yellowviolet,
	[
		"Gain bonuses depending on this synergy's tier.",
		""
	],
	[inst_complesyn_yelvio_energymodule, CompleSyn_YelVio_YellowIng.new()],
	[
		"Gain +1 energy after a round when that round is won.",
		"Gain +1 energy after a round when that round is lost.",
		"Yellow towers can absorb 3 more ingredients.",
		"Violet towers can now gain an Energy Module from the Yellow Synergy."
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	),
	
	"OrangeBlue" : ColorSynergy.new("OrangeBlue", [TowerColors.ORANGE, TowerColors.BLUE], [6, 5, 4, 3],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_compli_orangeblue,
	[
		"Heat modules that becomes overheated causes towers's shots to explode every x seconds.",
		"Explosions deal 1.5 elemental damage to two enemies, but not including the main target.",
		"Explosions benefit from base damage on on hit damage buffs at 50% efficiency. Explosions also benefit from explosion size buffs.",
		"",
		"All towers also gain ability potency.",
		""
	],
	[CompleSyn_OrangeBlue.new()],
	[
		"Explosion per 1 second. Towers gain 1 ap. Explosions are 100% bigger.",
		"Explosion per 1.5 seconds. Towers gain 0.75 ap. Explosions are 50% bigger.",
		"Explosion per 2.25 seconds. Towers gain 0.50 ap. Explosions are 25% bigger.",
		"Explosion per 3.0 seconds. Towers gain 0.25 ap."
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	
	# Ana
	"RedOV" : ColorSynergy.new("RedOV", [TowerColors.RED, TowerColors.ORANGE, TowerColors.VIOLET], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_redOV,
	["RedOV description"]),
	
	"OrangeYR" : ColorSynergy.new("OrangeYR", [TowerColors.ORANGE, TowerColors.YELLOW, TowerColors.RED], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_orangeYR,
	["OrangeYR description"]),
	
	"YellowGO" : ColorSynergy.new("YellowGO", [TowerColors.YELLOW, TowerColors.GREEN, TowerColors.ORANGE], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_yellowGO,
	["YellowGO description"]),
	
	"GreenBY" : ColorSynergy.new("GreenBY", [TowerColors.GREEN, TowerColors.BLUE, TowerColors.YELLOW], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_greenBY,
	["GreenBY description"]),
	
	"BlueVG" : ColorSynergy.new("BlueVG", [TowerColors.BLUE, TowerColors.VIOLET, TowerColors.GREEN], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_blueVG,
	[
		"Most abilities gain cooldown reduction.",
		""
	],
	[AnaSyn_BlueVG.new()],
	[
		"80% cdr",
		"55% cdr",
		"35% cdr"
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"VioletRB" : ColorSynergy.new("VioletRB", [TowerColors.VIOLET, TowerColors.RED, TowerColors.BLUE], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_violetRB,
	[
		"Each absorbed active ingredient gives additional effects.",
		"Only 10% of the bonus effect is gained when the additional ingredient absorbed is beyond the limit given by natural leveling and relics.",
		""
	],
	[AnaSyn_VioletRB.new()],
	[
		"+4 physical on hit damage",
		"+1.5 physical on hit damage",
		"+1.5 elemental on hit damage",
		"+30 range"
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
		),
	
	
	#Tria
	"RYB" : ColorSynergy.new("RYB", [TowerColors.RED, TowerColors.YELLOW, TowerColors.BLUE], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_tria_RYB,
	["RYB description"]),
	
	"OGV" : ColorSynergy.new("OGV", [TowerColors.ORANGE, TowerColors.GREEN, TowerColors.VIOLET], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_tria_OGV,
	["OGV description"]),
	
	
	# Special
	"RGB" : ColorSynergy.new("RGB", [TowerColors.RED, TowerColors.GREEN, TowerColors.BLUE], [3, 2, 1],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_special_RGB,
	["RGB description"]),
	
	"ROYGBV" : ColorSynergy.new("ROYGBV", [TowerColors.RED, TowerColors.ORANGE, TowerColors.YELLOW, TowerColors.GREEN, TowerColors.BLUE, TowerColors.VIOLET], 
	[3, 2, 1],
	[tier_prestigeW_pic, tier_dia_pic, tier_gold_pic],
	syn_compo_special_ROYGBV,
	["ROYGBV description"]),
}

var synergies : Dictionary
