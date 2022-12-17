extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")
const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const ConditionalClause = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const ScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/ScreenTintEffect.gd")

const BreezeAbility_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/Ability_Breeze_Icon.png")
const ManaBlast_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/Ability_ManaBlast_Icon.png")
const Renew_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/Ability_Renew_Icon.png")
const Empower_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/Ability_Empower_Icon.png")
const Empower_Pic_Selected = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/Ability_Empower_Icon_Selected.png")

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const AbilityButton = preload("res://GameHUDRelated/AbilityPanel/AbilityButton.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const BaseTowerDetectingAOE = preload("res://EnemyRelated/TowerInteractingRelated/Spawnables/BaseTowerDetectingAOE.gd")
const BaseTowerDetectingAOE_Scene = preload("res://EnemyRelated/TowerInteractingRelated/Spawnables/BaseTowerDetectingAOE.tscn")
const TD_AOEAttackModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TD_AOEAttackModule.gd")
const TD_AOEAttackModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TD_AOEAttackModule.tscn")

const ManaBurst_Mark_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_Mark.tscn")
const ManaBurst_Exp_Pic01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_01.png")
const ManaBurst_Exp_Pic02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_02.png")
const ManaBurst_Exp_Pic03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_03.png")
const ManaBurst_Exp_Pic04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_04.png")
const ManaBurst_Exp_Pic05 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_05.png")
const ManaBurst_Exp_Pic06 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_06.png")
const ManaBurst_Exp_Pic07 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/ManaBurst/ManaBurst_07.png")

const ManaBurst_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Blue_Related/AbilityAssets/Ability_ManaBlast_StatusBarIcon.png")


var game_elements : GameElements
var enemy_manager : EnemyManager

#
var breeze_ability : BaseAbility
const base_breeze_ability_cooldown : float = 30.0

const base_breeze_first_slow_amount : float = -50.0
const base_breeze_first_slow_duration : float = 3.0
var breeze_first_slow_modifier : PercentModifier
var breeze_first_slow_effect : EnemyAttributesEffect

const base_breeze_second_slow_amount : float = -15.0
const base_breeze_second_slow_duration : float = 6.0 + base_breeze_first_slow_duration
var breeze_second_slow_modifier : PercentModifier
var breeze_second_slow_effect : EnemyAttributesEffect

const base_breeze_damage : float = 4.0

# Assigned at construct breeze ability func
const breeze_ability_descriptions : Array = [
	
]


const empowered_base_breeze_second_slow_amount : float = -75.0
const empowered_base_breeze_second_slow_duration : float = 8.0 + base_breeze_first_slow_duration

const empowered_breeze_extra_descriptions = [
	"",
	"Empowered: Sea Breeze is empowered to slow by %s and lasts for %s" % [(str(-empowered_base_breeze_second_slow_amount) + "%,"), (str(empowered_base_breeze_second_slow_duration) + "s.")]
]

const linked_breeze_descriptions : Array = [
	breeze_ability_descriptions,
	empowered_breeze_extra_descriptions
]


#
var mana_blast_ability : BaseAbility
const mana_blast_ability_cooldown : float = 55.0

var mana_blast_module : AOEAttackModule

const mana_blast_base_damage : float = 15.0
#const mana_blast_extra_main_target_dmg_scale : float = 2.0

var mana_blast_buff_aoe_module : TD_AOEAttackModule
var mana_blast_buff_tower_effect : TowerAttributesEffect
const mana_blast_ap_buff_amount : float = 0.75
const mana_blast_buff_duration : float = 10.0

# Assigned at construct mana blast ability func
const mana_blast_ability_descriptions = []


#

const empowered_mana_blast_ap_buff_amount : float = 2.25

# Assigned at construct mana blast ability func
const empowered_mana_blast_extra_descriptions = []

const linked_mana_blast_descriptions : Array = [
	mana_blast_ability_descriptions,
	empowered_mana_blast_extra_descriptions
]



const renew_empower_shared_ability_cooldown : float = 50.0
const cannot_cast_as_renew_or_empower_clause_id : int = -20

var renew_ability : BaseAbility
const renew_ability_description : Array = [
	"Removes remaining time based cooldowns of ALL abilities. Renew is castable only when at least one BLUE ability is in cooldown.",
	"",
	"Does not affect Empower ability. Shares cooldown with Empower ability.",
	"Cooldown: %s" % [str(renew_empower_shared_ability_cooldown) + "s"]
]


const empower_ability_cancel_static_cooldown : float = 0.25
var empower_ability : BaseAbility
const empower_ability_description : Array = [
	"Greatly empowers the next BLUE ability that is casted. Empower is castable only when no BLUE ability is in cooldown.",
	"Re-casting cancels the effect instead, putting this ability at a %s cooldown." % (str(empower_ability_cancel_static_cooldown) + "s"),
	"",
	"Does not affect Renew ability. Shares cooldown with Renew ability.",
	"Cooldown: %s" % [str(renew_empower_shared_ability_cooldown) + "s"]
]

#

const renew_empower_ability_connected_ability_empowered_name_extension : String = " (Empowered)"

var is_next_ability_empowered : bool = false
var connected_blue_abilities : Array = []

var blue_abilities_descriptions_map : Dictionary = {}

 
# AP related

const tower_ap_tier_1 : float = 0.75
const tower_ap_tier_2 : float = 0.50
const tower_ap_tier_3 : float = 0.25

var tower_ap_effect : TowerAttributesEffect
var tower_ap_modi : FlatModifier

var curr_tier : int

#



func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
		enemy_manager = game_elements.enemy_manager
	
	
	# Abilities
	
	if tier <= 3:
		if breeze_ability == null:
			_construct_breeze_relateds()
	
	if tier <= 2:
		if mana_blast_ability == null:
			_construct_mana_blast_relateds()
		else:
			mana_blast_ability.set_clauses_to_usual_synergy_sufficient_based()
	else:
		if mana_blast_ability != null:
			mana_blast_ability.set_clauses_to_usual_synergy_insufficient_based()
	
	
	if tier <= 1:
		if renew_ability == null:
			_construct_renew_and_empower_abilities()
		else:
			renew_ability.set_clauses_to_usual_synergy_sufficient_based()
			empower_ability.set_clauses_to_usual_synergy_sufficient_based()
	else:
		if renew_ability != null:
			renew_ability.set_clauses_to_usual_synergy_insufficient_based()
			empower_ability.set_clauses_to_usual_synergy_insufficient_based()
	
	
	# Ability Potency
	if tower_ap_effect == null:
		_construct_ap_effect()
	
	curr_tier = tier
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	curr_tier = 0
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


func register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	game_elements.ability_manager.add_ability(ability, add_to_panel)


# Breeze related

func _construct_breeze_relateds():
	breeze_ability = BaseAbility.new()
	
	breeze_ability.is_timebound = true
	breeze_ability.connect("ability_activated", self, "_breeze_ability_activated", [], CONNECT_PERSIST)
	breeze_ability.icon = BreezeAbility_Pic
	
	breeze_ability.set_properties_to_usual_synergy_based()
	breeze_ability.synergy = self
	
	# INS START
	var interpreter_for_breeze_dmg = TextFragmentInterpreter.new()
	interpreter_for_breeze_dmg.display_body = false
	
	var ins_for_breeze_dmg = []
	ins_for_breeze_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", base_breeze_damage))
	
	interpreter_for_breeze_dmg.array_of_instructions = ins_for_breeze_dmg
	
	
	var plain_fragment__slow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "Slows")
	
	# INS END
	var temp_breeze_ability_desc = [
		["|0| all enemies by %s%% for %s seconds, then slows by %s%% for %s seconds. Also deals |1|." % [str(-base_breeze_first_slow_amount), str(base_breeze_first_slow_duration), str(-base_breeze_second_slow_amount), str(base_breeze_second_slow_duration - base_breeze_first_slow_duration)], [plain_fragment__slow, interpreter_for_breeze_dmg]],
		"Cooldown: %s s" % [str(base_breeze_ability_cooldown)],
		#"",
		#"Ability potency increases the slow percentage and the damage."
	]
	for desc in temp_breeze_ability_desc:
		breeze_ability_descriptions.append(desc)
	
	breeze_ability.descriptions = breeze_ability_descriptions
	breeze_ability.display_name = "Breeze"
	
	breeze_ability.set_properties_to_auto_castable()
	breeze_ability.auto_cast_func = "_breeze_ability_activated"
	
	register_ability_to_manager(breeze_ability)
	
	# breeze first slow
	breeze_first_slow_modifier = PercentModifier.new(StoreOfEnemyEffectsUUID.BLUE_BREEZE_FIRST_SLOW)
	breeze_first_slow_modifier.percent_amount = base_breeze_first_slow_amount
	breeze_first_slow_modifier.percent_based_on = PercentType.BASE
	
	breeze_first_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, breeze_first_slow_modifier, StoreOfEnemyEffectsUUID.BLUE_BREEZE_FIRST_SLOW)
	breeze_first_slow_effect.is_timebound = true
	breeze_first_slow_effect.time_in_seconds = base_breeze_first_slow_duration
	
	# breeze second slow
	breeze_second_slow_modifier = PercentModifier.new(StoreOfEnemyEffectsUUID.BLUE_BREEZE_SECOND_SLOW)
	breeze_second_slow_modifier.percent_amount = base_breeze_second_slow_amount
	breeze_second_slow_modifier.percent_based_on = PercentType.BASE
	
	breeze_second_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, breeze_second_slow_modifier, StoreOfEnemyEffectsUUID.BLUE_BREEZE_SECOND_SLOW)
	breeze_second_slow_effect.is_timebound = true
	breeze_second_slow_effect.time_in_seconds = base_breeze_second_slow_duration
	
	blue_abilities_descriptions_map[breeze_ability] = [
		breeze_ability_descriptions,
		empowered_breeze_extra_descriptions
	]


