extends "res://EnemyRelated/EnemyFactionPassives/BaseFactionPassive.gd"

const StoreOfEnemyMorphs = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/StoreOfEnemyMorphs.gd")
const AbstractMorph = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/AbstractMorph.gd")

const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")
const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")


signal current_morph_id_in_selection_banned(arg_morph_id)

#

var morph_id_to_info_singleton_map : Dictionary = {}


var _current_morpher_skill_set_ids_active__for_wildcards_only : Array = []  # ex: base kit skillset of sorcerer (if at least 1 sorcerer morph is selected)
var _current_morpher_skill_set_ids_active : Array = []

#

const rounds_to_offer_morph : Array = [
	"41",
	"51",
	"61",
	"71",
	"81",
	"91",
]

#

var morph_general_purpose_rng : RandomNumberGenerator

var active_morph_id_to_morph_map : Dictionary
var banned_morph_ids : Array

# DURING SELECTION GUI related

var current_offered_morph_ids_to_morph : Dictionary

const ban_count_per_selection : int = 1
var current_ban_count : int

const offer_count_per_selection : int = 3


#

var game_elements

# queue related

var reservation_for_whole_screen_gui

#

#############

func _init():
	_initialize_queue_reservation()

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	

#############

func _apply_faction_to_game_elements(arg_game_elements):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if morph_id_to_info_singleton_map.size() == 0:
		_initialize_morph_infos_and_singletons()
	
	
	morph_general_purpose_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.MORPHERS_GEN_PURPOSE)
	
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	_check_for_current_round_if_offer_morph_round()

func _initialize_morph_infos_and_singletons():
	for id in StoreOfEnemyMorphs.morph_id_to_morph_path_name.keys():
		var morph = load(StoreOfEnemyMorphs.morph_id_to_morph_path_name[id]).new()
		morph._configure_with_game_elements_and_fac_passive(game_elements)
		morph_id_to_info_singleton_map[id] = morph
	
	

###

func _on_round_end(arg_stageround):
	_check_for_current_round_if_offer_morph_round()
	

func _check_for_current_round_if_offer_morph_round():
	var stageround_id = game_elements.stage_round_manager.current_stageround.id
	
	for id in rounds_to_offer_morph:
		if stageround_id == id:
			_start_morph_offer()
			break


###

func _start_morph_offer():
	current_ban_count = ban_count_per_selection
	
	var valid_morph_ids = _get_all_valid_morph_ids()
	var randomized_morph_ids = _get_randomized_morph_ids_for_selection(valid_morph_ids)
	
	set_current_offered_morph_ids(randomized_morph_ids)
	
	
	start_show_morph_selection_panel()

# morph ids not banned, picked, and has stage_round is beyond the morph's minimum
func _get_all_valid_morph_ids():
	var stageround_id = game_elements.stage_round_manager.current_stageround.id
	
	var bucket = []
	for id in StoreOfEnemyMorphs.morph_id_to_morph_path_name.keys():
		var morph : AbstractMorph = morph_id_to_info_singleton_map[id]
		
		if !active_morph_id_to_morph_map.has(id) and !banned_morph_ids.has(id) and StageRound.is_stageround_id_higher_or_equal_than_second_param(stageround_id, morph.min_round_to_be_offerable_inc):
			bucket.append(id)
	
	return bucket

func _get_randomized_morph_ids_for_selection(arg_morph_ids_to_pick_from : Array):
	return StoreOfRNG.randomly_select_elements(arg_morph_ids_to_pick_from, morph_general_purpose_rng, offer_count_per_selection)

#

func set_current_offered_morph_ids(arg_morph_ids):
	for id in arg_morph_ids:
		var morph = morph_id_to_info_singleton_map[id]
		current_offered_morph_ids_to_morph[id] = morph
	
	

#

func start_show_morph_selection_panel():
	pass
	


func end_show_morph_selection_panel():
	pass
	


#

func ban_morph_offer(arg_morph_id):
	banned_morph_ids.append(arg_morph_id)
	
	if current_offered_morph_ids_to_morph.has(arg_morph_id):
		emit_signal("current_morph_id_in_selection_banned", arg_morph_id)
		


func activate_morph(arg_morph : AbstractMorph):
	if !active_morph_id_to_morph_map.has(arg_morph.id):
		active_morph_id_to_morph_map[arg_morph.id] = arg_morph
		
		arg_morph._apply_morph(game_elements)



