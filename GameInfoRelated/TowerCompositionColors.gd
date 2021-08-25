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
const AnaSyn_OrangeYR = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_OrangeYR/AnaSyn_OrangeYR.gd")
const AnaSyn_RedOV = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV/AnaSyn_RedOV.gd")
const AnaSyn_YellowGO = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_YellowGO/AnaSyn_YellowGO.gd")
const AnaSyn_GreenBY = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_GreenBY/AnaSyn_GreenBY.gd")

const TriaSyn_RYB = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_RYB/TriaSyn_RYB.gd")

var inst_complesyn_yelvio_energymodule : CompleSyn_YelVio_EnergyModule


func _init():
	inst_complesyn_yelvio_energymodule = CompleSyn_YelVio_EnergyModule.new(TowerDominantColors.inst_domsyn_yellow_energybattery)
	
	synergies = {
	# Comple
	"RedGreen" : ColorSynergy.new("RedGreen", [TowerColors.RED, TowerColors.GREEN], [5, 4, 3, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_compo_compli_redgreen,
	[
		"RedGreen description"
	],
	[],
	[
		""
	]),
	
	"YellowViolet" : ColorSynergy.new("YellowViolet", [TowerColors.YELLOW, TowerColors.VIOLET], [5, 4, 3, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_compo_compli_yellowviolet,
	[
		"Gain bonuses depending on this synergy's tier.",
		""
	],
	[inst_complesyn_yelvio_energymodule, CompleSyn_YelVio_YellowIng.new()],
	[
		"Gain 2 energy after a round when that round is won.",
		"Gain 1 energy after a round when that round is lost.",
		"Yellow towers can absorb 3 more ingredients.",
		"Violet towers can now gain an Energy Module from the Yellow Synergy."
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	),
	
	"OrangeBlue" : ColorSynergy.new("OrangeBlue", [TowerColors.ORANGE, TowerColors.BLUE], [5, 4, 3, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_compli_orangeblue,
	[
		"Main attacks of towers explode every few seconds.",
		"Explosions deal 3 elemental damage to 3 enemies.",
		"Explosions benefit from base damage and on hit damage buffs at 20% efficiency. Explosions also benefit from explosion size buffs.",
		"",
		"Towers with overheating heat modules gain 35% cooldown reduction for the explosion.",
		"Explosion's damage scales with the tower's ability potency.",
		""
	],
	[CompleSyn_OrangeBlue.new()],
	[
		"Explosion per 1.0 seconds. Explosions are 100% larger.",
		"Explosion per 2.5 seconds. Explosions are 75% larger.",
		"Explosion per 5.0 seconds. Explosions are 25% larger.",
		"Explosion per 8.0 seconds."
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	
	# Ana
	"RedOV" : ColorSynergy.new("RedOV", [TowerColors.RED, TowerColors.ORANGE, TowerColors.VIOLET], [3, 2, 1],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_redOV,
	[
		"All towers gain armor pierce and toughness pierce. These bonuses are doubled for the round after killing 4 enemies or dealing 140 post-mitigated damage."
	],
	[AnaSyn_RedOV.new()],
	[
		"+15 armor and toughness pierce.",
		"+9 armor and toughness pierce.",
		"+4 armor and toughness pierce."
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"OrangeYR" : ColorSynergy.new("OrangeYR", [TowerColors.ORANGE, TowerColors.YELLOW, TowerColors.RED], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_orangeYR,
	[
		"All towers gain attack speed after attacking, which stacks up to a limit. Bonuses received per attack inversely scales with tower's attack speed.",
		""
	],
	[AnaSyn_OrangeYR.new()],
	[
		"110% attack speed",
		"70% attack speed",
		"45% attack speed",
		"15% attack speed",
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"YellowGO" : ColorSynergy.new("YellowGO", [TowerColors.YELLOW, TowerColors.GREEN, TowerColors.ORANGE], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_yellowGO,
	[
		"Brings about a Fluctuation, which buffs a tower for 3 seconds. Fluctuation then seeks another tower to buff.",
		"Cycle: Fluctuation first goes to the first tower that attacks. Afterwards, Fluctuation loops to the highest base damage tower, then to the highest attack speed tower, then to the tower that has dealt the most damage in the round.",
		"Fluctuation cannot re-target to the same tower. Fluctuation will avoid towers that cannot attack, or with no enemies in its range. When no viable towers are found, the Cycle is reset.",
		"",
		"A Fluctuated tower gains buffs.",
		""
	],
	[AnaSyn_YellowGO.new()],
	[
		"+8.00 elemental on hit damage, +160% total base damage, +160% total attack speed, +50% base range.",
		"+5.00 elemental on hit damage, +130% total base damage, +130% total attack speed, +40% base range",
		"+2.50 elemental on hit damage, +65% total base damage, +65% total attack speed, +20% base range.",
		"+1.25 elemental on hit damage, +20% total base damage, +20% total attack speed, +10% base range."
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"GreenBY" : ColorSynergy.new("GreenBY", [TowerColors.GREEN, TowerColors.BLUE, TowerColors.YELLOW], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_greenBY,
	[
		"Towers gain bonus elemental damage on hit per main attack, up to a limit. The bonus can be granted only once per second.",
		""
	],
	[AnaSyn_GreenBY.new()],
	[
		"+0.60 on hit, up to 6",
		"+0.25 on hit, up to 5",
		"+0.15 on hit, up to 3",
		"+0.05 on hit, up to 1"
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"BlueVG" : ColorSynergy.new("BlueVG", [TowerColors.BLUE, TowerColors.VIOLET, TowerColors.GREEN], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_blueVG,
	[
		"Most abilities's cooldowns are reduced.",
		""
	],
	[AnaSyn_BlueVG.new()],
	[
		"80% reduction",
		"60% reduction",
		"30% reduction",
		"10% reduction"
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"VioletRB" : ColorSynergy.new("VioletRB", [TowerColors.VIOLET, TowerColors.RED, TowerColors.BLUE], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_violetRB,
	[
		"Each absorbed active ingredient gives additional effects.",
		"Only 10% of the bonus effect is gained when the additional ingredient absorbed is beyond the limit given by relics or natural leveling.",
		""
	],
	[AnaSyn_VioletRB.new()],
	[
		"+3 physical on hit damage",
		"+1 physical on hit damage",
		"+1 elemental on hit damage",
		"+20 range"
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	),
	
	
	#Tria
	"RYB" : ColorSynergy.new("RYB", [TowerColors.RED, TowerColors.YELLOW, TowerColors.BLUE], [3, 2, 1],#[4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_tria_RYB,
	[
		"Enemies that reach the end of the track for the first time are instead brought back to the start of the track.",
		"Enemies brought back heal for 40% of their missing health, and receive damage resistance. The damage resistance cannot be removed by any means.",
		"",
		"\"Just when you thought that you did it...\"",
		""
	],
	[TriaSyn_RYB.new()],
	[
		"40% damage resistance",
		"50% damage resistance",
		"65% damage resistance"
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"OGV" : ColorSynergy.new("OGV", [TowerColors.ORANGE, TowerColors.GREEN, TowerColors.VIOLET], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_tria_OGV,
	[
		"",
		""
	],
	[],
	[
		"",
		"",
		""
	]
	),
	
	
	# Special
#	"ROYGBV" : ColorSynergy.new("ROYGBV", [TowerColors.RED, TowerColors.ORANGE, TowerColors.YELLOW, TowerColors.GREEN, TowerColors.BLUE, TowerColors.VIOLET], 
#	[2, 1],
#	[tier_dia_pic, tier_gold_pic],
#	syn_compo_special_ROYGBV,
#	["ROYGBV description"]),
	
#	"RGB" : ColorSynergy.new("RGB", [TowerColors.RED, TowerColors.GREEN, TowerColors.BLUE], [3, 2, 1],
#	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
#	syn_compo_special_RGB,
#	["RGB description"]),
	
}

var synergies : Dictionary
