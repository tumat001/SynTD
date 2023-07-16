# NOTE:
# Towers with Ings is not yet supported/made

extends "res://MapsRelated/BaseMap.gd"

const MemoryType_Gold_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Gold.png")
const MemoryType_Gold_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Gold_Highlighted.png")
const MemoryType_Health_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Health.png")
const MemoryType_Health_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Health_Highlighted.png")
const MemoryType_Relic_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Relic.png")
const MemoryType_Relic_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Relic_Highlighted.png")
const MemoryType_Towers_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Towers.png")
const MemoryType_Towers_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Towers_Highlighted.png")
const MemoryType_TowersWithIngs_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_TowersWithIngs.png")
const MemoryType_TowersWithIngs_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_TowersWithIngs_Highlighted.png")
const MemoryType_None_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_None.png")
const MemoryType_None_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_None_Highlighted.png")
const MemoryType_Empty_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/MemoryType_Empty.png")


const GSSB_Memory_Recall_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Recall_Normal.png")
const GSSB_Memory_Recall_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Recall_Highlighted.png")
const GSSB_Memory_Sacrifice_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Sacrifice_Normal.png")
const GSSB_Memory_Sacrifice_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Sacrifice_Highlighted.png")
const GSSB_Memory_Summary_Normal = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Summary_Normal.png")
const GSSB_Memory_Summary_Highlighted = preload("res://MapsRelated/MapList/Map_Memories/GUI/Assets/GSSMs/GSSM_MemoryActionState_Button_Summary_Highlighted.png")

#

const GenStats_SmallButton = preload("res://GameHUDRelated/StatsPanel/SmallButtonRelated/GenStats_SmallButton.gd")
#const GenStats_SmallButton_Scene = preload("res://GameHUDRelated/StatsPanel/SmallButtonRelated/GenStats_SmallButton.tscn")

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")


const ModeNormal_Memories_StageRounds = preload("res://GameplayRelated/StagesAndRoundsRelated/CustomStagerounds/ModeNormal_Memories_StageRounds.gd")

const MemoryTypeSacrificeButton = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/Subs/MemoryTypeSacrificeButton/MemoryTypeSacrificeButton.gd")

const MemorySacrificeGUI_Scene = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/MemorySacrificeGUI.tscn")
const MemorySacrificeGUI = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/MemorySacrificeGUI.gd")
const MemoryRecallGUI_Scene = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemoryRecall/MemoryRecallGUI.tscn")
const MemoryRecallGUI = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemoryRecall/MemoryRecallGUI.gd")
const MemoryTypeRecallDetailsPanel = preload("res://MapsRelated/MapList/Map_Memories/GUI/Shared/MemoryTypeRecallDetailsPanel/MemoryTypeRecallDetailsPanel.gd")
const MemoryTypeRecallPanel = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemoryRecall/Subs/MemoryTypeRecallPanel/MemoryTypeRecallPanel.gd")
const MemorySummaryGUI = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySummary/MemorySummaryGUI.gd")
const MemorySummaryGUI_Scene = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySummary/MemorySummaryGUI.tscn")


const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const CenterBasedAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd")
const CenterBasedAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.tscn")

const Memories_CircleConcealParticle_Pic = preload("res://MapsRelated/MapList/Map_Memories/Particles/Memories_CircleConcealParticle.png")


const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const CircleDrawNode = preload("res://MiscRelated/DrawRelated/CircleDrawNode/CircleDrawNode.gd")

const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")
const NullErasingArray = preload("res://MiscRelated/DataCollectionRelated/NullErasingArray.gd")
const EnemyHealEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyHealEffect.gd")

const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const SingleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/SingleEnemySpawnInstruction.gd")
const AbstractSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/AbstractSpawnInstruction.gd")
const ChainSpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/ChainSpawnInstruction.gd")
const MultipleEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/MultipleEnemySpawnInstruction.gd")
const LinearEnemySpawnInstruction = preload("res://GameplayRelated/EnemySpawnRelated/SpawnInstructionsRelated/LinearEnemySpawnInstruction.gd")

const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")


#

signal conditions_changed__towers()
signal conditions_changed__towers_with_ings()
signal conditions_changed__relic_and_gold()
signal conditions_changed__gold()
signal conditions_changed__health()

signal warning_update__available_tower_slot_at_bench_changed()

#######

const CAN_WRITE_SAVE_FILE : bool = true  # correct val: true. change this when testing/exiting from testing
const CAN_ERASE_MEMORY_ON_ACCEPT : bool = true  # correct val: true

#

enum MemoryTypeId {
	EMPTY = -1,  # UNDECIDED (used for filling info in Summary)
	NONE = 0,  # DECIDED
	
	TOWERS = 1,
	TOWERS_WITH_INGS = 2,   # NOT yet supported as saving ings is troublesome
	#COMBINATION = 3,     
	RELIC_AND_GOLD = 4,
	GOLD = 5,
	HEALTH = 6,
	
}

const memory_type_id_to_conditions_changed_signal_name : Dictionary = {
	MemoryTypeId.NONE : "",
	MemoryTypeId.TOWERS: "conditions_changed__towers",
	MemoryTypeId.TOWERS_WITH_INGS: "conditions_changed__towers_with_ings",
	MemoryTypeId.RELIC_AND_GOLD: "conditions_changed__towers",
	MemoryTypeId.GOLD: "conditions_changed__gold",
	MemoryTypeId.HEALTH: "conditions_changed__health",
	
}

const TOWERS_WITH_INGS_MAX_ING_COUNT : int = 2

#####

class RoundMemorySacrificeInfo:
	
	var sacrifice_type_ids_available_to_param_map : Dictionary
	var stage_round_id : String
	

var stage_round_trigger_to_round_memory_info_map : Dictionary = {}


###


enum MemoryActionStates {
	NONE__WITH_NO_SACRIFICES = 0,
	NONE__WITH_SACRIFICES = 1,    # SUMMARY is viewable at this state
	
	SACRIFICING = 2,
	RECALLING = 3,
}
var _current_mem_action_state : int


#### gen stats small buttons

var GSSB__show_memory_sacrifice : GenStats_SmallButton
var GSSB__show_memory_recall : GenStats_SmallButton
var GSSB__show_memory_summary : GenStats_SmallButton

var _all_GSSB : Array
var _all_GSSB__to_highlight_with_mod_fluc : Array

var _at_least_one_GSSB_is_visible : bool

#

var _current_stageround_id
var _current_sacrifice_id_and_param

#

var _current_round_memory_sacrifice_info : RoundMemorySacrificeInfo
var _mem_type_sac_construction_param__none

var _memory_sacrifice_gui : MemorySacrificeGUI
var _memory_recall_gui : MemoryRecallGUI
var _memory_summary_gui : MemorySummaryGUI

#

const _modulate_transition_duration_for_GSSB : float = 0.75
const _min_modulate_rgb_for_GSSB : float = 0.8
const _max_modulate_rgb_for_GSSB : float = 1.5
var _current_modulate_rgb_for_GSSB : float setget set_current_modulate_rgb_for_GSSB

var _modulate_rgb_tweener_for_GSSB : SceneTreeTween


########### Memories related

const RECALL_MEMORY__NAME__STAGE_ROUND_ID = "stage_round_id"
const RECALL_MEMORY__NAME__MEMORY_TYPE_ID = "memory_type_id"
const RECALL_MEMORY__NAME__VERSION_NUM = "version_num"
const RECALL_MEMORY__NAME__PARAM = "param"

const _current_recall_memory_version__gold : int = 1 
const _current_recall_memory_version__health : int = 1 
const _current_recall_memory_version__relic_and_gold : int = 1 
const _current_recall_memory_version__towers : int = 1 


class RecallMemory:
	var stage_round_id : String
	
	var memory_type_id : int
	var param
	
	var version_num : int
	
	func convert_to_JSON():
		return to_json({
			RECALL_MEMORY__NAME__STAGE_ROUND_ID : stage_round_id,
			RECALL_MEMORY__NAME__MEMORY_TYPE_ID : memory_type_id,
			RECALL_MEMORY__NAME__VERSION_NUM : version_num,
			RECALL_MEMORY__NAME__PARAM : param,
			
		})
	
	#######
	
	
	
	


var _past__stageround_id_to_recall_memories_map : Dictionary
var _future__stageround_id_to_recall_memories_map : Dictionary

var _erase_future_recall_memory_in_curr_stage_round_id_after_recall_accept : bool

### PARTICLES

enum CircleParticleType {
	TOWER = 1,
	HUD = 2
}

enum MemoryActionState__Particles {
	SACRIFICE = 1,
	RECALL = 2,
}

var circle_conceal_particle_pool_compo : AttackSpritePoolComponent

const circle_conceal_min_count : int = 7
const circle_conceal_max_count : int = 11

const circle_conceal_mod_a_starting_min : float = 0.25
const circle_conceal_mod_a_starting_max : float = 0.5

const circle_conceal_mod_a_finishing_min : float = 0.85
const circle_conceal_mod_a_finishing_max : float = 1.0

const circle_conceal_initial_speed_to_center_min__sac : float = 80.0
const circle_conceal_initial_speed_to_center_max__sac : float = 100.0
const circle_conceal_speed_accel_to_center_min__sac : float = 300.0
const circle_conceal_speed_accel_to_center_max__sac : float = 350.0

const circle_conceal_initial_speed_to_center_min__recall : float = -350.0
const circle_conceal_initial_speed_to_center_max__recall : float = -250.0
const circle_conceal_speed_accel_to_center_min__recall : float = 200.0
const circle_conceal_speed_accel_to_center_max__recall : float = 300.0


const circle_conceal_particle_scale_min : float = 0.8
const circle_conceal_particle_scale_max : float = 1.2


const circle_conceal__circle_phase_duration : float = 0.75
const circle_conceal__beam_phase_duration : float = 0.35


const circle_conceal_delta_per_circle : float = 0.06


const circle_conceal_starting_dist_min__tower : float = 40.0
const circle_conceal_starting_dist_max__tower : float = 60.0
const circle_conceal_starting_dist_min__generic_hud : float = 50.0
const circle_conceal_starting_dist_max__generic_hud : float = 80.0


const circle_conceal_center_modification_mag__tower := Vector2(10, 10)
const circle_conceal_center_modification_mag__generic_hud := Vector2(18, 18)


var _circle_conceal_seq_data_list : Array

#######

enum EnableProcessClauseIds {
	CIRCLE_CONCEAL_SEQUENCE = 1
	
	TOWER_QUEUED_FOR_RECALL = 2
	
}

var enable_process_conditional_clauses : ConditionalClauses


var non_essential_rng : RandomNumberGenerator


# Tower queue for recall

var has_tower_ids_queued_for_recall : bool
var pause_tower_ids_queue_for_recall : bool

var tower_ids_queued_for_recall : Array = []
var delay_for_next_tower_id_recall : float

const DELAY_PER_NEXT_TOWER_ID_RECALL : float = 0.25

###### SAVE FILE RELATED

const SAVE_FILE__DICT__VERSION = "1"

const SAVE_FILE__DICT_KEY__VERSION = "SaveKey_Version"
const SAVE_FILE__DICT_KEY__SACRIFICE = "SaveKey_Sacrifice"


# Path related

enum SpecialPathId {
	PATH_01,
	PATH_02,
	PATH_03,
	PATH_04,
}

var special_path_to_spawn_loc_flag_map : Dictionary

const _special_enemy_common_spawn_metadata : Dictionary = {
	StoreOfEnemyMetadataIdsFromIns.NOT_SPAWNED_FROM_INS : true
}

var _special_enemy_spawn_metadata_for__path_01 : Dictionary
var _special_enemy_spawn_metadata_for__path_02 : Dictionary
var _special_enemy_spawn_metadata_for__path_03 : Dictionary
var _special_enemy_spawn_metadata_for__path_04 : Dictionary


# Mem Enemies Spawn related

var _rounds_before_next_special_round_id : int = 0
var _next_special_round_id

var _path_ids_used_this_round : Array

var _path_id_to_spawn_metadata_map : Dictionary = {}

# entries here get erased as they are traversed
var special_rounds_to_ins_method_map : Dictionary = {
	"104" : "get_spawn_ins_for_special_round__104",
	"103" : "get_spawn_ins_for_special_round__103",
	"102" : "get_spawn_ins_for_special_round__102",
	"101" : "get_spawn_ins_for_special_round__101",
	
	"94" : "get_spawn_ins_for_special_round__94",
	"93" : "get_spawn_ins_for_special_round__93",
	"92" : "get_spawn_ins_for_special_round__92",
	"91" : "get_spawn_ins_for_special_round__91",
	
	"84" : "get_spawn_ins_for_special_round__84",
	"82" : "get_spawn_ins_for_special_round__82",
	
	"74" : "get_spawn_ins_for_special_round__74",
	"72" : "get_spawn_ins_for_special_round__72",
	
	"64" : "get_spawn_ins_for_special_round__64",
	"62" : "get_spawn_ins_for_special_round__62",
	
	"54" : "get_spawn_ins_for_special_round__54",
	"52" : "get_spawn_ins_for_special_round__52",
	
	"44" : "get_spawn_ins_for_special_round__44",
	"42" : "get_spawn_ins_for_special_round__42",
	
	"34" : "get_spawn_ins_for_special_round__34",
	"32" : "get_spawn_ins_for_special_round__32",
	
	"24" : "get_spawn_ins_for_special_round__24",
	"22" : "get_spawn_ins_for_special_round__22",
	
	
	# temp for testing
#	"03" : "get_spawn_ins_for_special_round__03",
#	"01" : "get_spawn_ins_for_special_round__01",
}

########## Enemy Memory specific

const ENEMY_DREAM__HEALTH_PERCENT__DREAM_TRIGGER = 0.5
const ENEMY_DREAM__UNIT_OFFSET__DREAM_TRIGGER = 0.5
const ENEMY_DREAM__DELAY_BEFORE_DREAM_TRIGGER = 1.5
const ENEMY_DREAM__HEAL_AURA__RADIUS = 110.0
const ENEMY_DREAM__HEAL_AURA__DELTA_TO_REACH_MAX_RADIUS = 0.65
const ENEMY_DREAM__HEAL_AURA__DELTA_PER_TRIGGER = 0.5
const ENEMY_DREAM__HEAL_AURA__HEAL_PERCENT = 3.0
const ENEMY_DREAM__HEAL_AURA__FLAT_HEAL_MAX = 6.0


onready var dream_heal_aura_circle_draw_node = $DreamHealAuraCircleDrawNode
onready var dream_line_draw_node = $DreamLineDrawNode
var _dream_heal_aura_aoe_attk_module : AOEAttackModule

const ENEMY_DREAM_HEAL_AURA__FILL_COLOR := Color(112/255.0, 217/255.0, 2/255.0, 0.2)
const ENEMY_DREAM_HEAL_AURA__EDGE_COLOR := Color(84/255.0, 162/255.0, 2/255.0, 0.2)

const ENEMY_DREAM__DREAM_BEAM_COLOR := Color(112/255.0, 217/255.0, 2/255.0)

var enemy_dreamer_heal_modi : PercentModifier

var _all_active_dream_heal_markers : Array = []

var _dream_marker_attack_sprite_pool_compo : AttackSpritePoolComponent


const ENEMY_DREAM__MARK_CONSUME_INITIAL_DELAY = 7.0
const ENEMY_DREAM__MARK_CONSUME_DELAY_PER_MARK = 0.5
var _dream_marker_initial_delay_timer : Timer
var _dream_marker_per_mark_delay_timer : Timer

#

const ENEMY_MEMORIA__DMG_INSTANCE_COUNT_BEFORE_INVIS : int = 15
const ENEMY_MEMORIA__INVIS_DURATION : float = 5.0


const ENEMY_NIGHTMARE__OFFSET_TO_TRIGGER_BACK_TO_START : float = 20.0


const NIGHTMARE_MARKER_DATA_KEY__PATH_ID = "NightmareMarker__PathID"
const NIGHTMARE_MARKER_DATA_KEY__OFFSET = "NightmareMarker__Offset"
var _all_active_nightmare_spawn_marker_to_data_map : Dictionary = {}


var _nightmare_marker_attack_sprite_pool_compo : AttackSpritePoolComponent

const ENEMY_NIGHTMARE__MARK_CONSUME_INITIAL_DELAY = 7.0
const ENEMY_NIGHTMARE__MARK_CONSUME_DELAY_PER_MARK = 1.5
var _nightmare_marker_initial_delay_timer : Timer
var _nightmare_marker_per_mark_delay_timer : Timer



var _nightmare_smoke_attack_sprite_pool_compo : AttackSpritePoolComponent

######################

var game_elements setget set_game_elements
var stage_round_manager
var input_prompt_manager


###

onready var line_draw_node = $LineDrawNode

#

onready var main_enemy_path = $EnemyPaths/MainEnemyPath
onready var special_enemy_path_01 = $EnemyPaths/SpecialEnemyPath01
onready var special_enemy_path_02 = $EnemyPaths/SpecialEnemyPath02
onready var special_enemy_path_03 = $EnemyPaths/SpecialEnemyPath03
onready var special_enemy_path_04 = $EnemyPaths/SpecialEnemyPath04

