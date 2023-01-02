extends "res://MapsRelated/BaseMap.gd"

const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const Enchant_PillarEffect_StatusBarIcon_Blue = preload("res://MapsRelated/MapList/Map_Enchant/Assets/StatusBarIcons/EnchantPillarEffect_StatusBarIcon_Blue.png")
const Enchant_PillarEffect_StatusBarIcon_Green = preload("res://MapsRelated/MapList/Map_Enchant/Assets/StatusBarIcons/EnchantPillarEffect_StatusBarIcon_Green.png")
const Enchant_PillarEffect_StatusBarIcon_Red = preload("res://MapsRelated/MapList/Map_Enchant/Assets/StatusBarIcons/EnchantPillarEffect_StatusBarIcon_Red.png")
const Enchant_PillarEffect_StatusBarIcon_Yellow = preload("res://MapsRelated/MapList/Map_Enchant/Assets/StatusBarIcons/EnchantPillarEffect_StatusBarIcon_Yellow.png")

const Enchant_Ability_Pic_01 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Ability/Enchant_Ability_01.png")
const Enchant_Ability_Pic_02 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Ability/Enchant_Ability_02.png")
const Enchant_Ability_Pic_03 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_Ability/Enchant_Ability_03.png")

const Enchant_Altar_Pic_00 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Altar/Enchant_Altar_01.png")
const Enchant_Altar_Pic_01 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Altar/Enchant_Altar_02.png")
const Enchant_Altar_Pic_02 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Altar/Enchant_Altar_03.png")
const Enchant_Altar_Pic_03 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_Altar/Enchant_Altar_04.png")

const Enchant_AltarColorIndicator_Pic_Blue = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_AltarColorIndicator/Enchant_AltarColorIndicator_Blue.png")
const Enchant_AltarColorIndicator_Pic_Gray = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_AltarColorIndicator/Enchant_AltarColorIndicator_Gray.png")
const Enchant_AltarColorIndicator_Pic_Green = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_AltarColorIndicator/Enchant_AltarColorIndicator_Green.png")
const Enchant_AltarColorIndicator_Pic_Red = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_AltarColorIndicator/Enchant_AltarColorIndicator_Red.png")
const Enchant_AltarColorIndicator_Pic_Yellow = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_AltarColorIndicator/Enchant_AltarColorIndicator_Yellow.png")

const Enchant_Pillar = preload("res://MapsRelated/MapList/Map_Enchant/Subs/Enchant_Pillar/Enchant_Pillar.gd")

const BeamStretchAesthetic = preload("res://MiscRelated/BeamRelated/BeamStretchAesthetic.gd")
const BeamStretchAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamStretchAesthetic.tscn")
const Enchant_PillarPreFormed_Pic_Blue = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarPreFormed_Blue.png")
const Enchant_PillarPreFormed_Pic_Yellow = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarPreFormed_Yellow.png")
const Enchant_PillarPreFormed_Pic_Red = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarPreFormed_Red.png")
const Enchant_PillarPreFormed_Pic_Green = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarPreFormed_Green.png")

const Enchant_PillarActivation_Pic_Blue = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_Blue.png")
const Enchant_PillarActivation_Pic_Yellow = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_Yellow.png")
const Enchant_PillarActivation_Pic_Red = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_Red.png")
const Enchant_PillarActivation_Pic_Green = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_Green.png")

const Enchant_ProgressBar_Fill_Charges0 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_ProgressBar/Enchant_ProgressBar_Fill01.png")
const Enchant_ProgressBar_Fill_Charges1 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_ProgressBar/Enchant_ProgressBar_Fill02.png")
const Enchant_ProgressBar_Fill_Charges2 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_ProgressBar/Enchant_ProgressBar_Fill03.png")

#

signal current_ability_charges_changed(arg_val)
signal current_time_delta_for_next_charge_changed(arg_time_delta, arg_time_delta_plus_charges)
# note: if time delta change results in ability charge change, the ability charge change signal is emitted first

#

const purple_bolt__upgrade_01__flat_dmg : float = 1.5
const purple_bolt__upgrade_02__flat_dmg : float = 2.0
const purple_bolt__upgrade_03__flat_dmg : float = 2.5

const purple_bolt__upgrade_01__amount : int = 6
const purple_bolt__upgrade_02__amount : int = 8
const purple_bolt__upgrade_03__amount : int = 12

const purple_bolt__explosion_pierce : int = 3

const purple_bolt_delay_per_fire : float = 0.225


const base_dmg__upgrade_01__percent_amount : float = 10.0
const base_dmg__upgrade_02__percent_amount : float = 20.0
const base_dmg__upgrade_03__percent_amount : float = 30.0
const base_dmg__upgrade__percent_type : int = PercentType.MAX

const attk_speed__upgrade_01__percent_amount : float = 10.0
const attk_speed__upgrade_02__percent_amount : float = 20.0
const attk_speed__upgrade_03__percent_amount : float = 30.0
const attk_speed__upgrade__percent_type : int = PercentType.MAX