func _breeze_ability_activated():
	var final_ap_scale : float = breeze_ability.get_potency_to_use(1)
	breeze_first_slow_modifier.percent_amount = base_breeze_first_slow_amount * final_ap_scale
	
	if !is_next_ability_empowered:
		breeze_second_slow_modifier.percent_amount = base_breeze_second_slow_amount * final_ap_scale
	else:
		breeze_second_slow_modifier.percent_amount = empowered_base_breeze_second_slow_amount * final_ap_scale
	
	var dmg_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.BREEZE_DAMAGE)
	dmg_modi.flat_modifier = base_breeze_damage * final_ap_scale
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.BREEZE_DAMAGE, dmg_modi, DamageType.ELEMENTAL)
	var dmg_instance : DamageInstance = DamageInstance.new()
	dmg_instance.on_hit_damages[StoreOfTowerEffectsUUID.BREEZE_DAMAGE] = on_hit_dmg
	dmg_instance.on_hit_effects[StoreOfEnemyEffectsUUID.BLUE_BREEZE_FIRST_SLOW] = breeze_first_slow_effect
	
	var copy_of_second_slow = breeze_second_slow_effect._get_copy_scaled_by(1)
	if is_next_ability_empowered:
		copy_of_second_slow.time_in_seconds = empowered_base_breeze_second_slow_duration
	
	dmg_instance.on_hit_effects[StoreOfEnemyEffectsUUID.BLUE_BREEZE_SECOND_SLOW] = copy_of_second_slow
	
	var breeze_screen_effect = ScreenTintEffect.new()
	breeze_screen_effect.main_duration = 1.5
	breeze_screen_effect.fade_in_duration = 0.5
	breeze_screen_effect.fade_out_duration = 0.5
	breeze_screen_effect.tint_color = Color(186.0 / 255.0, 0.99, 0.99, 0.15)
	breeze_screen_effect.ins_uuid = StoreOfScreenEffectsUUID.BLUE_BREEZE
	breeze_screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS
	game_elements.screen_effect_manager.add_screen_tint_effect(breeze_screen_effect)
	
	for enemy in enemy_manager.get_all_targetable_and_invisible_enemies():
		call_deferred("_apply_breeze_to_enemy", enemy, dmg_instance)
	
	breeze_ability.start_time_cooldown(base_breeze_ability_cooldown)

