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
const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")
const CenterBasedAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.tscn")
const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const SingleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/SingleEnemySpawnInstruction.gd")
const AbstractSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd")
const ChainSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/ChainSpawnInstruction.gd")
const MultipleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/MultipleEnemySpawnInstruction.gd")
const LinearEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/LinearEnemySpawnInstruction.gd")

const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")

const MapEnchant_WholeScreenGUI_Scene = preload("res://MapsRelated/MapList/Map_Enchant/GUI/MapEnchant_WholeScreenGUI/MapEnchant_WholeScreenGUI.tscn")
const MapEnchant_WholeScreenGUI = preload("res://MapsRelated/MapList/Map_Enchant/GUI/MapEnchant_WholeScreenGUI/MapEnchant_WholeScreenGUI.gd")

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

#const Enchant_PillarActivation_Pic_Blue = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_Blue.png")
#const Enchant_PillarActivation_Pic_Yellow = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_Yellow.png")
#const Enchant_PillarActivation_Pic_Red = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_Red.png")
#const Enchant_PillarActivation_Pic_Green = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_Green.png")
const Enchant_PillarActivationV2_Pic_01 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_V2_01.png")
const Enchant_PillarActivationV2_Pic_02 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_V2_02.png")
const Enchant_PillarActivationV2_Pic_03 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_V2_03.png")
const Enchant_PillarActivationV2_Pic_04 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_V2_04.png")
const Enchant_PillarActivationV2_Pic_05 = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_PillarActivation/Enchant_PillarActivation_V2_05.png")

const Enchant_ProgressBar_Fill_Charges0 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_ProgressBar/Enchant_ProgressBar_Fill01.png")
const Enchant_ProgressBar_Fill_Charges1 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_ProgressBar/Enchant_ProgressBar_Fill02.png")
const Enchant_ProgressBar_Fill_Charges2 = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_ProgressBar/Enchant_ProgressBar_Fill03.png")

const Enchant_UpgradeBar_Fill_InProgress = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_UpgradeBar/Enchant_UpgradeBar_Fill_InProgress.png")
const Enchant_UpgradeBar_Fill_Full = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_UpgradeBar/Enchant_UpgradeBar_Fill_Full.png")
const Enchant_UpgradeBar_Fill_Partial = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_UpgradeBar/Enchant_UpgradeBar_Fill_Partial.png")

const InMapPlacable_Pic_Blue = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_CustomPlacableTextures/Enchant_InMapPlacable_Blue.png")
const InMapPlacable_Pic_Yellow = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_CustomPlacableTextures/Enchant_InMapPlacable_Yellow.png")
const InMapPlacable_Pic_Red = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_CustomPlacableTextures/Enchant_InMapPlacable_Red.png")
const InMapPlacable_Pic_Green = preload("res://MapsRelated/MapList/Map_Enchant/MapAssets/Enchant_CustomPlacableTextures/Enchant_InMapPlacable_Green.png")

const MapEnchant_AntiMagik_BeamSuck_Particle = preload("res://EnemyRelated/EnemyTypes/Type_Others/MapEnchant_AntiMagik/Assets/MapEnchant_AntiMagik_BeamSuck_Particle.png")

const MapEnchant_AntiMagik_FadeSelfParticle_Scene = preload("res://EnemyRelated/EnemyTypes/Type_Others/MapEnchant_AntiMagik/Subs/MapEnchant_AntiMagik_FadeSelfParticle.tscn")

#

signal current_ability_charges_changed(arg_val)
signal current_time_delta_for_next_charge_changed(arg_time_delta, arg_time_delta_plus_charges)
# note: if time delta change results in ability charge change, the ability charge change signal is emitted first

signal current_upgrade_phase_changed(arg_val)
signal current_upgrade_val_depleted_by_enemies()

signal next_special_round_id_changed(arg_val)  # empty string if no more
signal round_count_before_next_special_round_changed(arg_round_count, arg_next_special_round_id)  # "arg_next_special_round_id" is empty string if no more

#

const purple_bolt__upgrade_01__flat_dmg : float = 1.25
const purple_bolt__upgrade_02__flat_dmg : float = 1.5
const purple_bolt__upgrade_03__flat_dmg : float = 1.75
const purple_bolt__upgrade_04__flat_dmg : float = 2.0
const purple_bolt__upgrade_05__flat_dmg : float = 2.5
const purple_bolt__upgrade_06__flat_dmg : float = 3.0

const purple_bolt__upgrade_01__amount : int = 9
const purple_bolt__upgrade_02__amount : int = 11
const purple_bolt__upgrade_03__amount : int = 13
const purple_bolt__upgrade_04__amount : int = 15
const purple_bolt__upgrade_05__amount : int = 17
const purple_bolt__upgrade_06__amount : int = 20

const purple_bolt__explosion_pierce : int = 3

const purple_bolt_delay_per_fire : float = 0.225


const base_dmg__upgrade_01__percent_amount : float = 7.5
const base_dmg__upgrade_02__percent_amount : float = 10.0
const base_dmg__upgrade_03__percent_amount : float = 15.0
const base_dmg__upgrade_04__percent_amount : float = 20.0
const base_dmg__upgrade_05__percent_amount : float = 25.0
const base_dmg__upgrade_06__percent_amount : float = 32.5
const base_dmg__upgrade__percent_type : int = PercentType.MAX

const attk_speed__upgrade_01__percent_amount : float = 7.5
const attk_speed__upgrade_02__percent_amount : float = 10.0
const attk_speed__upgrade_03__percent_amount : float = 15.0
const attk_speed__upgrade_04__percent_amount : float = 20.0
const attk_speed__upgrade_05__percent_amount : float = 25.0
const attk_speed__upgrade_06__percent_amount : float = 32.5
const attk_speed__upgrade__percent_type : int = PercentType.MAX

const range__upgrade_01__percent_amount : float = 7.5
const range__upgrade_02__percent_amount : float = 10.0
const range__upgrade_03__percent_amount : float = 15.0
const range__upgrade_04__percent_amount : float = 20.0
const range__upgrade_05__percent_amount : float = 25.0
const range__upgrade_06__percent_amount : float = 32.5
const range__upgrade__percent_type : int = PercentType.MAX

const ap__upgrade_01__amount : float = 0.1
const ap__upgrade_02__amount : float = 0.2
const ap__upgrade_03__amount : float = 0.3
const ap__upgrade_04__amount : float = 0.4
const ap__upgrade_05__amount : float = 0.5
const ap__upgrade_06__amount : float = 0.65

const stat_buff_duration : float = 25.0

# map placeable related

const q1_placable_name_determiner = "Q1"
const q2_placable_name_determiner = "Q2"
const q3_placable_name_determiner = "Q3"
const q4_placable_name_determiner = "Q4"

#

var _map_enchant__attacks__hidden_tower

#

const initial_upgrade_phase : int = 0
# 0 - 6, where 0 is inactive.
var _current_upgrade_phase : int = initial_upgrade_phase
const max_upgrade_phase : int = 6

# NOTE: Accessed by MapEnchant_WholeScreenPanel. Don't change var name.
var _current_purple_bolt_flat_dmg : float
var _current_purple_bolt_amount : int
var _current_base_dmg_percent_amount : float
var _current_attk_speed_percent_amount : float
var _current_range_percent_amount : float
var _current_ap_amount : float


