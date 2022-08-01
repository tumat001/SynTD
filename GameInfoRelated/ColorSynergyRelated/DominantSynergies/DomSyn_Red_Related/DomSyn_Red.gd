extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const Red_PactWholePanel = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactWholePanel.gd")
const Red_PactWholePanel_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactWholePanel.tscn")
const Red_SynergyIconInteractable = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_SynergyIconInteractable.gd")
const Red_SynergyIconInteractable_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_SynergyIconInteractable.tscn")

const Red_BasePact = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd")

const red_inactive_health_deduct : float = 10.0


signal on_curr_tier_changed(new_tier)

var game_elements : GameElements
var red_pact_whole_panel : Red_PactWholePanel

var _added_red_pact_whole_panel_to_whole_screen : bool = false

var pact_decider_rng : RandomNumberGenerator
var tier_3_pacts_uuids : Array = []
var tier_2_pacts_uuids : Array = []
var tier_1_pacts_uuids : Array = []
var tier_0_pacts_uuids : Array = [] # from future sight

var syn_icon_interactable : Red_SynergyIconInteractable


var curr_tier : int
const TIER_INACTIVE : int = -1

#

var pact_uuid_to_pact_map_singleton : Dictionary = {}


#

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = tier
	
	if tier_3_pacts_uuids.size() == 0:
		_initialize_tier_3_pacts()
	
	if tier_2_pacts_uuids.size() == 0:
		_initialize_tier_2_pacts()
	
	if tier_1_pacts_uuids.size() == 0:
		_initialize_tier_1_pacts()
	
	if tier_0_pacts_uuids.size() == 0:
		_initialize_tier_0_pacts()
	
	if pact_uuid_to_pact_map_singleton.size() == 0:
		_initialize_pact_singletons()
	
	if game_elements == null:
		game_elements = arg_game_elements
	
	if red_pact_whole_panel == null:
		pact_decider_rng = StoreOfRNG.domsyn_red_pact_rng
		
		red_pact_whole_panel = Red_PactWholePanel_Scene.instance()
		#_initialize_red_pact_whole_panel()
	
	if syn_icon_interactable == null:
		syn_icon_interactable = Red_SynergyIconInteractable_Scene.instance()
		syn_icon_interactable.connect("show_syn_shop", self, "_on_show_syn_shop", [], CONNECT_PERSIST)
		game_elements.synergy_interactable_panel.add_synergy_interactable(syn_icon_interactable)
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end_red_inactive"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end_red_inactive")
	
	
	._apply_syn_to_game_elements(arg_game_elements, tier)
	
	emit_signal("on_curr_tier_changed", curr_tier)

# ini pacts
func _initialize_tier_3_pacts():
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.FIRST_IMPRESSION)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.SECOND_IMPRESSION)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.A_CHALLENGE)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PLAYING_WITH_FIRE)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.FUTURE_SIGHT)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.JEWELED_BLADE)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.JEWELED_STAFF)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.DOMINANCE_SUPPLEMENT)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PERSONAL_SPACE)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.SOLO_VICTOR)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.TRIO_VICTOR)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.RETRIBUTION)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.ABILITY_PROVISIONS)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.ORACLES_EYE)

func _initialize_tier_2_pacts():
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.FIRST_IMPRESSION)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.SECOND_IMPRESSION)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.A_CHALLENGE)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PLAYING_WITH_FIRE)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.FUTURE_SIGHT)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.JEWELED_BLADE)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.JEWELED_STAFF)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.DOMINANCE_SUPPLEMENT)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PERSONAL_SPACE)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.SOLO_VICTOR)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.TRIO_VICTOR)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.RETRIBUTION)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.ABILITY_PROVISIONS)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.ORACLES_EYE)
	
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.DRAGON_SOUL)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.TIGER_SOUL)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PRESTIGE)
	

func _initialize_tier_1_pacts():
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.FIRST_IMPRESSION)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.SECOND_IMPRESSION)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.A_CHALLENGE)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PLAYING_WITH_FIRE)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.FUTURE_SIGHT)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.JEWELED_BLADE)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.JEWELED_STAFF)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.DOMINANCE_SUPPLEMENT)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PERSONAL_SPACE)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.SOLO_VICTOR)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.TRIO_VICTOR)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.RETRIBUTION)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.ABILITY_PROVISIONS)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.ORACLES_EYE)
	
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.DRAGON_SOUL)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.TIGER_SOUL)
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PRESTIGE)
	
	tier_1_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.COMPLEMENTARY_SUPPLEMENT)
	

func _initialize_tier_0_pacts():
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.FIRST_IMPRESSION)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.SECOND_IMPRESSION)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.A_CHALLENGE)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PLAYING_WITH_FIRE)
	#tier_0_pacts_uuids.append(StoreOfPactUUID.FUTURE_SIGHT)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.JEWELED_BLADE)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.JEWELED_STAFF)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.DOMINANCE_SUPPLEMENT)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PERSONAL_SPACE)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.SOLO_VICTOR)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.TRIO_VICTOR)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.RETRIBUTION)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.ABILITY_PROVISIONS)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.ORACLES_EYE)
	
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.DRAGON_SOUL)
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.TIGER_SOUL)
	#tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.PRESTIGE)
	
	tier_0_pacts_uuids.append(StoreOfPactUUID.PactUUIDs.COMPLEMENTARY_SUPPLEMENT)