func _apply_breeze_to_enemy(enemy, dmg_instance):
	enemy.hit_by_damage_instance(dmg_instance)


# Mana Blast

func _construct_mana_blast_relateds():
	mana_blast_ability = BaseAbility.new()
	
	mana_blast_ability.is_timebound = true
	mana_blast_ability.connect("ability_activated", self, "_mana_blast_ability_activated", [], CONNECT_PERSIST)
	mana_blast_ability.icon = ManaBlast_Pic
	
	mana_blast_ability.set_properties_to_usual_synergy_based()
	mana_blast_ability.synergy = self
	
	# ins start
	var interpreter_for_mana_blast_dmg = TextFragmentInterpreter.new()
	interpreter_for_mana_blast_dmg.display_body = false
	
	var ins_for_mana_blast_dmg = []
	ins_for_mana_blast_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", mana_blast_base_damage))
	
	interpreter_for_mana_blast_dmg.array_of_instructions = ins_for_mana_blast_dmg
	
	
	var interpreter_for_mana_blast_ap = TextFragmentInterpreter.new()
	interpreter_for_mana_blast_ap.display_body = false
	
	var ins_for_mana_blast_ap = []
	ins_for_mana_blast_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", mana_blast_ap_buff_amount))
	
	interpreter_for_mana_blast_ap.array_of_instructions = ins_for_mana_blast_ap
	
	
	
	# ins end
	
	var temp_mana_blast_desc = [
		"Summon a mark at the cursor's location. After a brief delay, the mark releases a mana blast.",
		["The blast deals |0| to enemies inside.", [interpreter_for_mana_blast_dmg]],
		["Towers caught in the blast gain |0| for %s seconds." % [str(mana_blast_buff_duration)], [interpreter_for_mana_blast_ap]],
		"Cooldown: %s s" % str(mana_blast_ability_cooldown)
	]
	for desc in temp_mana_blast_desc:
		mana_blast_ability_descriptions.append(desc)
	
	mana_blast_ability.descriptions = mana_blast_ability_descriptions
	mana_blast_ability.display_name = "Mana Blast"
	
	mana_blast_ability.set_properties_to_auto_castable()
	mana_blast_ability.auto_cast_func = "_mana_blast_ability_activated"
	
	register_ability_to_manager(mana_blast_ability)
	
	# aoe module
	
	mana_blast_module = AOEAttackModule_Scene.instance()
	
	mana_blast_module.base_damage = mana_blast_base_damage
	mana_blast_module.base_damage_type = DamageType.ELEMENTAL
	mana_blast_module.base_attack_speed = 0
	mana_blast_module.base_attack_wind_up = 0
	mana_blast_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	mana_blast_module.is_main_attack = true
	mana_blast_module.module_id = StoreOfAttackModuleID.MAIN
	
	mana_blast_module.benefits_from_bonus_explosion_scale = true
	mana_blast_module.benefits_from_bonus_base_damage = true
	mana_blast_module.benefits_from_bonus_attack_speed = false
	mana_blast_module.benefits_from_bonus_on_hit_damage = true
	mana_blast_module.benefits_from_bonus_on_hit_effect = true
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic01)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic02)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic03)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic04)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic05)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic06)
	sprite_frames.add_frame("default", ManaBurst_Exp_Pic07)
	
	mana_blast_module.aoe_sprite_frames = sprite_frames
	mana_blast_module.sprite_frames_only_play_once = true
	mana_blast_module.pierce = -1
	mana_blast_module.duration = 0.3
	mana_blast_module.damage_repeat_count = 1
	
	mana_blast_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	mana_blast_module.base_aoe_scene = BaseAOE_Scene
	mana_blast_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	mana_blast_module.can_be_commanded_by_tower = false
	
	game_elements.add_child(mana_blast_module)
	
	
	# mana blast buff
	
	mana_blast_buff_aoe_module = TD_AOEAttackModule_Scene.instance()
	
	var buff_sprite_frames = SpriteFrames.new()
	buff_sprite_frames.add_frame("default", ManaBurst_Exp_Pic01)
	
	mana_blast_buff_aoe_module.aoe_sprite_frames = buff_sprite_frames
	mana_blast_buff_aoe_module.sprite_frames_only_play_once = true
	mana_blast_buff_aoe_module.pierce = -1
	mana_blast_buff_aoe_module.duration = 0.3
	mana_blast_buff_aoe_module.damage_repeat_count = 1
	
	mana_blast_buff_aoe_module.aoe_default_coll_shape = BaseTowerDetectingAOE.BaseAOEDefaultShapes.CIRCLE
	mana_blast_buff_aoe_module.base_aoe_scene = BaseTowerDetectingAOE_Scene
	mana_blast_buff_aoe_module.spawn_location_and_change = TD_AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	game_elements.add_child(mana_blast_buff_aoe_module)
	
	
	var buff_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.MANA_BLAST_BONUS_AP)
	buff_modi.flat_modifier = mana_blast_ap_buff_amount
	
	mana_blast_buff_tower_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, buff_modi, StoreOfTowerEffectsUUID.MANA_BLAST_BONUS_AP)
	mana_blast_buff_tower_effect.time_in_seconds = mana_blast_buff_duration
	mana_blast_buff_tower_effect.is_timebound = true
	mana_blast_buff_tower_effect.status_bar_icon = ManaBurst_StatusBarIcon
	
	# descs
	
	# INS START
	var interpreter_for_mana_blast_ap_emp = TextFragmentInterpreter.new()
	interpreter_for_mana_blast_ap_emp.display_body = false
	
	var ins_for_mana_blast_ap_emp = []
	ins_for_mana_blast_ap_emp.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", empowered_mana_blast_ap_buff_amount))
	
	interpreter_for_mana_blast_ap_emp.array_of_instructions = ins_for_mana_blast_ap_emp
	
	
	# INS END
	var temp_mana_blast_emp_desc = [
		"",
		["Empowered: Towers caught in the mana blast recieve |0| instead.", [interpreter_for_mana_blast_ap_emp]],
	]
	for desc in temp_mana_blast_emp_desc:
		empowered_mana_blast_extra_descriptions.append(desc)
	
	blue_abilities_descriptions_map[mana_blast_ability] = [
		mana_blast_ability_descriptions,
		empowered_mana_blast_extra_descriptions
	]


