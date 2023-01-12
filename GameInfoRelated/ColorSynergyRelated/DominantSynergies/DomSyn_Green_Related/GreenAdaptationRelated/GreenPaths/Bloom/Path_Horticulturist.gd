extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GreenAdaptationRelated/BaseGreenPath.gd"

const ShopManager = preload("res://GameElementsRelated/ShopManager.gd")


const green_tier_requirement_inclusive : int = 3

const extra_shop_slot_amount : int = 1
const triumph_adaptation_level_min_inclusive : int = 8

const path_name = "Horticulturist"
const path_descs = [
	"Unlock 4 exclusive green towers.",
	"Each shop refresh now offers an additional tower.",
	"",
	"Triumph adaptations are accessible only at level %s and above." % [str(triumph_adaptation_level_min_inclusive)],
	"Beyond adaptations are no longer accessible."
]
const path_small_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Green_Related/GUIRelated/Assets/Horticulturist_Icon.png")

var exclusive_tower_ids : Array = [
	Towers.SE_PROPAGER,
	Towers.L_ASSAUT,
	Towers.LA_CHASSEUR,
	Towers.LA_NATURE
]

var game_elements


func _init(arg_tier).(path_name, path_descs, path_small_icon, arg_tier):
	pass

#


func _apply_path_tier_to_game_elements(tier : int, arg_game_elements : GameElements):
	if game_elements == null:
		game_elements = arg_game_elements
	
	
	if tier <= green_tier_requirement_inclusive:
		game_elements.shop_manager.add_towers_per_refresh_amount_modifier(ShopManager.TowersPerShopModifiers.SYN_GREEN__HORTICULTURIST, extra_shop_slot_amount)
		
		if !game_elements.level_manager.is_connected("on_current_level_changed", self, "_on_player_level_changed"):
			game_elements.level_manager.connect("on_current_level_changed", self, "_on_player_level_changed", [], CONNECT_PERSIST)
		
		#
		
		for tower_id in exclusive_tower_ids:
			game_elements.shop_manager.add_tower_to_inventory(tower_id, Towers.TowerTiersMap[tower_id])
		
		_on_player_level_changed(game_elements.level_manager.current_level)
		dom_syn_green._curr_tier_1_layer.green_layer_activation_clauses.attempt_insert_clause(dom_syn_green._curr_tier_1_layer.GreenLayerConditionalClauses.HORTICULTURIST_ACTIVE)
	
	._apply_path_tier_to_game_elements(tier, arg_game_elements)

func _remove_path_from_game_elements(tier : int, arg_game_elements : GameElements):
	game_elements.shop_manager.remove_towers_per_refresh_amount_modifier(ShopManager.TowersPerShopModifiers.SYN_GREEN__HORTICULTURIST)
	
	if game_elements.level_manager.is_connected("on_current_level_changed", self, "_on_player_level_changed"):
		game_elements.level_manager.disconnect("on_current_level_changed", self, "_on_player_level_changed")
	
	for tower_id in exclusive_tower_ids:
		game_elements.shop_manager.remove_tower_from_inventory(tower_id)
	
	dom_syn_green._curr_tier_1_layer.green_layer_activation_clauses.remove_clause(dom_syn_green._curr_tier_1_layer.GreenLayerConditionalClauses.HORTICULTURIST_ACTIVE)
	
	._remove_path_from_game_elements(tier, arg_game_elements)

#

func _on_player_level_changed(arg_new_level):
	if arg_new_level >= triumph_adaptation_level_min_inclusive:
		dom_syn_green._curr_tier_2_layer.green_layer_activation_clauses.remove_clause(dom_syn_green._curr_tier_2_layer.GreenLayerConditionalClauses.HORTICULTURIST_ACTIVE)
	else:
		dom_syn_green._curr_tier_2_layer.green_layer_activation_clauses.attempt_insert_clause(dom_syn_green._curr_tier_2_layer.GreenLayerConditionalClauses.HORTICULTURIST_ACTIVE)