const range__upgrade_01__percent_amount : float = 10.0
const range__upgrade_02__percent_amount : float = 20.0
const range__upgrade_03__percent_amount : float = 30.0
const range__upgrade__percent_type : int = PercentType.MAX

const ap__upgrade_01__amount : float = 0.2
const ap__upgrade_02__amount : float = 0.4
const ap__upgrade_03__amount : float = 0.6

const stat_buff_duration : float = 20.0

#

var _map_enchant__attacks__hidden_tower

#

const initial_upgrade_phase : int = 0
# 0 - 3, where 0 is inactive.
var _current_upgrade_phase : int = initial_upgrade_phase

var _current_purple_bolt_flat_dmg : float
var _current_purple_bolt_amount : int
var _current_base_dmg_percent_amount : float
var _current_attk_speed_percent_amount : float
var _current_range_percent_amount : float
var _current_ap_amount : float


var last_calculated_enchant_ability_description_upgrade_phase : int = -1
var last_calculated_enchant_ability_base_description : Array

var last_calculated_enchant_ability_blue_description : Array
var last_calculated_enchant_ability_yellow_description : Array
var last_calculated_enchant_ability_red_description : Array
var last_calculated_enchant_ability_green_description : Array

var trailing_enchant_ability_description : Array = [
	"",
	"Cooldown: %s seconds per charge. Max 2 charges." % [enchant_ability_base_cooldown_per_charge]
]

#

enum EnchantColor {
	BLUE = 0,
	YELLOW = 1,
	RED = 2,
	GREEN = 3,
}

enum EnchantAbilityActivationalClauseIds {
	NO_CHARGES = 0,
	DURING_CASTING = 1,
	INITIALIZING = 2,
	DURING_ANIMATION = 3,
}

var _enchant_relateds_initialized = false
var enchant_ability : BaseAbility
const enchant_ability_max_charges : int = 2
const enchant_ability_base_cooldown_per_charge : float = 65.0

const enchant_ability_charges_on_first_time_activation : int = 1


var _current_enchant_color : int = -1
var _current_ability_charges : float

var _current_time_delta_for_next_charge : float


enum CooldownCountdownClauses {
	MAX_CHARGES = 0,
	ROUND_ENDED = 1,
}
var enchant_ability_cooldown_countdown_cond_clauses : ConditionalClauses

#

var _enchant_pillar_blue : Enchant_Pillar
var _enchant_pillar_yellow : Enchant_Pillar
var _enchant_pillar_red : Enchant_Pillar
var _enchant_pillar_green : Enchant_Pillar
var _all_enchant_pillars : Array

var _timer_for_enchant_effect_duration : Timer

#

var _enchant_effect__ap : TowerAttributesEffect
var _enchant_effect__attk_speed : TowerAttributesEffect
var _enchant_effect__base_dmg : TowerAttributesEffect
var _enchant_effect__range : TowerAttributesEffect

# beam related

var _preformed_beam__for_above_altar : BeamStretchAesthetic
var _preformed_beam__for_pillar_blue : BeamStretchAesthetic
var _preformed_beam__for_pillar_yellow : BeamStretchAesthetic
var _preformed_beam__for_pillar_red : BeamStretchAesthetic
var _preformed_beam__for_pillar_green : BeamStretchAesthetic

var _fully_formed_beam__for_above_altar : Sprite
var _fully_formed_beam__for_pillar_blue : Sprite
var _fully_formed_beam__for_pillar_yellow : Sprite
var _fully_formed_beam__for_pillar_red : Sprite
var _fully_formed_beam__for_pillar_green : Sprite

var _preformed_beam_for_pillar_x_to_stretch : BeamStretchAesthetic
var _fully_formed_beam_for_pillar_x_to_show : Sprite
var _color_when_beam_is_starting : int
var _enchant_pillar_of_color_to_activate : Enchant_Pillar
var _stretch_distance : float = Enchant_PillarActivation_Pic_Blue.get_size().y
const stretch_duration : float = 0.35

# prog bar related

var _last_used_charge_val_for_texture_update : int = -1
const charge_amount_to_texture_map : Dictionary = {
	0 : Enchant_ProgressBar_Fill_Charges0,
	1 : Enchant_ProgressBar_Fill_Charges1,
	2 : Enchant_ProgressBar_Fill_Charges2,
}

#

var game_elements
var map_enchant_gen_purpose_rng : RandomNumberGenerator

#

onready var enchant_pillar_q1 = $Environment/Enchant_Pillar_Q1
onready var enchant_pillar_q2 = $Environment/Enchant_Pillar_Q2
onready var enchant_pillar_q3 = $Environment/Enchant_Pillar_Q3
onready var enchant_pillar_q4 = $Environment/Enchant_Pillar_Q4

onready var enchant_altar = $Environment/Enchant_Altar
onready var enchant_color_panel = $Environment/Enchant_ColorPanel

onready var pos_2d_for_hidden_tower = $Markers/PosForHiddenTower