func _mana_blast_ability_activated():
	var enemies : Array = Targeting.enemies_to_target(enemy_manager.get_all_enemies(), Targeting.FIRST, 1, Vector2(0, 0), true)
	if enemies.size() >= 1:
		_set_ap_buff_to_give()
		_place_marker(enemies[0])
		mana_blast_ability.start_time_cooldown(mana_blast_ability_cooldown)


func _set_ap_buff_to_give():
	if is_next_ability_empowered:
		mana_blast_buff_tower_effect.attribute_as_modifier.flat_modifier = empowered_mana_blast_ap_buff_amount
	else:
		mana_blast_buff_tower_effect.attribute_as_modifier.flat_modifier = mana_blast_ap_buff_amount

func _place_marker(enemy):
	var marker = ManaBurst_Mark_Scene.instance()
	marker.frames_based_on_lifetime = true
	marker.lifetime = 0.6
	#marker.global_position = enemy.global_position
	marker.global_position = mana_blast_module.get_viewport().get_mouse_position()
	
	marker.connect("tree_exiting", self, "_marker_expire", [marker, enemy], CONNECT_ONESHOT)
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(marker)


func _marker_expire(marker : Node2D, enemy):
	var pos := marker.global_position
	var explosion = mana_blast_module.construct_aoe(pos, pos)
	
	explosion.scale *= 4
	explosion.global_position = marker.global_position
	#explosion.connect("before_enemy_hit_aoe", self, "_on_explosion_hit_enemy", [enemy], CONNECT_DEFERRED)
	
	mana_blast_module.set_up_aoe__add_child_and_emit_signals(explosion)
	_summon_tower_detecting_aoe(marker.global_position)


