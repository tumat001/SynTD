extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const HeatModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/HeatModule.gd")
const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")

const IncHeat_Image = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/AbilityAssets/IncHeat_Image.png")
const DecHeat_Image = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/AbilityAssets/DecHeat_Image.png")

signal on_round_end()
signal on_base_multiplier_changed(scale)


const tier_1_heat_effect_scale : float = 60.0
const tier_2_heat_effect_scale : float = 5.0
const tier_3_heat_effect_scale : float = 3.0
const tier_4_heat_effect_scale : float = 1.0

const inc_heat_amount_from_ability : int = 20
const inc_heat_amount_round_cooldown : int = 3
const dec_heat_amount_round_cooldown : int = 4

var current_heat_effect_scale : float

var should_modules_show_in_info : bool = false

var current_overheat_effects : Array = []

var game_elements : GameElements

var inc_heat_ability : BaseAbility
var dec_heat_ability : BaseAbility


# Adding syn to game ele

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	set_game_elements(arg_game_elements)
	should_modules_show_in_info = true
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	if tier == 4:
		current_heat_effect_scale = tier_4_heat_effect_scale
		_set_effect_multiplier_of_heat_modules(tier_4_heat_effect_scale)
	elif tier == 3:
		current_heat_effect_scale = tier_3_heat_effect_scale
		_set_effect_multiplier_of_heat_modules(tier_3_heat_effect_scale)
	elif tier == 2:
		current_heat_effect_scale = tier_2_heat_effect_scale
		_set_effect_multiplier_of_heat_modules(tier_2_heat_effect_scale)
	elif tier == 1:
		current_heat_effect_scale = tier_1_heat_effect_scale
		_set_effect_multiplier_of_heat_modules(tier_1_heat_effect_scale)
	
	if inc_heat_ability == null:
		_construct_inc_heat_ability()
	
	if dec_heat_ability == null:
		_construct_dec_heat_ability()
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	_towers_to_benefit_from_syn(all_towers)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


# Removing syn

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	should_modules_show_in_info = false
	current_heat_effect_scale = 0
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	_towers_to_remove_from_syn(all_towers)
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


# Game elements and round related

func set_game_elements(arg_game_elements):
	if game_elements == null:
		game_elements = arg_game_elements
		
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_ended")


func _on_round_ended(stageround):
	emit_signal("on_round_end")


# Heat module related

func construct_heat_module() -> HeatModule:
	var heat_module : HeatModule = HeatModule.new()
	heat_module.overheat_effects = current_overheat_effects
	heat_module.should_be_shown_in_info_panel = should_modules_show_in_info
	heat_module.base_effect_multiplier = current_heat_effect_scale
	
	connect("on_round_end", heat_module, "on_round_end", [], CONNECT_PERSIST)
	connect("on_base_multiplier_changed", heat_module, "set_base_effect_multiplier", [], CONNECT_PERSIST)
	
	return heat_module


func _set_effect_multiplier_of_heat_modules(scale : float):
	#emit_signal("on_base_multiplier_changed", scale)
	call_deferred("emit_signal", "on_base_multiplier_changed", scale)

# Towers

func _towers_to_benefit_from_syn(towers : Array):
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	#if tower._tower_colors.has(TowerColors.ORANGE):
	if tower.is_benefit_from_syn_having_or_as_if_having_color(TowerColors.ORANGE):
		if tower.heat_module == null:
			tower.heat_module = construct_heat_module()
			tower.heat_module.set_tower(tower)
		else:
			tower.heat_module.should_be_shown_in_info_panel = true
			tower.heat_module.base_effect_multiplier = current_heat_effect_scale


func _towers_to_remove_from_syn(towers : Array):
	for tower in towers:
		_tower_to_remove_from_synergy(tower)

func _tower_to_remove_from_synergy(tower : AbstractTower):
	if tower.heat_module != null:
		tower.heat_module.base_effect_multiplier = 0
		tower.heat_module.should_be_shown_in_info_panel = false



# ability related

func _construct_inc_heat_ability():
	inc_heat_ability = BaseAbility.new()
	
	inc_heat_ability.is_roundbound = true
	inc_heat_ability.connect("ability_activated", self, "_inc_heat_ability_activated", [], CONNECT_PERSIST)
	inc_heat_ability.icon = IncHeat_Image
	
	inc_heat_ability.set_properties_to_usual_synergy_based()
	inc_heat_ability.synergy = self
	
	inc_heat_ability.descriptions = [
		"Immediately increases all in map tower's heat module's heat by %s. Heat gained this way does not surpass the heat limit per round." % str(inc_heat_amount_from_ability),
		"Cooldown: %s rounds." % str(inc_heat_amount_round_cooldown)
	]
	inc_heat_ability.display_name = "Heat Up"
	
	inc_heat_ability.set_properties_to_auto_castable()
	inc_heat_ability.auto_cast_func = "_inc_heat_ability_activated"
	
	register_ability_to_manager(inc_heat_ability)

func register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	game_elements.ability_manager.add_ability(ability, add_to_panel)


func _inc_heat_ability_activated():
	for tower in game_elements.tower_manager.get_all_active_towers():
		if tower.heat_module != null and tower.is_current_placable_in_map():
			tower.heat_module.increment_current_heat(inc_heat_amount_from_ability)
	
	inc_heat_ability.start_round_cooldown(inc_heat_amount_round_cooldown)



func _construct_dec_heat_ability():
	dec_heat_ability = BaseAbility.new()
	
	dec_heat_ability.is_roundbound = true
	dec_heat_ability.connect("ability_activated", self, "_dec_heat_ability_activated", [], CONNECT_PERSIST)
	dec_heat_ability.icon = DecHeat_Image
	
	dec_heat_ability.set_properties_to_usual_synergy_based()
	dec_heat_ability.synergy = self
	
	dec_heat_ability.descriptions = [
		"Immediately stops all tower's heat module from gaining more heat for the round.",
		"Cooldown: %s rounds." % str(dec_heat_amount_round_cooldown)
	]
	dec_heat_ability.display_name = "Stabilize"
	
	dec_heat_ability.set_properties_to_auto_castable()
	dec_heat_ability.auto_cast_func = "_dec_heat_ability_activated"
	
	register_ability_to_manager(dec_heat_ability)


func _dec_heat_ability_activated():
	for tower in game_elements.tower_manager.get_all_active_towers():
		if tower.heat_module != null and tower.is_current_placable_in_map():
			tower.heat_module.set_max_heat_reached_in_round()
	
	dec_heat_ability.start_round_cooldown(dec_heat_amount_round_cooldown)
