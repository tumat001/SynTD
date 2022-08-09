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

const CompleSyn_YelVio_EnergyModule = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio/CompliSyn_YelVio_EnergyModule.gd")
const CompleSyn_YelVio_YellowIng = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio/CompliSyn_YelVio_YellowIng.gd")
const CompleSyn_OrangeBlue = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_OrangeBlue/CompliSyn_OrangeBlue.gd")
const CompliSyn_RedGreen = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_RedGreen/CompliSyn_RedGreen.gd")

const AnaSyn_BlueVG = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_BlueVG/AnaSyn_BlueVG.gd")
const AnaSyn_VioletRB = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2/AnaSyn_VioletRB_V2.gd")
const AnaSyn_OrangeYR = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_OrangeYR/AnaSyn_OrangeYR.gd")
const AnaSyn_RedOV = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_RedOV/AnaSyn_RedOV.gd")
const AnaSyn_YellowGO = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_YellowGO/AnaSyn_YellowGO.gd")
const AnaSyn_GreenBY = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_GreenBY/AnaSyn_GreenBY.gd")

const TriaSyn_RYB = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_RYB/TriaSyn_RYB.gd")
const TriaSyn_OGV = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_OGV/TriaSyn_OGV.gd")

var inst_complesyn_yelvio_energymodule : CompleSyn_YelVio_EnergyModule