func _summon_tower_detecting_aoe(pos : Vector2):
	var aoe = mana_blast_buff_aoe_module.construct_aoe(pos, pos)
	aoe.scale *= 4
	aoe.global_position = pos
	aoe.modulate = Color(0, 0, 0, 0)
	aoe.coll_source_layer = CollidableSourceAndDest.Source.FROM_TOWER
	
	aoe.connect("on_tower_hit", self, "_on_buff_aoe_hit_tower", [])
	CommsForBetweenScenes.ge_add_child_to_proj_hoster(aoe)


#func _on_explosion_hit_enemy(enemy, main_enemy):
#	if enemy == main_enemy and main_enemy != null:
#		var dmg_instance = mana_blast_module.construct_damage_instance()
#		main_enemy.hit_by_damage_instance(dmg_instance.get_copy_damage_only_scaled_by(mana_blast_extra_main_target_dmg_scale))

func _on_buff_aoe_hit_tower(tower):
	tower.add_tower_effect(mana_blast_buff_tower_effect._shallow_duplicate())

#

#func _construct_renew_empower_ability():
#	renew_empower_ability = BaseAbility.new()
#
#	renew_empower_ability.is_timebound = true
#	renew_empower_ability.connect("ability_activated", self, "_renew_empower_ability_activated", [], CONNECT_PERSIST)
#	renew_empower_ability.icon = Renew_Pic
#
#	renew_empower_ability.set_properties_to_usual_synergy_based()
#	renew_empower_ability.synergy = self
#
#	renew_empower_ability.display_name = "Renew/Empower"
#
#	#
#	_monitor_and_connect_ability(breeze_ability)
#	_monitor_and_connect_ability(mana_blast_ability)
#
#	register_ability_to_manager(renew_empower_ability)
#
#	call_deferred("_check_if_blue_abilities_are_in_cooldown")