var last_calculated_enchant_ability_description_upgrade_phase : int = -1
var last_calculated_enchant_ability_base_description : Array

var last_calculated_enchant_ability_purple_bolt_damage_stat_fragment : TextFragmentInterpreter

var last_calculated_enchant_ability_blue_description : Array
var last_calculated_enchant_ability_blue_stat_fragment : TextFragmentInterpreter
var last_calculated_enchant_ability_yellow_description : Array
var last_calculated_enchant_ability_yellow_stat_fragment : TextFragmentInterpreter
var last_calculated_enchant_ability_red_description : Array
var last_calculated_enchant_ability_red_stat_fragment : TextFragmentInterpreter
var last_calculated_enchant_ability_green_description : Array
var last_calculated_enchant_ability_green_stat_fragment : TextFragmentInterpreter

var trailing_enchant_ability_description : Array = [
	"",
	"When the effect duration ends, a new color is generated.",
	"Activating this consumes a charge. Up to %s charges can be stored." % [enchant_ability_max_charges],
	"Cooldown: %s seconds per charge." % [enchant_ability_base_cooldown_per_charge]
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
	DURING_EFFECTS = 4,
}

var _enchant_relateds_initialized = false
var enchant_ability : BaseAbility
const enchant_ability_max_charges : int = 2
const enchant_ability_base_cooldown_per_charge : float = 65.0

const enchant_ability_charges_on_first_time_activation : int = 1


var _current_enchant_color : int = -1
var _current_ability_charges : int

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

var _fully_formed_beam__for_above_altar : AnimatedSprite
var _fully_formed_beam__for_pillar_blue : AnimatedSprite
var _fully_formed_beam__for_pillar_yellow : AnimatedSprite
var _fully_formed_beam__for_pillar_red : AnimatedSprite
var _fully_formed_beam__for_pillar_green : AnimatedSprite

const fully_formed_beam__modulate_blue := Color(98/255.0, 78/255.0, 253/255.0, 0.6)
const fully_formed_beam__modulate_yellow := Color(252/255.0, 253/255.0, 78/255.0, 0.6)
const fully_formed_beam__modulate_red := Color(253/255.0, 78/255.0, 81/255.0, 0.6)
const fully_formed_beam__modulate_green := Color(101/255.0, 253/255.0, 78/255.0, 0.6)

var _preformed_beam_for_pillar_x_to_stretch : BeamStretchAesthetic
var _fully_formed_beam_for_pillar_x_to_show : AnimatedSprite
var _color_when_beam_is_starting : int
var _enchant_pillar_of_color_to_activate : Enchant_Pillar
var _stretch_distance : float = Enchant_PillarActivationV2_Pic_01.get_size().y
const stretch_duration : float = 0.35

# prog bar related

var _last_used_charge_val_for_texture_update : int = -1
const charge_amount_to_texture_map : Dictionary = {
	0 : Enchant_ProgressBar_Fill_Charges0,
	1 : Enchant_ProgressBar_Fill_Charges1,
	2 : Enchant_ProgressBar_Fill_Charges2,
}

# upgrade and upgrade bar related

enum UpgradeBarState {
	IN_PROGRESS = 0,
	FULL = 1,
	PARTIAL = 2,
}

var _current_upgrade_bar_state : int = -1
const upgrade_state_to_texture_map : Dictionary = {
	UpgradeBarState.IN_PROGRESS : Enchant_UpgradeBar_Fill_InProgress,
	UpgradeBarState.FULL : Enchant_UpgradeBar_Fill_Full,
	UpgradeBarState.PARTIAL : Enchant_UpgradeBar_Fill_Partial,
}

var _current_upgrade_bar_value : float = 0
var _current_upgrade_bar_value_for_inc_timers : float = 0
const max_upgrade_bar_val : float = 30.0
const upgrade_threshold_inc_for_improved_upgrade : float = 30.0

var _upgrade_disp_increment_timer : Timer
const upgrade_disp_increment_amount_per_inc : float = 1.0
const upgrade_disp_decrement_amount_per_dec : float = -3.0
const upgrade_disp_delta : float = 0.2

var _upgrade_val_amount_per_round : float

#

const enemy__anti_magik__delta_for_suck : float = 0.2
const enemy__anti_magik__upgrade_suck_per_detla : float = 1.0

var _is_current_upgrade_val_depleted_by_enemies = false 

# special rounds. ORDER MATTERS. From "greatest" to "least"
const special_rounds : Array = [
	"53",
	"43",
	"33",
	
	#"11",
	#"02",
]
const special_rounds_to_ins_method_map : Dictionary = {
	"53" : "get_spawn_ins_for_special_round__53",
	"43" : "get_spawn_ins_for_special_round__43",
	"33" : "get_spawn_ins_for_special_round__33",
	
	#"11" : "get_spawn_ins_for_special_round__02",
	#"02" : "get_spawn_ins_for_special_round__02",
}

# these vars are accessed by MapEnchant_WholeScreenGUI
var _next_special_round_id : String
var _rounds_before_next_special_round_id : int
#

const _special_enemy_spawn_metadata : Dictionary = {
	StoreOfEnemyMetadataIdsFromIns.MAP_ENCHANT__SPECIAL_ENEMY_MARKER : true,
	StoreOfEnemyMetadataIdsFromIns.NOT_SPAWNED_FROM_INS : true
}

# particles related

var beam_suck_particle_attk_sprite_pool : AttackSpritePoolComponent

var particle_for_upgrade_attk_sprite_pool : AttackSpritePoolComponent
var _timer_for_particle_for_upgrade : Timer
var _current_particle_for_upgrade_count_to_create : int

#

var reservation_for_whole_screen_gui

#

var special_room_drawer__x_left : float
var special_room_drawer__x_right : float

var special_room_drawer__y_start : float
var special_room_drawer__y_end : float

const special_room_drawer__color_01 := Color(195/255.0, 87/255.0, 24/255.0, 0.45)

const special_room_drawer_expand_duration :  float = 1.25

#

var game_elements
var map_enchant_gen_purpose_rng : RandomNumberGenerator
var non_essential_rng

var map_enchant_whole_screen_panel : MapEnchant_WholeScreenGUI

var _pink_spawn_loc_flag__for_special_path

#

onready var enchant_pillar_q1 = $Environment/Enchant_Pillar_Q1
onready var enchant_pillar_q2 = $Environment/Enchant_Pillar_Q2
onready var enchant_pillar_q3 = $Environment/Enchant_Pillar_Q3
onready var enchant_pillar_q4 = $Environment/Enchant_Pillar_Q4

onready var enchant_altar = $Environment/Enchant_Altar
onready var enchant_color_panel = $Environment/Enchant_ColorPanel

onready var pos_2d_for_hidden_tower = $Markers/PosForHiddenTower
onready var pos_2d_for_beam_suck = $Markers/PosForBeamSuck

onready var special_enemy_path = $EnemyPaths/SpecialEnemyPath
onready var special_enemy_path_texture_rect = $Environment/SpecialPath

onready var enchant_ability_progress_bar = $Environment/EnchantAbilityProgressBar
onready var enchant_upgrade_progress_bar = $Environment/EnchantUpgradeBar
onready var enchant_level_display_panel = $Environment/Enchant_LevelDisplayPanel

