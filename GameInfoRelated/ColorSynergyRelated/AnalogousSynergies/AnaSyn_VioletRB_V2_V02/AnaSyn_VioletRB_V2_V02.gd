extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const TowerEffect_VioletRB_V2_V02_Effect = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Effects/TowerEffect_VioletRB_V2_V02_Effect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

#const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

#

signal bararge_ability_activated()

#

#var beam_multiple_trail_component : MultipleTrailsForNodeComponent
const base_trail_length__min : int = 4
const base_trail_length__max : int = 10

const base_trail_width__min : int = 2
const base_trail_width__max : int = 8

var _next_id_for_effect__for_beam_component : int = 0


const cone_explosion_dmg_percent_ratio : float = 2.0
const cone_explosion_pierce : int = 4


const stacking_attk_speed_percent_amount__tier_01 : float = 30.0
const stacking_attk_speed_percent_amount__tier_02 : float = 30.0
const stacking_attk_speed_percent_amount__tier_03 : float = 30.0
const stacking_attk_speed_percent_amount__tier_04 : float = 30.0
var stacking_attk_speed_percent_type : int = PercentType.MAX

const stacking_base_dmg_percent_amount__tier_01 : float = 40.0
const stacking_base_dmg_percent_amount__tier_02 : float = 28.0
const stacking_base_dmg_percent_amount__tier_03 : float = 16.0
const stacking_base_dmg_percent_amount__tier_04 : float = 8.0
var stacking_base_dmg_percent_type : int = PercentType.MAX

const enhanced_main_attack_count : int = 7

const enhanced_attack_total_duration : float = 10.0


var barrage_ability : BaseAbility
const barrage_ability_base_cd__tier_01 : float = 30.0
const barrage_ability_base_cd__tier_02 : float = 35.0
const barrage_ability_base_cd__tier_03 : float = 40.0
const barrage_ability_base_cd__tier_04 : float = 45.0
var _current_barrage_ability_base_cd : float

var barrage_ability_descs : Array

#

var game_elements : GameElements
var curr_tier : int


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	if barrage_ability_descs.size() == 0:
		
		
		var plain_fragment__stacking_attk_speed__vrb = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ATTACK_SPEED, "30% stacking total attack speed")
		var plain_fragment__stacking_base_dmg__vrb = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BASE_DAMAGE, "stacking total percent base damage")
		
		var interpreter_for_dmg_scale__vrb = TextFragmentInterpreter.new()
		interpreter_for_dmg_scale__vrb.display_body = true
		interpreter_for_dmg_scale__vrb.header_description = ""
		interpreter_for_dmg_scale__vrb.display_header = false
		
		var ins_for_dmg_scale__vrb = []
		#ins_for_dmg_scale__vrb.append(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "of the attack's damage", cone_explosion_dmg_percent_ratio * 100, true)
		ins_for_dmg_scale__vrb.append(NumericalTextFragment.new(cone_explosion_dmg_percent_ratio * 100, true, -1))
		ins_for_dmg_scale__vrb.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_dmg_scale__vrb.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_dmg_scale__vrb.array_of_instructions = ins_for_dmg_scale__vrb
		
		
		barrage_ability_descs = [
			["Barrage: All towers gain |0| and |1| on the next %s main attacks main attacks within %s seconds." % [enhanced_main_attack_count, enhanced_attack_total_duration], [plain_fragment__stacking_attk_speed__vrb, plain_fragment__stacking_base_dmg__vrb]],
			["The last attack on hit also explodes in a cone behind the first enemy hit, dealing |0| of the attack's damage to %s enemies." % [cone_explosion_pierce], [interpreter_for_dmg_scale__vrb]],
			"The last attack also consumes all the stacking buffs.",
			"Cooldown: Varies with tier.",
		]
		
	
	if barrage_ability == null:
		_construct_barrage_ability_relateds()
	
	#if beam_multiple_trail_component == null:
	#	_construct_beam_multiple_trail_component()
	
	curr_tier = tier
	
	
	if curr_tier == 1:
		_current_barrage_ability_base_cd = barrage_ability_base_cd__tier_01
	elif curr_tier == 2:
		_current_barrage_ability_base_cd = barrage_ability_base_cd__tier_02
	elif curr_tier == 3:
		_current_barrage_ability_base_cd = barrage_ability_base_cd__tier_03
	elif curr_tier == 4:
		_current_barrage_ability_base_cd = barrage_ability_base_cd__tier_04
	
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(game_elements : GameElements, tier : int):
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	
	curr_tier = 0
	
	._remove_syn_from_game_elements(game_elements, tier)