func _construct_renew_and_empower_abilities():
	renew_ability = BaseAbility.new()
	
	renew_ability.is_timebound = true
	renew_ability.connect("ability_activated", self, "_cast_as_renew", [], CONNECT_PERSIST)
	renew_ability.icon = Renew_Pic
	
	renew_ability.descriptions = renew_ability_description
	
	renew_ability.set_properties_to_usual_synergy_based()
	renew_ability.synergy = self
	
	renew_ability.display_name = "Renew"
	
	renew_ability.set_properties_to_auto_castable()
	renew_ability.auto_cast_func = "_cast_as_renew"
	
	
	#
	
	empower_ability = BaseAbility.new()
	
	empower_ability.is_timebound = true
	empower_ability.connect("ability_activated", self, "_cast_as_empower", [], CONNECT_PERSIST)
	empower_ability.icon = Empower_Pic
	
	empower_ability.descriptions = empower_ability_description
	
	empower_ability.set_properties_to_usual_synergy_based()
	empower_ability.synergy = self
	
	empower_ability.display_name = "Empower"
	
	empower_ability.set_properties_to_auto_castable()
	empower_ability.auto_cast_func = "_cast_as_empower"
	
	#
	
	_monitor_and_connect_ability(breeze_ability)
	_monitor_and_connect_ability(mana_blast_ability)
	
	register_ability_to_manager(renew_ability)
	register_ability_to_manager(empower_ability)
	
	call_deferred("_check_if_blue_abilities_are_in_cooldown")


func _monitor_and_connect_ability(arg_ability : BaseAbility):
	if arg_ability != null:
		arg_ability.connect("current_time_cd_reached_zero", self, "_check_if_blue_abilities_are_in_cooldown", [], CONNECT_PERSIST)
		arg_ability.connect("ability_activated", self, "_monitored_ability_casted", [], CONNECT_PERSIST)
		arg_ability.connect("started_time_cooldown", self, "_monitored_ability_cd_started", [], CONNECT_PERSIST)
		connected_blue_abilities.append(arg_ability)


func _monitored_ability_cd_started(max_time_cd, current_time_cd):
	_check_if_blue_abilities_are_in_cooldown()

#func _check_if_blue_abilities_are_in_cooldown():
#	if _if_at_least_one_blue_abilities_is_in_cooldown():
#		_show_renew_as_display()
#	else:
#		_show_empower_as_display()

func _check_if_blue_abilities_are_in_cooldown():
	if _if_at_least_one_blue_abilities_is_in_cooldown():
		_enable_renew_and_disable_empower()
	else:
		_disable_renew_and_enable_empower()

func _if_at_least_one_blue_abilities_is_in_cooldown() -> bool:
	for ability in connected_blue_abilities:
		if ability != null:
			if !ability.is_time_ready_or_round_ready() and !ability.activation_conditional_clauses.has_clause(BaseAbility.ActivationClauses.SYNERGY_INACTIVE):
				return true
	
	return false


#func _show_empower_as_display():
#	renew_empower_ability.icon = Empower_Pic
#
#	var descs : Array = renew_empower_ability_constant_description.duplicate()
#	for desc in renew_empower_ability_empower_active_description:
#		descs.append(desc)
#	renew_empower_ability.descriptions = descs
#
#
#func _show_renew_as_display():
#	renew_empower_ability.icon = renew_empower_side_renew_icon
#
#	var descs : Array = renew_empower_ability_constant_description.duplicate()
#	for desc in renew_empower_ability_renew_active_description:
#		descs.append(desc)
#	renew_empower_ability.descriptions = descs

func _enable_renew_and_disable_empower():
	renew_ability.activation_conditional_clauses.remove_clause(cannot_cast_as_renew_or_empower_clause_id)
	empower_ability.activation_conditional_clauses.attempt_insert_clause(cannot_cast_as_renew_or_empower_clause_id)