onready var enchant_about_to_upgrade_particle = $Environment/Enchant_AboutToUpgradeParticle

onready var enchant_extra_info_button = $Environment/Enchant_WholeScreenInfoButton

onready var pos_for_special_room__bottom_left = $Markers/PosForSpecialRoom_BotLeft
onready var pos_for_special_room__top_right = $Markers/PosForSpecialRoom_TopRight
onready var enchant_special_room_drawer_01 = $Environment/SpecialRoomDrawer


#

func _ready():
	set_process(false)
	
	enchant_ability_progress_bar.visible = false
	special_enemy_path_texture_rect.visible = false
	enchant_level_display_panel.set_map_enchant(self)
	
	_hide_and_stop_about_to_upgrade_particle()
	
	_defer_initialize_particle_for_upgrade_attk_sprite_pool__and_relateds()
	_defer_initialize_special_room_drawers()

#

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	game_elements = arg_game_elements
	map_enchant_gen_purpose_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.MAP_ENCHANT_GEN_PURPOSE)
	
	special_enemy_path.is_used_for_natural_spawning = false
	
	game_elements.enemy_manager.current_path_to_spawn_pattern = arg_game_elements.enemy_manager.PathToSpawnPattern.SWITCH_PER_SPAWN
	
	#
	
	set_upgrade_phase(_current_upgrade_phase)
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	_defer_initialize_upgrade_bar_and_relateds()
	_defer_initialize_beam_suck_particle_attk_sprite_pool()
	
	_deferred_initialize_map_enchant_whole_screen_panel__and_relateds()

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
	
	enchant_ability.display_name = "Enchant"
	
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
	
	last_calculated_enchant_ability_purple_bolt_damage_stat_fragment = interpreter_for_purple_bolt_dmg
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
	
	last_calculated_enchant_ability_blue_stat_fragment = interpreter_for_ap
	last_calculated_enchant_ability_blue_description = [
		["BLUE: All |0| in the Blue Pillar's sector gain |1| for %s seconds." % stat_buff_duration, [plain_fragment__towers, interpreter_for_ap]]
	]
	
	
	### YELLOW
	
	var interpreter_for_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_attk_speed.display_body = false
	
	var ins_for_attk_speed = []
	ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "total attack speed", _current_attk_speed_percent_amount, true))
	
	interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
	
	last_calculated_enchant_ability_yellow_stat_fragment = interpreter_for_attk_speed
	last_calculated_enchant_ability_yellow_description = [
		["YELLOW: All |0| in the Yellow Pillar's sector gain |1| for %s seconds." % stat_buff_duration, [plain_fragment__towers, interpreter_for_attk_speed]]
	]
	
	
	### RED
	
	var interpreter_for_base_dmg = TextFragmentInterpreter.new()
	interpreter_for_base_dmg.display_body = false
	
	var ins_for_base_dmg = []
	ins_for_base_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "total base damage", _current_base_dmg_percent_amount, true))
	
	interpreter_for_base_dmg.array_of_instructions = ins_for_base_dmg
	
	last_calculated_enchant_ability_red_stat_fragment = interpreter_for_base_dmg
	last_calculated_enchant_ability_red_description = [
		["RED: All |0| in the Red Pillar's sector gain |1| for %s seconds." % stat_buff_duration, [plain_fragment__towers, interpreter_for_base_dmg]]
	]
	
	
	### GREEN
	
	var interpreter_for_range = TextFragmentInterpreter.new()
	interpreter_for_range.display_body = false
	
	var ins_for_range = []
	ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "total range", _current_range_percent_amount, true))
	
	interpreter_for_range.array_of_instructions = ins_for_range
	
	last_calculated_enchant_ability_green_stat_fragment = interpreter_for_range
	last_calculated_enchant_ability_green_description = [
		["GREEN: All |0| in the Green Pillar's sector gain |1| for %s seconds." % stat_buff_duration, [plain_fragment__towers, interpreter_for_range]]
	]
	
	


func get_enchant_ability_description_to_use():  # if changing this method name, change desc source func name in ability
	var bucket = []
	bucket.append_array(last_calculated_enchant_ability_base_description)
	
	if _current_enchant_color == EnchantColor.BLUE:
		bucket.append_array(last_calculated_enchant_ability_blue_description)
	elif _current_enchant_color == EnchantColor.YELLOW:
		bucket.append_array(last_calculated_enchant_ability_yellow_description)
	elif _current_enchant_color == EnchantColor.RED:
		bucket.append_array(last_calculated_enchant_ability_red_description)
	elif _current_enchant_color == EnchantColor.GREEN:
		bucket.append_array(last_calculated_enchant_ability_green_description)
	
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
	
	
	if _current_upgrade_phase > 0:
		if arg_color == EnchantColor.BLUE:
			_enchant_pillar_blue.set_not_glowing_placable_texture(InMapPlacable_Pic_Blue)
			_enchant_pillar_yellow.set_not_glowing_placable_texture_to_default()
			_enchant_pillar_red.set_not_glowing_placable_texture_to_default()
			_enchant_pillar_green.set_not_glowing_placable_texture_to_default()
			
			
		elif arg_color == EnchantColor.YELLOW:
			_enchant_pillar_blue.set_not_glowing_placable_texture_to_default()
			_enchant_pillar_yellow.set_not_glowing_placable_texture(InMapPlacable_Pic_Yellow)
			_enchant_pillar_red.set_not_glowing_placable_texture_to_default()
			_enchant_pillar_green.set_not_glowing_placable_texture_to_default()
			
			
		elif arg_color == EnchantColor.RED:
			_enchant_pillar_blue.set_not_glowing_placable_texture_to_default()
			_enchant_pillar_yellow.set_not_glowing_placable_texture_to_default()
			_enchant_pillar_red.set_not_glowing_placable_texture(InMapPlacable_Pic_Red)
			_enchant_pillar_green.set_not_glowing_placable_texture_to_default()
			
		elif arg_color == EnchantColor.GREEN:
			_enchant_pillar_blue.set_not_glowing_placable_texture_to_default()
			_enchant_pillar_yellow.set_not_glowing_placable_texture_to_default()
			_enchant_pillar_red.set_not_glowing_placable_texture_to_default()
			_enchant_pillar_green.set_not_glowing_placable_texture(InMapPlacable_Pic_Green)
			