onready var special_enemy_path = $EnemyPaths/SpecialEnemyPath

onready var enchant_ability_progress_bar = $Environment/EnchantAbilityProgressBar

#

func _ready():
	set_process(false)
	
	enchant_ability_progress_bar.visible = false

#

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	game_elements = arg_game_elements
	map_enchant_gen_purpose_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.MAP_ENCHANT_GEN_PURPOSE)
	
	special_enemy_path.is_used_for_natural_spawning = false
	
	#
	
	set_upgrade_phase(_current_upgrade_phase)
	
	

#### enchant ability

func _construct_and_add_enchant_ability():
	enchant_ability = BaseAbility.new()
	
	enchant_ability.is_timebound = false
	enchant_ability.is_roundbound = true
	enchant_ability.connect("ability_activated", self, "_on_enchant_ability_activated", [], CONNECT_PERSIST)
	
	enchant_ability.icon = Enchant_Ability_Pic_01
	
	enchant_ability.set_properties_to_auto_castable()
	enchant_ability.auto_cast_func = "_on_enchant_ability_activated"
	
	#enchant_ability.descriptions_source = self
	#enchant_ability.descriptions_source_func_name = "get_enchant_ability_description_to_use"
	enchant_ability.descriptions = get_enchant_ability_description_to_use()
	
	enchant_ability.activation_conditional_clauses.attempt_insert_clause(EnchantAbilityActivationalClauseIds.INITIALIZING)
	
	register_ability_to_manager(enchant_ability)



func register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	game_elements.ability_manager.add_ability(ability, add_to_panel)



func _calculate_enchant_ability_descriptions_if_needed():
	if last_calculated_enchant_ability_description_upgrade_phase != _current_upgrade_phase:
		_calculate_enchant_ability_descriptions()
		last_calculated_enchant_ability_description_upgrade_phase = _current_upgrade_phase

func _calculate_enchant_ability_descriptions():
	var interpreter_for_purple_bolt_dmg = TextFragmentInterpreter.new()
	interpreter_for_purple_bolt_dmg.display_body = false
	
	var ins_for_purple_bolt_dmg = []
	ins_for_purple_bolt_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", _current_purple_bolt_flat_dmg))
	
	interpreter_for_purple_bolt_dmg.array_of_instructions = ins_for_purple_bolt_dmg
	
	
	last_calculated_enchant_ability_base_description = [
		["Fire %s bolts to random enemies, with each exploding, dealing |0| to %s enemies." % [_current_purple_bolt_amount, purple_bolt__explosion_pierce], [interpreter_for_purple_bolt_dmg]],
		"Trigger additional effects based on generated color.",
		"",
	]
	
	### BLUE
	
	var plain_fragment__towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
	
	var interpreter_for_ap = TextFragmentInterpreter.new()
	interpreter_for_ap.display_body = false
	
	var ins_for_ap = []
	ins_for_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", _current_ap_amount, false))
	
	interpreter_for_ap.array_of_instructions = ins_for_ap
	
	
	last_calculated_enchant_ability_blue_description = [
		["BLUE: All |0| in the Blue Pillar's sector gain |1| for %s." % stat_buff_duration, [plain_fragment__towers, interpreter_for_ap]]
	]
	
	
	### YELLOW
	
	var interpreter_for_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_attk_speed.display_body = false
	
	var ins_for_attk_speed = []
	ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "total attack speed", _current_attk_speed_percent_amount, true))
	
	interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
	
	
	last_calculated_enchant_ability_yellow_description = [
		["YELLOW: All |0| in the Yellow Pillar's sector gain |1| for %s." % stat_buff_duration, [plain_fragment__towers, interpreter_for_attk_speed]]
	]
	
	
	### RED
	
	var interpreter_for_base_dmg = TextFragmentInterpreter.new()
	interpreter_for_base_dmg.display_body = false
	
	var ins_for_base_dmg = []
	ins_for_base_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "total attack speed", _current_attk_speed_percent_amount, true))
	
	interpreter_for_base_dmg.array_of_instructions = ins_for_base_dmg
	
	
	last_calculated_enchant_ability_red_description = [
		["RED: All |0| in the Red Pillar's sector gain |1| for %s." % stat_buff_duration, [plain_fragment__towers, interpreter_for_base_dmg]]
	]
	
	
	### GREEN
	
	var interpreter_for_range = TextFragmentInterpreter.new()
	interpreter_for_range.display_body = false
	
	var ins_for_range = []
	ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "total range", _current_range_percent_amount, true))
	
	interpreter_for_range.array_of_instructions = ins_for_range
	
	
	last_calculated_enchant_ability_red_description = [
		["GREEN: All |0| in the Green Pillar's sector gain |1| for %s." % stat_buff_duration, [plain_fragment__towers, interpreter_for_range]]
	]
	
	