var all_special_paths : Array
var special_path_id_to_path_map : Dictionary

#

onready var crater_glow__bottom = $Environment/CraterGlow_Bottom
onready var crater_glow__left = $Environment/CraterGlow_Left
onready var crater_glow__right = $Environment/CraterGlow_Right
onready var crater_glow__top = $Environment/CraterGlow_Top

var special_path_id_to_all_crater_glows_map : Dictionary
var _all_crater_glows_to_affect_for_tweener : Array


######################


func _ready():
	_initialize_special_paths()
	_initialize_crater_glows()
	

#

func set_game_elements(arg_ele):
	game_elements = arg_ele
	
	game_elements.connect("before_game_quit", self, "_on_before_game_quit", [], CONNECT_PERSIST)
	
	input_prompt_manager = game_elements.input_prompt_manager

#####

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	
	_initialize_special_path_var_relateds()
	
	
	set_game_elements(arg_game_elements)
	stage_round_manager = game_elements.stage_round_manager
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	
	if !game_elements.enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
		game_elements.enemy_manager.connect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path", [], CONNECT_PERSIST)
	
	#
	
	_initialize_memory_infos()
	_initialize_custom_stagerounds()
	_initialize_memory_sacrifice_gui()
	_initialize_memory_recall_gui()
	_initialize_memory_summary_gui()
	
	stage_round_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)
	stage_round_manager.connect("round_ended_game_start_aware", self, "_on_round_end__map_memories__for_special_round_tracking", [], CONNECT_PERSIST)
	
	_initialize_all_GSSB()
	_connect_to_relateds__for_sac__conditions_changed__all()
	_connect_to_relateds__for_recall__warning_update__all()
	
	#
	
	_load_memories_from_save_file()
	
	#
	
	call_deferred("_deferred_init")

func _deferred_init():
	_initialize_all_particle_pools()
	
	_initialize_enable_process_conditional_clauses()
	_initialize_line_draw_node()
	
	call_deferred("_deferred_set_prop_of_memory_summary_gui")
	
	_initialize_current_mem_action_state__at_game_beginning()
	
	######
	
	_initialize_all_enemy_dream_relateds()
	_initialize_all_enemy_nightmare_relateds()

func _initialize_custom_stagerounds():
	var stage_rounds = ModeNormal_Memories_StageRounds.new()
	
	game_elements.stage_round_manager.set_stagerounds(stage_rounds)


func _initialize_memory_infos():
	#TESTING
#	var mem_sac_info__test = RoundMemorySacrificeInfo.new()
#	mem_sac_info__test.stage_round_id = "02"
#	mem_sac_info__test.sacrifice_type_ids_available_to_param_map = {
#		MemoryTypeId.TOWERS : [5],
#		MemoryTypeId.GOLD : [100],
#		MemoryTypeId.HEALTH : [10],
#		MemoryTypeId.RELIC_AND_GOLD : [2, 10],
#	}
#	_add_memory_info(mem_sac_info__test)
#
#	var mem_sac_info__test1 = RoundMemorySacrificeInfo.new()
#	mem_sac_info__test1.stage_round_id = "11"
#	mem_sac_info__test1.sacrifice_type_ids_available_to_param_map = {
#		MemoryTypeId.TOWERS : [3],
#		MemoryTypeId.GOLD : [6],
#		MemoryTypeId.HEALTH : [10],
#	}
#	_add_memory_info(mem_sac_info__test1)
	#END OF TEST
	
	var mem_sac_info__3 = RoundMemorySacrificeInfo.new()
	mem_sac_info__3.stage_round_id = "33"
	mem_sac_info__3.sacrifice_type_ids_available_to_param_map = {
		MemoryTypeId.TOWERS : [2],
		MemoryTypeId.GOLD : [6],
		MemoryTypeId.HEALTH : [15],
	}
	_add_memory_info(mem_sac_info__3)
	
	var mem_sac_info__5 = RoundMemorySacrificeInfo.new()
	mem_sac_info__5.stage_round_id = "53"
	mem_sac_info__5.sacrifice_type_ids_available_to_param_map = {
		#MemoryTypeId.TOWERS_WITH_INGS : [1, TOWERS_WITH_INGS_MAX_ING_COUNT],
		MemoryTypeId.TOWERS : [3],
		MemoryTypeId.GOLD : [12],
		MemoryTypeId.HEALTH : [20],
	}
	_add_memory_info(mem_sac_info__5)
	
	var mem_sac_info__7 = RoundMemorySacrificeInfo.new()
	mem_sac_info__7.stage_round_id = "73"
	mem_sac_info__7.sacrifice_type_ids_available_to_param_map = {
		#MemoryTypeId.TOWERS_WITH_INGS : [2, TOWERS_WITH_INGS_MAX_ING_COUNT],
		MemoryTypeId.TOWERS : [5],
		MemoryTypeId.GOLD : [22],
		MemoryTypeId.HEALTH : [35],
		MemoryTypeId.RELIC_AND_GOLD : [1, 2],
	}
	_add_memory_info(mem_sac_info__7)
	
	var mem_sac_info__9 = RoundMemorySacrificeInfo.new()
	mem_sac_info__9.stage_round_id = "93"
	mem_sac_info__9.sacrifice_type_ids_available_to_param_map = {
		#MemoryTypeId.TOWERS_WITH_INGS : [3, TOWERS_WITH_INGS_MAX_ING_COUNT],
		MemoryTypeId.TOWERS : [6],
		MemoryTypeId.GOLD : [34],
		MemoryTypeId.HEALTH : [40],
		MemoryTypeId.RELIC_AND_GOLD : [1, 5],
	}
	_add_memory_info(mem_sac_info__9)
	


func _add_memory_info(arg_info : RoundMemorySacrificeInfo):
	stage_round_trigger_to_round_memory_info_map[arg_info.stage_round_id] = arg_info
	


func _initialize_memory_sacrifice_gui():
	_mem_type_sac_construction_param__none = _generate_mem_type_sacrifice_button_constructor_param(MemoryTypeId.NONE, null)
	
	_memory_sacrifice_gui = MemorySacrificeGUI_Scene.instance()
	game_elements.whole_screen_gui.add_control_but_dont_show(_memory_sacrifice_gui)
	
	_memory_sacrifice_gui.initialize_gui(game_elements)
	
	_memory_sacrifice_gui.connect("select_later_clicked", self, "_sacrifice__on_select_later_clicked", [], CONNECT_PERSIST)


func _initialize_enable_process_conditional_clauses():
	enable_process_conditional_clauses = ConditionalClauses.new()
	enable_process_conditional_clauses.connect("clause_inserted", self, "_on_enable_process_clause_ins_or_rem", [], CONNECT_PERSIST)
	enable_process_conditional_clauses.connect("clause_removed", self, "_on_enable_process_clause_ins_or_rem", [], CONNECT_PERSIST)
	
	_on_enable_process_clause_ins_or_rem(null)

func _on_enable_process_clause_ins_or_rem(_arg_clause):
	set_process(!enable_process_conditional_clauses.is_passed)


#########

func _initialize_all_GSSB():
	_initialize_GSSB__sacrifice()
	_initialize_GSSB__recall()
	_initialize_GSSB__summary()
	

func _initialize_GSSB__sacrifice():
	var constr_params = GenStats_SmallButton.ConstructorParams.new()
	
	constr_params.show_descs = false
	
	constr_params.image_normal = GSSB_Memory_Sacrifice_Normal
	constr_params.image_hovered = GSSB_Memory_Sacrifice_Highlighted
	
	constr_params.condition_visible__func_source = self
	constr_params.condition_visible__func_name = "_update_GSSB_visibility__mem_sacrifice"
	#constr_params.condition_visible__func_param
	
	constr_params.on_click__func_source = self
	constr_params.on_click__func_name = "_on_click__show_memory_sacrifice_gui"
	
	GSSB__show_memory_sacrifice = game_elements.general_stats_panel.construct_small_button_using_cons_params(constr_params)
	_all_GSSB.append(GSSB__show_memory_sacrifice)
	_all_GSSB__to_highlight_with_mod_fluc.append(GSSB__show_memory_sacrifice)
	

func _on_click__show_memory_sacrifice_gui():
	_memory_sacrifice_gui.show_gui()
	


func _initialize_GSSB__recall():
	var constr_params = GenStats_SmallButton.ConstructorParams.new()
	
	constr_params.show_descs = false
	
	constr_params.image_normal = GSSB_Memory_Recall_Normal
	constr_params.image_hovered = GSSB_Memory_Recall_Highlighted
	
	constr_params.condition_visible__func_source = self
	constr_params.condition_visible__func_name = "_update_GSSB_visibility__mem_recall"
	#constr_params.condition_visible__func_param
	
	constr_params.on_click__func_source = self
	constr_params.on_click__func_name = "_on_click__show_memory_recall_gui"
	
	GSSB__show_memory_recall = game_elements.general_stats_panel.construct_small_button_using_cons_params(constr_params)
	_all_GSSB.append(GSSB__show_memory_recall)
	_all_GSSB__to_highlight_with_mod_fluc.append(GSSB__show_memory_recall)
	

func _on_click__show_memory_recall_gui():
	_memory_recall_gui.show_gui()
	



func _initialize_GSSB__summary():
	var constr_params = GenStats_SmallButton.ConstructorParams.new()
	
	constr_params.show_descs = false
	
	constr_params.image_normal = GSSB_Memory_Summary_Normal
	constr_params.image_hovered = GSSB_Memory_Summary_Highlighted
	
	constr_params.condition_visible__func_source = self
	constr_params.condition_visible__func_name = "_update_GSSB_visibility__mem_summary"
	#constr_params.condition_visible__func_param
	
	constr_params.on_click__func_source = self
	constr_params.on_click__func_name = "_on_click__show_memory_summary_gui"
	
	GSSB__show_memory_summary = game_elements.general_stats_panel.construct_small_button_using_cons_params(constr_params)
	_all_GSSB.append(GSSB__show_memory_summary)
	

func _on_click__show_memory_summary_gui():
	_memory_summary_gui.show_gui()
	

#func _initialize_GSSB_modulate_rgb_tweener():
#	pass
#

func _start_GSSB_modulate_rgb_tweener():
	set_current_modulate_rgb_for_GSSB(_min_modulate_rgb_for_GSSB)
	
	_modulate_rgb_tweener_for_GSSB = create_tween()
	
	_modulate_rgb_tweener_for_GSSB.set_loops()
	_modulate_rgb_tweener_for_GSSB.tween_property(self, "_current_modulate_rgb_for_GSSB", _max_modulate_rgb_for_GSSB, _modulate_transition_duration_for_GSSB)
	_modulate_rgb_tweener_for_GSSB.tween_property(self, "_current_modulate_rgb_for_GSSB", _min_modulate_rgb_for_GSSB, _modulate_transition_duration_for_GSSB)
	

func _end_GSSB_modulate_rgb_tweener():
	_modulate_rgb_tweener_for_GSSB.stop()
	_modulate_rgb_tweener_for_GSSB.kill()


func set_current_modulate_rgb_for_GSSB(arg_val):
	_current_modulate_rgb_for_GSSB = arg_val
	
	for button in _all_GSSB__to_highlight_with_mod_fluc:
		if button.visible:
			button.modulate.r = _current_modulate_rgb_for_GSSB
			button.modulate.g = _current_modulate_rgb_for_GSSB
			button.modulate.b = _current_modulate_rgb_for_GSSB
	
	

#

func _initialize_current_mem_action_state__at_game_beginning():
	set_current_mem_action_state__to_none()


func set_current_mem_action_state__to_none():
	var state
	if _past__stageround_id_to_recall_memories_map.size() == 0 and _future__stageround_id_to_recall_memories_map.size() == 0:
		state = MemoryActionStates.NONE__WITH_NO_SACRIFICES
	else:
		state = MemoryActionStates.NONE__WITH_SACRIFICES
	
	set_current_mem_action_state(state)


func set_current_mem_action_state(arg_state):
	_current_mem_action_state = arg_state
	
	var old_val = _at_least_one_GSSB_is_visible
	_at_least_one_GSSB_is_visible = _update_all_GSSB_visibility()
	_update_round_is_startable()
	_update_GSSB_modulate_rgb_tweener_state(old_val)

func _update_all_GSSB_visibility():
	var at_least_one_is_vis : bool = false
	for button in _all_GSSB:
		var res = button.update_is_visible_based_on_conditions()
		if res:
			at_least_one_is_vis = true
	
	return at_least_one_is_vis

func _update_GSSB_visibility__mem_sacrifice(arg_params):
	return _current_mem_action_state == MemoryActionStates.SACRIFICING

func _update_GSSB_visibility__mem_recall(arg_params):
	return _current_mem_action_state == MemoryActionStates.RECALLING

func _update_GSSB_visibility__mem_summary(arg_params):
	return _current_mem_action_state == MemoryActionStates.NONE__WITH_SACRIFICES


func _update_round_is_startable():
	var clause = game_elements.stage_round_manager.BlockStartRoundClauseIds.MAP_MEMORIES__IS_IN_SAC_OR_RECALL
	
	if _current_mem_action_state == MemoryActionStates.NONE__WITH_NO_SACRIFICES or _current_mem_action_state == MemoryActionStates.NONE__WITH_SACRIFICES:
		game_elements.stage_round_manager.block_start_round_conditional_clauses.remove_clause(clause)
	else:
		game_elements.stage_round_manager.block_start_round_conditional_clauses.attempt_insert_clause(clause)
	

func _update_GSSB_modulate_rgb_tweener_state(arg_old_at_least_one_GSSB_is_visible):
	if _at_least_one_GSSB_is_visible != arg_old_at_least_one_GSSB_is_visible:
		if _at_least_one_GSSB_is_visible:
			_start_GSSB_modulate_rgb_tweener()
		else:
			_end_GSSB_modulate_rgb_tweener()
	


#######

func _on_round_started(arg_stageround):
	dream_heal_aura_circle_draw_node.pause_lifetime_of_all_draws = true
	
	make_all_flags_invis()
	
	_on_round_start__for_consume_dream_markers()
	_on_round_start__consume_all_nightmare_marks()

func _on_round_ended(arg_stageround):
	var id = arg_stageround.id
	if stage_round_trigger_to_round_memory_info_map.has(id):
		_current_stageround_id = id
		_current_round_memory_sacrifice_info = stage_round_trigger_to_round_memory_info_map[id]
		set_current_mem_action_state(MemoryActionStates.SACRIFICING)
		
		_show_memory_sacrifice_gui()
		
	else:
		_current_round_memory_sacrifice_info = null
		
	
	if dream_heal_aura_circle_draw_node.has_draw_param():
		dream_heal_aura_circle_draw_node.pause_lifetime_of_all_draws = false
		game_elements.stage_round_manager.block_start_round_conditional_clauses.attempt_insert_clause(game_elements.stage_round_manager.BlockStartRoundClauseIds.MAP_MEMORIES__REMOVING_ENEMY_DREAMER_DRAW_PARAMS)
		
		if !dream_heal_aura_circle_draw_node.is_connected("all_draw_params_finished", self, "_on_all_draw_params_finished__enemy_dream"):
			dream_heal_aura_circle_draw_node.connect("all_draw_params_finished", self, "_on_all_draw_params_finished__enemy_dream", [], CONNECT_PERSIST)
	
	#
	_on_round_end__stop_all_enemy_related_timers()
	
	if is_instance_valid(_dream_heal_aura_aoe_attk_module):
		_dream_heal_aura_aoe_attk_module.kill_all_created_aoe()


func _on_round_end__stop_all_enemy_related_timers():
	if is_instance_valid(_dream_marker_initial_delay_timer):
		_dream_marker_initial_delay_timer.stop()
		_dream_marker_per_mark_delay_timer.stop()
		
		_nightmare_marker_initial_delay_timer.stop()
		_nightmare_marker_per_mark_delay_timer.stop()

func _on_all_draw_params_finished__enemy_dream():
	game_elements.stage_round_manager.block_start_round_conditional_clauses.remove_clause(game_elements.stage_round_manager.BlockStartRoundClauseIds.MAP_MEMORIES__REMOVING_ENEMY_DREAMER_DRAW_PARAMS)
	


##

func _show_memory_sacrifice_gui():
	var constructor_params : Array
	for mem_type_id in _current_round_memory_sacrifice_info.sacrifice_type_ids_available_to_param_map.keys():
		var params = _current_round_memory_sacrifice_info.sacrifice_type_ids_available_to_param_map[mem_type_id]
		
		constructor_params.append(_generate_mem_type_sacrifice_button_constructor_param(mem_type_id, params))
	
	
	_memory_sacrifice_gui.configure_to_mem_sacrifice_button_construction_params(constructor_params)
	_memory_sacrifice_gui.configure_to_mem_sacrifice_button_construction_params__in_other_slots([_mem_type_sac_construction_param__none])
	
	_memory_sacrifice_gui.show_gui()
	

#######