func randomize_current_enchant_color():
	var current_colors = EnchantColor.values().duplicate()
	current_colors.erase(_current_enchant_color)
	
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
		
		randomize_current_enchant_color()
		#
		
		_defer_initialize_beams_and_particles()
		_defer_initialize_enchant_ability_progress_bar()
		_defer_initialize_placable_to_pillar_assignment()
		#_defer_initialize_upgrade_bar_and_relateds()
		
		enchant_ability.activation_conditional_clauses.call_deferred("remove_clause", EnchantAbilityActivationalClauseIds.INITIALIZING)
	
	if _current_upgrade_phase == 6:
		enchant_ability.icon = Enchant_Ability_Pic_03
		
		_current_purple_bolt_flat_dmg = purple_bolt__upgrade_06__flat_dmg
		_current_purple_bolt_amount = purple_bolt__upgrade_06__amount
		_current_base_dmg_percent_amount = base_dmg__upgrade_06__percent_amount
		_current_attk_speed_percent_amount = attk_speed__upgrade_06__percent_amount
		_current_range_percent_amount = range__upgrade_06__percent_amount
		_current_ap_amount = ap__upgrade_06__amount
		
		enchant_altar.texture = Enchant_Altar_Pic_03
		
	elif _current_upgrade_phase == 5:
		enchant_ability.icon = Enchant_Ability_Pic_02
		
		_current_purple_bolt_flat_dmg = purple_bolt__upgrade_05__flat_dmg
		_current_purple_bolt_amount = purple_bolt__upgrade_05__amount
		_current_base_dmg_percent_amount = base_dmg__upgrade_05__percent_amount
		_current_attk_speed_percent_amount = attk_speed__upgrade_05__percent_amount
		_current_range_percent_amount = range__upgrade_05__percent_amount
		_current_ap_amount = ap__upgrade_05__amount
		
		enchant_altar.texture = Enchant_Altar_Pic_02
		
	elif _current_upgrade_phase == 4:
		enchant_ability.icon = Enchant_Ability_Pic_02
		
		_current_purple_bolt_flat_dmg = purple_bolt__upgrade_04__flat_dmg
		_current_purple_bolt_amount = purple_bolt__upgrade_04__amount
		_current_base_dmg_percent_amount = base_dmg__upgrade_04__percent_amount
		_current_attk_speed_percent_amount = attk_speed__upgrade_04__percent_amount
		_current_range_percent_amount = range__upgrade_04__percent_amount
		_current_ap_amount = ap__upgrade_04__amount
		
		enchant_altar.texture = Enchant_Altar_Pic_02
		
	elif _current_upgrade_phase == 3:
		enchant_ability.icon = Enchant_Ability_Pic_02
		
		_current_purple_bolt_flat_dmg = purple_bolt__upgrade_03__flat_dmg
		_current_purple_bolt_amount = purple_bolt__upgrade_03__amount
		_current_base_dmg_percent_amount = base_dmg__upgrade_03__percent_amount
		_current_attk_speed_percent_amount = attk_speed__upgrade_03__percent_amount
		_current_range_percent_amount = range__upgrade_03__percent_amount
		_current_ap_amount = ap__upgrade_03__amount
		
		enchant_altar.texture = Enchant_Altar_Pic_02
		
	elif _current_upgrade_phase == 2:
		enchant_ability.icon = Enchant_Ability_Pic_01
		
		_current_purple_bolt_flat_dmg = purple_bolt__upgrade_02__flat_dmg
		_current_purple_bolt_amount = purple_bolt__upgrade_02__amount
		_current_base_dmg_percent_amount = base_dmg__upgrade_02__percent_amount
		_current_attk_speed_percent_amount = attk_speed__upgrade_02__percent_amount
		_current_range_percent_amount = range__upgrade_02__percent_amount
		_current_ap_amount = ap__upgrade_02__amount
		
		enchant_altar.texture = Enchant_Altar_Pic_01
		
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
	
	
	emit_signal("current_upgrade_phase_changed", _current_upgrade_phase)

func get_upgrade_phase() -> int:
	return _current_upgrade_phase



func _initialize_enchant_ability_and_relateds():
	_initialize_enchant_ability_cooldown_countdown_clauses()
	_construct_and_add_enchant_ability()
	_initialize_enchant_ability_cooldowns_and_charges()


func _initialize_enchant_ability_cooldown_countdown_clauses():
	enchant_ability_cooldown_countdown_cond_clauses = ConditionalClauses.new()
	enchant_ability_cooldown_countdown_cond_clauses.connect("clause_inserted", self, "on_enchant_ability_cooldown_countdown_cond_clauses_updated", [], CONNECT_PERSIST)
	enchant_ability_cooldown_countdown_cond_clauses.connect("clause_removed", self, "on_enchant_ability_cooldown_countdown_cond_clauses_updated", [], CONNECT_PERSIST)
	
	if !game_elements.stage_round_manager.round_started:
		enchant_ability_cooldown_countdown_cond_clauses.attempt_insert_clause(CooldownCountdownClauses.ROUND_ENDED)

func on_enchant_ability_cooldown_countdown_cond_clauses_updated(_arg_clause_id):
	set_process(enchant_ability_cooldown_countdown_cond_clauses.is_passed)



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
	_enchant_effect__ap.status_bar_icon = Enchant_PillarEffect_StatusBarIcon_Blue
	
	var total_attk_speed_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.MAP_ENCHANT__ATTK_SPEED_EFFECT)
	total_attk_speed_modi.percent_amount = _current_attk_speed_percent_amount
	total_attk_speed_modi.percent_based_on = PercentType.MAX
	total_attk_speed_modi.ignore_flat_limits = true
	_enchant_effect__attk_speed = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, total_attk_speed_modi, StoreOfTowerEffectsUUID.MAP_ENCHANT__ATTK_SPEED_EFFECT)
	_enchant_effect__attk_speed.is_timebound = false
	_enchant_effect__attk_speed.status_bar_icon = Enchant_PillarEffect_StatusBarIcon_Yellow
	
	var total_base_damage_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.MAP_ENCHANT__BASE_DMG_EFFECT)
	total_base_damage_modi.percent_amount = _current_base_dmg_percent_amount
	total_base_damage_modi.percent_based_on = PercentType.MAX
	total_base_damage_modi.ignore_flat_limits = true
	_enchant_effect__base_dmg = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS, total_base_damage_modi, StoreOfTowerEffectsUUID.MAP_ENCHANT__BASE_DMG_EFFECT)
	_enchant_effect__base_dmg.is_timebound = false
	_enchant_effect__base_dmg.status_bar_icon = Enchant_PillarEffect_StatusBarIcon_Red
	
	var total_range_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.MAP_ENCHANT__RANGE_EFFECT)
	total_range_modi.percent_amount = _current_range_percent_amount
	total_range_modi.percent_based_on = PercentType.MAX
	total_range_modi.ignore_flat_limits = true
	_enchant_effect__range = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_RANGE, total_range_modi, StoreOfTowerEffectsUUID.MAP_ENCHANT__RANGE_EFFECT)
	_enchant_effect__range.is_timebound = false
	_enchant_effect__range.status_bar_icon = Enchant_PillarEffect_StatusBarIcon_Green
	
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

func _on_attack_execution_completed():
	enchant_ability.activation_conditional_clauses.remove_clause(EnchantAbilityActivationalClauseIds.DURING_CASTING)


###########

func _defer_initialize_beams_and_particles():
	call_deferred("_initialize_beams_and_particles")