func get_enchant_ability_description_to_use():  # if changing this method name, change desc source func name in ability
	var bucket = []
	bucket.append_array(last_calculated_enchant_ability_base_description)
	
	if _current_enchant_color == EnchantColor.BLUE:
		bucket.append(last_calculated_enchant_ability_blue_description)
	elif _current_enchant_color == EnchantColor.YELLOW:
		bucket.append(last_calculated_enchant_ability_yellow_description)
	elif _current_enchant_color == EnchantColor.RED:
		bucket.append(last_calculated_enchant_ability_red_description)
	elif _current_enchant_color == EnchantColor.GREEN:
		bucket.append(last_calculated_enchant_ability_green_description)
	
	bucket.append_array(trailing_enchant_ability_description)
	
	return bucket


####

func set_enchant_color(arg_color : int):
	_current_enchant_color = arg_color
	
	if arg_color == -1:
		enchant_color_panel.texture = Enchant_AltarColorIndicator_Pic_Gray
	elif arg_color == EnchantColor.BLUE:
		enchant_color_panel.texture = Enchant_AltarColorIndicator_Pic_Blue
	elif arg_color == EnchantColor.YELLOW:
		enchant_color_panel.texture = Enchant_AltarColorIndicator_Pic_Yellow
	elif arg_color == EnchantColor.RED:
		enchant_color_panel.texture = Enchant_AltarColorIndicator_Pic_Red
	elif arg_color == EnchantColor.GREEN:
		enchant_color_panel.texture = Enchant_AltarColorIndicator_Pic_Green
	
	
	enchant_ability.descriptions = get_enchant_ability_description_to_use()

func randomize_current_enchant_color():
	var current_colors = EnchantColor.values().duplicate()
	current_colors.remove(_current_enchant_color)
	
	var rand_color = StoreOfRNG.randomly_select_one_element(current_colors, map_enchant_gen_purpose_rng)
	set_enchant_color(rand_color)


###

func set_upgrade_phase(arg_phase : int):
	_current_upgrade_phase = arg_phase
	
	if _current_upgrade_phase >= 1 and !_enchant_relateds_initialized:
		_enchant_relateds_initialized = true
		
		_initialize_enchant_ability_and_relateds()
		_initialize_enchant_effects()
		_initialize_pillars()
		_initialize_purple_attk_hidden_tower()
		
		#
		
		_defer_initialize_beams_and_particles()
		_defer_initialize_enchant_ability_progress_bar()
		
		enchant_ability.activation_conditional_clauses.call_deferred("remove_clause", EnchantAbilityActivationalClauseIds.INITIALIZING)
	
	
	if _current_upgrade_phase == 3:
		enchant_ability.icon = Enchant_Ability_Pic_03
		
		_current_purple_bolt_flat_dmg = purple_bolt__upgrade_03__flat_dmg
		_current_purple_bolt_amount = purple_bolt__upgrade_03__amount
		_current_base_dmg_percent_amount = base_dmg__upgrade_03__percent_amount
		_current_attk_speed_percent_amount = attk_speed__upgrade_03__percent_amount
		_current_range_percent_amount = range__upgrade_03__percent_amount
		_current_ap_amount = ap__upgrade_03__amount
		
		enchant_altar.texture = Enchant_Altar_Pic_03
		
	elif _current_upgrade_phase == 2:
		enchant_ability.icon = Enchant_Ability_Pic_02
		
		_current_purple_bolt_flat_dmg = purple_bolt__upgrade_02__flat_dmg
		_current_purple_bolt_amount = purple_bolt__upgrade_02__amount
		_current_base_dmg_percent_amount = base_dmg__upgrade_02__percent_amount
		_current_attk_speed_percent_amount = attk_speed__upgrade_02__percent_amount
		_current_range_percent_amount = range__upgrade_02__percent_amount
		_current_ap_amount = ap__upgrade_02__amount
		
		enchant_altar.texture = Enchant_Altar_Pic_02
		
	elif _current_upgrade_phase == 1:
		enchant_ability.icon = Enchant_Ability_Pic_01
		
		_current_purple_bolt_flat_dmg = purple_bolt__upgrade_01__flat_dmg
		_current_purple_bolt_amount = purple_bolt__upgrade_01__amount
		_current_base_dmg_percent_amount = base_dmg__upgrade_01__percent_amount
		_current_attk_speed_percent_amount = attk_speed__upgrade_01__percent_amount
		_current_range_percent_amount = range__upgrade_01__percent_amount
		_current_ap_amount = ap__upgrade_01__amount
		
		enchant_altar.texture = Enchant_Altar_Pic_01
		
	elif _current_upgrade_phase == 0:
		enchant_altar.texture = Enchant_Altar_Pic_00
	
	if _current_upgrade_phase >= 1:
		_update_enchant_effect_based_on_current_amounts()
		
		_calculate_enchant_ability_descriptions_if_needed()
		enchant_ability.descriptions = get_enchant_ability_description_to_use()
		
		_update_enchant_hidden_tower_based_on_current_amounts()