func _generate_mem_type_sacrifice_button_constructor_param(arg_type, arg_params):
	var constructor_param = MemoryTypeSacrificeButton.ConstructorParams.new()
	
	var descs
	var image_normal
	var image_hovered
	var on_click_func_name
	var condition_func_name
	var condition_func_param
	
	if arg_type == MemoryTypeId.GOLD:
		descs = _generate_sac_description_for_mem_type_with_params__gold(arg_params)
		image_normal = MemoryType_Gold_Normal
		image_hovered = MemoryType_Gold_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__gold" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__gold"
		
	elif arg_type == MemoryTypeId.HEALTH:
		descs = _generate_sac_description_for_mem_type_with_params__health(arg_params)
		image_normal = MemoryType_Health_Normal
		image_hovered = MemoryType_Health_Highlighted 
		on_click_func_name = "_on_execute_memory_sacrifice_type__health" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__health"
		
	elif arg_type == MemoryTypeId.RELIC_AND_GOLD:
		descs = _generate_sac_description_for_mem_type_with_params__relic_and_gold(arg_params)
		image_normal = MemoryType_Relic_Normal
		image_hovered = MemoryType_Relic_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__relic_and_gold" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__relic_and_gold"
		
	elif arg_type == MemoryTypeId.TOWERS:
		descs = _generate_sac_description_for_mem_type_with_params__towers(arg_params)
		image_normal = MemoryType_Towers_Normal
		image_hovered = MemoryType_Towers_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__towers" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__towers"
		
	elif arg_type == MemoryTypeId.TOWERS_WITH_INGS:
		descs = _generate_sac_description_for_mem_type_with_params__towers_with_ings(arg_params)
		image_normal = MemoryType_TowersWithIngs_Normal
		image_hovered = MemoryType_TowersWithIngs_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__towers_with_ings" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__towers_with_ings"
		
	elif arg_type == MemoryTypeId.NONE:
		
		descs = _generate_sac_description_for_mem_type_with_params__none(arg_params)
		image_normal = MemoryType_None_Normal
		image_hovered = MemoryType_None_Highlighted
		on_click_func_name = "_on_execute_memory_sacrifice_type__none" 
		condition_func_name = "_is_condition_met_for__memory_sacrifice_type__none"
		
		constructor_param.row_index = constructor_param.ROW_BELOW
	
	
	constructor_param.descriptions = descs
	constructor_param.header_left_text = "Sacrifice Info"
	constructor_param.image_normal = image_normal
	constructor_param.image_hovered = image_hovered
	constructor_param.on_click_func_source = self
	constructor_param.on_click_func_name = on_click_func_name
	constructor_param.on_click_func_params = arg_params
	constructor_param.condition_func_source = self
	constructor_param.condition_func_param = arg_params
	constructor_param.condition_func_name = condition_func_name
	constructor_param.condition_changed_signal_source = self
	constructor_param.condition_changed_signal_name = memory_type_id_to_conditions_changed_signal_name[arg_type]
	
	
	return constructor_param


func _generate_sac_description_for_mem_type_with_params__gold(arg_params):
	var plain_fragment__x_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % [arg_params[0]])
	
	return [
		["Sacrifice |0|.", [plain_fragment__x_gold]]
	]

func _generate_sac_description_for_mem_type_with_params__health(arg_params):
	var plain_fragment__x_health = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "%s health" % [arg_params[0]])
	
	return [
		["Sacrifice |0|.", [plain_fragment__x_health]]
	]

func _generate_sac_description_for_mem_type_with_params__relic_and_gold(arg_params):
	var gold_amount = arg_params[1]
	
	var plain_fragment__x_relic = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.RELIC, "%s relic(s)" % [arg_params[0]])
	
	if gold_amount != 0:
		var plain_fragment__x_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % [gold_amount])
		
		return [
			["Sacrifice |0| and |1|.", [plain_fragment__x_relic, plain_fragment__x_gold]]
		]
		
	else:
		return [
			["Sacrifice |0|.", [plain_fragment__x_relic]]
		]


func _generate_sac_description_for_mem_type_with_params__towers(arg_params):
	var plain_fragment__x_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s tower(s)" % [arg_params[0]])
	var plain_fragment__ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredients")
	
	return [
		["Sacrifice |0|. Does not include their |1|.", [plain_fragment__x_towers, plain_fragment__ingredients]]
	]

func _generate_sac_description_for_mem_type_with_params__towers_with_ings(arg_params):
	var plain_fragment__x_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s tower(s)" % [arg_params[0]])
	var plain_fragment__x_ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "%s ingredient(s)" % [arg_params[1]])
	
	return [
		["Sacrifice |0|. Includes up to |1|.", [plain_fragment__x_towers, plain_fragment__x_ingredients]]
	]

func _generate_sac_description_for_mem_type_with_params__none(arg_params):
	return [
		["Sacrifice nothing.", []]  # needed for alignment
	]


###############

func _is_condition_met_for__memory_sacrifice_type__none(arg_params):
	return true

func _is_condition_met_for__memory_sacrifice_type__gold(arg_params):
	return game_elements.gold_manager.current_gold >= arg_params[0]
	

func _is_condition_met_for__memory_sacrifice_type__health(arg_params):
	return game_elements.health_manager.current_health > arg_params[0]
	

func _is_condition_met_for__memory_sacrifice_type__relic_and_gold(arg_params):
	return game_elements.relic_manager.current_relic_count >= arg_params[0] and game_elements.gold_manager.current_gold >= arg_params[1]
	

func _is_condition_met_for__memory_sacrifice_type__towers(arg_params):
	var towers = _get_all_towers_viable_for_sacrifice()
	
	return towers.size() >= arg_params[0]

func _is_condition_met_for__memory_sacrifice_type__towers_with_ings(arg_params):
	var towers = _get_all_towers_viable_for_sacrifice()
	
	return towers.size() >= arg_params[0]


func _get_all_towers_viable_for_sacrifice() -> Array:
	var towers = game_elements.tower_manager.get_all_towers()
	var final_candidates = []
	for tower in towers:
		if _is_tower_valid_for_sacrifice(tower):
			final_candidates.append(tower)
			
	
	return final_candidates

##

func _connect_to_relateds__for_sac__conditions_changed__all():
	_connect_to_relateds__for_conditions_changed__gold()
	_connect_to_relateds__for_conditions_changed__health()
	_connect_to_relateds__for_conditions_changed__relic_and_gold()
	_connect_to_relateds__for_conditions_changed__towers_and_towers_with_ings()

func _connect_to_relateds__for_conditions_changed__gold():
	game_elements.gold_manager.connect("current_gold_changed", self, "_on_current_gold_changed", [], CONNECT_PERSIST)

func _on_current_gold_changed(arg_amount):
	emit_signal("conditions_changed__gold")


func _connect_to_relateds__for_conditions_changed__health():
	game_elements.health_manager.connect("current_health_changed", self, "_on_current_health_changed", [], CONNECT_PERSIST)

func _on_current_health_changed(arg_amount):
	emit_signal("conditions_changed__health")


func _connect_to_relateds__for_conditions_changed__relic_and_gold():
	game_elements.gold_manager.connect("current_gold_changed", self, "_on_current_relic_or_gold_changed", [], CONNECT_PERSIST)
	game_elements.relic_manager.connect("current_relic_count_changed", self, "_on_current_relic_or_gold_changed", [], CONNECT_PERSIST)

func _on_current_relic_or_gold_changed(arg_amount):
	emit_signal("conditions_changed__relic_and_gold")


func _connect_to_relateds__for_conditions_changed__towers_and_towers_with_ings():
	game_elements.tower_manager.connect("tower_in_queue_free", self, "_on_tower_queued_free", [], CONNECT_PERSIST)
	game_elements.tower_manager.connect("tower_is_hidden_changed", self, "_on_tower_is_hidden_changed", [], CONNECT_PERSIST)
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added", [], CONNECT_PERSIST)

func _on_tower_queued_free(arg_tower):
	_emit_signals__for_conditions_changed__all_tower_relateds()

func _on_tower_is_hidden_changed(arg_tower, arg_val):
	_emit_signals__for_conditions_changed__all_tower_relateds()

func _on_tower_added(arg_tower):
	call_deferred("_emit_signals__for_conditions_changed__all_tower_relateds")


func _emit_signals__for_conditions_changed__all_tower_relateds():
	emit_signal("conditions_changed__towers")
	emit_signal("conditions_changed__towers_with_ings")
	

##

func _on_execute_memory_sacrifice_type__gold(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.GOLD, arg_params]
	_wrap_up_memory_sacrifice_phase()
	
	#
	game_elements.gold_manager.decrease_gold_by(arg_params[0], game_elements.gold_manager.DecreaseGoldSource.MAP_SPECIFIC)
	_store_to_future_recall_mem_dict__mem_sac__gold(_current_stageround_id, arg_params[0])
	
	#
	var gold_panel_pos = _get_center_of_control(game_elements.general_stats_panel.gold_panel)
	var seq_data = create_circle_conceal_seq_data(CircleParticleType.HUD, MemoryActionState__Particles.SACRIFICE, gold_panel_pos, gold_panel_pos)
	seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = gold_panel_pos
	start_circle_conceal_particle_fx_sequence(seq_data)

func _get_center_of_control(arg_control) -> Vector2:
	return arg_control.rect_global_position + (arg_control.rect_size / 2)



func _on_execute_memory_sacrifice_type__health(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.HEALTH, arg_params]
	_wrap_up_memory_sacrifice_phase()
	
	#
	game_elements.health_manager.decrease_health_by(arg_params[0], game_elements.health_manager.DecreaseHealthSource.MAP_SPECIFIC)
	_store_to_future_recall_mem_dict__mem_sac__health(_current_stageround_id, arg_params[0])
	
	#
	var panel_pos = game_elements.right_side_panel.round_status_panel.get_heart_icon_global_pos()
	var seq_data = create_circle_conceal_seq_data(CircleParticleType.HUD, MemoryActionState__Particles.SACRIFICE, panel_pos, panel_pos)
	seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = panel_pos
	start_circle_conceal_particle_fx_sequence(seq_data)
	

func _on_execute_memory_sacrifice_type__relic_and_gold(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.RELIC_AND_GOLD, arg_params]
	_wrap_up_memory_sacrifice_phase()
	
	#
	game_elements.relic_manager.decrease_relic_count_by(arg_params[0], game_elements.relic_manager.DecreaseRelicSource.MAP_SPECIFIC)
	game_elements.gold_manager.decrease_gold_by(arg_params[1], game_elements.gold_manager.DecreaseGoldSource.MAP_SPECIFIC)
	_store_to_future_recall_mem_dict__mem_sac__relic_and_gold(_current_stageround_id, arg_params[0], arg_params[1])
	
	if arg_params[1] != 0:
		var gold_panel_pos = _get_center_of_control(game_elements.general_stats_panel.gold_panel) #game_elements.general_stats_panel.gold_panel.rect_global_position
		var seq_data = create_circle_conceal_seq_data(CircleParticleType.HUD, MemoryActionState__Particles.SACRIFICE, gold_panel_pos, gold_panel_pos)
		seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = gold_panel_pos
		start_circle_conceal_particle_fx_sequence(seq_data)
	
	var relic_panel_pos = _get_center_of_control(game_elements.general_stats_panel.relic_panel) #game_elements.general_stats_panel.relic_panel.rect_global_position
	var seq_data = create_circle_conceal_seq_data(CircleParticleType.HUD, MemoryActionState__Particles.SACRIFICE, relic_panel_pos, relic_panel_pos)
	seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = relic_panel_pos
	start_circle_conceal_particle_fx_sequence(seq_data)
	

func _on_execute_memory_sacrifice_type__towers(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.TOWERS, arg_params]
	_start_select_multiple_towers_prompt(arg_params[0],
	[
		["To sacrifice for Memories (ingredients NOT included)", []]
	])
	

func _on_execute_memory_sacrifice_type__towers_with_ings(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.TOWERS_WITH_INGS, arg_params]
	_start_select_multiple_towers_prompt(arg_params[0],
	[
		["To sacrifice for Memories (ingredients included)", []]
	])
	

func _on_execute_memory_sacrifice_type__none(arg_params):
	_current_sacrifice_id_and_param = [MemoryTypeId.NONE, arg_params]
	_wrap_up_memory_sacrifice_phase()
	
	_attempt_show_memory_recall_gui__or_end_if_not_appropriate()
	

func _sacrifice__on_select_later_clicked():
	_memory_sacrifice_gui.hide_gui()
	

func _wrap_up_memory_sacrifice_phase():
	_memory_sacrifice_gui.hide_gui()


##

func _start_select_multiple_towers_prompt(arg_tower_count, arg_custom_lines : Array):
	_memory_sacrifice_gui.hide_gui()
	
	var adv_param = input_prompt_manager.MultipleTowerSelectionAdvParam.new()
	adv_param.min_select_count = arg_tower_count
	adv_param.max_select_count = arg_tower_count
	
	input_prompt_manager.prompt_select_multiple_towers(adv_param, self, "_finished_tower_selected_from_multiple_select", "_cancelled_multiple_tower_selection", "_is_tower_valid_for_sacrifice",
	arg_custom_lines)
	

func _is_tower_valid_for_sacrifice(arg_tower):
	return !arg_tower.is_a_summoned_tower and !arg_tower.is_queued_for_deletion()
	

func _cancelled_multiple_tower_selection():
	_memory_sacrifice_gui.show_gui()
	


func _finished_tower_selected_from_multiple_select(arg_towers):
	var sac_id = _current_sacrifice_id_and_param[0]
	if sac_id == MemoryTypeId.TOWERS:
		_store_to_future_recall_mem_dict__mem_sac__towers(_current_stageround_id, arg_towers)
		
		
	elif sac_id == MemoryTypeId.TOWERS_WITH_INGS:
		_store_to_future_recall_mem_dict__mem_sac__towers_with_ings(_current_stageround_id, arg_towers)
		
		
	
	for tower in arg_towers:
		var seq_data = create_circle_conceal_seq_data(CircleParticleType.TOWER, MemoryActionState__Particles.SACRIFICE, tower.global_position, tower.global_position)
		start_circle_conceal_particle_fx_sequence(seq_data)
		
		#tower.queue_free()
		tower.can_be_sold_conditonal_clauses.attempt_insert_clause(tower.CanBeSoldClauses.MAP_MEMORIES__IN_SAC)
		tower.can_be_placed_in_map_conditional_clause.attempt_insert_clause(tower.CanBePlacedInMapClauses.GENERIC_CANNOT_BE_PLACED_IN_MAP)
		tower.can_be_placed_in_bench_conditional_clause.attempt_insert_clause(tower.CanBePlacedInBenchClauses.GENERIC_CANNOT_BE_PLACED_IN_BENCH)
		tower.is_selectable_conditional_clauses.attempt_insert_clause(tower.IsSelectableClauseIds.MAP_MEMORIES__IN_SAC)
		
		seq_data.metadata[seq_data.METADATA_KEY__TOWER] = tower
		seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = tower.global_position


###

func _construct_recall_memory(arg_stageround_id, arg_mem_type : int, 
	arg_params):
	
	var recall_mem = RecallMemory.new()
	recall_mem.memory_type_id = arg_mem_type
	recall_mem.stage_round_id = arg_stageround_id
	recall_mem.param = arg_params
	
	return recall_mem

func _set_recall_memory_to_future_memories_map(arg_recall_memory : RecallMemory, arg_custom_stageround_id = null):
	var stageround_id_to_use = arg_custom_stageround_id
	if arg_custom_stageround_id == null:
		stageround_id_to_use = arg_recall_memory.stage_round_id
	else:
		arg_recall_memory.stage_round_id = arg_custom_stageround_id
	
	_future__stageround_id_to_recall_memories_map[stageround_id_to_use] = arg_recall_memory
	
	_update_memory_summary_panel__changed_future_recall_mem_map(arg_recall_memory)


#

func _store_to_future_recall_mem_dict__mem_sac__gold(arg_stage_round, arg_amount):
	var recall_mem = _construct_recall_memory(arg_stage_round, MemoryTypeId.GOLD, arg_amount)
	recall_mem.version_num = _current_recall_memory_version__gold
	
	_set_recall_memory_to_future_memories_map(recall_mem)

func _store_to_future_recall_mem_dict__mem_sac__health(arg_stage_round, arg_amount):
	var recall_mem = _construct_recall_memory(arg_stage_round, MemoryTypeId.HEALTH, arg_amount)
	recall_mem.version_num = _current_recall_memory_version__health
	
	_set_recall_memory_to_future_memories_map(recall_mem)
	

func _store_to_future_recall_mem_dict__mem_sac__relic_and_gold(arg_stage_round, arg_relic_amount, arg_gold_amount):
	var recall_mem = _construct_recall_memory(arg_stage_round, MemoryTypeId.RELIC_AND_GOLD, [arg_relic_amount, arg_gold_amount])
	recall_mem.version_num = _current_recall_memory_version__relic_and_gold
	
	_set_recall_memory_to_future_memories_map(recall_mem)

func _store_to_future_recall_mem_dict__mem_sac__towers(arg_stage_round, arg_towers):
	var tower_ids = []
	for tower in arg_towers:
		tower_ids.append(tower.tower_id)
	
	###
	
	var recall_mem = _construct_recall_memory(arg_stage_round, MemoryTypeId.TOWERS, tower_ids)
	recall_mem.version_num = _current_recall_memory_version__towers
	
	_set_recall_memory_to_future_memories_map(recall_mem)