func _initialize_beams_and_particles():
	_preformed_beam__for_above_altar = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_above_altar.position = pos_2d_for_hidden_tower.global_position
	_preformed_beam__for_above_altar.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_preformed_beam__for_above_altar)
	
	_preformed_beam__for_pillar_blue = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_pillar_blue.position = _enchant_pillar_blue.get_position_of_top() #- Vector2(0, _stretch_distance / 1)
	_preformed_beam__for_pillar_blue.texture = Enchant_PillarPreFormed_Pic_Blue
	_preformed_beam__for_pillar_blue.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_preformed_beam__for_pillar_blue)
	
	_preformed_beam__for_pillar_yellow = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_pillar_yellow.position = _enchant_pillar_yellow.get_position_of_top() #- Vector2(0, _stretch_distance / 1)
	_preformed_beam__for_pillar_yellow.texture = Enchant_PillarPreFormed_Pic_Yellow
	_preformed_beam__for_pillar_yellow.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_preformed_beam__for_pillar_yellow)
	
	_preformed_beam__for_pillar_red = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_pillar_red.position = _enchant_pillar_red.get_position_of_top() #- Vector2(0, _stretch_distance / 1) 
	_preformed_beam__for_pillar_red.texture = Enchant_PillarPreFormed_Pic_Red
	_preformed_beam__for_pillar_red.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_preformed_beam__for_pillar_red)
	
	_preformed_beam__for_pillar_green = BeamStretchAesthetic_Scene.instance()
	_preformed_beam__for_pillar_green.position = _enchant_pillar_green.get_position_of_top() #- Vector2(0, _stretch_distance / 1)
	_preformed_beam__for_pillar_green.texture = Enchant_PillarPreFormed_Pic_Green
	_preformed_beam__for_pillar_green.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_preformed_beam__for_pillar_green)
	
	#####
	
	var sprite_frames_to_use = SpriteFrames.new()
	sprite_frames_to_use.add_frame("default", Enchant_PillarActivationV2_Pic_01)
	sprite_frames_to_use.add_frame("default", Enchant_PillarActivationV2_Pic_02)
	sprite_frames_to_use.add_frame("default", Enchant_PillarActivationV2_Pic_03)
	sprite_frames_to_use.add_frame("default", Enchant_PillarActivationV2_Pic_04)
	sprite_frames_to_use.add_frame("default", Enchant_PillarActivationV2_Pic_05)
	sprite_frames_to_use.set_animation_speed("default", 15)
	
	
	_fully_formed_beam__for_above_altar = AnimatedSprite.new()
	_fully_formed_beam__for_above_altar.position = pos_2d_for_hidden_tower.global_position - Vector2(0, (_stretch_distance / 2))
	_fully_formed_beam__for_above_altar.frames = sprite_frames_to_use
	_fully_formed_beam__for_above_altar.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_fully_formed_beam__for_above_altar)
	
	_fully_formed_beam__for_pillar_blue = AnimatedSprite.new()
	_fully_formed_beam__for_pillar_blue.position = _enchant_pillar_blue.get_position_of_top() - Vector2(0, (_stretch_distance / 0.75))
	_fully_formed_beam__for_pillar_blue.frames = sprite_frames_to_use
	_fully_formed_beam__for_pillar_blue.modulate = fully_formed_beam__modulate_blue
	_fully_formed_beam__for_pillar_blue.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_fully_formed_beam__for_pillar_blue)
	
	_fully_formed_beam__for_pillar_yellow = AnimatedSprite.new()
	_fully_formed_beam__for_pillar_yellow.position = _enchant_pillar_yellow.get_position_of_top() - Vector2(0, (_stretch_distance / 0.75))
	_fully_formed_beam__for_pillar_yellow.frames = sprite_frames_to_use
	_fully_formed_beam__for_pillar_yellow.modulate = fully_formed_beam__modulate_yellow
	_fully_formed_beam__for_pillar_yellow.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_fully_formed_beam__for_pillar_yellow)
	
	_fully_formed_beam__for_pillar_red = AnimatedSprite.new()
	_fully_formed_beam__for_pillar_red.position = _enchant_pillar_red.get_position_of_top() - Vector2(0, (_stretch_distance / 0.75))
	_fully_formed_beam__for_pillar_red.frames = sprite_frames_to_use
	_fully_formed_beam__for_pillar_red.modulate = fully_formed_beam__modulate_red
	_fully_formed_beam__for_pillar_red.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_fully_formed_beam__for_pillar_red)
	
	_fully_formed_beam__for_pillar_green = AnimatedSprite.new()
	_fully_formed_beam__for_pillar_green.position = _enchant_pillar_green.get_position_of_top() - Vector2(0, (_stretch_distance / 0.75))
	_fully_formed_beam__for_pillar_green.frames = sprite_frames_to_use
	_fully_formed_beam__for_pillar_green.modulate = fully_formed_beam__modulate_green
	_fully_formed_beam__for_pillar_green.visible = false
	CommsForBetweenScenes.deferred_ge_add_child_to_below_screen_effects_node_hoster(_fully_formed_beam__for_pillar_green)
	


func _start_display_of_beam_animations():
	_color_when_beam_is_starting = _current_enchant_color
	enchant_ability.activation_conditional_clauses.attempt_insert_clause(EnchantAbilityActivationalClauseIds.DURING_ANIMATION)
	
	if _color_when_beam_is_starting == EnchantColor.BLUE:
		_preformed_beam__for_above_altar.texture = Enchant_PillarPreFormed_Pic_Blue
		_preformed_beam_for_pillar_x_to_stretch = _preformed_beam__for_pillar_blue
		_fully_formed_beam_for_pillar_x_to_show = _fully_formed_beam__for_pillar_blue
		_enchant_pillar_of_color_to_activate = _enchant_pillar_blue
		#_fully_formed_beam__for_above_altar.texture = Enchant_PillarActivation_Pic_Blue
		_fully_formed_beam__for_above_altar.modulate = fully_formed_beam__modulate_blue
		
	elif _color_when_beam_is_starting == EnchantColor.YELLOW:
		_preformed_beam__for_above_altar.texture = Enchant_PillarPreFormed_Pic_Yellow
		_preformed_beam_for_pillar_x_to_stretch = _preformed_beam__for_pillar_yellow
		_fully_formed_beam_for_pillar_x_to_show = _fully_formed_beam__for_pillar_yellow
		_enchant_pillar_of_color_to_activate = _enchant_pillar_yellow
		#_fully_formed_beam__for_above_altar.texture = Enchant_PillarActivation_Pic_Yellow
		_fully_formed_beam__for_above_altar.modulate = fully_formed_beam__modulate_yellow
		
	elif _color_when_beam_is_starting == EnchantColor.RED:
		_preformed_beam__for_above_altar.texture = Enchant_PillarPreFormed_Pic_Red
		_preformed_beam_for_pillar_x_to_stretch = _preformed_beam__for_pillar_red
		_fully_formed_beam_for_pillar_x_to_show = _fully_formed_beam__for_pillar_red
		_enchant_pillar_of_color_to_activate = _enchant_pillar_red
		#_fully_formed_beam__for_above_altar.texture = Enchant_PillarActivation_Pic_Red
		_fully_formed_beam__for_above_altar.modulate = fully_formed_beam__modulate_red
		
	elif _color_when_beam_is_starting == EnchantColor.GREEN:
		_preformed_beam__for_above_altar.texture = Enchant_PillarPreFormed_Pic_Green
		_preformed_beam_for_pillar_x_to_stretch = _preformed_beam__for_pillar_green
		_fully_formed_beam_for_pillar_x_to_show = _fully_formed_beam__for_pillar_green
		_enchant_pillar_of_color_to_activate = _enchant_pillar_green
		#_fully_formed_beam__for_above_altar.texture = Enchant_PillarActivation_Pic_Green
		_fully_formed_beam__for_above_altar.modulate = fully_formed_beam__modulate_green
		
	
	#_preformed_beam__for_above_altar.reset()
	_preformed_beam__for_above_altar.connect("beam_fully_stretched", self, "_on_preformed_beam_above_altar_fully_stretched", [], CONNECT_ONESHOT)
	#_preformed_beam__for_above_altar.start_stretch(_preformed_beam__for_above_altar.global_position, stretch_duration)
	_preformed_beam__for_above_altar.start_stretch(_preformed_beam__for_above_altar.global_position + Vector2(0, _stretch_distance * 1.75), stretch_duration)
	

