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
const CompliSyn_RedGreen = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/CompliSyn_RedGreen.gd")

const AnaSyn_BlueVG = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_BlueVG/AnaSyn_BlueVG.gd")
const AnaSyn_VioletRB = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB/AnaSyn_VioletRB.gd")
const AnaSyn_OrangeYR = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_OrangeYR/AnaSyn_OrangeYR.gd")
const AnaSyn_RedOV = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV/AnaSyn_RedOV.gd")
const AnaSyn_YellowGO = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_YellowGO/AnaSyn_YellowGO.gd")
const AnaSyn_GreenBY = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_GreenBY/AnaSyn_GreenBY.gd")

const TriaSyn_RYB = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_RYB/TriaSyn_RYB.gd")
const TriaSyn_OGV = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_OGV/TriaSyn_OGV.gd")

var inst_complesyn_yelvio_energymodule : CompleSyn_YelVio_EnergyModule


func _init():
	inst_complesyn_yelvio_energymodule = CompleSyn_YelVio_EnergyModule.new(TowerDominantColors.inst_domsyn_yellow_energybattery)
	
	synergies = {
	# Comple
	"RedGreen" : ColorSynergy.new("RedGreen", [TowerColors.RED, TowerColors.GREEN], [5, 4, 3],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_compo_compli_redgreen,
	[
		"Main attacks on hit apply a stack of Red or Green Technique, depending on the tower's color. Normal enemies receive 2 stacks instead.",
		"Applying a Technique while a different colored Technique exists on an enemy erases all applied Technique stacks, and triggers Detonation effects of the pre-existing Technique.",
		"",
		"Red Detonation: Deal additional physical damage.",
		"10+ stacks) Tantrum: Rapidly shoot (5 + 1/2 of total stacks) red bolts to random enemies in range. Bolts deal physical damage.",
		"",
		"Green Detonation: Gain a single use effect shield for a duration.",
		"10+ stacks) Pulse: Towers caught in the pulse receive healing, and have their next (3 + 1/5 of total stacks) attacks apply a slow for 8 seconds. Number of stacks inceases healing, size of Pulse, and the slow's effectiveness.",
		"",
	],
	[CompliSyn_RedGreen.new()],
	[
		"(Red: 0.4 dmg per stack, 6.0 damage per bolt.) (Green: 0.5 seconds per stack. 40% slow minimum.)",
		"(Red: 0.3 dmg per stack, 4.5 damage per bolt.) (Green: 0.4 seconds per stack. 30% slow minimum.)",
		"(Red: 0.2 dmg per stack, 3.5 damage per bolt.) (Green: 0.3 seconds per stack. 20% slow minimum.)",
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"YellowViolet" : ColorSynergy.new("YellowViolet", [TowerColors.YELLOW, TowerColors.VIOLET], [5, 4, 3, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_compo_compli_yellowviolet,
	[
		"Gain bonuses depending on this synergy's tier.",
		""
	],
	[inst_complesyn_yelvio_energymodule, CompleSyn_YelVio_YellowIng.new()],
	[
		"Gain 1 energy after a round when that round is won.",
		"Gain 2 energy after a round when that round is lost.",
		"Yellow towers can absorb 1 more ingredient.",
		"Violet towers can now gain an Energy Module from the Yellow Synergy.",
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	),
	
	"OrangeBlue" : ColorSynergy.new("OrangeBlue", [TowerColors.ORANGE, TowerColors.BLUE], [5, 4, 3, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_compli_orangeblue,
	[
		"Main attacks of towers explode every few seconds.",
		"Explosions deal 4 elemental damage to 3 enemies.",
		"Explosions benefit from base damage and on hit damage buffs at 20% efficiency. Explosions also benefit from explosion size buffs.",
		"",
		"Towers with overheating heat modules gain 50% cooldown reduction for the explosion, and explosions deal 25% increased damage.",
		"Explosion's damage scales with the tower's ability potency.",
		""
	],
	[CompleSyn_OrangeBlue.new()],
	[
		"Explosion per 0.4 seconds. Explosions are 100% larger.",
		"Explosion per 1.5 seconds. Explosions are 75% larger.",
		"Explosion per 4.5 seconds. Explosions are 25% larger.",
		"Explosion per 10.0 seconds."
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	
	# Ana
	"RedOV" : ColorSynergy.new("RedOV", [TowerColors.RED, TowerColors.ORANGE, TowerColors.VIOLET], [3, 2, 1],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_redOV,
	[
		"All towers gain armor pierce and toughness pierce. These bonuses are doubled for the round after killing 4 enemies or dealing 140 post-mitigated damage.",
		""
	],
	[AnaSyn_RedOV.new()],
	[
		"+14 armor and toughness pierce.",
		"+8 armor and toughness pierce.",
		"+4 armor and toughness pierce."
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"OrangeYR" : ColorSynergy.new("OrangeYR", [TowerColors.ORANGE, TowerColors.YELLOW, TowerColors.RED], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_orangeYR,
	[
		"All towers gain attack speed after attacking, which stacks up to a limit. Bonuses received per attack inversely scales with tower's attack speed.",
		"It takes 15 seconds worth of attacks to reach the limit.",
		""
	],
	[AnaSyn_OrangeYR.new()],
	[
		"Up to 150% attack speed",
		"Up to 95% attack speed",
		"Up to 40% attack speed",
		"Up to 15% attack speed",
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"YellowGO" : ColorSynergy.new("YellowGO", [TowerColors.YELLOW, TowerColors.GREEN, TowerColors.ORANGE], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_yellowGO,
	[
		"Brings about a Fluctuation, which buffs a tower for 3 seconds. Fluctuation then seeks another tower to buff.",
		"Cycle: Fluctuation goes to the first tower that attacks. Afterwards, Fluctuation loops to the highest base damage tower, then to the highest attack speed tower, then to the tower that has dealt the most damage in the round.",
		"Fluctuation cannot re-target to the same tower. Fluctuation will avoid towers that cannot attack, or with no enemies in its range. When no viable towers are found, the Cycle is reset.",
		"",
		"A Fluctuated tower gains buffs.",
		""
	],
	[AnaSyn_YellowGO.new()],
	[
		"+6.0 elemental on hit damage, +150% total base damage, +150% total attack speed, +50% base range.",
		"+3.5 elemental on hit damage, +80% total base damage, +80% total attack speed, +30% base range",
		"+2.0 elemental on hit damage, +40% total base damage, +40% total attack speed, +20% base range.",
		"+1.0 elemental on hit damage, +20% total base damage, +20% total attack speed, +10% base range."
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
		"+0.35 on hit, up to 7.0",
		"+0.18 on hit, up to 3.6",
		"+0.07 on hit, up to 1.4",
		"+0.03 on hit, up to 0.6"
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
		"50% reduction",
		"25% reduction",
		"15% reduction"
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"VioletRB" : ColorSynergy.new("VioletRB", [TowerColors.VIOLET, TowerColors.RED, TowerColors.BLUE], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_violetRB,
	[
		"Enemies that reach below 80% of their max health become Voided. Voided enemies gain Void effects depending on the tier.",
		"",
		"Ability Void: Enemies are stunned for 2 seconds after casting an ability.",
		"Pride Void: Elite type enemies become Normal type instead.",
		"Strength Void: Enemies deal 25% less damage to the player.",
		"",
		"Void effects cannot be removed by any means.",
		""
	],
	[AnaSyn_VioletRB.new()],
	[
		"Ability Void",
		"Pride Void",
		"Strength Void",
	],
	ColorSynergy.HighlightDeterminer.ALL_BELOW
	),
	
	
	#Tria
	"RYB" : ColorSynergy.new("RYB", [TowerColors.RED, TowerColors.YELLOW, TowerColors.BLUE], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_tria_RYB,
	[
		"The first few enemies that reach the end of the track for the first time are instead brought back to the start of the track, preventing life loss. This counter resets every round.",
		"Enemies brought back heal for 40% of their missing health, and receive damage resistance. The damage resistance cannot be removed by any means.",
		"Elite and Boss enemies count as 2 enemies for this effect.",
		"",
		"Triggering this effect counts as a round loss.",
		"",
		"\"Just when you thought it was all over...\"",
		""
	],
	[TriaSyn_RYB.new()],
	[
		"25% damage resistance, 16 enemies",
		"50% damage resistance, 10 enemies",
		"70% damage resistance, 6 enemies"
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	),
	
	"OGV" : ColorSynergy.new("OGV", [TowerColors.ORANGE, TowerColors.GREEN, TowerColors.VIOLET], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_tria_OGV,
	[
		"Exposes the enemy player's soul every middle of the round, allowing towers to deal damage to it.",
		"Killing the soul damages the enemy player. The damage amount is influenced by the synergy's tier, and how far the soul has travelled.",
		"",
		"You instantly win the game once the enemy player reaches 0 hp.",
		"",
		"Gain ability: Power Fund.",
		"Power Fund: Spend 3 gold to give all towers bonus attack speed for 8 attacks for 5 seconds.",
		"Cooldown: 1 round",
		""
	],
	[TriaSyn_OGV.new()],
	[
		"45% bonus attack speed. 30 max damage per round.",
		"25% bonus attack speed. 20 max damage per round.",
		"15% bonus attack speed. 15 max damage per round."
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