func _init():
	inst_complesyn_yelvio_energymodule = CompleSyn_YelVio_EnergyModule.new(TowerDominantColors.inst_domsyn_yellow_energybattery)
	
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
	
	var red_green_syn = ColorSynergy.new("RedGreen", [TowerColors.RED, TowerColors.GREEN], [5, 4, 3],
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
		#6 damage per bolt
		["(Red: |0| per stack, |1| per bolt.) (Green: 0.5 seconds per stack. 40% slow minimum.)", [interpreter_for_redgreen_dmg_per_stack_gold, interpreter_for_redgreen_dmg_per_bolt_gold]],
		["(Red: |0| per stack, |1| per bolt.) (Green: 0.4 seconds per stack. 30% slow minimum.)", [interpreter_for_redgreen_dmg_per_stack_silver, interpreter_for_redgreen_dmg_per_bolt_silver]],
		["(Red: |0| per stack, |1| per bolt.) (Green: 0.3 seconds per stack. 20% slow minimum.)", [interpreter_for_redgreen_dmg_per_stack_bronze, interpreter_for_redgreen_dmg_per_bolt_bronze]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	)
	
	# 
	
	var interpreter_for_orangeblue_explosion_dmg = TextFragmentInterpreter.new()
	interpreter_for_orangeblue_explosion_dmg.display_body = true
	interpreter_for_orangeblue_explosion_dmg.use_color_for_dark_background = false
	
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
	interpreter_for_orangeblue_explosion_dmg.display_header = true
	
	var ins_for_orangeblue_explosion_dmg_increase = []
	ins_for_orangeblue_explosion_dmg_increase.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "increased damage", 25, true))
	
	interpreter_for_orangeblue_explosion_dmg_increase.array_of_instructions = ins_for_orangeblue_explosion_dmg_increase
	
	
	
	#
	
	var orange_blue_syn = ColorSynergy.new("OrangeBlue", [TowerColors.ORANGE, TowerColors.BLUE], [5, 4, 3, 2],
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
	[CompleSyn_OrangeBlue.new()],
	[
		"Explosion per 0.4 seconds. Explosions are 100% larger.",
		"Explosion per 1.5 seconds. Explosions are 75% larger.",
		"Explosion per 4.5 seconds. Explosions are 25% larger.",
		"Explosion per 10.0 seconds."
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	)
	
	#
	
	var interpreter_for_orangeYR_attk_speed_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_orangeYR_attk_speed_tier_1.display_body = false
	
	var ins_for_orangeYR_attk_speed_tier_1 = []
	ins_for_orangeYR_attk_speed_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 170, true))
	
	interpreter_for_orangeYR_attk_speed_tier_1.array_of_instructions = ins_for_orangeYR_attk_speed_tier_1
	
	#
	
	var interpreter_for_orangeYR_attk_speed_tier_2 : TextFragmentInterpreter = interpreter_for_orangeYR_attk_speed_tier_1.get_deep_copy()
	interpreter_for_orangeYR_attk_speed_tier_2.array_of_instructions[0].num_val = 90
	
	var interpreter_for_orangeYR_attk_speed_tier_3 : TextFragmentInterpreter = interpreter_for_orangeYR_attk_speed_tier_1.get_deep_copy()
	interpreter_for_orangeYR_attk_speed_tier_3.array_of_instructions[0].num_val = 50
	
	var interpreter_for_orangeYR_attk_speed_tier_4 : TextFragmentInterpreter = interpreter_for_orangeYR_attk_speed_tier_1.get_deep_copy()
	interpreter_for_orangeYR_attk_speed_tier_4.array_of_instructions[0].num_val = 20
	
	
	
	var orange_yr_syn = ColorSynergy.new("OrangeYR", [TowerColors.ORANGE, TowerColors.YELLOW, TowerColors.RED], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_orangeYR,
	[
		"Main attacks cause towers to gain attack speed, which stacks up to a limit. Bonuses received per attack inversely scales with tower's attack speed.",
		"15 seconds worth of attacks are required to reach the limit.",
		""
	],
	[AnaSyn_OrangeYR.new()],
	[
		["Up to |0|", [interpreter_for_orangeYR_attk_speed_tier_1]],
		["Up to |0|", [interpreter_for_orangeYR_attk_speed_tier_2]],
		["Up to |0|", [interpreter_for_orangeYR_attk_speed_tier_3]],
		["Up to |0|", [interpreter_for_orangeYR_attk_speed_tier_4]],
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	)
	
	#
	
	var interpreter_for_yelloGO_ele_on_hit_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_yelloGO_ele_on_hit_tier_1.display_body = false
	
	var ins_for_yelloGO_ele_on_hit_tier_1 = []
	ins_for_yelloGO_ele_on_hit_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental on hit damage", 6))
	
	interpreter_for_yelloGO_ele_on_hit_tier_1.array_of_instructions = ins_for_yelloGO_ele_on_hit_tier_1
	
	
	var interpreter_for_yelloGO_ele_on_hit_tier_2 : TextFragmentInterpreter = interpreter_for_yelloGO_ele_on_hit_tier_1.get_deep_copy()
	interpreter_for_yelloGO_ele_on_hit_tier_2.array_of_instructions[0].num_val = 3.5
	
	var interpreter_for_yelloGO_ele_on_hit_tier_3 : TextFragmentInterpreter = interpreter_for_yelloGO_ele_on_hit_tier_1.get_deep_copy()
	interpreter_for_yelloGO_ele_on_hit_tier_3.array_of_instructions[0].num_val = 2.0
	
	var interpreter_for_yelloGO_ele_on_hit_tier_4 : TextFragmentInterpreter = interpreter_for_yelloGO_ele_on_hit_tier_1.get_deep_copy()
	interpreter_for_yelloGO_ele_on_hit_tier_4.array_of_instructions[0].num_val = 1.0
	
	#
	
	var interpreter_for_yelloGO_base_dmg_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_yelloGO_base_dmg_tier_1.display_body = false
	
	var ins_for_yelloGO_base_dmg_tier_1 = []
	ins_for_yelloGO_base_dmg_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "total base damage", 150, true))
	
	interpreter_for_yelloGO_base_dmg_tier_1.array_of_instructions = ins_for_yelloGO_base_dmg_tier_1
	
	
	var interpreter_for_yelloGO_base_dmg_tier_2 : TextFragmentInterpreter = interpreter_for_yelloGO_base_dmg_tier_1.get_deep_copy()
	interpreter_for_yelloGO_base_dmg_tier_2.array_of_instructions[0].num_val = 80
	
	var interpreter_for_yelloGO_base_dmg_tier_3 : TextFragmentInterpreter = interpreter_for_yelloGO_base_dmg_tier_1.get_deep_copy()
	interpreter_for_yelloGO_base_dmg_tier_3.array_of_instructions[0].num_val = 40
	
	var interpreter_for_yelloGO_base_dmg_tier_4 : TextFragmentInterpreter = interpreter_for_yelloGO_base_dmg_tier_1.get_deep_copy()
	interpreter_for_yelloGO_base_dmg_tier_4.array_of_instructions[0].num_val = 20
	
	
	#
	
	var interpreter_for_yelloGO_attk_speed_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_yelloGO_attk_speed_tier_1.display_body = false
	
	var ins_for_yelloGO_attk_speed_tier_1 = []
	ins_for_yelloGO_attk_speed_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "total attack speed", 150, true))
	
	interpreter_for_yelloGO_attk_speed_tier_1.array_of_instructions = ins_for_yelloGO_attk_speed_tier_1
	
	
	var interpreter_for_yelloGO_attk_speed_tier_2 : TextFragmentInterpreter = interpreter_for_yelloGO_attk_speed_tier_1.get_deep_copy()
	interpreter_for_yelloGO_attk_speed_tier_2.array_of_instructions[0].num_val = 80
	
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
	
	
	
	var yellow_go_syn = ColorSynergy.new("YellowGO", [TowerColors.YELLOW, TowerColors.GREEN, TowerColors.ORANGE], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_yellowGO,
	[
		"Brings about a Fluctuation, which buffs a tower for 3 seconds. Fluctuation then seeks another tower to buff.",
		"Cycle: Fluctuation goes to the first tower that attacks. Afterwards, Fluctuation loops to the highest base damage tower, then to the highest attack speed tower, then to the tower that has dealt the most damage in the round.",
		"Fluctuation cannot re-target to the same tower. Fluctuation will avoid towers that cannot attack, or with no enemies in its range. When no viable tower is found, the Cycle is reset.",
		"",
		"A Fluctuated tower gains buffs.",
		""
	],
	[AnaSyn_YellowGO.new()],
	[
		["+|0|, +|1|, +|2|, +|3|.", [interpreter_for_yelloGO_ele_on_hit_tier_1, interpreter_for_yelloGO_base_dmg_tier_1, interpreter_for_yelloGO_attk_speed_tier_1, interpreter_for_yelloGO_range_tier_1]],
		["+|0|, +|1|, +|2|, +|3|", [interpreter_for_yelloGO_ele_on_hit_tier_2, interpreter_for_yelloGO_base_dmg_tier_2, interpreter_for_yelloGO_attk_speed_tier_2, interpreter_for_yelloGO_range_tier_2]],
		["+|0|, +|1|, +|2|, +|3|.", [interpreter_for_yelloGO_ele_on_hit_tier_3, interpreter_for_yelloGO_base_dmg_tier_3, interpreter_for_yelloGO_attk_speed_tier_3, interpreter_for_yelloGO_range_tier_3]],
		["+|0|, +|1|, +|2|, +|3|.", [interpreter_for_yelloGO_ele_on_hit_tier_4, interpreter_for_yelloGO_base_dmg_tier_4, interpreter_for_yelloGO_attk_speed_tier_4, interpreter_for_yelloGO_range_tier_4]]
	],
	ColorSynergy.HighlightDeterminer.SINGLE
	)
	
	#
	
	var interpreter_for_greenBY_ele_on_hit_per_stack_tier_1 = TextFragmentInterpreter.new()
	interpreter_for_greenBY_ele_on_hit_per_stack_tier_1.display_body = false
	
	var ins_for_greenBY_ele_on_hit_per_stack_tier_1 = []
	ins_for_greenBY_ele_on_hit_per_stack_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "on hit dmg", 0.35))
	
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
	ins_for_greenBY_ele_on_hit_max_tier_1.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "", 7.0))
	
	interpreter_for_greenBY_ele_on_hit_max_tier_1.array_of_instructions = ins_for_greenBY_ele_on_hit_max_tier_1
	
	
	var interpreter_for_greenBY_ele_on_hit_max_tier_2 : TextFragmentInterpreter = interpreter_for_greenBY_ele_on_hit_max_tier_1.get_deep_copy()
	interpreter_for_greenBY_ele_on_hit_max_tier_2.array_of_instructions[0].num_val = 3.4
	
	var interpreter_for_greenBY_ele_on_hit_max_tier_3 : TextFragmentInterpreter = interpreter_for_greenBY_ele_on_hit_max_tier_1.get_deep_copy()
	interpreter_for_greenBY_ele_on_hit_max_tier_3.array_of_instructions[0].num_val = 1.4
	
	var interpreter_for_greenBY_ele_on_hit_max_tier_4 : TextFragmentInterpreter = interpreter_for_greenBY_ele_on_hit_max_tier_1.get_deep_copy()
	interpreter_for_greenBY_ele_on_hit_max_tier_4.array_of_instructions[0].num_val = 0.6
	
	
	
	
	var green_by_syn = ColorSynergy.new("GreenBY", [TowerColors.GREEN, TowerColors.BLUE, TowerColors.YELLOW], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_greenBY,
	[
		"Towers gain bonus elemental damage on hit per main attack, up to a limit. The bonus can be granted only once per second.",
		""
	],
	[AnaSyn_GreenBY.new()],
	[
		["+|0|, up to |1|", [interpreter_for_greenBY_ele_on_hit_per_stack_tier_1, interpreter_for_greenBY_ele_on_hit_max_tier_1]],
		["+|0|, up to |1|", [interpreter_for_greenBY_ele_on_hit_per_stack_tier_2, interpreter_for_greenBY_ele_on_hit_max_tier_2]],
		["+|0|, up to |1|", [interpreter_for_greenBY_ele_on_hit_per_stack_tier_3, interpreter_for_greenBY_ele_on_hit_max_tier_3]],
		["+|0|, up to |1|", [interpreter_for_greenBY_ele_on_hit_per_stack_tier_4, interpreter_for_greenBY_ele_on_hit_max_tier_4]]
	],
	ColorSynergy.HighlightDeterminer.SINGLE
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
	
	
	
	
	var blue_vg_syn = ColorSynergy.new("BlueVG", [TowerColors.BLUE, TowerColors.VIOLET, TowerColors.GREEN], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_blueVG,
	[
		"All abilities's cooldowns are reduced.",
		"",
		"Right before a tower casts an ability, the tower gains stacking ability potency for the round. AP gained scales on its cooldown.",
		["Towers with abilities whose cooldowns are not time-based are granted |0| per cast instead.", [interpreter_for_blueVG_ap_for_no_cd]],
		""
	],
	[AnaSyn_BlueVG.new()],
	[
		["|0|. +|1| per 15 seconds of cooldown.", [interpreter_for_blue_vg_cooldown_tier_1, interpreter_for_blueVG_ap_per_cast_ratio]],
		["|0|. +|1| per 20 seconds of cooldown.", [interpreter_for_blue_vg_cooldown_tier_2, interpreter_for_blueVG_ap_per_cast_ratio]],
		["|0|. +|1| per 30 seconds of cooldown.", [interpreter_for_blue_vg_cooldown_tier_3, interpreter_for_blueVG_ap_per_cast_ratio]],
		["|0|. +|1| per 40 seconds of cooldown.", [interpreter_for_blue_vg_cooldown_tier_4, interpreter_for_blueVG_ap_per_cast_ratio]]
	],
	ColorSynergy.HighlightDeterminer.SINGLE
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
	
	
	
	
	var violet_rb_syn = ColorSynergy.new("VioletRB", [TowerColors.VIOLET, TowerColors.RED, TowerColors.BLUE], [4, 3, 2, 1],
	[tier_dia_pic, tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_ana_violetRB,
	[
		"Main attacks cause towers to lose 5% of their max health.",
		"Upon dying, towers equally split a percent of their total base damage and total ability potency to all other towers.",
		"The last standing tower becomes invulenrable and immune to enemy effects, and gains 50% projectile speed for the rest of the round.",
		""
	],
	[AnaSyn_VioletRB.new()],
	[
		["|0|, |1|", [interpreter_for_violetRB_base_dmg_ratio_tier_1, interpreter_for_violetRB_ap_ratio_tier_1]],
		["|0|, |1|", [interpreter_for_violetRB_base_dmg_ratio_tier_2, interpreter_for_violetRB_ap_ratio_tier_2]],
		["|0|, |1|", [interpreter_for_violetRB_base_dmg_ratio_tier_3, interpreter_for_violetRB_ap_ratio_tier_3]],
		["|0|, |1|", [interpreter_for_violetRB_base_dmg_ratio_tier_4, interpreter_for_violetRB_ap_ratio_tier_4]]
	],
	ColorSynergy.HighlightDeterminer.SINGLE
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
	
	
	
	var ogv_syn = ColorSynergy.new("OGV", [TowerColors.ORANGE, TowerColors.GREEN, TowerColors.VIOLET], [3, 2, 1], #[4, 3, 2],
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
		"Cooldown: 1 round",
		""
	],
	[TriaSyn_OGV.new()],
	[
		["|0|. 30 max damage per round.", [interpreter_for_ogv_attk_speed_tier_1]],
		["|0|. 20 max damage per round.", [interpreter_for_ogv_attk_speed_tier_2]],
		["|0|. 15 max damage per round.", [interpreter_for_ogv_attk_speed_tier_3]]
	]
	)
	
	
	# ------------------------------------------------------
	
	synergies = {
	# Comple
	"RedGreen" : red_green_syn,
	
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
	
	"OrangeBlue" : orange_blue_syn,
	
	
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
	
	"OrangeYR" : orange_yr_syn,
	
	"YellowGO" : yellow_go_syn,
	
	"GreenBY" : green_by_syn,
	
	"BlueVG" : blue_vg_syn,
	
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
#	[AnaSyn_VioletRB.new()],
#	[
#		"Pride Void",
#		"Ability Void",
#		"Strength Void",
#	],
#	ColorSynergy.HighlightDeterminer.ALL_BELOW
#	),
	
	"VioletRB" : violet_rb_syn,
	
	#Tria
	"RYB" : ColorSynergy.new("RYB", [TowerColors.RED, TowerColors.YELLOW, TowerColors.BLUE], [4, 3, 2],
	[tier_gold_pic, tier_silver_pic, tier_bronze_pic],
	syn_compo_tria_RYB,
	[
		"The first few enemies that reach the end of the track for the first time are instead brought back to the start of the track, preventing life loss. This counter resets every round.",
		"Enemies brought back heal for 40% of their missing health and receive damage resistance. The damage resistance cannot be removed by any means.",
		"Elite and Boss enemies count as 2 enemies for this effect.",
		"",
		"Triggering this effect counts as a round loss.",
		"",
		"\"Just when they thought it was all over...\"",
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
	
	"OGV" : ogv_syn,
	
	
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