func _on_preformed_beam_above_altar_fully_stretched():
	_on_finished_beam_animation__start_effects()
	
	#_preformed_beam_for_pillar_x_to_stretch.connect("beam_fully_stretched", self, "_on_preformed_beam_above_pillar_x_stretched", [], CONNECT_ONESHOT)
	#_preformed_beam_for_pillar_x_to_stretch.start_stretch(_enchant_pillar_of_color_to_activate.get_position_of_top(), stretch_duration)

#func _on_preformed_beam_above_pillar_x_stretched():
#	_on_finished_beam_animation__start_effects()

func _on_finished_beam_animation__start_effects():
	enchant_ability.activation_conditional_clauses.attempt_insert_clause(EnchantAbilityActivationalClauseIds.DURING_EFFECTS)
	
	enchant_ability.activation_conditional_clauses.remove_clause(EnchantAbilityActivationalClauseIds.DURING_ANIMATION)
	
	_enchant_pillar_of_color_to_activate.set_is_active(true)
	_timer_for_enchant_effect_duration.start(stat_buff_duration)
	
	_fully_formed_beam__for_above_altar.play()
	_fully_formed_beam_for_pillar_x_to_show.play()
	
	
	_preformed_beam__for_above_altar.visible = false
	_preformed_beam_for_pillar_x_to_stretch.visible = false
	_fully_formed_beam__for_above_altar.visible = true
	_fully_formed_beam_for_pillar_x_to_show.visible = true


func _on_timer_for_enchant_effect_duration_timeout():
	_enchant_pillar_of_color_to_activate.set_is_active(false)
	
	_fully_formed_beam__for_above_altar.stop()
	_fully_formed_beam_for_pillar_x_to_show.stop()
	
	_fully_formed_beam__for_above_altar.visible = false
	_fully_formed_beam_for_pillar_x_to_show.visible = false
	_preformed_beam__for_above_altar.reset()
	_preformed_beam_for_pillar_x_to_stretch.reset()
	
	enchant_ability.activation_conditional_clauses.remove_clause(EnchantAbilityActivationalClauseIds.DURING_EFFECTS)
	randomize_current_enchant_color()

func _on_round_end__map_enchant(arg_stageround):
	if _timer_for_enchant_effect_duration.time_left > 0:
		_timer_for_enchant_effect_duration.paused = true
	
	enchant_ability_cooldown_countdown_cond_clauses.attempt_insert_clause(CooldownCountdownClauses.ROUND_ENDED)
	
	if is_instance_valid(_map_enchant__attacks__hidden_tower):
		_map_enchant__attacks__hidden_tower.set_current_purple_proj_amount_for_barrage_left(0)

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
	
	enchant_ability_progress_bar.visible = true

func _on_current_time_delta_for_next_charge_changed__for_prog_bar_update(arg_time_delta, arg_time_delta_plus_charges):
	_update_enchant_ability_progress_bar__curr_val()
	

func _update_enchant_ability_progress_bar__curr_val():
	var curr_prog_val = (enchant_ability_base_cooldown_per_charge * (enchant_ability_max_charges - 1)) - (_current_time_delta_for_next_charge - (_current_ability_charges * enchant_ability_base_cooldown_per_charge))
	
	enchant_ability_progress_bar.current_value = curr_prog_val


func _on_current_ability_charges_changed(arg_charges):
	_update_enchant_ability_progress_bar__texture()

func _update_enchant_ability_progress_bar__texture():
	if _last_used_charge_val_for_texture_update != _current_ability_charges:
		_last_used_charge_val_for_texture_update = _current_ability_charges
		
		enchant_ability_progress_bar.fill_foreground_pic = charge_amount_to_texture_map[_current_ability_charges]

######

func _defer_initialize_placable_to_pillar_assignment():
	call_deferred("_initialize_placable_to_pillar_assignment")
	

func _initialize_placable_to_pillar_assignment():
	var all_placables__copy = game_elements.map_manager.get_all_placables__copy()
	
	for placable in all_placables__copy:
		if q1_placable_name_determiner in placable.name:
			enchant_pillar_q1.add_associated_placable(placable)
		elif q2_placable_name_determiner in placable.name:
			enchant_pillar_q2.add_associated_placable(placable)
		elif q3_placable_name_determiner in placable.name:
			enchant_pillar_q3.add_associated_placable(placable)
		elif q4_placable_name_determiner in placable.name:
			enchant_pillar_q4.add_associated_placable(placable)
		


####

func _defer_initialize_upgrade_bar_and_relateds():
	call_deferred("_initialize_upgrade_bar_and_relateds")

func _initialize_upgrade_bar_and_relateds():
	_set_upgrade_bar_state(UpgradeBarState.IN_PROGRESS)
	enchant_upgrade_progress_bar.max_value = max_upgrade_bar_val
	call_deferred("_immediate_set_upgrade_bar_value", 0)
	
	
	_upgrade_disp_increment_timer = Timer.new()
	_upgrade_disp_increment_timer.one_shot = false
	_upgrade_disp_increment_timer.connect("timeout", self, "_increment_upgrade_bar_value", [], CONNECT_PERSIST)
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_upgrade_disp_increment_timer)
	
	###
	
	if special_rounds.size() > 0:
		_reset_upgrade_bar_state_and_val__and_update_inc_per_round()
		_remove_last_special_round_in_list__and_track_removed()
	
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end__map_enchant__for_special_round_tracking", [], CONNECT_PERSIST)
	#game_elements.stage_round_manager.connect("round_started", self, "_on_round_start__map_enchant__for_special_round_tracking", [], CONNECT_PERSIST)


func _start_increment_set_of_upgrade_bar_value(to_val : float):
	_current_upgrade_bar_value = to_val
	
	if _upgrade_disp_increment_timer.time_left == 0:
		var is_equal = _increment_upgrade_bar_value()
		if !is_equal:
			_upgrade_disp_increment_timer.start(upgrade_disp_delta)

func _increment_upgrade_bar_value():
	var is_equal : bool = false
	if _current_upgrade_bar_value > _current_upgrade_bar_value_for_inc_timers:
		_current_upgrade_bar_value_for_inc_timers += upgrade_disp_increment_amount_per_inc
		if _current_upgrade_bar_value_for_inc_timers >= _current_upgrade_bar_value:
			_current_upgrade_bar_value_for_inc_timers = _current_upgrade_bar_value
			_upgrade_disp_increment_timer.stop()
			is_equal = true
		
	elif _current_upgrade_bar_value < _current_upgrade_bar_value_for_inc_timers:
		_current_upgrade_bar_value_for_inc_timers += upgrade_disp_decrement_amount_per_dec
		if _current_upgrade_bar_value_for_inc_timers <= _current_upgrade_bar_value:
			_current_upgrade_bar_value_for_inc_timers = _current_upgrade_bar_value
			_upgrade_disp_increment_timer.stop()
			is_equal = true
		
	
	enchant_upgrade_progress_bar.current_value = _current_upgrade_bar_value_for_inc_timers
	return is_equal