func _store_to_future_recall_mem_dict__mem_sac__towers_with_ings(arg_stage_round, arg_towers):
	var tower_id_to_serialized_ings_map : Dictionary = {}
	for tower in arg_towers:
		pass
		#DELEGATED to future when saving ings is possible
	
	print("MEMORIES -> Towers With Ings not supported yet")



################################## LOAD

func _load_memories_from_save_file():
	GameSaveManager.load_map_metadata__of_map_memories(self, 
			"_load_memories__using_save_file_from_save_manager")

func _load_memories__using_save_file_from_save_manager(load_file):
	var save_dict = parse_json(load_file.get_line())
	
	_past__stageround_id_to_recall_memories_map = _construct_memories_from_JSON(save_dict)


func _construct_memories_from_JSON(arg_dict):
	var version = int(arg_dict[SAVE_FILE__DICT_KEY__VERSION])
	
	var sac_dict = arg_dict[SAVE_FILE__DICT_KEY__SACRIFICE] #JSON.parse(arg_dict[SAVE_FILE__DICT_KEY__SACRIFICE])
	return _construct_memories_from_save_dict(sac_dict, version)

func _construct_memories_from_save_dict(arg_save_dict, version):
	
	if version == 1:
		var mems = {}
		for stage_round_id in arg_save_dict.keys():
			mems[stage_round_id] = _construct_recall_memory_from_dict(arg_save_dict[stage_round_id])
		
		return mems
		
	



func _construct_recall_memory_from_dict(arg_dict):
	arg_dict = JSON.parse(arg_dict).result
	
	#
	
	var recall_memory = RecallMemory.new()
	
	var params
	var memory_type_id
	var version_num
	
	for prop_name in arg_dict.keys():
		if prop_name != RECALL_MEMORY__NAME__PARAM:
			recall_memory.set(prop_name, arg_dict[prop_name])
		else:
			params = arg_dict[prop_name]
	
	memory_type_id = recall_memory.memory_type_id
	version_num = recall_memory.version_num
	
	if memory_type_id == MemoryTypeId.GOLD:
		if recall_memory.version_num == 1:
			params = int(params)
			recall_memory.version_num = _current_recall_memory_version__gold
			
	elif memory_type_id == MemoryTypeId.HEALTH:
		if recall_memory.version_num == 1:
			params = int(params)
			recall_memory.version_num = _current_recall_memory_version__health
		
	elif memory_type_id == MemoryTypeId.RELIC_AND_GOLD:
		if recall_memory.version_num == 1:
			var bucket = []
			for x in params:
				bucket.append(int(x))
			params = bucket
			recall_memory.version_num = _current_recall_memory_version__relic_and_gold
		
	elif memory_type_id == MemoryTypeId.TOWERS:
		if recall_memory.version_num == 1:
			var bucket = []
			for x in params:
				bucket.append(int(x))
			params = bucket
			recall_memory.version_num = _current_recall_memory_version__towers
		
	
	
	recall_memory.param = params
	
	return recall_memory


##################

func _on_before_game_quit():
	_transfer_untraversed_past_recall_mem_into_future()
	
	_write_savables_to_save_file()
	


func _transfer_untraversed_past_recall_mem_into_future():
	for stageround_id in stage_round_trigger_to_round_memory_info_map:
		if _past__stageround_id_to_recall_memories_map.has(stageround_id):
			if !_future__stageround_id_to_recall_memories_map.has(stageround_id):
				_future__stageround_id_to_recall_memories_map[stageround_id] = _past__stageround_id_to_recall_memories_map[stageround_id]
				
	


func _write_savables_to_save_file():
	if CAN_WRITE_SAVE_FILE:
		var save_dict = {}
		
		save_dict[SAVE_FILE__DICT_KEY__VERSION] = SAVE_FILE__DICT__VERSION
		save_dict[SAVE_FILE__DICT_KEY__SACRIFICE] = _convert_future_stage_round_id_to_recall_memories_map__to_json_compat() #_future__stageround_id_to_recall_memories_map
		
		GameSaveManager.save_map_data__map_memories(save_dict)


func _convert_future_stage_round_id_to_recall_memories_map__to_json_compat():
	var dict = {}
	for stageround_id in _future__stageround_id_to_recall_memories_map:
		dict[stageround_id] = _future__stageround_id_to_recall_memories_map[stageround_id].convert_to_JSON()
	
	return dict

#################
# PARTICLES
#################

func _initialize_all_particle_pools():
	_initialize_particle_attk_sprite_pool()

func _initialize_particle_attk_sprite_pool():
	circle_conceal_particle_pool_compo = AttackSpritePoolComponent.new()
	circle_conceal_particle_pool_compo.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	circle_conceal_particle_pool_compo.node_to_listen_for_queue_free = self
	circle_conceal_particle_pool_compo.source_for_funcs_for_attk_sprite = self
	circle_conceal_particle_pool_compo.func_name_for_creating_attack_sprite = "_create_circle_conceal_particle"
	

func _create_circle_conceal_particle():
	var particle = CenterBasedAttackSprite_Scene.instance()
	
	particle.texture_to_use = Memories_CircleConcealParticle_Pic
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	
	particle.z_as_relative = false
	particle.z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
	
	return particle


func _initialize_line_draw_node():
	line_draw_node.z_as_relative = false
	line_draw_node.z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL

##

func create_circle_conceal_seq_data(arg_type : int, arg_mem_action_state : int, arg_source_pos : Vector2, arg_center_pos : Vector2) -> CircleConcealSequenceData:
	var seq_data = CircleConcealSequenceData.new()
	
	seq_data.rng_to_use = non_essential_rng
	seq_data.seq_particle_type = arg_type
	seq_data.mem_action_state = arg_mem_action_state
	
	seq_data.center = arg_center_pos
	seq_data.source_pos = arg_source_pos
	
	
	if arg_mem_action_state == MemoryActionState__Particles.SACRIFICE:
		seq_data.circle_mod_rgb__range_a = Color(253/255.0, 78/255.0, 81/255.0)
		seq_data.circle_mod_rgb__range_b = Color(218/255.0, 2/255.0, 5/255.0)
		
		seq_data.beam_mod_rgb__range_a = seq_data.circle_mod_rgb__range_a * 1.2
		seq_data.beam_mod_rgb__range_b = seq_data.circle_mod_rgb__range_b * 1.2
		
		
	elif arg_mem_action_state == MemoryActionState__Particles.RECALL:
		seq_data.circle_mod_rgb__range_a = Color(77/255.0, 122/255.0, 253/255.0)
		seq_data.circle_mod_rgb__range_b = Color(253/255.0, 78/255.0, 81/255.0)
		
		seq_data.beam_mod_rgb__range_a = seq_data.circle_mod_rgb__range_a * 1.2
		seq_data.beam_mod_rgb__range_b = seq_data.circle_mod_rgb__range_b * 1.2
		
	
	
	seq_data.delta_per_circle = circle_conceal_delta_per_circle
	
	seq_data.circle_count = non_essential_rng.randi_range(circle_conceal_min_count, circle_conceal_max_count)
	
	seq_data.delta_for_circle_phase = circle_conceal__circle_phase_duration
	seq_data.delta_for_beam_phase = circle_conceal__beam_phase_duration
	
	seq_data.func_source = self
	
	if arg_mem_action_state == MemoryActionState__Particles.SACRIFICE:
		seq_data.func_to_call_for_create_circle = "_create_circle_conceal_particle__using_seq_data__sac"
		seq_data.func_to_call_on_circle_phase_end = "_on_circle_conceal_seq__circle_phase_ended"
		seq_data.func_to_call_for_end = "_on_circle_conceal_seq_ended__sac"
		seq_data.func_to_call_for_line_draw_node_exec = "_on_circle_conceal_exec_line_draw_node"
		seq_data.func_to_call_on_beam_phase_end = ""
		
		seq_data.starting_state = CircleConcealSequenceData.CIRCLE_STATE
		seq_data.ending_state = CircleConcealSequenceData.BEAM_STATE
		
		
	elif arg_mem_action_state == MemoryActionState__Particles.RECALL:
		seq_data.func_to_call_for_create_circle = "_create_circle_conceal_particle__using_seq_data__recall"
		seq_data.func_to_call_on_circle_phase_end = "_on_circle_conceal_seq__circle_phase_ended"
		seq_data.func_to_call_for_end = "_on_circle_conceal_seq_ended__recall"
		seq_data.func_to_call_for_line_draw_node_exec = "_on_circle_conceal_exec_line_draw_node"
		seq_data.func_to_call_on_beam_phase_end = "_on_circle_conceal_seq__beam_phase_ended__recall"
		
		seq_data.starting_state = CircleConcealSequenceData.BEAM_STATE
		seq_data.ending_state = CircleConcealSequenceData.CIRCLE_STATE
		
	
	seq_data.configure_data(non_essential_rng)
	
	return seq_data
	


# sequence of:
# 1) Circles appearing at an angle (range) with dist (range) from center pos, increasing in scale
# 2) Beam straight up
# 3) Func call on end (of circle or beam state -> optional)

func start_circle_conceal_particle_fx_sequence(seq_data : CircleConcealSequenceData):
	#var seq_data = CircleConcealSequenceData.new()
	_circle_conceal_seq_data_list.append(seq_data)
	
	enable_process_conditional_clauses.attempt_insert_clause(EnableProcessClauseIds.CIRCLE_CONCEAL_SEQUENCE)
	


func _process(delta):
	for data in _circle_conceal_seq_data_list:
		data.delta(delta)
	
	###
	
	if has_tower_ids_queued_for_recall and !pause_tower_ids_queue_for_recall:
		delay_for_next_tower_id_recall -= delta
		
		if delay_for_next_tower_id_recall <= 0:
			_attempt_summon_tower_id_from_recall(tower_ids_queued_for_recall.pop_front())
			

func _create_circle_conceal_particle__using_seq_data__sac(arg_data : CircleConcealSequenceData):
	var particle = circle_conceal_particle_pool_compo.get_or_create_attack_sprite_from_pool()
	
	_configure_circle_conceal_particle_using_data(particle, arg_data)

func _create_circle_conceal_particle__using_seq_data__recall(arg_data : CircleConcealSequenceData):
	var particle = circle_conceal_particle_pool_compo.get_or_create_attack_sprite_from_pool()
	
	_configure_circle_conceal_particle_using_data(particle, arg_data)
	


func _configure_circle_conceal_particle_using_data(particle : CenterBasedAttackSprite, arg_data : CircleConcealSequenceData):
	#arg_data.configure_data()
	
	arg_data.configure_circle_particle_based_on_self(particle)
	
	if arg_data.seq_particle_type == CircleParticleType.TOWER:
		var starting_angle_and_center_dist_mag = arg_data.generate_random_starting_angle_and_center_dist_modi_from_center(arg_data.source_pos, circle_conceal_center_modification_mag__tower)
		arg_data.angle_min = 1
		arg_data.angle_max = 359
		
		arg_data.starting_dist_min = circle_conceal_starting_dist_min__tower
		arg_data.starting_dist_max = circle_conceal_starting_dist_max__tower
		
		arg_data.center_modi = starting_angle_and_center_dist_mag[1]
		
	elif arg_data.seq_particle_type == CircleParticleType.HUD:
		var starting_angle_and_center_dist_mag = arg_data.generate_random_starting_angle_and_center_dist_modi_from_center(arg_data.source_pos, circle_conceal_center_modification_mag__generic_hud)
		#arg_data.angle_min = starting_angle_and_center_dist_mag[0]
		#arg_data.angle_max = starting_angle_and_center_dist_mag[0]
		arg_data.angle_min = 1
		arg_data.angle_max = 359
		
		
		arg_data.starting_dist_min = circle_conceal_starting_dist_min__generic_hud
		arg_data.starting_dist_max = circle_conceal_starting_dist_max__generic_hud
		
		arg_data.center_modi = starting_angle_and_center_dist_mag[1]
	
	
	particle.center_pos_of_basis = arg_data.center + arg_data.center_modi
	
	
	if arg_data.mem_action_state == MemoryActionState__Particles.SACRIFICE:
		particle.initial_speed_towards_center = non_essential_rng.randi_range(circle_conceal_initial_speed_to_center_min__sac, circle_conceal_initial_speed_to_center_max__sac)
		particle.speed_accel_towards_center = non_essential_rng.randi_range(circle_conceal_speed_accel_to_center_min__sac, circle_conceal_speed_accel_to_center_max__sac)
		
		particle.min_starting_distance_from_center = arg_data.starting_dist_min
		particle.max_starting_distance_from_center = arg_data.starting_dist_max
		
		particle.min_speed_towards_center = 0
		particle.max_speed_towards_center = 9999999
		
	elif arg_data.mem_action_state == MemoryActionState__Particles.RECALL:
		particle.initial_speed_towards_center = non_essential_rng.randi_range(circle_conceal_initial_speed_to_center_min__recall, circle_conceal_initial_speed_to_center_max__recall)
		particle.speed_accel_towards_center = non_essential_rng.randi_range(circle_conceal_speed_accel_to_center_min__recall, circle_conceal_speed_accel_to_center_max__recall)
		
		particle.min_starting_distance_from_center = 5
		particle.max_starting_distance_from_center = 10
		
		particle.min_speed_towards_center = -999999
		particle.max_speed_towards_center = 0
		
	
	
	particle.min_starting_angle = arg_data.angle_min
	particle.max_starting_angle = arg_data.angle_max
	
	particle.lifetime = 1.2
	
	var scale_mag = non_essential_rng.randf_range(circle_conceal_particle_scale_min, circle_conceal_particle_scale_max)
	particle.scale = Vector2(scale_mag, scale_mag)
	
	
	particle.reset_for_another_use()
	
	
	
	particle.modulate.a = non_essential_rng.randf_range(circle_conceal_mod_a_starting_min, circle_conceal_mod_a_starting_max)
	
	var finishing_mod_a_limit = non_essential_rng.randf_range(circle_conceal_mod_a_finishing_min, circle_conceal_mod_a_finishing_max)
	particle.transparency_per_sec = -(finishing_mod_a_limit - particle.modulate.a) / particle.lifetime
	
	particle.visible = true
	
	#####
	
	return particle



func _on_circle_conceal_seq__circle_phase_ended(arg_seq : CircleConcealSequenceData):
	if arg_seq.metadata.has(CircleConcealSequenceData.METADATA_KEY__TOWER):
		var tower = arg_seq.metadata[CircleConcealSequenceData.METADATA_KEY__TOWER]
		
		if is_instance_valid(tower):
			tower.queue_free()


func _on_circle_conceal_seq_ended__sac(arg_seq):
	_circle_conceal_seq_data_list.erase(arg_seq)
	
	if _circle_conceal_seq_data_list.size() == 0:
		enable_process_conditional_clauses.remove_clause(EnableProcessClauseIds.CIRCLE_CONCEAL_SEQUENCE)
	
	_on_sacrifice_animations_ended()

func _on_circle_conceal_seq_ended__recall(arg_seq):
	_circle_conceal_seq_data_list.erase(arg_seq)
	
	if _circle_conceal_seq_data_list.size() == 0:
		enable_process_conditional_clauses.remove_clause(EnableProcessClauseIds.CIRCLE_CONCEAL_SEQUENCE)
	

func _on_circle_conceal_seq__beam_phase_ended__recall(arg_seq : CircleConcealSequenceData):
	if arg_seq.metadata.has(arg_seq.METADATA_KEY__MEM_TYPE_ID):
		var mem_type = arg_seq.metadata[arg_seq.METADATA_KEY__MEM_TYPE_ID]
		
		var params
		if arg_seq.metadata.has(arg_seq.METADATA_KEY__MEM_PARAM):
			params = arg_seq.metadata[arg_seq.METADATA_KEY__MEM_PARAM]
		
		
		if mem_type == MemoryTypeId.GOLD:
			var amount = params
			game_elements.gold_manager.increase_gold_by(amount, game_elements.gold_manager.IncreaseGoldSource.MAP_SPECIFIC_BEHAVIOR)
			
		elif mem_type == MemoryTypeId.HEALTH:
			var amount = params
			game_elements.health_manager.increase_health_by(amount, game_elements.health_manager.IncreaseHealthSource.MAP_SPECIFIC)
			
		elif mem_type == MemoryTypeId.RELIC_AND_GOLD:
			var relic_amount = params[0]
			game_elements.relic_manager.increase_relic_count_by(relic_amount, game_elements.relic_manager.IncreaseRelicSource.MAP_SPECIFIC_BEHAVIOR)
			
			var gold_amount = params[1]
			game_elements.gold_manager.increase_gold_by(gold_amount, game_elements.gold_manager.IncreaseGoldSource.MAP_SPECIFIC_BEHAVIOR)
			
			
		elif mem_type == MemoryTypeId.TOWERS:
			var tower_id = arg_seq.metadata[CircleConcealSequenceData.METADATA_KEY__TOWER_ID_TO_CREATE]
			var bench_slot = arg_seq.metadata[CircleConcealSequenceData.METADATA_KEY__BENCH_PLACABLE_TO_PUT_TOWER]
			game_elements.tower_inventory_bench.create_tower_and_add_to_scene(tower_id, bench_slot)
		
	