func _disable_renew_and_enable_empower():
	renew_ability.activation_conditional_clauses.attempt_insert_clause(cannot_cast_as_renew_or_empower_clause_id)
	empower_ability.activation_conditional_clauses.remove_clause(cannot_cast_as_renew_or_empower_clause_id)


#

#func _renew_empower_ability_activated():
#	if _if_at_least_one_blue_abilities_is_in_cooldown():
#		_cast_as_renew()
#	else:
#		_cast_as_empower()

#

func _cast_as_renew():
	#for ability in connected_blue_abilities:
	#	ability.remove_all_time_cooldown()
	
	for ability in game_elements.ability_manager.all_abilities:
		if ability != empower_ability and ability != renew_ability:
			ability.remove_all_time_cooldown()
	
	#renew_empower_ability.start_time_cooldown(renew_empower_ability_cooldown)
	renew_ability.start_time_cooldown(renew_empower_shared_ability_cooldown)
	empower_ability.start_time_cooldown(renew_empower_shared_ability_cooldown)
	
	set_deferred("is_next_ability_empowered", false)
	_display_normal_version_of_monitored_ability_descriptions()

#

func _cast_as_empower():
	if !is_next_ability_empowered:
		is_next_ability_empowered = true
		empower_ability.icon = Empower_Pic_Selected
		
		_display_empowered_version_of_monitored_ability_descriptions()
	else:
		_return_from_empowered(true)

func _display_empowered_version_of_monitored_ability_descriptions():
	for ability in connected_blue_abilities:
		var linked_descs : Array = blue_abilities_descriptions_map[ability]
		var final_descs : Array = []
		
		for descs in linked_descs:
			for desc in descs:
				final_descs.append(desc)
		
		ability.descriptions = final_descs
		
		ability.display_name = ability.display_name + renew_empower_ability_connected_ability_empowered_name_extension



func _monitored_ability_casted():
	if is_next_ability_empowered:
		_return_from_empowered(false)


#func _return_from_empowered(is_recast : bool = false):
#	if is_recast:
#		renew_empower_ability.start_time_cooldown(renew_empower_ability_empower_static_cooldown)
#		_show_empower_as_display()
#
#	else:
#		renew_empower_ability.start_time_cooldown(renew_empower_ability_cooldown)
#		_show_renew_as_display()
#
#	_display_normal_version_of_monitored_ability_descriptions()
#
#	set_deferred("is_next_ability_empowered", false)

func _return_from_empowered(is_recast : bool = false):
	if is_recast:
		empower_ability.start_time_cooldown(empower_ability_cancel_static_cooldown)
		
	else:
		empower_ability.start_time_cooldown(renew_empower_shared_ability_cooldown)
		renew_ability.start_time_cooldown(renew_empower_shared_ability_cooldown)
	
	_display_normal_version_of_monitored_ability_descriptions()
	empower_ability.icon = Empower_Pic
	
	set_deferred("is_next_ability_empowered", false)



func _display_normal_version_of_monitored_ability_descriptions():
	for ability in connected_blue_abilities:
		var linked_descs : Array = blue_abilities_descriptions_map[ability]
		var final_descs : Array = []
		
		for desc in linked_descs[0]:
			final_descs.append(desc)
		
		ability.descriptions = final_descs
		
		ability.display_name = ability.display_name.replace(renew_empower_ability_connected_ability_empowered_name_extension, "")


# AP Effect related

func _construct_ap_effect():
	tower_ap_modi = FlatModifier.new(StoreOfTowerEffectsUUID.BLUE_AP_EFFECT)
	tower_ap_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, tower_ap_modi, StoreOfTowerEffectsUUID.BLUE_AP_EFFECT)



func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if tower.is_benefit_from_syn_having_or_as_if_having_color(TowerColors.BLUE) and !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLUE_AP_EFFECT):
		
		if curr_tier == 1:
			tower_ap_modi.flat_modifier = tower_ap_tier_1
		elif curr_tier == 2:
			tower_ap_modi.flat_modifier = tower_ap_tier_2
		elif curr_tier == 3:
			tower_ap_modi.flat_modifier = tower_ap_tier_3
		
		tower.add_tower_effect(tower_ap_effect._shallow_duplicate())



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.BLUE_AP_EFFECT)
	if effect != null:
		tower.remove_tower_effect(effect)