func _immediate_set_upgrade_bar_value(arg_val):
	if arg_val < 0:
		arg_val = 0
	
	_current_upgrade_bar_value = arg_val
	_current_upgrade_bar_value_for_inc_timers = arg_val
	enchant_upgrade_progress_bar.current_value = arg_val

func _set_upgrade_bar_state(arg_state : int):
	var old_state = _current_upgrade_bar_state
	_current_upgrade_bar_state = arg_state
	
	if old_state != _current_upgrade_bar_state:
		enchant_upgrade_progress_bar.fill_foreground_pic = upgrade_state_to_texture_map[arg_state]


func decrease_upgrade_var_value__by_enemies(arg_dec):
	_immediate_set_upgrade_bar_value(_current_upgrade_bar_value - arg_dec)
	_set_upgrade_bar_state(UpgradeBarState.PARTIAL)
	
	if _current_upgrade_bar_value <= 0:
		_is_current_upgrade_val_depleted_by_enemies = true
		_hide_and_stop_about_to_upgrade_particle()
		emit_signal("current_upgrade_val_depleted_by_enemies")


func _reset_upgrade_bar_state_and_val__and_update_inc_per_round():
	var rounds_before_target = game_elements.stage_round_manager.get_number_of_rounds_before_stageround_id_reached(special_rounds[special_rounds.size() - 1])
	var start_inc : bool = false
	
	if rounds_before_target == 0:
		rounds_before_target = 1
		start_inc = true
	
	_upgrade_val_amount_per_round = upgrade_threshold_inc_for_improved_upgrade / (rounds_before_target)
	_rounds_before_next_special_round_id = rounds_before_target
	
	_is_current_upgrade_val_depleted_by_enemies = false
	
	if start_inc:
		_start_increment_set_of_upgrade_bar_value(_upgrade_val_amount_per_round)

func _remove_last_special_round_in_list__and_track_removed():
	_next_special_round_id = special_rounds[special_rounds.size() - 1]
	special_rounds.remove(special_rounds.size() - 1)
	
	emit_signal("next_special_round_id_changed", _next_special_round_id)

func _on_round_end__map_enchant__for_special_round_tracking(arg_stageround):
	_rounds_before_next_special_round_id -= 1
	
	if _rounds_before_next_special_round_id == 0:
		_set_upgrade_bar_state(UpgradeBarState.FULL)
		_start_increment_set_of_upgrade_bar_value(_current_upgrade_bar_value + _upgrade_val_amount_per_round)
		_append_instructions_to_EM_interpreter__based_on_curr_round()
		_start_monitor_for_special_enemy_spawn()
		_show_and_start_about_to_upgrade_particle()
		enchant_special_room_drawer_01.start_display()
		
	elif _rounds_before_next_special_round_id == -1:  # when special round is done
		_evaluate_current_upgrade_val_for_upgrade_phase_inc()
		
		_set_upgrade_bar_state(UpgradeBarState.IN_PROGRESS)
		_start_increment_set_of_upgrade_bar_value(0)
		_end_monitor_for_special_enemy_spawn()
		_hide_and_stop_about_to_upgrade_particle()
		enchant_special_room_drawer_01.end_display()
		
		if special_rounds.size() > 0:
			_reset_upgrade_bar_state_and_val__and_update_inc_per_round()
			_remove_last_special_round_in_list__and_track_removed()
		else:
			# no more special rounds
			game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end__map_enchant__for_special_round_tracking")
			beam_suck_particle_attk_sprite_pool.clear_pool()
			
			_next_special_round_id = ""
			_rounds_before_next_special_round_id = -1
			emit_signal("next_special_round_id_changed", _next_special_round_id)
		
	else:
		_start_increment_set_of_upgrade_bar_value(_current_upgrade_bar_value + _upgrade_val_amount_per_round)
	
	
	emit_signal("round_count_before_next_special_round_changed", _rounds_before_next_special_round_id, _next_special_round_id)
	

func get_next_special_round_id():
	return _next_special_round_id

#func _on_round_start__map_enchant__for_special_round_tracking(arg_stageround):
#	pass
#

#

func _evaluate_current_upgrade_val_for_upgrade_phase_inc():
	if is_equal_approx(_current_upgrade_bar_value, max_upgrade_bar_val):
		set_upgrade_phase(_current_upgrade_phase + 2)
		_request_particle_for_upgrade_to_play(14)
	elif _current_upgrade_bar_value > 0:
		set_upgrade_phase(_current_upgrade_phase + 1)
		_request_particle_for_upgrade_to_play(7)


#

func _defer_initialize_beam_suck_particle_attk_sprite_pool():
	call_deferred("_initialize_beam_suck_particle_attk_sprite_pool")

func _initialize_beam_suck_particle_attk_sprite_pool():
	beam_suck_particle_attk_sprite_pool = AttackSpritePoolComponent.new()
	beam_suck_particle_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	beam_suck_particle_attk_sprite_pool.node_to_listen_for_queue_free = game_elements
	beam_suck_particle_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	beam_suck_particle_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_beam_suck_particle"


func _create_beam_suck_particle():
	var particle = CenterBasedAttackSprite_Scene.instance()
	
	particle.texture_to_use = MapEnchant_AntiMagik_BeamSuck_Particle
	particle.initial_speed_towards_center = 200
	particle.speed_accel_towards_center = 300
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	
	return particle

func request_suck_particle_to_play(arg_source_pos, arg_destination_pos):
	var particle = beam_suck_particle_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	
	var pos_of_center = arg_destination_pos #global_position + position_offset_for_center_of_blue_particle
	particle.center_pos_of_basis = pos_of_center
	
	particle.reset_for_another_use()
	
	var rand_num_01 = non_essential_rng.randi_range(-9, 9)
	var rand_num_02 = non_essential_rng.randi_range(-9, 9)
	particle.global_position = arg_source_pos + Vector2(rand_num_01, rand_num_01)
	
	particle.lifetime = 0.3
	particle.visible = true
	


#



func _defer_initialize_particle_for_upgrade_attk_sprite_pool__and_relateds():
	call_deferred("_initialize_particle_for_upgrade_attk_sprite_pool__and_relateds")

func _initialize_particle_for_upgrade_attk_sprite_pool__and_relateds():
	particle_for_upgrade_attk_sprite_pool = AttackSpritePoolComponent.new()
	particle_for_upgrade_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	particle_for_upgrade_attk_sprite_pool.node_to_listen_for_queue_free = game_elements
	particle_for_upgrade_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	particle_for_upgrade_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_particle_for_upgrade"
	
	_timer_for_particle_for_upgrade = Timer.new()
	_timer_for_particle_for_upgrade.one_shot = false
	_timer_for_particle_for_upgrade.connect("timeout", self, "_on_timer_for_particle_for_upgrade_timeout", [], CONNECT_PERSIST)
	add_child(_timer_for_particle_for_upgrade)