func _on_circle_conceal_exec_line_draw_node(arg_seq : CircleConcealSequenceData):
	var line_draw_param = line_draw_node.LineDrawParams.new()
	
	if arg_seq.mem_action_state == MemoryActionState__Particles.SACRIFICE:
		
		line_draw_param.source_pos = arg_seq.metadata[arg_seq.METADATA_KEY__GLOB_POSITION] 
		line_draw_param.dest_pos = Vector2(line_draw_param.source_pos.x, game_elements.get_top_left_coordinates_of_playable_map().y)
		line_draw_param.total_line_length = line_draw_param.source_pos.distance_to(line_draw_param.dest_pos)
		
		line_draw_param.line_length_per_sec = 1200
		line_draw_param.color = arg_seq._beam_mod
		line_draw_param.width = 8
		
		
		
	elif arg_seq.mem_action_state == MemoryActionState__Particles.RECALL:
		var pos = arg_seq.metadata[arg_seq.METADATA_KEY__GLOB_POSITION] 
		
		line_draw_param.source_pos = Vector2(pos.x, game_elements.get_top_left_coordinates_of_playable_map().y)
		line_draw_param.dest_pos = pos
		line_draw_param.total_line_length = pos.distance_to(line_draw_param.source_pos)
		
		line_draw_param.line_length_per_sec = 1200
		line_draw_param.color = arg_seq._beam_mod
		line_draw_param.width = 8
		
		
	
	line_draw_node.add_line_draw_param(line_draw_param)
	




class CircleConcealSequenceData:
	
	const METADATA_KEY__TOWER : String = "Metadata_Tower"
	const METADATA_KEY__GLOB_POSITION : String = "Metadata_TowerGlobPosition"
	const METADATA_KEY__TOWER_ID_TO_CREATE : String = "Metadata_TowerIdToCreate"
	const METADATA_KEY__BENCH_PLACABLE_TO_PUT_TOWER : String = "Metadata_BenchPlacableToPutTower"
	
	const METADATA_KEY__MEM_TYPE_ID : String = "Metadata_MemTypeId"
	const METADATA_KEY__MEM_PARAM : String = "Metadata_MemParam"
	
	
	#
	
	var rng_to_use : RandomNumberGenerator
	var seq_particle_type : int
	var mem_action_state : int
	
	var center : Vector2
	var center_modi : Vector2
	var source_pos : Vector2
	
	var angle_min
	var angle_max
	var starting_dist_min
	var starting_dist_max
	
	var circle_mod_rgb__range_a : Color
	var circle_mod_rgb__range_b : Color
	
	var beam_mod_rgb__range_a : Color
	var beam_mod_rgb__range_b : Color
	
	var is_make_circle_mod_same_to_beam_mod : bool
	
	var delta_per_circle : float
	
	var circle_count : int
	var delta_for_circle_phase : float
	var delta_for_beam_phase : float
	
	var _delta_left_for_next_circle : float
	var _current_circle_count : int
	var _delta_left_for_circle_phase : float
	
	var _delta_left_for_beam_phase : float
	
	var _circle_mod : Color
	var _beam_mod : Color
	
	
	const CIRCLE_STATE = 1
	const BEAM_STATE = 2
	var _current_state : int
	
	
	var starting_state : int = CIRCLE_STATE
	var ending_state : int = BEAM_STATE
	
	var _is_showing_circle_show : bool
	var _started_beam_show : bool
	
	
	var delay : float
	var _current_delay : float
	
	var func_source : Object
	# funcs accept 1 arg, in which "self" is passed
	var func_to_call_for_create_circle : String  # used by this.
	var func_to_call_on_circle_phase_end : String  # used by this
	var func_to_call_on_beam_phase_end : String  # "extendable"
	var func_to_call_for_end : String # used by this
	var func_to_call_for_line_draw_node_exec : String # used by this
	
	var metadata : Dictionary = {}
	
	#########
	
	func _get_rand_range_of_modulates(arg_mod_x : Color, arg_mod_y : Color, 
				arg_rng : RandomNumberGenerator):
		
		var r
		var g
		var b
		
		r = arg_rng.randf_range(arg_mod_x.r, arg_mod_y.r)
		g = arg_rng.randf_range(arg_mod_x.g, arg_mod_y.g)
		b = arg_rng.randf_range(arg_mod_x.b, arg_mod_y.b)
		
		return Color(r, g, b)
	
	
	##
	
	func generate_random_starting_angle_and_center_dist_modi_from_center(arg_source_pos : Vector2, arg_source_pos_magnitude_rand_range : Vector2, arg_rng : RandomNumberGenerator = rng_to_use) -> Array:
		var rand_vector2 = Vector2(_generate_random_num_with_mag__from_neg_to_positive(arg_source_pos_magnitude_rand_range.x, arg_rng), _generate_random_num_with_mag__from_neg_to_positive(arg_source_pos_magnitude_rand_range.y, arg_rng))
		
		
		var angle = center.angle_to_point(rand_vector2)
		
		return [angle, rand_vector2]
	
	
	func _generate_random_num_with_mag__from_neg_to_positive(arg_num, arg_rng : RandomNumberGenerator):
		return arg_rng.randi_range(-arg_num, arg_num)
	
	
	#
	func configure_data(arg_rng : RandomNumberGenerator = rng_to_use):
		_delta_left_for_next_circle = 0
		_current_circle_count = circle_count
		_delta_left_for_circle_phase = delta_for_circle_phase
		_delta_left_for_beam_phase = delta_for_beam_phase
		
		_set_beam_mod_rgb__randomized(rng_to_use)
		
		reset()
		
		if starting_state == CIRCLE_STATE:
			_switch_to_circle_state()
		elif starting_state == BEAM_STATE:
			_switch_to_beam_state()
	
	func configure_circle_particle_based_on_self(arg_particle):
		_set_circle_mod_rgb__randomized(rng_to_use)
		
		arg_particle.modulate = _circle_mod
		
		
	
	
	
	func delta(arg_delta):
		if _current_delay > 0:
			_current_delay -= arg_delta
			return
		
		########
		
		if _is_showing_circle_show:
			if _current_circle_count > 0:
				_delta_left_for_next_circle -= arg_delta
				if _delta_left_for_next_circle <= 0:
					_delta_left_for_next_circle += delta_per_circle
					_current_circle_count -= 1
					if func_source != null:
						
						func_source.call(func_to_call_for_create_circle, self)
			
		#########
		
		if _current_state == CIRCLE_STATE:
			_delta_left_for_circle_phase -= arg_delta
			if _delta_left_for_circle_phase <= 0:
				_switch_to_beam_state()
				if func_source != null:
					if func_source.has_method(func_to_call_on_circle_phase_end):
						func_source.call(func_to_call_on_circle_phase_end, self)
					
					if ending_state == CIRCLE_STATE:
						func_source.call(func_to_call_for_end, self)
			
			
			#
			
		elif _current_state == BEAM_STATE:
			_delta_left_for_beam_phase -= arg_delta
			if _delta_left_for_beam_phase <= 0:
				_switch_to_circle_state()
				if func_source != null:
					if func_source.has_method(func_to_call_on_beam_phase_end):
						func_source.call(func_to_call_on_beam_phase_end, self)
					
					if ending_state == BEAM_STATE:
						func_source.call(func_to_call_for_end, self)
			
			if !_started_beam_show:
				_started_beam_show = true
				
				if func_source != null:
					func_source.call(func_to_call_for_line_draw_node_exec, self)
		
	
	
	func _switch_to_beam_state():
		_current_state = BEAM_STATE
		
	
	func _switch_to_circle_state():
		_current_state = CIRCLE_STATE
		_is_showing_circle_show = true
	
	
	func reset():
		_is_showing_circle_show = false
		_started_beam_show = false
		
		_current_delay = delay
		
	
	
	#######
	
	func _set_circle_mod_rgb__randomized(arg_rng):
		_circle_mod = _get_rand_range_of_modulates(circle_mod_rgb__range_a, circle_mod_rgb__range_b, arg_rng)
		
	
	func _set_beam_mod_rgb__randomized(arg_rng):
		if is_make_circle_mod_same_to_beam_mod:
			_beam_mod = _circle_mod
		else:
			_beam_mod = _get_rand_range_of_modulates(beam_mod_rgb__range_a, beam_mod_rgb__range_b, arg_rng)
	
	



########################
# RECALL
########################

func _initialize_memory_recall_gui():
	_memory_recall_gui = MemoryRecallGUI_Scene.instance()
	
	_memory_recall_gui.initialize_gui(game_elements)
	
	game_elements.whole_screen_gui.add_control_but_dont_show(_memory_recall_gui)
	


func _on_sacrifice_animations_ended():
	_attempt_show_memory_recall_gui__or_end_if_not_appropriate()

func _attempt_show_memory_recall_gui__or_end_if_not_appropriate():
	if _current_mem_action_state == MemoryActionStates.SACRIFICING:  # needed, as sometimes Recalling with Health causes to repeat itself
		_memory_sacrifice_gui.hide_gui()
		
		if _is_current_round_has_past_recall_memory():
			_show_memory_recall_gui()
		else:
			set_current_mem_action_state__to_none()


func _is_current_round_has_past_recall_memory():
	if _past__stageround_id_to_recall_memories_map.has(_current_stageround_id):
		var recall_mem : RecallMemory = _past__stageround_id_to_recall_memories_map[_current_stageround_id]
		if recall_mem != null:
			if recall_mem.memory_type_id != MemoryTypeId.EMPTY and recall_mem.memory_type_id != MemoryTypeId.NONE:
				return true
			else:
				return false
			
		else:
			return false
		
	else:
		return false

func _show_memory_recall_gui():
	set_current_mem_action_state(MemoryActionStates.RECALLING)
	
	
	# placed here to prevent loss of memory on crash/exit during recall phase
	var preserved = _preserve_past_recall_memory_into_future()
	if preserved:
		_erase_future_recall_memory_in_curr_stage_round_id_after_recall_accept = true
	else:
		_erase_future_recall_memory_in_curr_stage_round_id_after_recall_accept = false
	
	#
	var past_recall_memory : RecallMemory = _past__stageround_id_to_recall_memories_map[_current_stageround_id]
	
	var params = _generate_mem_recall_gui_constructor_param(past_recall_memory.memory_type_id, past_recall_memory.param)
	
	_memory_recall_gui.set_prop_based_on_constructor(params)
	_memory_recall_gui.show_gui()

func _preserve_past_recall_memory_into_future():
	if !_future__stageround_id_to_recall_memories_map.has(_current_stageround_id) and _past__stageround_id_to_recall_memories_map.has(_current_stageround_id):
		#_future__stageround_id_to_recall_memories_map[_current_stageround_id] = _past__stageround_id_to_recall_memories_map[_current_stageround_id]
		_set_recall_memory_to_future_memories_map(_past__stageround_id_to_recall_memories_map[_current_stageround_id])
		
		return true
	
	
	return false



######

func _generate_recall_description_for_mem_type_with_params__gold(arg_params):
	var plain_fragment__x_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % [arg_params])
	
	return [
		["Gain |0|.", [plain_fragment__x_gold]]
	]

func _generate_recall_description_for_mem_type_with_params__health(arg_params):
	var plain_fragment__x_health = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "%s health" % [arg_params])
	
	return [
		["Gain |0|.", [plain_fragment__x_health]]
	]

func _generate_recall_description_for_mem_type_with_params__relic_and_gold(arg_params):
	var gold_amount = arg_params[1]
	
	var plain_fragment__x_relic = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.RELIC, "%s relic(s)" % [arg_params[0]])
	
	if gold_amount != 0:
		var plain_fragment__x_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % [gold_amount])
		
		return [
			["Gain |0| and |1|.", [plain_fragment__x_relic, plain_fragment__x_gold]]
		]
		
	else:
		return [
			["Gain |0|.", [plain_fragment__x_relic]]
		]


func _generate_recall_description_for_mem_type_with_params__towers(arg_params):
	var plain_fragment__x_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s tower(s)" % [arg_params.size()])
	
	return [
		["Gain |0|.", [plain_fragment__x_towers]]
	]

func _generate_recall_description_for_mem_type_with_params__towers_with_ings(arg_params):
	# not correct. no params for ings, since this aint supported
	var plain_fragment__x_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s tower(s)" % [arg_params.size()])
	var plain_fragment__x_ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "%s ingredient(s)" % [arg_params[1]])
	
	return [
		["Gain |0|. Including their |1|.", [plain_fragment__x_towers, plain_fragment__x_ingredients]]
	]

func _generate_recall_description_for_mem_type_with_params__none(arg_params):
	return [
		["Gain nothing", []]
	]

func _generate_recall_description_for_mem_type_with_params__empty(arg_params):
	return [
		["None sacrificed yet for this round.", []],
		["Sacrificing nothing this round preserves the previous sacrifice (if sacrifice is declined).", []]
	]



func _generate_mem_recall_details_panel_constructor_param(arg_type, arg_params):
	var constructor_param  = MemoryTypeRecallDetailsPanel.ConstructorParams.new()
	
	
	var descs
	var header_text
	var warning_header_text = MemoryTypeRecallDetailsPanel.ConstructorParams.WARNING_HEADER_TEXT__NOTE
	
	var warning_desc_func_name
	var warning_desc_func_params = [arg_type, arg_params]
	
	var warning_update_signal_name : String = ""
	
	var tower_ids = []
	
	
	if arg_type == MemoryTypeId.GOLD:
		descs = _generate_recall_description_for_mem_type_with_params__gold(arg_params)
		header_text = "Gold"
		
	elif arg_type == MemoryTypeId.HEALTH:
		descs = _generate_recall_description_for_mem_type_with_params__health(arg_params)
		header_text = "Health"
		
	elif arg_type == MemoryTypeId.RELIC_AND_GOLD:
		descs = _generate_sac_description_for_mem_type_with_params__relic_and_gold(arg_params)
		header_text = "Relic and Gold"
		
	elif arg_type == MemoryTypeId.TOWERS:
		descs = _generate_recall_description_for_mem_type_with_params__towers(arg_params)
		header_text = "Towers"
		
		warning_update_signal_name = "warning_update__available_tower_slot_at_bench_changed"
		warning_desc_func_name = "_generate_recall_desc__warning__not_enough_available_tower_slots"
		
		tower_ids = arg_params
		
	elif arg_type == MemoryTypeId.TOWERS_WITH_INGS:
		descs = _generate_recall_description_for_mem_type_with_params__towers_with_ings(arg_params)
		header_text = "Towers With Ingredients"
		
		warning_update_signal_name = "warning_update__available_tower_slot_at_bench_changed"
		warning_desc_func_name = "_generate_recall_desc__warning__not_enough_available_tower_slots"
		
		tower_ids = arg_params
		
		
	elif arg_type == MemoryTypeId.NONE:
		descs = _generate_recall_description_for_mem_type_with_params__none(arg_params)
		header_text = "No Sacrifice"
		
		
	elif arg_type == MemoryTypeId.EMPTY:
		descs = _generate_recall_description_for_mem_type_with_params__empty(arg_params)
		header_text = ""
		
	
	#
	
	constructor_param.descriptions = descs
	
	constructor_param.header_text = header_text
	constructor_param.warning_header_text = warning_header_text 
	
	constructor_param.warning_desc_func_source = self
	constructor_param.warning_desc_func_param = warning_desc_func_params
	constructor_param.warning_desc_func_name = warning_desc_func_name
	
	constructor_param.set_tower_type_infos_to_show__with_tower_ids(tower_ids)
	
	if warning_update_signal_name.length() != 0:
		constructor_param.warning_update_signal_source = self
		constructor_param.warning_update_signal_name = warning_update_signal_name
	
	
	return constructor_param



func _connect_to_relateds__for_recall__warning_update__all():
	_connect__for_recall__warning_update__tower_available_slot()


func _connect__for_recall__warning_update__tower_available_slot():
	game_elements.tower_inventory_bench.connect("bench_occupancy_changed", self, "_on_tower_inventory_bench_occupancy_changed", [], CONNECT_PERSIST)
	

func _on_tower_inventory_bench_occupancy_changed(arg_towers, arg_is_full):
	emit_signal("warning_update__available_tower_slot_at_bench_changed")
	

#

func _generate_recall_desc__warning__not_enough_available_tower_slots(arg_params):
	var tower_ids = arg_params[1]
	var free_space = game_elements.tower_inventory_bench.get_empty_slot_count()
	
	if tower_ids.size() > free_space:
		var plain_fragment__x_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s tower(s)" % [tower_ids.size()])
		
		return [
			["There is not enough bench space for |0|.", [plain_fragment__x_towers]],
			["The other towers will be received when bench slots are freed.", []]
		]
		
	else:
		return []
	

#####

