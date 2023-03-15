extends "res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd"


const NO_SYNERGY = "GameModi_VioVar_NO_SYNERGY"

enum VioletVariation {
	V01 = 0,
	V02 = 1
}



var all_violet_variation_tower_ids = [
	Towers.SHACKLED,
	Towers.PING,
	Towers.VARIANCE,
	Towers.CHAOS,
	Towers.PROMINENCE,
	Towers.TESLA,
	
	Towers.BOUNDED,
	Towers.CELESTIAL,
	Towers.BIOMORPH,
	Towers.CYNOSURE,
	Towers.LIFELINE,
	Towers.IMPEDE,
	Towers.REALMD,
]


var violet_variation_v01_tower_ids = [
	Towers.SHACKLED,
	
	Towers.PING,
	Towers.VARIANCE,
	
	Towers.CHAOS,
	Towers.PROMINENCE,
	Towers.TESLA,
]

var violet_variation_v02_tower_ids = [
	Towers.CYNOSURE,
	
	Towers.CELESTIAL,
	Towers.BIOMORPH,
	Towers.IMPEDE,
	
	Towers.BOUNDED,
	Towers.LIFELINE,
	
	Towers.VARIANCE,
	
	Towers.REALMD
]

var violet_variation_to__available_tower_ids_map : Dictionary = {
	VioletVariation.V01 : violet_variation_v01_tower_ids,
	VioletVariation.V02 : violet_variation_v02_tower_ids,
}

var violet_variation_to__dom_syn_violet_synergy_id_map : Dictionary = {
	VioletVariation.V01 : TowerDominantColors.SynergyID__Violet,
	VioletVariation.V02 : TowerDominantColors.SynergyID__Violet_V02,
}

var violet_variation_to__compo_syn_yelvio_synergy_id_map : Dictionary = {
	VioletVariation.V01 : TowerCompositionColors.SynergyId__YellowViolet,
	VioletVariation.V02 : TowerCompositionColors.SynergyId__YellowViolet_V02,
}

var violet_variation_to__compo_syn_violetrb_synergy_id_map : Dictionary = {
	VioletVariation.V01 : TowerCompositionColors.SynergyId__VioletRB,
	VioletVariation.V02 : TowerCompositionColors.SynergyId__VioletRB_V02,
}

var violet_variation_to__compo_syn_OGV_synergy_id_map : Dictionary = {
	VioletVariation.V01 : TowerCompositionColors.SynergyId__OGV,
	VioletVariation.V02 : NO_SYNERGY,
}


#

var _banned_dom_syn_ids : Array
var _banned_compo_syn_ids : Array

var shop_manager
var synergy_manager

#

func _init().(StoreOfGameModifiers.GameModiIds__VioletVariationDecider, 
		BreakpointActivation.BEFORE_GAME_START, 
		"Violet Variation Randomizer"):
	
	pass
	


func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	
	shop_manager = game_elements.shop_manager
	synergy_manager = game_elements.synergy_manager
	
	_clear_all_violet_towers_pool_parameters()
	_apply_random_violet_variation()


func _clear_all_violet_towers_pool_parameters():
	for id in all_violet_variation_tower_ids:
		shop_manager.remove_tower_id_from_blacklisted_towers_to_inventory(id)
		shop_manager.remove_tower_id_from_towers_not_initially_in_inventory(id)


func _apply_random_violet_variation():
	var vio_variation = StoreOfRNG.randomly_select_one_element(VioletVariation.values(), StoreOfRNG.get_rng(StoreOfRNG.RNGSource.VIOLET_VARIATION_RANDOMIZER))
	
	_apply_towers_in_violet_variation(vio_variation)
	_apply_synergies(vio_variation)

func _apply_towers_in_violet_variation(arg_variation):
	var vio_tower_ids = violet_variation_to__available_tower_ids_map[arg_variation]
	_enable_tower_ids(vio_tower_ids)
	

func _apply_synergies(arg_variation):
	# DOM SYN --> VIOLET
	var dom_syn_vio_to_apply = violet_variation_to__dom_syn_violet_synergy_id_map[arg_variation]
	for syn_id in violet_variation_to__dom_syn_violet_synergy_id_map.values():
		if syn_id != dom_syn_vio_to_apply:
			if syn_id != NO_SYNERGY:
				synergy_manager.add_dominant_synergy_id_banned_this_game(syn_id, false)
				_banned_dom_syn_ids.append(syn_id)
	
	# COMPO SYN --> YEL VIO
	var compo_syn_yelvio_to_apply = violet_variation_to__compo_syn_yelvio_synergy_id_map[arg_variation]
	for syn_id in violet_variation_to__compo_syn_yelvio_synergy_id_map.values():
		if syn_id != compo_syn_yelvio_to_apply:
			if syn_id != NO_SYNERGY:
				synergy_manager.add_composite_synergy_id_banned_this_game(syn_id, false)
				_banned_compo_syn_ids.append(syn_id)
	
	# ANA SYN --> VIOLET RB
	var ana_syn_violet_rb_to_apply = violet_variation_to__compo_syn_violetrb_synergy_id_map[arg_variation]
	for syn_id in violet_variation_to__compo_syn_violetrb_synergy_id_map.values():
		if syn_id != ana_syn_violet_rb_to_apply:
			if syn_id != NO_SYNERGY:
				synergy_manager.add_composite_synergy_id_banned_this_game(syn_id, false)
				_banned_compo_syn_ids.append(syn_id)
	
	# TRIA SYN --> OGV
	var tria_syn_ogv_to_apply = violet_variation_to__compo_syn_OGV_synergy_id_map[arg_variation]
	for syn_id in violet_variation_to__compo_syn_OGV_synergy_id_map.values():
		if syn_id != tria_syn_ogv_to_apply:
			if syn_id != NO_SYNERGY:
				synergy_manager.add_composite_synergy_id_banned_this_game(syn_id, false)
				_banned_compo_syn_ids.append(syn_id)
	
	
	
	### KEEP AT BOTTOM
	
	synergy_manager.update_dominant_available_synergies_this_game__from_outside()
	synergy_manager.update_composite_available_synergies_this_game__from_outside()
	


#

func _enable_tower_ids(arg_towers_to_enable : Array):
	for id in all_violet_variation_tower_ids:
		if !arg_towers_to_enable.has(id):
			_blacklist_tower_id_from_shop_parameters(id)

func _blacklist_tower_id_from_shop_parameters(arg_id):
	shop_manager.add_tower_id_to_blacklisted_towers_to_inventory(arg_id)
	shop_manager.add_tower_id_to_towers_not_initially_in_inventory(arg_id)



###

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	
	
	_clear_all_violet_towers_pool_parameters()
	