func _initialize_enchant_ability_and_relateds():
	_initialize_enchant_ability_cooldown_countdown_clauses()
	_construct_and_add_enchant_ability()
	_initialize_enchant_ability_cooldowns_and_charges()
	
	randomize_current_enchant_color()


func _initialize_enchant_ability_cooldown_countdown_clauses():
	enchant_ability_cooldown_countdown_cond_clauses = ConditionalClauses.new()
	enchant_ability_cooldown_countdown_cond_clauses.connect("clause_inserted", self, "on_enchant_ability_cooldown_countdown_cond_clauses_updated", [], CONNECT_PERSIST)
	enchant_ability_cooldown_countdown_cond_clauses.connect("clause_removed", self, "on_enchant_ability_cooldown_countdown_cond_clauses_updated", [], CONNECT_PERSIST)
	
	if !game_elements.stage_round_manager.round_started:
		enchant_ability_cooldown_countdown_cond_clauses.attempt_insert_clause(CooldownCountdownClauses.ROUND_ENDED)

func on_enchant_ability_cooldown_countdown_cond_clauses_updated(_arg_clause_id):
	set_process(!enchant_ability_cooldown_countdown_cond_clauses.is_passed)



func _initialize_enchant_ability_cooldowns_and_charges():
	set_current_time_delta_for_next_charge(enchant_ability_base_cooldown_per_charge)
	set_current_ability_charges(enchant_ability_charges_on_first_time_activation)

func set_current_ability_charges(arg_val):
	_current_ability_charges = arg_val
	
	if _current_ability_charges < enchant_ability_max_charges:
		#set_process(true)
		enchant_ability_cooldown_countdown_cond_clauses.remove_clause(CooldownCountdownClauses.MAX_CHARGES)
		
	else:
		#set_process(false)
		enchant_ability_cooldown_countdown_cond_clauses.attempt_insert_clause(CooldownCountdownClauses.MAX_CHARGES)
	
	
	if _current_ability_charges > 0:
		enchant_ability.activation_conditional_clauses.remove_clause(EnchantAbilityActivationalClauseIds.NO_CHARGES)
	else:
		enchant_ability.activation_conditional_clauses.attempt_insert_clause(EnchantAbilityActivationalClauseIds.NO_CHARGES)
	
	emit_signal("current_ability_charges_changed", _current_ability_charges)

func set_current_time_delta_for_next_charge(arg_val):
	_current_time_delta_for_next_charge = arg_val
	
	if _current_time_delta_for_next_charge <= 0:
		#_current_time_delta_for_next_charge = 0
		
		_current_time_delta_for_next_charge = (enchant_ability_base_cooldown_per_charge + _current_time_delta_for_next_charge)  # plussing to compensate for counting more than negatives
		set_current_ability_charges(_current_ability_charges + 1)
	
	emit_signal("current_time_delta_for_next_charge_changed", _current_time_delta_for_next_charge, _current_time_delta_for_next_charge + (_current_ability_charges * enchant_ability_base_cooldown_per_charge))


func _initialize_enchant_effects():
	var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.MAP_ENCHANT__AP_EFFECT)
	base_ap_attr_mod.flat_modifier = _current_ap_amount
	_enchant_effect__ap = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.MAP_ENCHANT__AP_EFFECT)
	_enchant_effect__ap.is_timebound = false
	_enchant_effect__ap.effect_icon = Enchant_PillarEffect_StatusBarIcon_Blue
	
	var total_attk_speed_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.MAP_ENCHANT__ATTK_SPEED_EFFECT)
	total_attk_speed_modi.percent_amount = _current_attk_speed_percent_amount
	total_attk_speed_modi.percent_based_on = PercentType.MAX
	total_attk_speed_modi.ignore_flat_limits = true
	_enchant_effect__attk_speed = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, total_attk_speed_modi, StoreOfTowerEffectsUUID.MAP_ENCHANT__ATTK_SPEED_EFFECT)
	_enchant_effect__attk_speed.is_timebound = false
	_enchant_effect__attk_speed.effect_icon = Enchant_PillarEffect_StatusBarIcon_Yellow
	
	var total_base_damage_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.MAP_ENCHANT__BASE_DMG_EFFECT)
	total_base_damage_modi.percent_amount = _current_base_dmg_percent_amount
	total_base_damage_modi.percent_based_on = PercentType.MAX
	total_base_damage_modi.ignore_flat_limits = true
	_enchant_effect__base_dmg = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS, total_base_damage_modi, StoreOfTowerEffectsUUID.MAP_ENCHANT__BASE_DMG_EFFECT)
	_enchant_effect__base_dmg.is_timebound = false
	_enchant_effect__base_dmg.effect_icon = Enchant_PillarEffect_StatusBarIcon_Red
	
	var total_range_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.MAP_ENCHANT__RANGE_EFFECT)
	total_range_modi.percent_amount = _current_range_percent_amount
	total_range_modi.percent_based_on = PercentType.MAX
	total_range_modi.ignore_flat_limits = true
	_enchant_effect__range = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_RANGE, total_range_modi, StoreOfTowerEffectsUUID.MAP_ENCHANT__RANGE_EFFECT)
	_enchant_effect__range.is_timebound = false
	_enchant_effect__range.effect_icon = Enchant_PillarEffect_StatusBarIcon_Green
	
	#
	
	_timer_for_enchant_effect_duration = Timer.new()
	_timer_for_enchant_effect_duration.one_shot = true
	_timer_for_enchant_effect_duration.connect("timeout", self, "_on_timer_for_enchant_effect_duration_timeout", [], CONNECT_PERSIST)
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_timer_for_enchant_effect_duration)
	
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end__map_enchant", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("round_started", self, "_on_round_start__map_enchant", [], CONNECT_PERSIST)