func _generate_mem_recall_type_panel_constructor_param(arg_type, arg_params):
	var constructor_param = MemoryTypeRecallPanel.ConstructorParams.new()
	
	var image_normal
	var image_hovered
	
	if arg_type == MemoryTypeId.GOLD:
		image_normal = MemoryType_Gold_Normal
		image_hovered = MemoryType_Gold_Highlighted
		
	elif arg_type == MemoryTypeId.HEALTH:
		image_normal = MemoryType_Health_Normal
		image_hovered = MemoryType_Health_Highlighted 
		
	elif arg_type == MemoryTypeId.RELIC_AND_GOLD:
		image_normal = MemoryType_Relic_Normal
		image_hovered = MemoryType_Relic_Highlighted
		
	elif arg_type == MemoryTypeId.TOWERS:
		image_normal = MemoryType_Towers_Normal
		image_hovered = MemoryType_Towers_Highlighted
		
	elif arg_type == MemoryTypeId.TOWERS_WITH_INGS:
		image_normal = MemoryType_TowersWithIngs_Normal
		image_hovered = MemoryType_TowersWithIngs_Highlighted
		
	elif arg_type == MemoryTypeId.NONE:
		image_normal = MemoryType_None_Normal
		image_hovered = MemoryType_None_Highlighted
		
	elif arg_type == MemoryTypeId.EMPTY:
		image_normal = MemoryType_Empty_Normal
		image_hovered = MemoryType_Empty_Normal
	
	var constr_param__mem_rec_details_panel = _generate_mem_recall_details_panel_constructor_param(arg_type, arg_params)
	
	#
	
	constructor_param.memory_icon_normal = image_normal
	constructor_param.memory_icon_hovered = image_hovered
	constructor_param.recall_details_constr_params = constr_param__mem_rec_details_panel
	
	return constructor_param




func _generate_mem_recall_gui_constructor_param(arg_type, arg_params):
	var constructor_param = MemoryRecallGUI.ConstructorParams.new()
	
	var is_sac_made_prev_in_curr_round = _is_sacrifice_made_in_curr_round()
	
	var on_accept_func_name
	var on_accept_func_param
	
	var on_decline_func_name
	var on_decline_func_param
	
	if arg_type == MemoryTypeId.GOLD:
		on_accept_func_name = "_on_mem_recall_accept__gold"
		
	elif arg_type == MemoryTypeId.HEALTH:
		on_accept_func_name = "_on_mem_recall_accept__health"
		
	elif arg_type == MemoryTypeId.RELIC_AND_GOLD:
		on_accept_func_name = "_on_mem_recall_accept__relic_and_gold"
		
	elif arg_type == MemoryTypeId.TOWERS:
		on_accept_func_name = "_on_mem_recall_accept__towers"
		
	elif arg_type == MemoryTypeId.TOWERS_WITH_INGS:
		on_accept_func_name = "_on_mem_recall_accept__towers_with_ings"
		
	
	on_accept_func_param = arg_params
	on_decline_func_name = "_on_mem_recall_decline"
	on_decline_func_param = [arg_type, arg_params]
	
	####
	
	constructor_param.memory_type_recall_panel_constr_params = _generate_mem_recall_type_panel_constructor_param(arg_type, arg_params)
	constructor_param.is_sac_made_prev_in_curr_round = is_sac_made_prev_in_curr_round
	
	constructor_param.on_accept_func_source = self
	constructor_param.on_accept_func_name = on_accept_func_name
	constructor_param.on_accept_func_params = on_accept_func_param
	
	constructor_param.on_decline_func_source = self
	constructor_param.on_decline_func_name = on_decline_func_name
	constructor_param.on_decline_func_params = on_decline_func_param
	
	return constructor_param

func _is_sacrifice_made_in_curr_round():
	return _current_sacrifice_id_and_param != null and _current_sacrifice_id_and_param.size() != 0 and _current_sacrifice_id_and_param[0] != MemoryTypeId.NONE


func _on_mem_recall_accept__gold(arg_params):
	_wrap_up_mem_recall()
	
	#
	var gold_panel_pos = _get_center_of_control(game_elements.general_stats_panel.gold_panel) #game_elements.general_stats_panel.gold_panel.rect_global_position
	var seq_data = create_circle_conceal_seq_data(CircleParticleType.HUD, MemoryActionState__Particles.RECALL, gold_panel_pos, gold_panel_pos)
	seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = gold_panel_pos
	seq_data.metadata[seq_data.METADATA_KEY__MEM_TYPE_ID] = MemoryTypeId.GOLD
	seq_data.metadata[seq_data.METADATA_KEY__MEM_PARAM] = arg_params
	
	start_circle_conceal_particle_fx_sequence(seq_data)
	
	erase_future_recall_memory_in_curr_stage_round_id__if_applicable()

func _on_mem_recall_accept__health(arg_params):
	_wrap_up_mem_recall()
	
	#
	var panel_pos = game_elements.right_side_panel.round_status_panel.get_heart_icon_global_pos()
	var seq_data = create_circle_conceal_seq_data(CircleParticleType.HUD, MemoryActionState__Particles.RECALL, panel_pos, panel_pos)
	seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = panel_pos
	seq_data.metadata[seq_data.METADATA_KEY__MEM_TYPE_ID] = MemoryTypeId.HEALTH
	seq_data.metadata[seq_data.METADATA_KEY__MEM_PARAM] = arg_params
	start_circle_conceal_particle_fx_sequence(seq_data)
	
	erase_future_recall_memory_in_curr_stage_round_id__if_applicable()

func _on_mem_recall_accept__relic_and_gold(arg_params):
	_wrap_up_mem_recall()
	
	#
	if arg_params[1] != 0:
		var gold_panel_pos = _get_center_of_control(game_elements.general_stats_panel.gold_panel) #game_elements.general_stats_panel.gold_panel.rect_global_position
		var seq_data = create_circle_conceal_seq_data(CircleParticleType.HUD, MemoryActionState__Particles.RECALL, gold_panel_pos, gold_panel_pos)
		seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = gold_panel_pos
		#seq_data.metadata[seq_data.METADATA_KEY__MEM_TYPE_ID] = MemoryTypeId.RELIC_AND_GOLD
		#seq_data.metadata[seq_data.METADATA_KEY__MEM_PARAM] = [0, 0]
		start_circle_conceal_particle_fx_sequence(seq_data)
	
	var relic_panel_pos = _get_center_of_control(game_elements.general_stats_panel.relic_panel) #game_elements.general_stats_panel.relic_panel.rect_global_position
	var seq_data = create_circle_conceal_seq_data(CircleParticleType.HUD, MemoryActionState__Particles.RECALL, relic_panel_pos, relic_panel_pos)
	seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = relic_panel_pos
	seq_data.metadata[seq_data.METADATA_KEY__MEM_TYPE_ID] = MemoryTypeId.RELIC_AND_GOLD
	seq_data.metadata[seq_data.METADATA_KEY__MEM_PARAM] = arg_params
	start_circle_conceal_particle_fx_sequence(seq_data)
	
	erase_future_recall_memory_in_curr_stage_round_id__if_applicable()

func _on_mem_recall_accept__towers(arg_params):
	_wrap_up_mem_recall()
	
	#
	_start_give_towers_via_recall(arg_params)
	
	erase_future_recall_memory_in_curr_stage_round_id__if_applicable()

func _on_mem_recall_accept__towers_with_ings(arg_params):
	_wrap_up_mem_recall()
	
	print("Towers with ings not supported -- Recall")
	
	erase_future_recall_memory_in_curr_stage_round_id__if_applicable()

func _on_mem_recall_decline(arg_type_and_params):
	_preserve_past_recall_memory_into_future()
	
	_wrap_up_mem_recall()
	

func _wrap_up_mem_recall():
	_memory_recall_gui.hide_gui()
	
	set_current_mem_action_state__to_none()



func erase_future_recall_memory_in_curr_stage_round_id__if_applicable():
	if _erase_future_recall_memory_in_curr_stage_round_id_after_recall_accept:
		if CAN_ERASE_MEMORY_ON_ACCEPT:
			_future__stageround_id_to_recall_memories_map.erase(_current_stageround_id)
			
			_set_recall_memory_to_future_memories_map(_construct_recall_memory__nothing(_current_stageround_id))

func _construct_recall_memory__nothing(arg_stageround_id):
	return _construct_recall_memory(arg_stageround_id, MemoryTypeId.NONE, null)


#

func _start_give_towers_via_recall(arg_tower_ids):
	if arg_tower_ids.size() != 0:
		has_tower_ids_queued_for_recall = true
		pause_tower_ids_queue_for_recall = false
		tower_ids_queued_for_recall.append_array(arg_tower_ids)
		
		enable_process_conditional_clauses.attempt_insert_clause(EnableProcessClauseIds.TOWER_QUEUED_FOR_RECALL)

func _attempt_summon_tower_id_from_recall(arg_tower_id) -> bool:
	if !game_elements.tower_inventory_bench.is_bench_full():
		_summon_tower_id_from_recall(arg_tower_id)
		delay_for_next_tower_id_recall += DELAY_PER_NEXT_TOWER_ID_RECALL
		
		return true
		
		
	else:
		_listen_for_freed_bench_slot__for_tower_recall(arg_tower_id)
		
		return false

func _listen_for_freed_bench_slot__for_tower_recall(arg_tower_id):
	pause_tower_ids_queue_for_recall = true
	
	if !game_elements.tower_inventory_bench.is_connected("bench_occupancy_changed", self, "_on_bench_occupancy_changed__for_tower_recall_queue"):
		game_elements.tower_inventory_bench.connect("bench_occupancy_changed", self, "_on_bench_occupancy_changed__for_tower_recall_queue", [arg_tower_id], CONNECT_PERSIST)

func _on_bench_occupancy_changed__for_tower_recall_queue(arg_towers, arg_is_full, arg_tower_id):
	if !arg_is_full:
		_stop_listen_for_freed_bench_slot__for_tower_recall()
		
		_summon_tower_id_from_recall(arg_tower_id)
		
		delay_for_next_tower_id_recall = DELAY_PER_NEXT_TOWER_ID_RECALL
		pause_tower_ids_queue_for_recall = false


func _stop_listen_for_freed_bench_slot__for_tower_recall():
	if game_elements.tower_inventory_bench.is_connected("bench_occupancy_changed", self, "_on_bench_occupancy_changed__for_tower_recall_queue"):
		game_elements.tower_inventory_bench.disconnect("bench_occupancy_changed", self, "_on_bench_occupancy_changed__for_tower_recall_queue")


#

func _summon_tower_id_from_recall(arg_tower_id):
	#tower_ids_queued_for_recall.erase(arg_tower_id)
	if tower_ids_queued_for_recall.size() == 0:
		has_tower_ids_queued_for_recall = false
	
	####
	
	var placable = game_elements.tower_inventory_bench.find_empty_slot_from_last__for_outside()
	
	var seq_data = create_circle_conceal_seq_data(CircleParticleType.TOWER, MemoryActionState__Particles.RECALL, placable.global_position, placable.global_position)
	
	placable.occupancy_reserved_clauses.attempt_insert_clause(placable.OccupancyReservedClauseIds.MAP_MEMORIES__IN_RECALL_BEAM_IN_FLIGHT)
	
	seq_data.metadata[seq_data.METADATA_KEY__TOWER_ID_TO_CREATE] = arg_tower_id
	seq_data.metadata[seq_data.METADATA_KEY__BENCH_PLACABLE_TO_PUT_TOWER] = placable
	seq_data.metadata[seq_data.METADATA_KEY__GLOB_POSITION] = placable.global_position
	seq_data.metadata[seq_data.METADATA_KEY__MEM_TYPE_ID] = MemoryTypeId.TOWERS
	#seq_data.metadata[seq_data.METADATA_KEY__MEM_PARAM] = arg_params
	
	start_circle_conceal_particle_fx_sequence(seq_data)
	


####

func _initialize_memory_summary_gui():
	_memory_summary_gui = MemorySummaryGUI_Scene.instance()
	
	_memory_summary_gui.initialize_gui(game_elements)
	
	game_elements.whole_screen_gui.add_control_but_dont_show(_memory_summary_gui)
	

func _deferred_set_prop_of_memory_summary_gui():
	var constr_params = MemorySummaryGUI.ConstructorParams.new()
	constr_params.all_stageround_ids_with_action = stage_round_trigger_to_round_memory_info_map.keys()
	constr_params.past__stageround_id_to_recall_memories_map = _past__stageround_id_to_recall_memories_map
	constr_params.future__stageround_id_to_recall_memories_map = _future__stageround_id_to_recall_memories_map
	constr_params.func_source_for__empty_recall_type_panel_constr_param = self
	constr_params.func_name_for__empty_recall_type_panel_constr_param = "_convert_null_to_recall_type_panel_constr_param"
	constr_params.func_source_for__convert_recall_memory_into_type_panel_constr_param = self
	constr_params.func_name_for__convert_recall_memory_into_type_panel_constr_param = "_convert_recall_mem_to_recall_type_panel_constr_param"
	
	_memory_summary_gui.set_prop_based_on_constructor(constr_params)
	


func _update_memory_summary_panel__changed_future_recall_mem_map(arg_recall_mem : RecallMemory):
	_memory_summary_gui.set_future_recall_memory__in_stage_round(arg_recall_mem, arg_recall_mem.stage_round_id)
	



func _convert_null_to_recall_type_panel_constr_param(is_past : bool):
	if is_past:
		return _generate_mem_recall_type_panel_constructor_param(MemoryTypeId.NONE, null)
	else:
		return _generate_mem_recall_type_panel_constructor_param(MemoryTypeId.EMPTY, null)

func _convert_recall_mem_to_recall_type_panel_constr_param(arg_recall_mem : RecallMemory) -> MemoryTypeRecallPanel.ConstructorParams:
	return _generate_mem_recall_type_panel_constructor_param(arg_recall_mem.memory_type_id, arg_recall_mem.param)
	


####################### CRATER GLOWS

func _initialize_crater_glows():
#	all_crater_glows.append(crater_glow__bottom)
#	all_crater_glows.append(crater_glow__left)
#	all_crater_glows.append(crater_glow__right)
#	all_crater_glows.append(crater_glow__top)
	
	special_path_id_to_all_crater_glows_map[SpecialPathId.PATH_01] = crater_glow__bottom
	special_path_id_to_all_crater_glows_map[SpecialPathId.PATH_02] = crater_glow__left
	special_path_id_to_all_crater_glows_map[SpecialPathId.PATH_03] = crater_glow__top
	special_path_id_to_all_crater_glows_map[SpecialPathId.PATH_04] = crater_glow__right
	
	for crater in special_path_id_to_all_crater_glows_map.values():
		crater.visible = false


func _update_visibility_of_crater_glows(arg_path_ids_used):
	_all_crater_glows_to_affect_for_tweener.clear()
	
	for path_id in SpecialPathId.values():
		if arg_path_ids_used.has(path_id):
			_all_crater_glows_to_affect_for_tweener.append(special_path_id_to_all_crater_glows_map[path_id])
			
	
	for crater in special_path_id_to_all_crater_glows_map.values():
		if _all_crater_glows_to_affect_for_tweener.has(crater):
			_make_crater_visible__via_tweener(crater)
			
		else:
			_make_crater_invisible__via_tweener(crater)
		
	

func _make_crater_visible__via_tweener(crater):
	crater.visible = true
	
	var tweener = create_tween()
	tweener.tween_property(crater, "modulate:a", 1.0, 0.85)


func _make_crater_invisible__via_tweener(crater):
	var tweener = create_tween()
	tweener.tween_property(crater, "modulate:a", 0.0, 0.85)
	tweener.tween_property(crater, "visible", true, 0)
	




##

func _initialize_special_paths():
	all_special_paths.append(special_enemy_path_01)
	all_special_paths.append(special_enemy_path_02)
	all_special_paths.append(special_enemy_path_03)
	all_special_paths.append(special_enemy_path_04)
	
	
	var curve_of_main = main_enemy_path.get_copy_of_curve(false)
	var points_of_main = curve_of_main.get_baked_points()
	for path in all_special_paths:
		_configure_curve_of_special_path(path, curve_of_main, points_of_main)
		_configure_special_path(path)
	
	for i in all_special_paths.size():
		special_path_id_to_path_map[SpecialPathId.values()[i]] = all_special_paths[i]


func _configure_curve_of_special_path(arg_path : EnemyPath, arg_curve_of_main_path : Curve2D, arg_points_of_main : PoolVector2Array):
	## FIRST STEP:
	# FIND the point closest to the special path's end.
	var global_pos_of_last_point : Vector2 = arg_path.curve.get_point_position(arg_path.curve.get_point_count() - 1) + arg_path.global_position
	
	var pos_relative_to_curve_main = global_pos_of_last_point - main_enemy_path.global_position
	var point_pos_nearest_to_curve_of_main = main_enemy_path.curve.get_closest_point(pos_relative_to_curve_main) + main_enemy_path.global_position
	
	
	## 2nd STEP:
	# Make a point arr starting with the special curve's points + main arr points (starting with point nearest to end of special path)
	var past_the_point_index_nearest_to_curve_of_main : bool = false
	var points_for_special_curve : Array = []
	
	
	for point in arg_path.curve.get_baked_points():
		points_for_special_curve.append(point)
	
	for point in main_enemy_path.curve.get_baked_points():
		if _is_vectors_close_to_equal(point + arg_path.global_position, point_pos_nearest_to_curve_of_main):
			past_the_point_index_nearest_to_curve_of_main = true
		
		if past_the_point_index_nearest_to_curve_of_main:
			points_for_special_curve.append(point)
			
		
	
	
	# if no nearest point found: error:
	if !past_the_point_index_nearest_to_curve_of_main:
		print("MAP - MEMORIES: no nearest point found for creation of special path. ERROR - should never happen")
		return
	
	
	## 3rd STEP:
	# MAKE a new curve, starting with the special path's curve
	arg_path.set_curve_and_id__using_vector_points(points_for_special_curve, EnemyPath.default_curve_id)
	