func _initialize_pact_singletons():
	for uuid in StoreOfPactUUID.PactUUIDs:
		#var pact = _generate_pact_with_tier(uuid, 0)
		var pact = StoreOfPactUUID.construct_pact(StoreOfPactUUID.PactUUIDs[uuid], 0)
		pact_uuid_to_pact_map_singleton[StoreOfPactUUID.PactUUIDs[uuid]] = pact



#
func _generate_random_untaken_tier_3_pact() -> Red_BasePact:
	return _generate_random_untaken_pact_from_source(tier_3_pacts_uuids, 3)

func _generate_random_untaken_tier_2_pact() -> Red_BasePact:
	return _generate_random_untaken_pact_from_source(tier_2_pacts_uuids, 2)

func _generate_random_untaken_tier_1_pact() -> Red_BasePact:
	return _generate_random_untaken_pact_from_source(tier_1_pacts_uuids, 1)

func _generate_random_untaken_tier_0_pact() -> Red_BasePact:
	return _generate_random_untaken_pact_from_source(tier_0_pacts_uuids, 0)


# code for deciding what pact to offer
func _generate_random_untaken_pact_from_source(source : Array, tier) -> Red_BasePact:
	if red_pact_whole_panel != null and red_pact_whole_panel.unsworn_pact_list != null:
		var copy = source.duplicate()
		for pact_uuid in red_pact_whole_panel.unsworn_pact_list.get_all_pact_uuids():
			copy.erase(pact_uuid)
		for pact_uuid in red_pact_whole_panel.sworn_pact_list.get_all_pact_uuids():
			copy.erase(pact_uuid)
		
		#
		
		var bucket_to_remove : Array = []
		for pact_uuid in copy:
			var pact_singleton : Red_BasePact = pact_uuid_to_pact_map_singleton[pact_uuid]
			if !pact_singleton.is_pact_offerable(game_elements, self, tier):
				bucket_to_remove.append(pact_uuid)
		
		for pact_uuid in bucket_to_remove:
			copy.erase(pact_uuid)
		
		#
		
		if copy.size() > 0:
			var pact_uuid : int = copy[pact_decider_rng.randi_range(0, copy.size() - 1)]
			return _generate_pact_with_tier(pact_uuid, tier)
		else:
			return null
	
	return null

# code for constructing the pact itself
func _generate_pact_with_tier(pact_uuid : int, tier : int) -> Red_BasePact:
	var pact = StoreOfPactUUID.construct_pact(pact_uuid, tier)
	
	if pact_uuid == StoreOfPactUUID.PactUUIDs.FUTURE_SIGHT:
		pact.red_syn = self
	
	pact.set_up_tier_changes_and_watch_requirements(game_elements, self)
	
	return pact

#

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = TIER_INACTIVE
	
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end_red_inactive"):
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end_red_inactive", [], CONNECT_PERSIST)
	
	._remove_syn_from_game_elements(arg_game_elements, tier)
	
	emit_signal("on_curr_tier_changed", curr_tier)


#

func _on_round_end(curr_stageround):
	var pact
	
	if curr_tier == 1:
		pact = _generate_random_untaken_tier_1_pact()
	elif curr_tier == 2:
		pact = _generate_random_untaken_tier_2_pact()
	elif curr_tier == 3:
		pact = _generate_random_untaken_tier_3_pact()
	
	if pact != null:
		red_pact_whole_panel.unsworn_pact_list.add_pact(pact)


func _on_unsworn_pact_to_be_sworn(pact):
	red_pact_whole_panel.unsworn_pact_list.remove_pact(pact)
	red_pact_whole_panel.sworn_pact_list.add_pact(pact)
	
	pact.pact_sworn()
	#pact._apply_pact_to_game_elements(game_elements)

func _on_sworn_pact_card_removed(pact):
	pact.pact_unsworn()
	#pact._remove_pact_from_game_elements(game_elements)


#

func _on_round_end_red_inactive(curr_stageround):
	if red_pact_whole_panel.sworn_pact_list.get_pact_count() > 0:
		#game_elements.health_manager.decrease_health_by(red_inactive_health_deduct, game_elements.HealthManager.DecreaseHealthSource.SYNERGY)
		pass

#

func _on_show_syn_shop():
	game_elements.whole_screen_gui.show_control(red_pact_whole_panel)
	
	if !_added_red_pact_whole_panel_to_whole_screen:
		_added_red_pact_whole_panel_to_whole_screen = true
		_initialize_red_pact_whole_panel()

func _initialize_red_pact_whole_panel():
	red_pact_whole_panel.unsworn_pact_list.card_limit = 3
	red_pact_whole_panel.sworn_pact_list.card_limit = 3
	
	red_pact_whole_panel.connect("unsworn_pact_to_be_sworn", self, "_on_unsworn_pact_to_be_sworn", [], CONNECT_PERSIST)
	red_pact_whole_panel.connect("sworn_pact_card_removed", self, "_on_sworn_pact_card_removed", [], CONNECT_PERSIST)
	
	# add three
	for i in 3:
		var pact = _generate_random_untaken_tier_3_pact()
		if pact != null:
			red_pact_whole_panel.unsworn_pact_list.add_pact(pact)
	
	# for debugging only
	red_pact_whole_panel.unsworn_pact_list.add_pact(_generate_pact_with_tier(StoreOfPactUUID.PactUUIDs.ORACLES_EYE, 2))