func _create_particle_for_upgrade():
	var particle = CenterBasedAttackSprite_Scene.instance()
	
	particle.texture_to_use = MapEnchant_AntiMagik_BeamSuck_Particle
	particle.initial_speed_towards_center = 200
	particle.speed_accel_towards_center = 300
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	
	return particle

func _request_particle_for_upgrade_to_play(arg_count):
	_current_particle_for_upgrade_count_to_create = arg_count
	_create_and_configure_particle_for_upgrade__and_reduce_counters()
	if _current_particle_for_upgrade_count_to_create > 0:
		_timer_for_particle_for_upgrade.start(0.1)

func _on_timer_for_particle_for_upgrade_timeout():
	_create_and_configure_particle_for_upgrade__and_reduce_counters()


func _create_and_configure_particle_for_upgrade__and_reduce_counters():
	var particle = particle_for_upgrade_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	
	var pos_of_center = enchant_altar.global_position
	particle.center_pos_of_basis = pos_of_center
	
	particle.reset_for_another_use()
	
	var rand_num_01 = non_essential_rng.randi_range(-7, 7)
	var rand_num_02 = non_essential_rng.randi_range(-7, 7)
	particle.global_position = enchant_about_to_upgrade_particle.global_position + Vector2(rand_num_01, rand_num_01)
	
	particle.lifetime = 0.28
	particle.visible = true
	
	#
	
	_current_particle_for_upgrade_count_to_create -= 1
	if _current_particle_for_upgrade_count_to_create == 0:
		_timer_for_particle_for_upgrade.stop()
	
	#
	
	return particle

##

func request_anti_magik_self_fade_particle_to_play(arg_pos, arg_is_flipped_h : bool):
	var particle = MapEnchant_AntiMagik_FadeSelfParticle_Scene.instance()
	particle.lifetime = 0.4
	particle.set_anim_speed_based_on_lifetime()
	particle.lifetime_to_start_transparency = 0.25
	particle.transparency_per_sec = 1 / particle.lifetime_to_start_transparency
	particle.position = arg_pos
	
	particle.flip_h = arg_is_flipped_h
	
	CommsForBetweenScenes.ge_add_child_to_below_screen_effects_node_hoster(particle)

#

func _hide_and_stop_about_to_upgrade_particle():
	enchant_about_to_upgrade_particle.stop()
	enchant_about_to_upgrade_particle.visible = false

func _show_and_start_about_to_upgrade_particle():
	enchant_about_to_upgrade_particle.play()
	enchant_about_to_upgrade_particle.visible = true


# whole screen related

func _deferred_initialize_map_enchant_whole_screen_panel__and_relateds():
	call_deferred("_initialize_map_enchant_whole_screen_panel__and_relateds")

func _initialize_map_enchant_whole_screen_panel__and_relateds():
	map_enchant_whole_screen_panel = MapEnchant_WholeScreenGUI_Scene.instance()
	game_elements.whole_screen_gui.add_control_but_dont_show(map_enchant_whole_screen_panel)
	
	map_enchant_whole_screen_panel.set_map_enchant(self)
	map_enchant_whole_screen_panel.initialize()
	
	#
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	
	enchant_extra_info_button.connect("released_mouse_event", self, "_on_enchant_extra_info_button_released_mouse_event", [], CONNECT_PERSIST)


func _on_enchant_extra_info_button_released_mouse_event(arg_event : InputEventMouseButton):
	if arg_event.button_index == BUTTON_LEFT:
		_queue_show_map_enchant_whole_screen_panel()

func _queue_show_map_enchant_whole_screen_panel():
	game_elements.whole_screen_gui.queue_control(map_enchant_whole_screen_panel, reservation_for_whole_screen_gui)


###

func _defer_initialize_special_room_drawers():
	call_deferred("_initialize_special_room_drawers")

func _initialize_special_room_drawers():
	special_room_drawer__x_left = pos_for_special_room__bottom_left.global_position.x
	special_room_drawer__x_right = pos_for_special_room__top_right.global_position.x
	special_room_drawer__y_start = pos_for_special_room__bottom_left.global_position.y
	special_room_drawer__y_end = pos_for_special_room__top_right.global_position.y
	
	_configure_special_room_drawer_node(enchant_special_room_drawer_01, special_room_drawer__color_01)

func _configure_special_room_drawer_node(arg_node, arg_color_to_use):
	arg_node.pos_x_left = special_room_drawer__x_left
	arg_node.pos_x_right = special_room_drawer__x_right
	arg_node.pos_y_start = special_room_drawer__y_start
	arg_node.pos_y_end = special_room_drawer__y_end
	
	arg_node.color_to_use = arg_color_to_use
	arg_node.duration = special_room_drawer_expand_duration

###############

func _append_instructions_to_EM_interpreter__based_on_curr_round():
	var arr = call(special_rounds_to_ins_method_map[_next_special_round_id])
	game_elements.enemy_manager.append_instructions_to_interpreter(arr)

func _start_monitor_for_special_enemy_spawn():
	if !game_elements.enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		game_elements.enemy_manager.connect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path", [], CONNECT_PERSIST)
	
	special_enemy_path_texture_rect.visible = true
	
	if !is_instance_valid(_pink_spawn_loc_flag__for_special_path):
		_pink_spawn_loc_flag__for_special_path = create_spawn_loc_flag_at_path(special_enemy_path, default_flag_offset_from_path, EnemySpawnLocIndicator_Flag.FlagTextureIds.PINK__MAP_ENCHANT, false)
	else:
		_pink_spawn_loc_flag__for_special_path.visible = true

func _end_monitor_for_special_enemy_spawn():
	if game_elements.enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		game_elements.enemy_manager.disconnect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path")
	
	special_enemy_path_texture_rect.visible = false
	
	_pink_spawn_loc_flag__for_special_path.visible = false


func _before_enemy_is_added_to_path(enemy, path):
	if !_is_current_upgrade_val_depleted_by_enemies and enemy.enemy_id == EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK:
		if enemy.enemy_spawn_metadata_from_ins != null and enemy.enemy_spawn_metadata_from_ins.has(StoreOfEnemyMetadataIdsFromIns.MAP_ENCHANT__SPECIAL_ENEMY_MARKER):
			special_enemy_path.add_child(enemy)
			
			enemy.beam_stretch_destination_pos = pos_2d_for_beam_suck.global_position
			enemy.delta_for_suck = enemy__anti_magik__delta_for_suck
			enemy.upgrade_suck_per_detla = enemy__anti_magik__upgrade_suck_per_detla
			enemy.map_enchant = self
			
			enemy.configure_properties_to_behave_at_special_path()

# for testing
#func get_spawn_ins_for_special_round__02():
#	return [
#		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
#
#		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK, _special_enemy_spawn_metadata),
#
#		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK, _special_enemy_spawn_metadata),
#	]


func get_spawn_ins_for_special_round__33():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		
		
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK, _special_enemy_spawn_metadata),
	]

func get_spawn_ins_for_special_round__43():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		
		
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK, _special_enemy_spawn_metadata),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK, _special_enemy_spawn_metadata),
	]

func get_spawn_ins_for_special_round__53():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK),
		
		
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK, _special_enemy_spawn_metadata),
		SingleEnemySpawnInstruction.new(17.5, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK, _special_enemy_spawn_metadata),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_ENCHANT_ANTI_MAGIK, _special_enemy_spawn_metadata),
	]

