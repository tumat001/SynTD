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


const CompleSyn_OrangeBlue = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/CompliSyn_OrangeBlue.gd")
const CompliSyn_RedGreen = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/CompliSyn_RedGreen.gd")
const CompliSyn_YellowViolet = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/CompliSyn_YelVio_V2.gd")

const AnaSyn_BlueVG = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_BlueVG/AnaSyn_BlueVG.gd")
const AnaSyn_VioletRB = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2/AnaSyn_VioletRB_V2.gd")
const AnaSyn_OrangeYR = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_OrangeYR/AnaSyn_OrangeYR.gd")
#const AnaSyn_RedOV = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV/AnaSyn_RedOV.gd")
const AnaSyn_RedOV = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV_V2/AnaSyn_RedOV_V2.gd")
const AnaSyn_YellowGO = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_YellowGO/AnaSyn_YellowGO.gd")
const AnaSyn_GreenBY = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_GreenBY/AnaSyn_GreenBY.gd")

const TriaSyn_RYB = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_RYB/TriaSyn_RYB.gd")
const TriaSyn_OGV = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_OGV/TriaSyn_OGV.gd")

#var inst_complesyn_yelvio_energymodule : CompleSyn_YelVio_EnergyModule

enum SynergyId {
	RedGreen = 1,
	OrangeBlue = 2,
	YellowViolet = 3,
	OrangeYR = 4,
	YellowGO = 5,
	GreenBY = 6,
	BlueVG = 7,
	VioletRB = 8,
	RYB = 9
	OGV = 10,
	RedOV = 11,
}

const synergy_id_to_syn_name_dictionary := {
	SynergyId.RedGreen : "RedGreen",
	SynergyId.OrangeBlue : "OrangeBlue",
	SynergyId.YellowViolet : "YellowViolet",
	SynergyId.OrangeYR : "OrangeYR",
	SynergyId.YellowGO : "YellowGO",
	SynergyId.GreenBY : "GreenBY",
	SynergyId.BlueVG : "BlueVG",
	SynergyId.VioletRB : "VioletRB",
	SynergyId.RYB : "RYB",
	SynergyId.OGV : "OGV",
	SynergyId.RedOV : "RedOV",
}