func _update_enchant_effect_based_on_current_amounts():
	_enchant_effect__ap.attribute_as_modifier.flat_modifier = _current_ap_amount
	_enchant_effect__attk_speed.attribute_as_modifier.percent_amount = _current_attk_speed_percent_amount
	_enchant_effect__base_dmg.attribute_as_modifier.percent_amount = _current_base_dmg_percent_amount
	_enchant_effect__range.attribute_as_modifier.percent_amount = _current_range_percent_amount
	
	_update_pillar_effects()

func _update_pillar_effects():
	if is_instance_valid(_enchant_pillar_blue) and _enchant_effect__ap != null:
		_enchant_pillar_blue.set_tower_effect_to_give(_enchant_effect__ap)
		_enchant_pillar_yellow.set_tower_effect_to_give(_enchant_effect__attk_speed)
		_enchant_pillar_red.set_tower_effect_to_give(_enchant_effect__base_dmg)
		_enchant_pillar_green.set_tower_effect_to_give(_enchant_effect__range)



func _initialize_pillars():
	_all_enchant_pillars.append(enchant_pillar_q1)
	_all_enchant_pillars.append(enchant_pillar_q2)
	_all_enchant_pillars.append(enchant_pillar_q3)
	_all_enchant_pillars.append(enchant_pillar_q4)
	
	for pillar in _all_enchant_pillars:
		pillar.set_is_active(false)
	
	##
	
	var _all_unassigned_pillars : Array = _all_enchant_pillars.duplicate()
	
	var _current_available_pillar_colors : Array = Enchant_Pillar.PillarColor.values().duplicate(true)
	
	while _current_available_pillar_colors.size() > 0:
		var rand_color = StoreOfRNG.randomly_select_one_element(_current_available_pillar_colors, map_enchant_gen_purpose_rng)
		_current_available_pillar_colors.erase(rand_color)
		
		var pillar = _all_unassigned_pillars[_all_unassigned_pillars.size() - 1]
		pillar.set_pillar_color(rand_color)
		
		if rand_color == Enchant_Pillar.PillarColor.BLUE:
			_enchant_pillar_blue = pillar
			
		elif rand_color == Enchant_Pillar.PillarColor.YELLOW:
			_enchant_pillar_yellow = pillar
			
		elif rand_color == Enchant_Pillar.PillarColor.RED:
			_enchant_pillar_red = pillar
			
		elif rand_color == Enchant_Pillar.PillarColor.GREEN:
			_enchant_pillar_green = pillar
			
		
		_all_unassigned_pillars.remove(_all_unassigned_pillars.size() - 1)
	
	
	_update_pillar_effects()

func _process(delta):
	set_current_time_delta_for_next_charge(_current_time_delta_for_next_charge - delta)
	

#

func _update_enchant_hidden_tower_based_on_current_amounts():
	if is_instance_valid(_map_enchant__attacks__hidden_tower):
		_map_enchant__attacks__hidden_tower.set_purple_bolt_explosion_pierce(purple_bolt__explosion_pierce)
		_map_enchant__attacks__hidden_tower.set_purple_bolt_explosion_dmg(_current_purple_bolt_flat_dmg)
		_map_enchant__attacks__hidden_tower.set_purple_bolt_amount_per_barrage(_current_purple_bolt_amount)
		_map_enchant__attacks__hidden_tower.set_purple_bolt_delay_per_fire(purple_bolt_delay_per_fire)

func _initialize_purple_attk_hidden_tower():
	_map_enchant__attacks__hidden_tower = game_elements.tower_inventory_bench.create_hidden_tower_and_add_to_scene(Towers.MAP_ENCHANT__ATTACKS)
	_map_enchant__attacks__hidden_tower.connect("attack_execution_completed", self, "_on_attack_execution_completed", [], CONNECT_PERSIST)
	
	_update_enchant_hidden_tower_based_on_current_amounts()
	
	_map_enchant__attacks__hidden_tower.global_position = pos_2d_for_hidden_tower.global_position


############

func _on_enchant_ability_activated():
	enchant_ability.activation_conditional_clauses.attempt_insert_clause(EnchantAbilityActivationalClauseIds.DURING_CASTING)
	_map_enchant__attacks__hidden_tower.execute_attacks()
	
	_start_display_of_beam_animations()
	
	#
	set_current_ability_charges(_current_ability_charges - 1)
	randomize_current_enchant_color()