func _is_vectors_close_to_equal(arg_vec_a : Vector2, arg_vec_b : Vector2):
	return (arg_vec_a - arg_vec_b).length() < 10



func _configure_special_path(arg_path : EnemyPath):
	arg_path.is_used_for_natural_spawning = false
	
	arg_path.is_used_and_active = false


###########


func _on_round_end__map_memories__for_special_round_tracking(_arg_stageround, is_game_start):
	if !is_game_start:
		_rounds_before_next_special_round_id -= 1
	else:
		_configure_last_special_round_in_list()
	
	if _rounds_before_next_special_round_id == 0:
		var path_ids_used = _append_instructions_to_EM_interpreter__based_on_curr_round__and_get_path_ids_used()
		_start_monitor_for_special_enemy_spawn(path_ids_used)
		
		_update_visibility_of_crater_glows(path_ids_used)
		
	elif _rounds_before_next_special_round_id == -1:  # when special round is done
		_end_monitor_for_special_enemy_spawn()
		
		if special_rounds_to_ins_method_map.size() > 0:
			_configure_last_special_round_in_list()
		else:
			# no more special rounds
			game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end__map_enchant__for_special_round_tracking")
			
			_next_special_round_id = ""
			_rounds_before_next_special_round_id = -1
			
		
		_update_visibility_of_crater_glows([])


func _configure_last_special_round_in_list():
	_next_special_round_id = special_rounds_to_ins_method_map.keys()[special_rounds_to_ins_method_map.size() - 1]
	_rounds_before_next_special_round_id = game_elements.stage_round_manager.get_number_of_rounds_before_stageround_id_reached(_next_special_round_id)

func _remove_current_next_special_round_id():
	special_rounds_to_ins_method_map.erase(_next_special_round_id)
	

#func get_next_special_round_id():
#	return _next_special_round_id


#

func _append_instructions_to_EM_interpreter__based_on_curr_round__and_get_path_ids_used():
	var ins : Array = call(special_rounds_to_ins_method_map[_next_special_round_id])
	_remove_current_next_special_round_id()
	
	game_elements.enemy_manager.append_instructions_to_interpreter(ins)
	
	#
	var path_ids_used : Array = _get_path_ids_used_from_ins(ins)
	
	return path_ids_used

func _get_path_ids_used_from_ins(arg_ins):
	var path_ids = []
	for ins in arg_ins:
		if ins.enemy_metadata_map.has(StoreOfEnemyMetadataIdsFromIns.MAP_MEMORIES__SPECIAL_PATH):
			var path_id = ins.enemy_metadata_map[StoreOfEnemyMetadataIdsFromIns.MAP_MEMORIES__SPECIAL_PATH]
			if !path_ids.has(path_id):
				path_ids.append(path_id)
	
	return path_ids


func _start_monitor_for_special_enemy_spawn(arg_path_ids_used : Array):
	_path_ids_used_this_round = arg_path_ids_used
	
	for path_id in _path_ids_used_this_round:
		var path = special_path_id_to_path_map[path_id]
		
		path.is_used_and_active = true
		
		var spawn_loc_flag
		if special_path_to_spawn_loc_flag_map.has(path):
			spawn_loc_flag = special_path_to_spawn_loc_flag_map[path]
		
		if !is_instance_valid(spawn_loc_flag):
			spawn_loc_flag = create_spawn_loc_flag_at_path(path, default_flag_offset_from_path, EnemySpawnLocIndicator_Flag.FlagTextureIds.MAP_MEMORIES, false)
			special_path_to_spawn_loc_flag_map[path] = spawn_loc_flag
		else:
			spawn_loc_flag.visible = true


func _end_monitor_for_special_enemy_spawn():
	#if game_elements.enemy_manager.is_connected("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path"):
	#	game_elements.enemy_manager.disconnect("before_enemy_is_added_to_path", self, "_before_enemy_is_added_to_path")
	
	for path_id in _path_ids_used_this_round:
		var path = special_path_id_to_path_map[path_id]
		
		path.is_used_and_active = false
		
		var spawn_loc_flag = special_path_to_spawn_loc_flag_map[path]
		spawn_loc_flag.visible = false
	
	
	_path_ids_used_this_round.clear()

func _before_enemy_is_added_to_path(enemy, path):
	if enemy.enemy_spawn_metadata_from_ins != null:
		if enemy.enemy_spawn_metadata_from_ins.has(StoreOfEnemyMetadataIdsFromIns.MAP_MEMORIES__SPECIAL_PATH):
			var path_id = enemy.enemy_spawn_metadata_from_ins[StoreOfEnemyMetadataIdsFromIns.MAP_MEMORIES__SPECIAL_PATH]
			
			var special_path = special_path_id_to_path_map[path_id]
			special_path.add_child(enemy)
			
	
	if enemy.enemy_id == EnemyConstants.Enemies.MAP_MEMORIES__DREAM:
		_configure_enemy_dream(enemy)
	elif enemy.enemy_id == EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA:
		_configure_enemy_memoria(enemy)
	elif enemy.enemy_id == EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE:
		_configure_enemy_nightmare(enemy)
	


#######################
# ENEMIES RELATED
########################

######## DREAMER

func _configure_enemy_dream(arg_enemy_dream):
	arg_enemy_dream.configure_dream_release_properties(ENEMY_DREAM__UNIT_OFFSET__DREAM_TRIGGER, ENEMY_DREAM__DELAY_BEFORE_DREAM_TRIGGER, ENEMY_DREAM__HEALTH_PERCENT__DREAM_TRIGGER)
	arg_enemy_dream.connect("dream_released", self, "_on_dream_released__by_enemy_dream")



func _initialize_all_enemy_dream_relateds():
	_dream_marker_attack_sprite_pool_compo = AttackSpritePoolComponent.new()
	_dream_marker_attack_sprite_pool_compo.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	_dream_marker_attack_sprite_pool_compo.node_to_listen_for_queue_free = self
	_dream_marker_attack_sprite_pool_compo.source_for_funcs_for_attk_sprite = self
	_dream_marker_attack_sprite_pool_compo.func_name_for_creating_attack_sprite = "_create_dreamer_mark_particle__for_pool_compo"
	
	
	##############
	
	_dream_heal_aura_aoe_attk_module = AOEAttackModule_Scene.instance()
	_dream_heal_aura_aoe_attk_module.base_damage_scale = 0
	_dream_heal_aura_aoe_attk_module.base_damage = 0
	_dream_heal_aura_aoe_attk_module.base_damage_type = 0
	_dream_heal_aura_aoe_attk_module.base_attack_speed = 0
	_dream_heal_aura_aoe_attk_module.base_attack_wind_up = 0
	_dream_heal_aura_aoe_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	_dream_heal_aura_aoe_attk_module.is_main_attack = false
	_dream_heal_aura_aoe_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	_dream_heal_aura_aoe_attk_module.benefits_from_bonus_explosion_scale = false
	_dream_heal_aura_aoe_attk_module.benefits_from_bonus_base_damage = false
	_dream_heal_aura_aoe_attk_module.benefits_from_bonus_attack_speed = false
	_dream_heal_aura_aoe_attk_module.benefits_from_bonus_on_hit_damage = false
	_dream_heal_aura_aoe_attk_module.benefits_from_bonus_on_hit_effect = false
	_dream_heal_aura_aoe_attk_module.benefits_from_ingredient_effect = false
	
	_dream_heal_aura_aoe_attk_module.sprite_frames_only_play_once = false
	_dream_heal_aura_aoe_attk_module.pierce = -1
	_dream_heal_aura_aoe_attk_module.duration = 1
	#_dream_heal_aura_aoe_attk_module.damage_repeat_count = domain_base_duration * domain_DOT_dmg_apply_rate_per_sec
	_dream_heal_aura_aoe_attk_module.is_decrease_duration = false
	
	_dream_heal_aura_aoe_attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	_dream_heal_aura_aoe_attk_module.base_aoe_scene = BaseAOE_Scene
	_dream_heal_aura_aoe_attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	_dream_heal_aura_aoe_attk_module.kill_all_created_aoe_at_round_end = true
	_dream_heal_aura_aoe_attk_module.pause_decrease_duration_of_aoe_at_round_end = true
	_dream_heal_aura_aoe_attk_module.unpause_decrease_duration_of_aoe_at_round_start = true
	
	_dream_heal_aura_aoe_attk_module.absolute_z_index_of_aoe = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	_dream_heal_aura_aoe_attk_module.can_be_commanded_by_tower = false
	
	
	#add_attack_module(_dream_heal_aura_aoe_attk_module)
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_dream_heal_aura_aoe_attk_module)
	
	####################
	
	enemy_dreamer_heal_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.MAP_MEMORIES__ENEMY_DREAM__HEAL_EFFECT)
	enemy_dreamer_heal_modi.percent_amount = ENEMY_DREAM__HEAL_AURA__HEAL_PERCENT
	enemy_dreamer_heal_modi.percent_based_on = PercentType.MAX
	enemy_dreamer_heal_modi.ignore_flat_limits = false
	enemy_dreamer_heal_modi.flat_minimum = 0
	enemy_dreamer_heal_modi.flat_maximum = ENEMY_DREAM__HEAL_AURA__FLAT_HEAL_MAX
	
	########################
	
	dream_heal_aura_circle_draw_node.z_as_relative = false
	dream_heal_aura_circle_draw_node.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	dream_line_draw_node.z_as_relative = false
	dream_line_draw_node.z_index = ZIndexStore.PARTICLE_EFFECTS
	
	#########################
	
	_dream_marker_initial_delay_timer = Timer.new()
	_dream_marker_initial_delay_timer.one_shot = true
	_dream_marker_initial_delay_timer.connect("timeout", self, "_on_dream_marker_initial_delay_timer_timeout", [], CONNECT_PERSIST)
	add_child(_dream_marker_initial_delay_timer)
	
	_dream_marker_per_mark_delay_timer = Timer.new()
	_dream_marker_per_mark_delay_timer.one_shot = false
	_dream_marker_per_mark_delay_timer.connect("timeout", self, "_on_dream_marker_per_mark_delay_timer_timeout", [], CONNECT_PERSIST)
	add_child(_dream_marker_per_mark_delay_timer)
	

func _create_dreamer_mark_particle__for_pool_compo():
	var particle = AttackSprite_Scene.instance()
	particle.modulate.a = 0.75
	
	particle.lifetime = 1
	particle.has_lifetime = false
	
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	particle.texture_to_use = preload("res://EnemyRelated/EnemyTypes/Type_Others/Map_Memories_Relateds/MapMemories_Dream/Dream_Marker.png")
	
	return particle


func _place_active_dreamer_marker_at_pos(arg_pos):
	var dreamer_marker = _dream_marker_attack_sprite_pool_compo.get_or_create_attack_sprite_from_pool()
	
	_all_active_dream_heal_markers.append(dreamer_marker)
	
	dreamer_marker.global_position = arg_pos

#####

func _on_round_start__for_consume_dream_markers():
	if _all_active_dream_heal_markers.size() > 0:
		_dream_marker_initial_delay_timer.start(ENEMY_DREAM__MARK_CONSUME_INITIAL_DELAY)
		
	



func _on_dream_marker_initial_delay_timer_timeout():
	_consume_active_dreamer_marker__and_summon_heal_aoe()
	
	if _all_active_dream_heal_markers.size() > 0:
		_dream_marker_per_mark_delay_timer.start(ENEMY_DREAM__MARK_CONSUME_DELAY_PER_MARK)

func _on_dream_marker_per_mark_delay_timer_timeout():
	_consume_active_dreamer_marker__and_summon_heal_aoe()
	
	if _all_active_dream_heal_markers.size() == 0:
		_dream_marker_per_mark_delay_timer.stop()



func _consume_active_dreamer_marker__and_summon_heal_aoe(arg_marker : AttackSprite = _all_active_dream_heal_markers[_all_active_dream_heal_markers.size() - 1]):
	var pos = arg_marker.global_position
	
	_all_active_dream_heal_markers.erase(arg_marker)
	
	arg_marker.turn_invisible_from_simulated_lifetime_end()
	
	_summon_heal_aoe_at_pos(pos)


func _summon_heal_aoe_at_pos(arg_pos : Vector2):
	var aoe : BaseAOE = _dream_heal_aura_aoe_attk_module.construct_aoe(arg_pos, arg_pos)
	
	aoe.collision_duration = ENEMY_DREAM__HEAL_AURA__DELTA_PER_TRIGGER
	aoe.connect("before_enemy_hit_aoe", self, "_on_before_enemy_hit_aoe__dream_heal")
	
	
	var shape = CircleShape2D.new()
	shape.radius = 1
	aoe.aoe_shape_to_set_on_ready = shape
	
	var final_radius = ENEMY_DREAM__HEAL_AURA__RADIUS
	aoe.coll_shape_circle_inc_per_sec = final_radius / ENEMY_DREAM__HEAL_AURA__DELTA_TO_REACH_MAX_RADIUS
	aoe.coll_shape_circle_max_val = final_radius
	
	_dream_heal_aura_aoe_attk_module.set_up_aoe__add_child_and_emit_signals(aoe)
	
	###
	
	var draw_params = dream_heal_aura_circle_draw_node.DrawParams.new()
	draw_params.center_pos = arg_pos
	draw_params.current_radius = shape.radius
	draw_params.max_radius = final_radius
	draw_params.radius_per_sec = aoe.coll_shape_circle_inc_per_sec
	draw_params.fill_color = ENEMY_DREAM_HEAL_AURA__FILL_COLOR
	
	draw_params.outline_color = ENEMY_DREAM_HEAL_AURA__EDGE_COLOR
	draw_params.outline_width = 2
	
	draw_params.lifetime_of_draw = 0.5
	draw_params.lifetime_to_start_transparency = 0.1
	
	draw_params.configure_self_to_pause_and_unpause_based_on_stage_status(game_elements)
	
	dream_heal_aura_circle_draw_node.add_draw_param(draw_params)
	


func _on_before_enemy_hit_aoe__dream_heal(arg_enemy):
	arg_enemy.percent_heal_without_overhealing(enemy_dreamer_heal_modi)


func _on_dream_released__by_enemy_dream(arg_pos, arg_inner_circle_pos):
	_place_active_dreamer_marker_at_pos(arg_pos)
	
	#
	
	var line_draw_param = dream_line_draw_node.LineDrawParams.new()
	
	line_draw_param.source_pos = arg_inner_circle_pos
	line_draw_param.dest_pos = Vector2(line_draw_param.source_pos.x, game_elements.get_top_left_coordinates_of_playable_map().y)
	line_draw_param.total_line_length = line_draw_param.source_pos.distance_to(line_draw_param.dest_pos)
	
	line_draw_param.line_length_per_sec = 1200
	line_draw_param.color = ENEMY_DREAM__DREAM_BEAM_COLOR
	line_draw_param.width = 4
	
	dream_line_draw_node.add_line_draw_param(line_draw_param)
	

# MEMORIA

func _configure_enemy_memoria(arg_enemy):
	arg_enemy.configure_memoria_properties(ENEMY_MEMORIA__DMG_INSTANCE_COUNT_BEFORE_INVIS, ENEMY_MEMORIA__INVIS_DURATION)
	


# NIGHTMARE

func _initialize_all_enemy_nightmare_relateds():
	_nightmare_marker_attack_sprite_pool_compo = AttackSpritePoolComponent.new()
	_nightmare_marker_attack_sprite_pool_compo.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	_nightmare_marker_attack_sprite_pool_compo.node_to_listen_for_queue_free = self
	_nightmare_marker_attack_sprite_pool_compo.source_for_funcs_for_attk_sprite = self
	_nightmare_marker_attack_sprite_pool_compo.func_name_for_creating_attack_sprite = "_create_nightmare_mark_particle__for_pool_compo"
	
	##
	
	_nightmare_marker_initial_delay_timer = Timer.new()
	_nightmare_marker_initial_delay_timer.one_shot = true
	_nightmare_marker_initial_delay_timer.connect("timeout", self, "_on_nightmare_marker_initial_delay_timer_timeout", [], CONNECT_PERSIST)
	add_child(_nightmare_marker_initial_delay_timer)
	
	_nightmare_marker_per_mark_delay_timer = Timer.new()
	_nightmare_marker_per_mark_delay_timer.one_shot = false
	_nightmare_marker_per_mark_delay_timer.connect("timeout", self, "_on_nightmare_marker_per_mark_delay_timer_timeout", [], CONNECT_PERSIST)
	add_child(_nightmare_marker_per_mark_delay_timer)
	
	##
	
	_nightmare_smoke_attack_sprite_pool_compo = AttackSpritePoolComponent.new()
	_nightmare_smoke_attack_sprite_pool_compo.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	_nightmare_smoke_attack_sprite_pool_compo.node_to_listen_for_queue_free = self
	_nightmare_smoke_attack_sprite_pool_compo.source_for_funcs_for_attk_sprite = self
	_nightmare_smoke_attack_sprite_pool_compo.func_name_for_creating_attack_sprite = "_create_nightmare_smoke_particle__for_pool_compo"
	