func _init():
	#inst_complesyn_yelvio_energymodule = CompleSyn_YelVio_EnergyModule.new(TowerDominantColors.inst_domsyn_yellow_energybattery)
	
	# 
	
	var interpreter_for_redgreen_dmg_per_bolt_gold = TextFragmentInterpreter.new()
	interpreter_for_redgreen_dmg_per_bolt_gold.display_body = false
	interpreter_for_redgreen_dmg_per_bolt_gold.use_color_for_dark_background = false
	
	var ins_for_redgreen_dmg_per_bolt_gold = []
	ins_for_redgreen_dmg_per_bolt_gold.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "dmg", 6))
	
	interpreter_for_redgreen_dmg_per_bolt_gold.array_of_instructions = ins_for_redgreen_dmg_per_bolt_gold
	
	#
	
	var interpreter_for_redgreen_dmg_per_bolt_silver : TextFragmentInterpreter = interpreter_for_redgreen_dmg_per_bolt_gold.get_deep_copy()
	interpreter_for_redgreen_dmg_per_bolt_silver.array_of_instructions[0].num_val = 4.5
	
	var interpreter_for_redgreen_dmg_per_bolt_bronze : TextFragmentInterpreter = interpreter_for_redgreen_dmg_per_bolt_gold.get_deep_copy()
	interpreter_for_redgreen_dmg_per_bolt_bronze.array_of_instructions[0].num_val = 3.5
	
	
	#
	
	var interpreter_for_redgreen_dmg_per_stack_gold = TextFragmentInterpreter.new()
	interpreter_for_redgreen_dmg_per_stack_gold.display_body = false
	interpreter_for_redgreen_dmg_per_stack_gold.use_color_for_dark_background = false
	
	var ins_for_redgreen_dmg_per_stack_gold = []
	ins_for_redgreen_dmg_per_stack_gold.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "dmg", 0.4))
	
	interpreter_for_redgreen_dmg_per_stack_gold.array_of_instructions = ins_for_redgreen_dmg_per_stack_gold
	
	#
	
	var interpreter_for_redgreen_dmg_per_stack_silver : TextFragmentInterpreter = interpreter_for_redgreen_dmg_per_stack_gold.get_deep_copy()
	interpreter_for_redgreen_dmg_per_stack_silver.array_of_instructions[0].num_val = 0.3
	
	var interpreter_for_redgreen_dmg_per_stack_bronze : TextFragmentInterpreter = interpreter_for_redgreen_dmg_per_stack_gold.get_deep_copy()
	interpreter_for_redgreen_dmg_per_stack_bronze.array_of_instructions[0].num_val = 0.2
	
	
	#
	
	var red_green_syn = ColorSynergy.new(SynergyId.RedGreen, synergy_id_to_syn_name_dictionary[SynergyId.RedGreen], [TowerColors.RED, TowerColors.GREEN], [5, 4, 3],
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
	[CompliSyn_RedGreen],
	[
		["(Red: |0| per stack, |1| per bolt.) (Green: 0.3 seconds per stack. 20% slow minimum.)", [interpreter_for_redgreen_dmg_per_stack_bronze, interpreter_for_redgreen_dmg_per_bolt_bronze]],
		["(Red: |0| per stack, |1| per bolt.) (Green: 0.4 seconds per stack. 30% slow minimum.)", [interpreter_for_redgreen_dmg_per_stack_silver, interpreter_for_redgreen_dmg_per_bolt_silver]],
		["(Red: |0| per stack, |1| per bolt.) (Green: 0.5 seconds per stack. 40% slow minimum.)", [interpreter_for_redgreen_dmg_per_stack_gold, interpreter_for_redgreen_dmg_per_bolt_gold]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[
		"Main attacks apply a stack of \"Red\" or \"Green\" based on the tower's color. Breaking the single color streak triggers effects.",
		"If Red streak is broken: Deal additional damage.",
		"If at 10+ stacks: shoot (5 + 1/2 of total stacks) red bolt to random enemies in range.",
		"",
		"If Green streak is broken: Block the next enemy effect for a duration.",
		"If at 10+ stacks: heal nearby towers, and slow enemies hit. Stacks increase the heal, the slow, and the number of attacks that apply the slow.",
		""
	],
	ColorSynergy.Difficulty.DIFFICULT
	)
	
	# 
	
	var interpreter_for_orangeblue_explosion_dmg = TextFragmentInterpreter.new()
	interpreter_for_orangeblue_explosion_dmg.display_body = true
	interpreter_for_orangeblue_explosion_dmg.use_color_for_dark_background = false
	interpreter_for_orangeblue_explosion_dmg.display_header = false
	
	var outer_ins_for_orange_blue_explosion_dmg = []
	var ins_for_orange_blue_explosion_dmg = []
	ins_for_orange_blue_explosion_dmg.append(NumericalTextFragment.new(4, false, DamageType.ELEMENTAL))
	ins_for_orange_blue_explosion_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
	ins_for_orange_blue_explosion_dmg.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.2, DamageType.ELEMENTAL))
	ins_for_orange_blue_explosion_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
	ins_for_orange_blue_explosion_dmg.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.2)) # stat basis does not matter here
	
	outer_ins_for_orange_blue_explosion_dmg.append(ins_for_orange_blue_explosion_dmg)
	
	outer_ins_for_orange_blue_explosion_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
	outer_ins_for_orange_blue_explosion_dmg.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
	
	
	interpreter_for_orangeblue_explosion_dmg.array_of_instructions = outer_ins_for_orange_blue_explosion_dmg
	
	
	#
	
	var interpreter_for_orangeblue_explosion_dmg_increase = TextFragmentInterpreter.new()
	interpreter_for_orangeblue_explosion_dmg_increase.display_body = false
	interpreter_for_orangeblue_explosion_dmg.display_header = false
	
	var ins_for_orangeblue_explosion_dmg_increase = []
	ins_for_orangeblue_explosion_dmg_increase.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "increased damage", 25, true))
	
	interpreter_for_orangeblue_explosion_dmg_increase.array_of_instructions = ins_for_orangeblue_explosion_dmg_increase
	
	
	
	#
	
	var orange_blue_syn = ColorSynergy.new(SynergyId.OrangeBlue, synergy_id_to_syn_name_dictionary[SynergyId.OrangeBlue], [TowerColors.ORANGE, TowerColors.BLUE], [5, 4, 3, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_compli_orangeblue,
	[
		"Main attacks on hit cause an explosion every few seconds.",
		["Explosions deal |0| to 3 enemies.", [interpreter_for_orangeblue_explosion_dmg]],
		"Explosions also benefit from explosion size buffs.",
		"",
		["Towers with heat modules with 100 heat gain 50% cooldown reduction for the explosion, and explosions deal |0|.", [interpreter_for_orangeblue_explosion_dmg_increase]],
		""
	],
	[CompleSyn_OrangeBlue],
	[
		
		"Explosion per 10.0 seconds.",
		"Explosion per 4.5 seconds. Explosions are 25% larger.",
		"Explosion per 1.5 seconds. Explosions are 75% larger.",
		"Explosion per 0.4 seconds. Explosions are 100% larger.",
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[
		"Main attacks on hit cause an explosion every few seconds.",
		["Explosions deal |0| to 3 enemies.", [interpreter_for_orangeblue_explosion_dmg]],
		"",
	],
	ColorSynergy.Difficulty.EFFORTLESS
	)
	
	#
	
	var interpreter_for_orangeYR_attk_speed_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_orangeYR_attk_speed_tier_1.display_body = false
	
	var ins_for_orangeYR_attk_speed_tier_1 = []
	ins_for_orangeYR_attk_speed_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 140, true))
	
	interpreter_for_orangeYR_attk_speed_tier_1.array_of_instructions = ins_for_orangeYR_attk_speed_tier_1
	
	#
	
	var interpreter_for_orangeYR_attk_speed_tier_2 : TextFragmentInterpreter = interpreter_for_orangeYR_attk_speed_tier_1.get_deep_copy()
	interpreter_for_orangeYR_attk_speed_tier_2.array_of_instructions[0].num_val = 80
	
	var interpreter_for_orangeYR_attk_speed_tier_3 : TextFragmentInterpreter = interpreter_for_orangeYR_attk_speed_tier_1.get_deep_copy()
	interpreter_for_orangeYR_attk_speed_tier_3.array_of_instructions[0].num_val = 40
	
	var interpreter_for_orangeYR_attk_speed_tier_4 : TextFragmentInterpreter = interpreter_for_orangeYR_attk_speed_tier_1.get_deep_copy()
	interpreter_for_orangeYR_attk_speed_tier_4.array_of_instructions[0].num_val = 20
	
	
	
	var orange_yr_syn = ColorSynergy.new(SynergyId.OrangeYR, synergy_id_to_syn_name_dictionary[SynergyId.OrangeYR], [TowerColors.ORANGE, TowerColors.YELLOW, TowerColors.RED], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_orangeYR,
	[
		"Main attacks cause towers to gain attack speed, up to a limit.",
		"15 seconds worth of attacks are required to reach the limit.",
		""
	],
	[AnaSyn_OrangeYR],
	[
		["Up to |0|.", [interpreter_for_orangeYR_attk_speed_tier_4]],
		["Up to |0|.", [interpreter_for_orangeYR_attk_speed_tier_3]],
		["Up to |0|.", [interpreter_for_orangeYR_attk_speed_tier_2]],
		["Up to |0|.", [interpreter_for_orangeYR_attk_speed_tier_1]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[
		"Main attacks cause towers to gain attack speed, up to a limit.",
		"",
	],
	ColorSynergy.Difficulty.EFFORTLESS
	)
	
	#
	
	var interpreter_for_yelloGO_ele_on_hit_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_yelloGO_ele_on_hit_tier_1.display_body = false
	
	var ins_for_yelloGO_ele_on_hit_tier_1 = []
	ins_for_yelloGO_ele_on_hit_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental on hit damage", 5))
	
	interpreter_for_yelloGO_ele_on_hit_tier_1.array_of_instructions = ins_for_yelloGO_ele_on_hit_tier_1
	
	
	var interpreter_for_yelloGO_ele_on_hit_tier_2 : TextFragmentInterpreter = interpreter_for_yelloGO_ele_on_hit_tier_1.get_deep_copy()
	interpreter_for_yelloGO_ele_on_hit_tier_2.array_of_instructions[0].num_val = 3.0
	
	var interpreter_for_yelloGO_ele_on_hit_tier_3 : TextFragmentInterpreter = interpreter_for_yelloGO_ele_on_hit_tier_1.get_deep_copy()
	interpreter_for_yelloGO_ele_on_hit_tier_3.array_of_instructions[0].num_val = 2.0
	
	var interpreter_for_yelloGO_ele_on_hit_tier_4 : TextFragmentInterpreter = interpreter_for_yelloGO_ele_on_hit_tier_1.get_deep_copy()
	interpreter_for_yelloGO_ele_on_hit_tier_4.array_of_instructions[0].num_val = 1.0
	
	#
	
	var interpreter_for_yelloGO_base_dmg_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_yelloGO_base_dmg_tier_1.display_body = false
	
	var ins_for_yelloGO_base_dmg_tier_1 = []
	ins_for_yelloGO_base_dmg_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "total base damage", 130, true))
	
	interpreter_for_yelloGO_base_dmg_tier_1.array_of_instructions = ins_for_yelloGO_base_dmg_tier_1
	
	
	var interpreter_for_yelloGO_base_dmg_tier_2 : TextFragmentInterpreter = interpreter_for_yelloGO_base_dmg_tier_1.get_deep_copy()
	interpreter_for_yelloGO_base_dmg_tier_2.array_of_instructions[0].num_val = 70
	
	var interpreter_for_yelloGO_base_dmg_tier_3 : TextFragmentInterpreter = interpreter_for_yelloGO_base_dmg_tier_1.get_deep_copy()
	interpreter_for_yelloGO_base_dmg_tier_3.array_of_instructions[0].num_val = 40
	
	var interpreter_for_yelloGO_base_dmg_tier_4 : TextFragmentInterpreter = interpreter_for_yelloGO_base_dmg_tier_1.get_deep_copy()
	interpreter_for_yelloGO_base_dmg_tier_4.array_of_instructions[0].num_val = 20
	
	
	#
	
	var interpreter_for_yelloGO_attk_speed_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_yelloGO_attk_speed_tier_1.display_body = false
	
	var ins_for_yelloGO_attk_speed_tier_1 = []
	ins_for_yelloGO_attk_speed_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "total attack speed", 130, true))
	
	interpreter_for_yelloGO_attk_speed_tier_1.array_of_instructions = ins_for_yelloGO_attk_speed_tier_1
	
	
	var interpreter_for_yelloGO_attk_speed_tier_2 : TextFragmentInterpreter = interpreter_for_yelloGO_attk_speed_tier_1.get_deep_copy()
	interpreter_for_yelloGO_attk_speed_tier_2.array_of_instructions[0].num_val = 70
	
	var interpreter_for_yelloGO_attk_speed_tier_3 : TextFragmentInterpreter = interpreter_for_yelloGO_attk_speed_tier_1.get_deep_copy()
	interpreter_for_yelloGO_attk_speed_tier_3.array_of_instructions[0].num_val = 40
	
	var interpreter_for_yelloGO_attk_speed_tier_4 : TextFragmentInterpreter = interpreter_for_yelloGO_attk_speed_tier_1.get_deep_copy()
	interpreter_for_yelloGO_attk_speed_tier_4.array_of_instructions[0].num_val = 20
	
	#
	
	var interpreter_for_yelloGO_range_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_yelloGO_range_tier_1.display_body = false
	
	var ins_for_yelloGO_range_tier_1 = []
	ins_for_yelloGO_range_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "base range", 50, true))
	
	interpreter_for_yelloGO_range_tier_1.array_of_instructions = ins_for_yelloGO_range_tier_1
	
	
	var interpreter_for_yelloGO_range_tier_2 : TextFragmentInterpreter = interpreter_for_yelloGO_range_tier_1.get_deep_copy()
	interpreter_for_yelloGO_range_tier_2.array_of_instructions[0].num_val = 30
	
	var interpreter_for_yelloGO_range_tier_3 : TextFragmentInterpreter = interpreter_for_yelloGO_range_tier_1.get_deep_copy()
	interpreter_for_yelloGO_range_tier_3.array_of_instructions[0].num_val = 20
	
	var interpreter_for_yelloGO_range_tier_4 : TextFragmentInterpreter = interpreter_for_yelloGO_range_tier_1.get_deep_copy()
	interpreter_for_yelloGO_range_tier_4.array_of_instructions[0].num_val = 10
	
	
	
	var yellow_go_syn = ColorSynergy.new(SynergyId.YellowGO, synergy_id_to_syn_name_dictionary[SynergyId.YellowGO], [TowerColors.YELLOW, TowerColors.GREEN, TowerColors.ORANGE], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_yellowGO,
	[
		"Fluctuation: buff a tower for 3 seconds before buffing another tower.",
		"Cycle: Fluctuation goes to the first tower that attacks. Afterwards, Fluctuation loops to the highest base damage tower, then to the highest attack speed tower, then to the tower that has dealt the most damage in the round.",
		"Fluctuation cannot re-target to the same tower. Fluctuation will avoid towers that cannot attack, or with no enemies in its range. When no viable tower is found, the Cycle is reset.",
		"",
		"A Fluctuated tower gains buffs.",
		""
	],
	[AnaSyn_YellowGO],
	[
		["+|0|, +|1|, +|2|, +|3|.", [interpreter_for_yelloGO_ele_on_hit_tier_4, interpreter_for_yelloGO_base_dmg_tier_4, interpreter_for_yelloGO_attk_speed_tier_4, interpreter_for_yelloGO_range_tier_4]],
		["+|0|, +|1|, +|2|, +|3|.", [interpreter_for_yelloGO_ele_on_hit_tier_3, interpreter_for_yelloGO_base_dmg_tier_3, interpreter_for_yelloGO_attk_speed_tier_3, interpreter_for_yelloGO_range_tier_3]],
		["+|0|, +|1|, +|2|, +|3|.", [interpreter_for_yelloGO_ele_on_hit_tier_2, interpreter_for_yelloGO_base_dmg_tier_2, interpreter_for_yelloGO_attk_speed_tier_2, interpreter_for_yelloGO_range_tier_2]],
		["+|0|, +|1|, +|2|, +|3|.", [interpreter_for_yelloGO_ele_on_hit_tier_1, interpreter_for_yelloGO_base_dmg_tier_1, interpreter_for_yelloGO_attk_speed_tier_1, interpreter_for_yelloGO_range_tier_1]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[
		"Buff a tower for 3 seconds before buffing another tower.",
		"The highest base damage tower, attack speed tower, and the tower that dealt the most damage in the round are prioritized by the buff.",
		"Towers with no enemies in their range are ignored.",
		""
	],
	ColorSynergy.Difficulty.EASY
	)
	
	#
	
	var interpreter_for_greenBY_ele_on_hit_per_stack_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_greenBY_ele_on_hit_per_stack_tier_1.display_body = false
	
	var ins_for_greenBY_ele_on_hit_per_stack_tier_1 = []
	ins_for_greenBY_ele_on_hit_per_stack_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "on hit dmg", 0.30))
	
	interpreter_for_greenBY_ele_on_hit_per_stack_tier_1.array_of_instructions = ins_for_greenBY_ele_on_hit_per_stack_tier_1
	
	
	var interpreter_for_greenBY_ele_on_hit_per_stack_tier_2 : TextFragmentInterpreter = interpreter_for_greenBY_ele_on_hit_per_stack_tier_1.get_deep_copy()
	interpreter_for_greenBY_ele_on_hit_per_stack_tier_2.array_of_instructions[0].num_val = 0.17
	
	var interpreter_for_greenBY_ele_on_hit_per_stack_tier_3 : TextFragmentInterpreter = interpreter_for_greenBY_ele_on_hit_per_stack_tier_1.get_deep_copy()
	interpreter_for_greenBY_ele_on_hit_per_stack_tier_3.array_of_instructions[0].num_val = 0.07
	
	var interpreter_for_greenBY_ele_on_hit_per_stack_tier_4 : TextFragmentInterpreter = interpreter_for_greenBY_ele_on_hit_per_stack_tier_1.get_deep_copy()
	interpreter_for_greenBY_ele_on_hit_per_stack_tier_4.array_of_instructions[0].num_val = 0.03
	
	
	
	var interpreter_for_greenBY_ele_on_hit_max_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_greenBY_ele_on_hit_max_tier_1.display_body = false
	
	var ins_for_greenBY_ele_on_hit_max_tier_1 = []
	ins_for_greenBY_ele_on_hit_max_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "", 6.0))
	
	interpreter_for_greenBY_ele_on_hit_max_tier_1.array_of_instructions = ins_for_greenBY_ele_on_hit_max_tier_1
	
	
	var interpreter_for_greenBY_ele_on_hit_max_tier_2 : TextFragmentInterpreter = interpreter_for_greenBY_ele_on_hit_max_tier_1.get_deep_copy()
	interpreter_for_greenBY_ele_on_hit_max_tier_2.array_of_instructions[0].num_val = 3.4
	
	var interpreter_for_greenBY_ele_on_hit_max_tier_3 : TextFragmentInterpreter = interpreter_for_greenBY_ele_on_hit_max_tier_1.get_deep_copy()
	interpreter_for_greenBY_ele_on_hit_max_tier_3.array_of_instructions[0].num_val = 1.4
	
	var interpreter_for_greenBY_ele_on_hit_max_tier_4 : TextFragmentInterpreter = interpreter_for_greenBY_ele_on_hit_max_tier_1.get_deep_copy()
	interpreter_for_greenBY_ele_on_hit_max_tier_4.array_of_instructions[0].num_val = 0.6
	
	
	
	
	var green_by_syn = ColorSynergy.new(SynergyId.GreenBY, synergy_id_to_syn_name_dictionary[SynergyId.GreenBY], [TowerColors.GREEN, TowerColors.BLUE, TowerColors.YELLOW], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_greenBY,
	[
		"Towers gain bonus elemental damage on hit per main attack, up to a limit. The bonus can be granted only once per second.",
		""
	],
	[AnaSyn_GreenBY],
	[
		["+|0|, up to |1|.", [interpreter_for_greenBY_ele_on_hit_per_stack_tier_4, interpreter_for_greenBY_ele_on_hit_max_tier_4]],
		["+|0|, up to |1|.", [interpreter_for_greenBY_ele_on_hit_per_stack_tier_3, interpreter_for_greenBY_ele_on_hit_max_tier_3]],
		["+|0|, up to |1|.", [interpreter_for_greenBY_ele_on_hit_per_stack_tier_2, interpreter_for_greenBY_ele_on_hit_max_tier_2]],
		["+|0|, up to |1|.", [interpreter_for_greenBY_ele_on_hit_per_stack_tier_1, interpreter_for_greenBY_ele_on_hit_max_tier_1]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[],
	ColorSynergy.Difficulty.EFFORTLESS
	)
	
	#
	
	var interpreter_for_blue_vg_cooldown_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_blue_vg_cooldown_tier_1.display_body = false
	
	var ins_for_blue_vg_cooldown_tier_1 = []
	ins_for_blue_vg_cooldown_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, -1, "reduction", 80, true))
	
	interpreter_for_blue_vg_cooldown_tier_1.array_of_instructions = ins_for_blue_vg_cooldown_tier_1
	
	
	var interpreter_for_blue_vg_cooldown_tier_2 : TextFragmentInterpreter = interpreter_for_blue_vg_cooldown_tier_1.get_deep_copy()
	interpreter_for_blue_vg_cooldown_tier_2.array_of_instructions[0].num_val = 60
	
	var interpreter_for_blue_vg_cooldown_tier_3 : TextFragmentInterpreter = interpreter_for_blue_vg_cooldown_tier_1.get_deep_copy()
	interpreter_for_blue_vg_cooldown_tier_3.array_of_instructions[0].num_val = 40
	
	var interpreter_for_blue_vg_cooldown_tier_4 : TextFragmentInterpreter = interpreter_for_blue_vg_cooldown_tier_1.get_deep_copy()
	interpreter_for_blue_vg_cooldown_tier_4.array_of_instructions[0].num_val = 20
	
	
	
	var interpreter_for_blueVG_ap_per_cast_ratio = TextFragmentInterpreter.new()
	interpreter_for_blueVG_ap_per_cast_ratio.display_body = false
	
	var ins_for_blueVG_ap_per_cast_ratio = []
	ins_for_blueVG_ap_per_cast_ratio.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ap", 0.25))
	
	interpreter_for_blueVG_ap_per_cast_ratio.array_of_instructions = ins_for_blueVG_ap_per_cast_ratio
	
	
	
	var interpreter_for_blueVG_ap_for_no_cd = TextFragmentInterpreter.new()
	interpreter_for_blueVG_ap_for_no_cd.display_body = false
	
	var ins_for_blueVG_ap_for_no_cd = []
	ins_for_blueVG_ap_for_no_cd.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ap", 0.05))
	
	interpreter_for_blueVG_ap_for_no_cd.array_of_instructions = ins_for_blueVG_ap_for_no_cd
	
	
	
	
	var blue_vg_syn = ColorSynergy.new(SynergyId.BlueVG, synergy_id_to_syn_name_dictionary[SynergyId.BlueVG], [TowerColors.BLUE, TowerColors.VIOLET, TowerColors.GREEN], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_blueVG,
	[
		"All abilities's cooldowns are reduced.",
		"",
		"Right before a tower casts an ability, the tower gains stacking ability potency for the round. AP gained scales on its cooldown.",
		["Towers with abilities whose cooldowns are not time-based are granted |0| per cast instead.", [interpreter_for_blueVG_ap_for_no_cd]],
		""
	],
	[AnaSyn_BlueVG],
	[
		["|0|. +|1| per 50 seconds of cooldown.", [interpreter_for_blue_vg_cooldown_tier_4, interpreter_for_blueVG_ap_per_cast_ratio]],
		["|0|. +|1| per 40 seconds of cooldown.", [interpreter_for_blue_vg_cooldown_tier_3, interpreter_for_blueVG_ap_per_cast_ratio]],
		["|0|. +|1| per 30 seconds of cooldown.", [interpreter_for_blue_vg_cooldown_tier_2, interpreter_for_blueVG_ap_per_cast_ratio]],
		["|0|. +|1| per 20 seconds of cooldown.", [interpreter_for_blue_vg_cooldown_tier_1, interpreter_for_blueVG_ap_per_cast_ratio]],
		
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[],
	ColorSynergy.Difficulty.EFFORTLESS
	)
	
	#
	
	var interpreter_for_violetRB_base_dmg_ratio_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_violetRB_base_dmg_ratio_tier_1.display_body = false
	
	var ins_for_violetRB_base_dmg_ratio_tier_1 = []
	ins_for_violetRB_base_dmg_ratio_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "of total base damage", 100, true))
	
	interpreter_for_violetRB_base_dmg_ratio_tier_1.array_of_instructions = ins_for_violetRB_base_dmg_ratio_tier_1
	
	
	var interpreter_for_violetRB_base_dmg_ratio_tier_2 : TextFragmentInterpreter = interpreter_for_violetRB_base_dmg_ratio_tier_1.get_deep_copy()
	interpreter_for_violetRB_base_dmg_ratio_tier_2.array_of_instructions[0].num_val = 80
	
	var interpreter_for_violetRB_base_dmg_ratio_tier_3 : TextFragmentInterpreter = interpreter_for_violetRB_base_dmg_ratio_tier_1.get_deep_copy()
	interpreter_for_violetRB_base_dmg_ratio_tier_3.array_of_instructions[0].num_val = 60
	
	var interpreter_for_violetRB_base_dmg_ratio_tier_4 : TextFragmentInterpreter = interpreter_for_violetRB_base_dmg_ratio_tier_1.get_deep_copy()
	interpreter_for_violetRB_base_dmg_ratio_tier_4.array_of_instructions[0].num_val = 40
	
	
	
	var interpreter_for_violetRB_ap_ratio_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_violetRB_ap_ratio_tier_1.display_body = false
	
	var ins_for_violetRB_ap_ratio_tier_1 = []
	ins_for_violetRB_ap_ratio_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "of total ability potency", 25, true))
	
	interpreter_for_violetRB_ap_ratio_tier_1.array_of_instructions = ins_for_violetRB_ap_ratio_tier_1
	
	
	var interpreter_for_violetRB_ap_ratio_tier_2 = interpreter_for_violetRB_ap_ratio_tier_1.get_deep_copy()
	interpreter_for_violetRB_ap_ratio_tier_2.array_of_instructions[0].num_val = 20
	
	var interpreter_for_violetRB_ap_ratio_tier_3 = interpreter_for_violetRB_ap_ratio_tier_1.get_deep_copy()
	interpreter_for_violetRB_ap_ratio_tier_3.array_of_instructions[0].num_val = 15
	
	var interpreter_for_violetRB_ap_ratio_tier_4 = interpreter_for_violetRB_ap_ratio_tier_1.get_deep_copy()
	interpreter_for_violetRB_ap_ratio_tier_4.array_of_instructions[0].num_val = 10
	
	
	
	
	var violet_rb_syn = ColorSynergy.new(SynergyId.VioletRB, synergy_id_to_syn_name_dictionary[SynergyId.VioletRB], [TowerColors.VIOLET, TowerColors.RED, TowerColors.BLUE], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_violetRB,
	[
		"Main attacks cause towers to lose 4% of their max health.",
		"Upon dying, towers split a percent of their total base damage and total ability potency equally to all other towers.",
		"The last standing tower becomes invulenrable and immune to enemy effects, and gains 50% projectile speed for the rest of the round.",
		""
	],
	[AnaSyn_VioletRB],
	[
		["|0|, |1|.", [interpreter_for_violetRB_base_dmg_ratio_tier_4, interpreter_for_violetRB_ap_ratio_tier_4]],
		["|0|, |1|.", [interpreter_for_violetRB_base_dmg_ratio_tier_3, interpreter_for_violetRB_ap_ratio_tier_3]],
		["|0|, |1|.", [interpreter_for_violetRB_base_dmg_ratio_tier_2, interpreter_for_violetRB_ap_ratio_tier_2]],
		["|0|, |1|.", [interpreter_for_violetRB_base_dmg_ratio_tier_1, interpreter_for_violetRB_ap_ratio_tier_1]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[],
	ColorSynergy.Difficulty.DIFFICULT
	)
	
	#
	
	var interpreter_for_ogv_attk_speed_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_ogv_attk_speed_tier_1.display_body = false
	
	var ins_for_ogv_attk_speed_tier_1 = []
	ins_for_ogv_attk_speed_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 70, true))
	
	interpreter_for_ogv_attk_speed_tier_1.array_of_instructions = ins_for_ogv_attk_speed_tier_1
	
	
	var interpreter_for_ogv_attk_speed_tier_2 : TextFragmentInterpreter = interpreter_for_ogv_attk_speed_tier_1.get_deep_copy()
	interpreter_for_ogv_attk_speed_tier_2.array_of_instructions[0].num_val = 50
	
	var interpreter_for_ogv_attk_speed_tier_3 : TextFragmentInterpreter = interpreter_for_ogv_attk_speed_tier_1.get_deep_copy()
	interpreter_for_ogv_attk_speed_tier_3.array_of_instructions[0].num_val = 30
	
	
	var ogv_syn = ColorSynergy.new(SynergyId.OGV, synergy_id_to_syn_name_dictionary[SynergyId.OGV], [TowerColors.ORANGE, TowerColors.GREEN, TowerColors.VIOLET], [3, 2, 1], #[4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_tria_OGV,
	[
		"Exposes the enemy player's soul every middle of the round, allowing towers to deal damage to it.",
		"Killing the soul damages the enemy player. The damage amount is influenced by the synergy's tier, and how far the soul has travelled.",
		"Killing the soul before travelling 50% of its path awards the full damage amount.",
		"",
		"You instantly win the game once the enemy player reaches 0 hp.",
		"",
		"Gain ability: Power Fund.",
		"Power Fund: Spend 3 gold to give all towers bonus attack speed for 8 attacks for 5 seconds.",
		"Cooldown: 1 round.",
		""
	],
	[TriaSyn_OGV],
	[
		["|0|. 12 max damage per round.", [interpreter_for_ogv_attk_speed_tier_3]],
		["|0|. 16 max damage per round.", [interpreter_for_ogv_attk_speed_tier_2]],
		["|0|. 30 max damage per round.", [interpreter_for_ogv_attk_speed_tier_1]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[
		"Exposes the enemy player's soul every middle of the round, allowing towers to deal damage to it.",
		"Killing the soul damages the enemy player. The damage amount is influenced by the synergy's tier, and how far the soul has travelled.",
		"",
		"You instantly win the game once the enemy player reaches 0 hp.",
		""
	],
	ColorSynergy.Difficulty.CHALLENGING
	)
	
	
	var interpreter_for_yelvio_yellow_shell_dmg_tier_4 = TextFragmentInterpreter.new()
	interpreter_for_yelvio_yellow_shell_dmg_tier_4.display_body = false
	interpreter_for_yelvio_yellow_shell_dmg_tier_4.use_color_for_dark_background = false
	
	var ins_for_yelvio_yellow_shell_dmg_tier_4 = []
	ins_for_yelvio_yellow_shell_dmg_tier_4.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "damage", 3.0))
	
	interpreter_for_yelvio_yellow_shell_dmg_tier_4.array_of_instructions = ins_for_yelvio_yellow_shell_dmg_tier_4
	
	
	var interpreter_for_yelvio_yellow_shell_dmg_tier_3 : TextFragmentInterpreter = interpreter_for_yelvio_yellow_shell_dmg_tier_4.get_deep_copy()
	interpreter_for_yelvio_yellow_shell_dmg_tier_3.array_of_instructions[0].num_val = 4.0
	
	var interpreter_for_yelvio_yellow_shell_dmg_tier_2 : TextFragmentInterpreter = interpreter_for_yelvio_yellow_shell_dmg_tier_4.get_deep_copy()
	interpreter_for_yelvio_yellow_shell_dmg_tier_2.array_of_instructions[0].num_val = 6.0
	
	var interpreter_for_yelvio_yellow_shell_dmg_tier_1 : TextFragmentInterpreter = interpreter_for_yelvio_yellow_shell_dmg_tier_4.get_deep_copy()
	interpreter_for_yelvio_yellow_shell_dmg_tier_1.array_of_instructions[0].num_val = 8.0
	
	
	###
	
	var interpreter_for_red_ov_initial_bonus_dmg_amount_tier_3 = TextFragmentInterpreter.new()
	interpreter_for_red_ov_initial_bonus_dmg_amount_tier_3.display_body = false
	var ins_for_red_ov_initial_bonus_dmg_amount_tier_3 = []
	ins_for_red_ov_initial_bonus_dmg_amount_tier_3.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 15, true))
	interpreter_for_red_ov_initial_bonus_dmg_amount_tier_3.array_of_instructions = ins_for_red_ov_initial_bonus_dmg_amount_tier_3
	
	var interpreter_for_red_ov_extra_empowered_bonus_dmg_amount_tier_3 = interpreter_for_red_ov_initial_bonus_dmg_amount_tier_3.get_deep_copy()
	interpreter_for_red_ov_extra_empowered_bonus_dmg_amount_tier_3.array_of_instructions[0].num_val = 15
	
	var interpreter_for_red_ov_initial_bonus_dmg_amount_tier_2 = interpreter_for_red_ov_initial_bonus_dmg_amount_tier_3.get_deep_copy()
	interpreter_for_red_ov_initial_bonus_dmg_amount_tier_2.array_of_instructions[0].num_val = 25
	var interpreter_for_red_ov_extra_empowered_bonus_dmg_amount_tier_2 = interpreter_for_red_ov_initial_bonus_dmg_amount_tier_3.get_deep_copy()
	interpreter_for_red_ov_extra_empowered_bonus_dmg_amount_tier_2.array_of_instructions[0].num_val = 25
	
	var interpreter_for_red_ov_initial_bonus_dmg_amount_tier_1 = interpreter_for_red_ov_initial_bonus_dmg_amount_tier_3.get_deep_copy()
	interpreter_for_red_ov_initial_bonus_dmg_amount_tier_1.array_of_instructions[0].num_val = 35
	var interpreter_for_red_ov_extra_empowered_bonus_dmg_amount_tier_1 = interpreter_for_red_ov_initial_bonus_dmg_amount_tier_3.get_deep_copy()
	interpreter_for_red_ov_extra_empowered_bonus_dmg_amount_tier_1.array_of_instructions[0].num_val = 35
	
	
	# ------------------------------------------------------
	
	synergies = {
	# Comple
	synergy_id_to_syn_name_dictionary[SynergyId.RedGreen] : red_green_syn,
	
	
	synergy_id_to_syn_name_dictionary[SynergyId.YellowViolet] : ColorSynergy.new(SynergyId.YellowViolet, synergy_id_to_syn_name_dictionary[SynergyId.YellowViolet], [TowerColors.YELLOW, TowerColors.VIOLET], [5, 4, 3, 2],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic], 
	syn_compo_compli_yellowviolet,
	[
		"Summon Rift Axis that controls the division between the Yellow and Violet rifts. Towers receive effects based on their rift location.",
		"",
		"Violet rift: On round end, towers have their self ingredient effect upgraded by an amount.",
		"",
		"Yellow rift: Every 15 seconds, all towers in the yellow rift fire a shell at the first enemy, exploding to deal damage to 3 enemies. Towers fire again if only 0 or 1 enemies is hit.",
		"",
	],
	[CompliSyn_YellowViolet],
	[
		["+10% ingredient upgrade. |0| per yellow shell.", [interpreter_for_yelvio_yellow_shell_dmg_tier_4]],
		["+15% ingredient upgrade. |0| per yellow shell.", [interpreter_for_yelvio_yellow_shell_dmg_tier_3]],
		["+30% ingredient upgrade. |0| per yellow shell.", [interpreter_for_yelvio_yellow_shell_dmg_tier_2]],
		["+45% ingredient upgrade. |0| per yellow shell.", [interpreter_for_yelvio_yellow_shell_dmg_tier_1]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[],
	ColorSynergy.Difficulty.DIFFICULT
	),
	 
	
	synergy_id_to_syn_name_dictionary[SynergyId.OrangeBlue] : orange_blue_syn,
	
	
	# Ana
	synergy_id_to_syn_name_dictionary[SynergyId.RedOV] : ColorSynergy.new(SynergyId.RedOV, synergy_id_to_syn_name_dictionary[SynergyId.RedOV], [TowerColors.RED, TowerColors.ORANGE, TowerColors.VIOLET], [3, 2, 1],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_redOV,
	[
		"After 8 main attacks, towers rally all other towers in range, buffing them to gain bonus damage for 6 seconds.",
		"A tower triggering rally for the 4th time or more allows it to give an additional bonus damage buff per rally.",
		""
	],
	[AnaSyn_RedOV],
	[
		["Base buff: |0|. Additional buff: |1|.", [interpreter_for_red_ov_initial_bonus_dmg_amount_tier_3, interpreter_for_red_ov_extra_empowered_bonus_dmg_amount_tier_3]],
		["Base buff: |0|. Additional buff: |1|.", [interpreter_for_red_ov_initial_bonus_dmg_amount_tier_2, interpreter_for_red_ov_extra_empowered_bonus_dmg_amount_tier_2]],
		["Base buff: |0|. Additional buff: |1|.", [interpreter_for_red_ov_initial_bonus_dmg_amount_tier_1, interpreter_for_red_ov_extra_empowered_bonus_dmg_amount_tier_1]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[],
	ColorSynergy.Difficulty.EFFORTLESS
	),
	
	synergy_id_to_syn_name_dictionary[SynergyId.OrangeYR] : orange_yr_syn,
	
	synergy_id_to_syn_name_dictionary[SynergyId.YellowGO] : yellow_go_syn,
	
	synergy_id_to_syn_name_dictionary[SynergyId.GreenBY] : green_by_syn,
	
	synergy_id_to_syn_name_dictionary[SynergyId.BlueVG] : blue_vg_syn,
	
#	"VioletRB" : ColorSynergy.new("VioletRB", [TowerColors.VIOLET, TowerColors.RED, TowerColors.BLUE], [4, 3, 2],
#	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
#	syn_compo_ana_violetRB,
#	[
#		"Enemies that reach below 85% of their max health become Voided. Voided enemies gain Void effects depending on the tier.",
#		"",
#		"Pride Void: Elite type enemies become Normal type instead.",
#		"Ability Void: Enemies are stunned for 3 seconds after casting an ability.",
#		"Strength Void: Enemies deal 50% less damage to the player.",
#		"",
#		"Void effects cannot be removed by any means.",
#		""
#	],
#	[AnaSyn_VioletRB],
#	[
#		"Pride Void",
#		"Ability Void",
#		"Strength Void",
#	],
#	ColorSynergy.HighlightDeterminer.ALL_BELOW
#	),
	
	synergy_id_to_syn_name_dictionary[SynergyId.VioletRB] : violet_rb_syn,
	
	#Tria
	synergy_id_to_syn_name_dictionary[SynergyId.RYB] : ColorSynergy.new(SynergyId.RYB, synergy_id_to_syn_name_dictionary[SynergyId.RYB], [TowerColors.RED, TowerColors.YELLOW, TowerColors.BLUE], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_tria_RYB,
	[
		"Every round: the first few enemies that reach the end of the track for the first time are instead brought back to the start of the track, preventing life loss.",
		"Enemies brought back heal for 60% of their missing health and receive damage resistance. The damage resistance cannot be removed by any means.",
		"Elite and Boss enemies count as 2 enemies for this effect.",
		"",
		"Triggering this effect counts as a round loss.",
		"",
		"\"Just when they thought it was all over...\"",
		""
	],
	[TriaSyn_RYB],
	[
		"40% damage resistance, 6 enemies.",
		"25% damage resistance, 10 enemies.",
		"10% damage resistance, 16 enemies.",
	],
	ColorSynergy.HighlightDeterminer.SINGLE,
	{},
	[
		"Every round: the first few enemies that reach the end of the track for the first time are instead brought back to the start of the track, preventing life loss.",
		"Enemies brought back heal for 60% of their missing health and receive damage resistance.",
		"Elite and Boss enemies count as 2 enemies for this effect.",
		"",
		"Triggering this effect counts as a round loss.",
		"",
	],
	ColorSynergy.Difficulty.EFFORTLESS
	),
	
	synergy_id_to_syn_name_dictionary[SynergyId.OGV] : ogv_syn,
	
	
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

#


func reset_synergies_instances():
	for syn in synergies.values():
		syn.reset_synergy_effects_instances()