func _on_attack_execution_completed():
	enchant_ability.activation_conditional_clauses.remove_clause(EnchantAbilityActivationalClauseIds.DURING_CASTING)

###########

func _defer_initialize_beams_and_particles():
	call_deferred("_initialize_beams_and_particles")

func _initialize_beams_and_particles():
	_preformed_beam__for_above_altar = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_above_altar.position = pos_2d_for_hidden_tower.global_position
	_preformed_beam__for_above_altar.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_preformed_beam__for_above_altar)
	
	_preformed_beam__for_pillar_blue = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_pillar_blue.position = _enchant_pillar_blue.get_position_of_top() - _stretch_distance
	_preformed_beam__for_pillar_blue.texture = Enchant_PillarPreFormed_Pic_Blue
	_preformed_beam__for_pillar_blue.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_enchant_pillar_blue)
	
	_preformed_beam__for_pillar_yellow = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_pillar_yellow.position = _enchant_pillar_yellow.get_position_of_top() - _stretch_distance
	_preformed_beam__for_pillar_yellow.texture = Enchant_PillarPreFormed_Pic_Yellow
	_preformed_beam__for_pillar_yellow.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_enchant_pillar_yellow)
	
	_preformed_beam__for_pillar_red = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_pillar_red.position = _enchant_pillar_red.get_position_of_top() - _stretch_distance 
	_preformed_beam__for_pillar_red.texture = Enchant_PillarPreFormed_Pic_Red
	_preformed_beam__for_pillar_red.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_preformed_beam__for_pillar_red)
	
	_preformed_beam__for_pillar_green = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_pillar_green.position = _enchant_pillar_green.get_position_of_top() - _stretch_distance
	_preformed_beam__for_pillar_green.texture = Enchant_PillarPreFormed_Pic_Green
	_preformed_beam__for_pillar_green.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_preformed_beam__for_pillar_green)
	
	#####
	
	_fully_formed_beam__for_above_altar = Sprite.new()
	_fully_formed_beam__for_above_altar.position = pos_2d_for_hidden_tower.global_position - (_stretch_distance / 2)
	_fully_formed_beam__for_above_altar.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_fully_formed_beam__for_above_altar)
	
	_fully_formed_beam__for_pillar_blue = Sprite.new()
	_fully_formed_beam__for_pillar_blue.position = _enchant_pillar_blue.get_position_of_top() - (_stretch_distance / 2)
	_fully_formed_beam__for_pillar_blue.texture = Enchant_PillarActivation_Pic_Blue
	_fully_formed_beam__for_pillar_blue.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_fully_formed_beam__for_pillar_blue)
	
	_fully_formed_beam__for_pillar_yellow = Sprite.new()
	_fully_formed_beam__for_pillar_yellow.position = _enchant_pillar_yellow.get_position_of_top() - (_stretch_distance / 2)
	_fully_formed_beam__for_pillar_yellow.texture = Enchant_PillarActivation_Pic_Yellow
	_fully_formed_beam__for_pillar_yellow.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_fully_formed_beam__for_pillar_yellow)
	
	_fully_formed_beam__for_pillar_red = Sprite.new()
	_fully_formed_beam__for_pillar_red.position = _enchant_pillar_red.get_position_of_top() - (_stretch_distance / 2)
	_fully_formed_beam__for_pillar_red.texture = Enchant_PillarActivation_Pic_Red
	_fully_formed_beam__for_pillar_red.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_fully_formed_beam__for_pillar_red)
	
	_fully_formed_beam__for_pillar_green = Sprite.new()
	_fully_formed_beam__for_pillar_green.position = _enchant_pillar_green.get_position_of_top() - (_stretch_distance / 2)
	_fully_formed_beam__for_pillar_green.texture = Enchant_PillarActivation_Pic_Green
	_fully_formed_beam__for_pillar_green.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(_fully_formed_beam__for_pillar_green)
	
	