func _create_nightmare_mark_particle__for_pool_compo():
	var particle = AttackSprite_Scene.instance()
	particle.modulate.a = 0.85
	
	particle.lifetime = 1
	particle.has_lifetime = false
	
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	particle.texture_to_use = preload("res://EnemyRelated/EnemyTypes/Type_Others/Map_Memories_Relateds/MapMemories_Nightmare/Nightmare_Marker.png")
	
	return particle

func _create_nightmare_smoke_particle__for_pool_compo():
	var particle = CenterBasedAttackSprite_Scene.instance()
	particle.modulate.a = 1
	
	#particle.lifetime = 1
	particle.has_lifetime = true
	
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	particle.texture_to_use = preload("res://EnemyRelated/EnemyTypes/Type_Others/Map_Memories_Relateds/MapMemories_Nightmare/Particles/Nightmare_Smoke_6x6.png")
	
	return particle

func _generate_single_nightmare_smoke_particle__static(arg_pos,
		arg_min_starting_distance, arg_max_starting_distance):
	var particle : CenterBasedAttackSprite = _nightmare_smoke_attack_sprite_pool_compo.get_or_create_attack_sprite_from_pool()
	
	particle.center_pos_of_basis = arg_pos
	
	particle.initial_speed_towards_center = 0 #non_essential_rng.randi_range(circle_conceal_initial_speed_to_center_min__sac, circle_conceal_initial_speed_to_center_max__sac)
	particle.speed_accel_towards_center = 0 #non_essential_rng.randi_range(circle_conceal_speed_accel_to_center_min__sac, circle_conceal_speed_accel_to_center_max__sac)
	
	particle.min_starting_distance_from_center = arg_min_starting_distance #arg_data.starting_dist_min
	particle.max_starting_distance_from_center = arg_max_starting_distance #arg_data.starting_dist_max
	
	particle.min_speed_towards_center = -999999
	particle.max_speed_towards_center = 9999999
	
	
	particle.min_starting_angle = 0
	particle.max_starting_angle = 359
	
	particle.lifetime = non_essential_rng.randf_range(0.8, 1.5)
	particle.lifetime_to_start_transparency = particle.lifetime - 0.5
	
	particle.reset_for_another_use()
	
	
	
	particle.modulate.a = non_essential_rng.randf_range(0.8, 1)
	
	var finishing_mod_a_limit = 0
	particle.transparency_per_sec = -(finishing_mod_a_limit - particle.modulate.a) / (particle.lifetime - particle.lifetime_to_start_transparency)
	
	particle.visible = true



func _generate_single_nightmare_smoke_particle__moving(arg_pos,
		arg_min_starting_distance, arg_max_starting_distance):
	var particle : CenterBasedAttackSprite = _nightmare_smoke_attack_sprite_pool_compo.get_or_create_attack_sprite_from_pool()
	
	
	#var rand_center_modi_x = non_essential_rng.randf_range(0, 20)
	#var rand_center_modi_y = non_essential_rng.randf_range(0, 20)
	particle.center_pos_of_basis = arg_pos #+ Vector2(rand_center_modi_x, rand_center_modi_y)
	
	particle.initial_speed_towards_center = non_essential_rng.randi_range(10, 40)
	particle.speed_accel_towards_center = 40 - particle.initial_speed_towards_center
	
	particle.min_starting_distance_from_center = arg_min_starting_distance #arg_data.starting_dist_min
	particle.max_starting_distance_from_center = arg_max_starting_distance #arg_data.starting_dist_max
	
	particle.min_speed_towards_center = -999999
	particle.max_speed_towards_center = 9999999
	
	
	particle.min_starting_angle = 0
	particle.max_starting_angle = 359
	
	particle.lifetime = non_essential_rng.randf_range(0.8, 1.5)
	particle.lifetime_to_start_transparency = particle.lifetime - 0.5
	
	particle.reset_for_another_use()
	
	
	
	particle.modulate.a = non_essential_rng.randf_range(0.8, 1)
	
	var finishing_mod_a_limit = 0
	particle.transparency_per_sec = -(finishing_mod_a_limit - particle.modulate.a) / (particle.lifetime - particle.lifetime_to_start_transparency)
	
	particle.visible = true


#

func _configure_enemy_nightmare(arg_enemy):
	arg_enemy.configure_nightmare_properties(ENEMY_NIGHTMARE__OFFSET_TO_TRIGGER_BACK_TO_START)
	
	arg_enemy.connect("reached_near_end_or_at_end", self, "_on_reached_near_end_or_at_end__enemy_nightmare")
	#arg_enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_killed_by_damage_with_no_more_revives__enemy_nightmare", [], CONNECT_ONESHOT)
	arg_enemy.connect("tree_exiting", self, "_on_queue_free__enemy_nightmare", [arg_enemy])
	arg_enemy.connect("reached_end_of_path__from_surrender", self, "_on_nightmare_reached_end_of_path__from_surrender", [])

#func _on_killed_by_damage_with_no_more_revives__enemy_nightmare(damage_instance_report, arg_enemy):
#	_place_active_nightmare_marker__using_nightmare(arg_enemy, arg_enemy.global_position, arg_enemy.offset)
#	_create_black_particle_smoke__when_nightmare_dies(arg_enemy.get_position_added_pos_and_offset_modifiers(arg_enemy.global_position))

func _on_queue_free__enemy_nightmare(arg_enemy):
	_place_active_nightmare_marker__using_nightmare(arg_enemy, arg_enemy.global_position, arg_enemy.offset)
	_create_black_particle_smoke__when_nightmare_dies(arg_enemy.get_position_added_pos_and_offset_modifiers(arg_enemy.global_position))
	
	_disconnect_nightmare_marker_spawning_signals(arg_enemy)

func _on_nightmare_reached_end_of_path__from_surrender(arg_enemy):
	var offset = 0
	var pos = arg_enemy.current_path.get_global_pos_of_offset(offset)
	
	
	_place_active_nightmare_marker__using_nightmare(arg_enemy, pos, offset)
	_create_black_particle_smoke__when_nightmare_dies(arg_enemy.get_position_added_pos_and_offset_modifiers(arg_enemy.global_position))
	
	_disconnect_nightmare_marker_spawning_signals(arg_enemy)


func _disconnect_nightmare_marker_spawning_signals(enemy):
	if enemy.is_connected("tree_exiting", self, "_on_queue_free__enemy_nightmare"):
		enemy.disconnect("tree_exiting", self, "_on_queue_free__enemy_nightmare")
	if enemy.is_connected("reached_end_of_path__from_surrender", self, "_on_nightmare_reached_end_of_path__from_surrender"):
		enemy.disconnect("reached_end_of_path__from_surrender", self, "_on_nightmare_reached_end_of_path__from_surrender")


func _place_active_nightmare_marker__using_nightmare(arg_enemy, arg_pos : Vector2, arg_offset : float):
	var nightmare_marker = _nightmare_marker_attack_sprite_pool_compo.get_or_create_attack_sprite_from_pool()
	
	var path_id = arg_enemy.enemy_spawn_metadata_from_ins[StoreOfEnemyMetadataIdsFromIns.MAP_MEMORIES__SPECIAL_PATH]
	_all_active_nightmare_spawn_marker_to_data_map[nightmare_marker] = {
		NIGHTMARE_MARKER_DATA_KEY__PATH_ID : path_id,
		NIGHTMARE_MARKER_DATA_KEY__OFFSET : arg_offset
	}
	
	nightmare_marker.global_position = arg_pos

func _create_black_particle_smoke__when_nightmare_dies(arg_pos):
	for i in 12:
		_generate_single_nightmare_smoke_particle__static(arg_pos, 4, 22)



func _on_round_start__consume_all_nightmare_marks():
	if _all_active_nightmare_spawn_marker_to_data_map.size() > 0:
		_nightmare_marker_initial_delay_timer.start(ENEMY_NIGHTMARE__MARK_CONSUME_INITIAL_DELAY)


func _on_nightmare_marker_initial_delay_timer_timeout():
	_consume_latest_active_nightmare_marker__and_summon_nightmare()
	
	if _all_active_nightmare_spawn_marker_to_data_map.size() > 0:
		_nightmare_marker_per_mark_delay_timer.start(ENEMY_NIGHTMARE__MARK_CONSUME_DELAY_PER_MARK)


func _on_nightmare_marker_per_mark_delay_timer_timeout():
	_consume_latest_active_nightmare_marker__and_summon_nightmare()
	
	if _all_active_nightmare_spawn_marker_to_data_map.size() == 0:
		_nightmare_marker_per_mark_delay_timer.stop()



func _consume_latest_active_nightmare_marker__and_summon_nightmare():
	var marker = _all_active_nightmare_spawn_marker_to_data_map.keys()[_all_active_nightmare_spawn_marker_to_data_map.size() - 1]
	var data_map = _all_active_nightmare_spawn_marker_to_data_map[marker]
	var path_id = data_map[NIGHTMARE_MARKER_DATA_KEY__PATH_ID]
	var offset = data_map[NIGHTMARE_MARKER_DATA_KEY__OFFSET]
	
	_all_active_nightmare_spawn_marker_to_data_map.erase(marker)
	
	marker.turn_invisible_from_simulated_lifetime_end()
	
	_summon_nightmare_at_pos_and_path_id(marker.global_position, path_id, offset)

func _summon_nightmare_at_pos_and_path_id(arg_pos, arg_path_id, arg_offset):
	_create_black_particle_smoke__when_nightmare_summoned_from_marker(arg_pos)
	
	var path = special_path_id_to_path_map[arg_path_id]
	var nightmare_enemy = game_elements.enemy_manager.spawn_enemy(EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, path, false, _retrieve_spawn_metadata_for_path(arg_path_id))
	nightmare_enemy.set_offset__and_configure_other_properties(arg_offset)

func _create_black_particle_smoke__when_nightmare_summoned_from_marker(arg_pos):
	for i in 12:
		_generate_single_nightmare_smoke_particle__moving(arg_pos, 4, 22)

#

func _on_reached_near_end_or_at_end__enemy_nightmare(arg_enemy):
	#arg_enemy.set_offset__and_configure_other_properties(0)
	arg_enemy.start_fade_to_invisible__using_tween(0.5, self, "_on_nightmare_reached_fully_invis__from_fade_with_tweener", [arg_enemy], true, true, true, true)
	

func _on_nightmare_reached_fully_invis__from_fade_with_tweener(arg_params):
	var enemy = arg_params[0]
	
	if is_instance_valid(enemy):
		if !enemy.already_reached_end_once:
			enemy.already_reached_end_once = true
			enemy.set_offset__and_configure_other_properties(0)
			enemy.start_unfade_into_visibility__using_tween(0.5, self, "_on_nightmare_reached_full_vis__from_unfade_with_tweener", [enemy])
			
		else:
			
			if is_instance_valid(enemy.current_path):
				_place_active_nightmare_marker__using_nightmare(enemy, enemy.current_path.get_global_pos_of_offset(0), 0)
			
			#if enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_killed_by_damage_with_no_more_revives__enemy_nightmare"):
			#	enemy.disconnect("on_killed_by_damage_with_no_more_revives", self, "_on_killed_by_damage_with_no_more_revives__enemy_nightmare")
			
			_disconnect_nightmare_marker_spawning_signals(enemy)
			
			enemy.execute_self_by(0, null, true)




func _on_nightmare_reached_full_vis__from_unfade_with_tweener(arg_params):
	pass


####################
# ENEMIES IN ROUNDS
####################

func _initialize_special_path_var_relateds():
	for path_id in SpecialPathId.values():
		_path_id_to_spawn_metadata_map[path_id] = _generate_spawn_metadata_for_path(path_id)

func _generate_spawn_metadata_for_path(arg_path_id : int):
	var spawn_metadata = {}
	for mdata in _special_enemy_common_spawn_metadata.keys():
		spawn_metadata[mdata] = _special_enemy_common_spawn_metadata[mdata]
	
	#
	
	spawn_metadata[StoreOfEnemyMetadataIdsFromIns.MAP_MEMORIES__SPECIAL_PATH] = arg_path_id
	
	return spawn_metadata

func _retrieve_spawn_metadata_for_path(arg_path_id : int):
	return _path_id_to_spawn_metadata_map[arg_path_id]


#######################

func get_spawn_ins_for_special_round__01():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
	]

func get_spawn_ins_for_special_round__03():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
	]




func get_spawn_ins_for_special_round__22():
	return [
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
	]

func get_spawn_ins_for_special_round__24():
	return [
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
	]


func get_spawn_ins_for_special_round__32():
	return [
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
	]

func get_spawn_ins_for_special_round__34():
	return [
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
	]


func get_spawn_ins_for_special_round__42():
	return [
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
	]

func get_spawn_ins_for_special_round__44():
	return [
		SingleEnemySpawnInstruction.new(7, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
	]



func get_spawn_ins_for_special_round__52():
	return [
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(2, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(16, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		
	]

func get_spawn_ins_for_special_round__54():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
	]



func get_spawn_ins_for_special_round__62():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(2, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		SingleEnemySpawnInstruction.new(5, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(6, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(8, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		
	]

func get_spawn_ins_for_special_round__64():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(2, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
		
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(31, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
	]


func get_spawn_ins_for_special_round__72():
	return [
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		SingleEnemySpawnInstruction.new(15, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(17, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(18, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(18.5, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(18.75, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(35, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
	]

func get_spawn_ins_for_special_round__74():
	return [
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		#
		
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		#
		
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(30, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
	]



func get_spawn_ins_for_special_round__82():
	return [
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		
		MultipleEnemySpawnInstruction.new(10, 5, 1, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		MultipleEnemySpawnInstruction.new(20, 5, 1, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
	]

func get_spawn_ins_for_special_round__84():
	return [
		
		MultipleEnemySpawnInstruction.new(20, 3, 6, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		LinearEnemySpawnInstruction.new(30, 8, 0.5, 0.060, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, 0.15, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
	]



func get_spawn_ins_for_special_round__91():
	return [
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
		MultipleEnemySpawnInstruction.new(25, 2, 3, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		MultipleEnemySpawnInstruction.new(30, 2, 3, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		MultipleEnemySpawnInstruction.new(35, 2, 3, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
		
	]

func get_spawn_ins_for_special_round__92():
	return [
		
		MultipleEnemySpawnInstruction.new(0, 2, 3, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		MultipleEnemySpawnInstruction.new(10, 4, 1, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		MultipleEnemySpawnInstruction.new(25, 2, 1, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		MultipleEnemySpawnInstruction.new(25, 2, 1, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
	]

func get_spawn_ins_for_special_round__93():
	return [
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		MultipleEnemySpawnInstruction.new(15, 2, 1, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		MultipleEnemySpawnInstruction.new(15, 2, 1, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		MultipleEnemySpawnInstruction.new(20, 3, 1, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		MultipleEnemySpawnInstruction.new(20, 3, 1, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
	]

func get_spawn_ins_for_special_round__94():
	return [
		SingleEnemySpawnInstruction.new(1, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(2, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(3, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		SingleEnemySpawnInstruction.new(4, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		SingleEnemySpawnInstruction.new(11, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(12, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(13, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		SingleEnemySpawnInstruction.new(14, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		SingleEnemySpawnInstruction.new(31, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(32, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(33, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		SingleEnemySpawnInstruction.new(34, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		
	]



func get_spawn_ins_for_special_round__101():
	return [
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		LinearEnemySpawnInstruction.new(0, 12, 2, 0.060, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, 0.25, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		
		LinearEnemySpawnInstruction.new(0, 5, 0.5, 0.10, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, 0.25, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
	]

func get_spawn_ins_for_special_round__102():
	return [
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		SingleEnemySpawnInstruction.new(10, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		MultipleEnemySpawnInstruction.new(30, 5, 1, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
	]

func get_spawn_ins_for_special_round__103():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
		MultipleEnemySpawnInstruction.new(30, 8, 0.75, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		MultipleEnemySpawnInstruction.new(30, 8, 0.75, EnemyConstants.Enemies.MAP_MEMORIES__DREAM, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_03)),
		
	]

func get_spawn_ins_for_special_round__104():
	return [
		SingleEnemySpawnInstruction.new(0, EnemyConstants.Enemies.MAP_MEMORIES__NIGHTMARE, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_04)),
		
		####
		
		SingleEnemySpawnInstruction.new(20, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(21, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(22, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_01)),
		SingleEnemySpawnInstruction.new(23, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(24, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		SingleEnemySpawnInstruction.new(25, EnemyConstants.Enemies.MAP_MEMORIES__MEMORIA, _retrieve_spawn_metadata_for_path(SpecialPathId.PATH_02)),
		
		
	]