#


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_RB_V2_V02_EFFECT__GENERAL):
		var effect = TowerEffect_VioletRB_V2_V02_Effect.new()
		
		if curr_tier == 1:
			effect.stacking_attk_speed_percent_amount = stacking_attk_speed_percent_amount__tier_01
			effect.stacking_base_dmg_percent_amount = stacking_base_dmg_percent_amount__tier_01
			
		elif curr_tier == 2:
			effect.stacking_attk_speed_percent_amount = stacking_attk_speed_percent_amount__tier_02
			effect.stacking_base_dmg_percent_amount = stacking_base_dmg_percent_amount__tier_02
			
		elif curr_tier == 3:
			effect.stacking_attk_speed_percent_amount = stacking_attk_speed_percent_amount__tier_03
			effect.stacking_base_dmg_percent_amount = stacking_base_dmg_percent_amount__tier_03
			
		elif curr_tier == 4:
			effect.stacking_attk_speed_percent_amount = stacking_attk_speed_percent_amount__tier_04
			effect.stacking_base_dmg_percent_amount = stacking_base_dmg_percent_amount__tier_04
			
		
		effect.cone_explosion_dmg_percent_ratio = cone_explosion_dmg_percent_ratio
		effect.cone_explosion_pierce = cone_explosion_pierce
		
		effect.stacking_attk_speed_percent_type = stacking_attk_speed_percent_type
		effect.stacking_base_dmg_percent_type = stacking_base_dmg_percent_type
		
		effect.enhanced_main_attack_count = enhanced_main_attack_count
		
		#effect.beam_multiple_trail_component = beam_multiple_trail_component
		effect.base_trail_length__min = base_trail_length__min
		effect.base_trail_length__max = base_trail_length__max
		effect.base_trail_width__min = base_trail_width__min
		effect.base_trail_width__max = base_trail_width__max
		
		effect.id_for_beam_component = _next_id_for_effect__for_beam_component
		_next_id_for_effect__for_beam_component += 1
		
		connect("bararge_ability_activated", effect, "activate_effects_of_barrage", [], CONNECT_PERSIST)
		
		effect.is_timebound = false
		#effect.time_in_seconds = enhanced_attack_total_duration
		
		effect.time_of_buff = enhanced_attack_total_duration
		effect.status_bar_icon_to_use = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/AbilityAssets/VioRB_V02_Barrage_StatusBarIcon.png")
		
		
		tower.add_tower_effect(effect)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_RB_V2_V02_EFFECT__GENERAL)
	
	if effect != null:
		tower.remove_tower_effect(effect)
		
		disconnect("bararge_ability_activated", effect, "activate_effects_of_barrage")

##########

func _construct_barrage_ability_relateds():
	barrage_ability = BaseAbility.new()
	
	barrage_ability.is_timebound = true
	barrage_ability.connect("ability_activated", self, "_barrage_ability_activated", [], CONNECT_PERSIST)
	barrage_ability.icon = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/AbilityAssets/VioRB_V02_Barrage_AbilityIcon.png")
	
	barrage_ability.set_properties_to_usual_synergy_based()
	barrage_ability.synergy = self
	
	barrage_ability.descriptions = barrage_ability_descs
	barrage_ability.display_name = "Barrage"
	
	register_ability_to_manager(barrage_ability)
	

func register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	game_elements.ability_manager.add_ability(ability, add_to_panel)

#

#func _construct_beam_multiple_trail_component():
#	beam_multiple_trail_component = MultipleTrailsForNodeComponent.new()
#	beam_multiple_trail_component.node_to_host_trails = CommsForBetweenScenes.current_game_elements__other_node_hoster
#	beam_multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
#

##

func _barrage_ability_activated():
	emit_signal("bararge_ability_activated")
	
	barrage_ability.start_time_cooldown(_current_barrage_ability_base_cd)