func _start_display_of_beam_animations():
	_color_when_beam_is_starting = _current_enchant_color
	enchant_ability.activation_conditional_clauses.attempt_insert_clause(EnchantAbilityActivationalClauseIds.DURING_ANIMATION)
	
	if _color_when_beam_is_starting == EnchantColor.BLUE:
		_preformed_beam_for_pillar_x_to_stretch = _preformed_beam__for_pillar_blue
		_fully_formed_beam_for_pillar_x_to_show = _fully_formed_beam__for_pillar_blue
		_enchant_pillar_of_color_to_activate = _enchant_pillar_blue
		_fully_formed_beam__for_above_altar.texture = Enchant_PillarActivation_Pic_Blue
		
	elif _color_when_beam_is_starting == EnchantColor.YELLOW:
		_preformed_beam_for_pillar_x_to_stretch = _preformed_beam__for_pillar_yellow
		_fully_formed_beam_for_pillar_x_to_show = _fully_formed_beam__for_pillar_yellow
		_enchant_pillar_of_color_to_activate = _enchant_pillar_yellow
		_fully_formed_beam__for_above_altar.texture = Enchant_PillarActivation_Pic_Yellow
		
	elif _color_when_beam_is_starting == EnchantColor.RED:
		_preformed_beam_for_pillar_x_to_stretch = _preformed_beam__for_pillar_red
		_fully_formed_beam_for_pillar_x_to_show = _fully_formed_beam__for_pillar_red
		_enchant_pillar_of_color_to_activate = _enchant_pillar_red
		_fully_formed_beam__for_above_altar.texture = Enchant_PillarActivation_Pic_Red
		
	elif _color_when_beam_is_starting == EnchantColor.GREEN:
		_preformed_beam_for_pillar_x_to_stretch = _preformed_beam__for_pillar_green
		_fully_formed_beam_for_pillar_x_to_show = _fully_formed_beam__for_pillar_green
		_enchant_pillar_of_color_to_activate = _enchant_pillar_green
		_fully_formed_beam__for_above_altar.texture = Enchant_PillarActivation_Pic_Green
		
	
	#_preformed_beam__for_above_altar.reset()
	_preformed_beam__for_above_altar.connect("beam_fully_stretched", self, "_on_preformed_beam_above_altar_fully_stretched", [], CONNECT_ONESHOT)
	_preformed_beam__for_above_altar.start_stretch(_preformed_beam__for_above_altar.global_position - Vector2(0, _stretch_distance), stretch_duration)
	

func _on_preformed_beam_above_altar_fully_stretched():
	_preformed_beam_for_pillar_x_to_stretch.connect("beam_fully_stretched", self, "_on_preformed_beam_above_pillar_x_stretched", [], CONNECT_ONESHOT)
	_preformed_beam_for_pillar_x_to_stretch.start_stretch(_preformed_beam_for_pillar_x_to_stretch.get_position_of_top(), stretch_duration)

func _on_preformed_beam_above_pillar_x_stretched():
	_enchant_pillar_of_color_to_activate.set_is_active(true)
	_timer_for_enchant_effect_duration.start(stat_buff_duration)
	
	_fully_formed_beam__for_above_altar.visible = true
	_fully_formed_beam_for_pillar_x_to_show.visible = true

func _on_timer_for_enchant_effect_duration_timeout():
	_enchant_pillar_of_color_to_activate.set_is_active(false)
	
	_fully_formed_beam__for_above_altar.visible = false
	_fully_formed_beam_for_pillar_x_to_show.visible = false
	_preformed_beam__for_above_altar.reset()
	_preformed_beam_for_pillar_x_to_stretch.reset()


func _on_round_end__map_enchant(arg_stageround):
	if _timer_for_enchant_effect_duration.time_left > 0:
		_timer_for_enchant_effect_duration.paused = true
	
	enchant_ability_cooldown_countdown_cond_clauses.attempt_insert_clause(CooldownCountdownClauses.ROUND_ENDED)

func _on_round_start__map_enchant(arg_stageround):
	if _timer_for_enchant_effect_duration.paused:
		_timer_for_enchant_effect_duration.paused = false
	
	enchant_ability_cooldown_countdown_cond_clauses.remove_clause(CooldownCountdownClauses.ROUND_ENDED)

###

func _defer_initialize_enchant_ability_progress_bar():
	call_deferred("_initialize_enchant_ability_progress_bar")

func _initialize_enchant_ability_progress_bar():
	enchant_ability_progress_bar.value_per_chunk = enchant_ability_base_cooldown_per_charge
	enchant_ability_progress_bar.max_value = enchant_ability_base_cooldown_per_charge * enchant_ability_max_charges
	
	connect("current_time_delta_for_next_charge_changed", self, "_on_current_time_delta_for_next_charge_changed__for_prog_bar_update", [], CONNECT_PERSIST)
	connect("current_ability_charges_changed", self, "_on_current_ability_charges_changed", [], CONNECT_PERSIST)
	
	_update_enchant_ability_progress_bar__curr_val()
	_update_enchant_ability_progress_bar__texture()

func _on_current_time_delta_for_next_charge_changed__for_prog_bar_update(arg_time_delta, arg_time_delta_plus_charges):
	_update_enchant_ability_progress_bar__curr_val()
	

func _update_enchant_ability_progress_bar__curr_val():
	var curr_prog_val = _current_time_delta_for_next_charge + (_current_ability_charges * enchant_ability_base_cooldown_per_charge)
	
	enchant_ability_progress_bar.current_value = curr_prog_val


func _on_current_ability_charges_changed(arg_charges):
	_update_enchant_ability_progress_bar__texture()

func _update_enchant_ability_progress_bar__texture():
	if _last_used_charge_val_for_texture_update != _current_ability_charges:
		_last_used_charge_val_for_texture_update = _current_ability_charges
		
		enchant_ability_progress_bar.fill_foreground_pic = charge_amount_to_texture_map[_current_ability_charges]

