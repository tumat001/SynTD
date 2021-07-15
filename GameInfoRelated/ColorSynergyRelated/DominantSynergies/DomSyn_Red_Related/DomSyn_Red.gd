extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const Red_PactWholePanel = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactWholePanel.gd")
const Red_PactWholePanel_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_PactWholePanel.tscn")
const Red_SynergyIconInteractable = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_SynergyIconInteractable.gd")
const Red_SynergyIconInteractable_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_GUI/Red_SynergyIconInteractable.tscn")

const red_inactive_health_deduct : float = 10.0

var game_elements : GameElements
var red_pact_whole_panel : Red_PactWholePanel

var pact_decider_rng : RandomNumberGenerator
var tier_3_pacts_uuids : Array = []
var tier_2_pacts_uuids : Array = []

var syn_icon_interactable : Red_SynergyIconInteractable

var curr_tier : int

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = tier
	
	if tier_3_pacts_uuids.size() == 0:
		_initialize_tier_3_pacts()
	
	if tier_2_pacts_uuids.size() == 0:
		_initialize_tier_2_pacts()
	
	if game_elements == null:
		game_elements = arg_game_elements
	
	if red_pact_whole_panel == null:
		pact_decider_rng = StoreOfRNG.domsyn_red_pact_rng
		
		red_pact_whole_panel = Red_PactWholePanel_Scene.instance()
		game_elements.whole_screen_gui.add_child(red_pact_whole_panel)
		red_pact_whole_panel.unsworn_pact_list.card_limit = 3
		red_pact_whole_panel.sworn_pact_list.card_limit = 3
		
		red_pact_whole_panel.connect("unsworn_pact_to_be_sworn", self, "_on_unsworn_pact_to_be_sworn", [], CONNECT_PERSIST)
		red_pact_whole_panel.connect("sworn_pact_card_removed", self, "_on_sworn_pact_card_removed", [], CONNECT_PERSIST)
		
		# add three
		for i in 3:
			var pact = _generate_random_untaken_tier_3_pact()
			if pact != null:
				red_pact_whole_panel.unsworn_pact_list.add_pact(pact)
	
	
	if syn_icon_interactable == null:
		syn_icon_interactable = Red_SynergyIconInteractable_Scene.instance()
		syn_icon_interactable.connect("show_syn_shop", self, "_on_show_syn_shop", [], CONNECT_PERSIST)
		game_elements.synergy_interactable_panel.add_synergy_interactable(syn_icon_interactable)
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end_red_inactive"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end_red_inactive")
	
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _initialize_tier_3_pacts():
	tier_3_pacts_uuids.append(StoreOfPactUUID.FIRST_IMPRESSION)
	tier_3_pacts_uuids.append(StoreOfPactUUID.SECOND_IMPRESSION)
	tier_3_pacts_uuids.append(StoreOfPactUUID.A_CHALLENGE)
	tier_3_pacts_uuids.append(StoreOfPactUUID.PLAYING_WITH_FIRE)
	tier_3_pacts_uuids.append(StoreOfPactUUID.FUTURE_SIGHT)

func _initialize_tier_2_pacts():
	tier_2_pacts_uuids.append(StoreOfPactUUID.FIRST_IMPRESSION)
	tier_2_pacts_uuids.append(StoreOfPactUUID.SECOND_IMPRESSION)
	tier_2_pacts_uuids.append(StoreOfPactUUID.A_CHALLENGE)
	tier_2_pacts_uuids.append(StoreOfPactUUID.PLAYING_WITH_FIRE)
	tier_2_pacts_uuids.append(StoreOfPactUUID.FUTURE_SIGHT)



func _generate_random_untaken_tier_3_pact():
	var copy_of_tier_3s = tier_3_pacts_uuids.duplicate()
	for pact_uuid in red_pact_whole_panel.unsworn_pact_list.get_all_pact_uuids():
		copy_of_tier_3s.erase(pact_uuid)
	for pact_uuid in red_pact_whole_panel.sworn_pact_list.get_all_pact_uuids():
		copy_of_tier_3s.erase(pact_uuid)
	
	if copy_of_tier_3s.size() > 0:
		var pact_uuid : int = copy_of_tier_3s[pact_decider_rng.randi_range(0, copy_of_tier_3s.size() - 1)]
		var pact = StoreOfPactUUID.construct_pact(pact_uuid, 3)
		
		if pact_uuid == StoreOfPactUUID.FUTURE_SIGHT and pact != null:
			pact.red_syn = self
		
		return pact
	else:
		return null

func _generate_random_untaken_tier_2_pact():
	var copy_of_tier_2s = tier_2_pacts_uuids.duplicate()
	for pact_uuid in red_pact_whole_panel.unsworn_pact_list.get_all_pact_uuids():
		copy_of_tier_2s.erase(pact_uuid)
	for pact_uuid in red_pact_whole_panel.sworn_pact_list.get_all_pact_uuids():
		copy_of_tier_2s.erase(pact_uuid)
	
	if copy_of_tier_2s.size() > 0:
		var pact_uuid : int = copy_of_tier_2s[pact_decider_rng.randi_range(0, copy_of_tier_2s.size() - 1)]
		var pact = StoreOfPactUUID.construct_pact(pact_uuid, 2)
		
		if pact_uuid == StoreOfPactUUID.FUTURE_SIGHT:
			pact.red_syn = self
	else:
		return null


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	
	if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_end_red_inactive"):
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end_red_inactive", [], CONNECT_PERSIST)
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


#

func _on_round_end(curr_stageround):
	var pact
	
	if curr_tier == 1:
		pass
	elif curr_tier == 2:
		pact = _generate_random_untaken_tier_2_pact()
	elif curr_tier == 3:
		pact = _generate_random_untaken_tier_3_pact()
	
	if pact != null:
		red_pact_whole_panel.unsworn_pact_list.add_pact(pact)


func _on_unsworn_pact_to_be_sworn(pact):
	red_pact_whole_panel.unsworn_pact_list.remove_pact(pact)
	red_pact_whole_panel.sworn_pact_list.add_pact(pact)
	pact._apply_pact_to_game_elements(game_elements)

func _on_sworn_pact_card_removed(pact):
	pact._remove_pact_from_game_elements(game_elements)


#

func _on_round_end_red_inactive(curr_stageround):
	game_elements.health_manager.decrease_health_by(red_inactive_health_deduct, game_elements.HealthManager.DecreaseHealthSource.SYNERGY)

#

func _on_show_syn_shop():
	game_elements.whole_screen_gui.show_control(red_pact_whole_panel)

