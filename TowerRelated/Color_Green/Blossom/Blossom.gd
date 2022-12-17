extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerBeamConnectionComponent = preload("res://MiscRelated/CommonComponents/TowerBeamConnectionComponent.gd")
const Blossom_ConnectionBeamPic = preload("res://TowerRelated/Color_Green/Blossom/Blossom_ConnectionBeam.png")
const SetPartner_Pic = preload("res://TowerRelated/Color_Green/Blossom/AbilityPanel/SetPartner_ButtonImage.png")
const UnassignPartner_Pic = preload("res://TowerRelated/Color_Green/Blossom/AbilityPanel/UnassignPartner_ButtonImage.png")

const attk_speed_amount : float = 20.0
const attk_speed_flat_maximum : float = 2.0

const base_dmg_amount : float = 20.0
const base_dmg_flat_maximum : float = 4.0

const omnivamp_amount : float = 2.0

const effect_vulnerability_amount : float = -50.0

const unpaired_frame_index : int = 0
const paired_frame_index : int = 1
const dead_frame_index : int = 2


const cannot_assign_new_partner_clause : int = -10
const cannot_unassign_curr_partner_clause : int = -10

signal can_assign_partner_status_changed(can_assign)
signal can_unassign_current_partner_status_changed(can_unassign)

signal partner_tower_assigned_changed(partner_tower)
signal showing_partner_connection_status_changed(is_showing)


var partner_tower

var total_attk_speed_effect : TowerAttributesEffect
var total_base_damage_effect : TowerAttributesEffect
var percent_omnivamp_effect : TowerAttributesEffect
var effect_vulnerability_effect : TowerAttributesEffect
var blossom_mark_effect : TowerMarkEffect

var partner_assign_ability : BaseAbility
var partner_assign_activation_clauses : ConditionalClauses

var partner_unassign_ability : BaseAbility
var partner_unassign_activation_clauses : ConditionalClauses

var tower_beam_connection_component : TowerBeamConnectionComponent
var is_showing_partner_connection : bool setget ,is_showing_partner_connection


var is_showing_select_partner_beam : bool = false


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BLOSSOM)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	#
	_construct_effects()
	_construct_beam_connection_component()
	_construct_abilities()
	
	connect("on_round_end", self, "_on_round_end_b", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_on_round_start_b", [], CONNECT_PERSIST)
	connect("on_current_health_changed", self, "_on_current_health_chaged_b", [], CONNECT_PERSIST)
	connect("tower_not_in_active_map", self, "_on_self_placed_in_bench", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


# effects

func _construct_effects():
	var total_attk_speed_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.BLOSSOM_TOTAL_ATTK_SPEED_BUFF)
	total_attk_speed_modi.percent_amount = attk_speed_amount
	total_attk_speed_modi.ignore_flat_limits = false
	total_attk_speed_modi.flat_maximum = attk_speed_flat_maximum
	
	total_attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, total_attk_speed_modi, StoreOfTowerEffectsUUID.BLOSSOM_TOTAL_ATTK_SPEED_BUFF)
	total_attk_speed_effect.is_timebound = false
	
	
	var total_base_damage_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.BLOSSOM_TOTAL_BASE_DMG_BUFF)
	total_base_damage_modi.percent_amount = base_dmg_amount
	total_base_damage_modi.ignore_flat_limits = false
	total_base_damage_modi.flat_maximum = base_dmg_flat_maximum
	
	total_base_damage_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS, total_base_damage_modi, StoreOfTowerEffectsUUID.BLOSSOM_TOTAL_BASE_DMG_BUFF)
	total_base_damage_effect.is_timebound = false
	
	
	var percent_vamp_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.BLOSSOM_PERCENT_DMG_OMNIVAMP_BUFF)
	percent_vamp_modi.percent_amount = omnivamp_amount
	
	percent_omnivamp_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_DAMAGE_OMNIVAMP, percent_vamp_modi, StoreOfTowerEffectsUUID.BLOSSOM_PERCENT_DMG_OMNIVAMP_BUFF)
	percent_omnivamp_effect.is_timebound = false
	
	blossom_mark_effect = TowerMarkEffect.new(StoreOfTowerEffectsUUID.BLOSSOM_MARK_EFFECT)
	
	
	var effect_vul_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.BLOSSOM_EFFECT_VUL_EFFECT)
	effect_vul_modi.percent_amount = effect_vulnerability_amount
	effect_vul_modi.percent_based_on = PercentType.BASE
	
	effect_vulnerability_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_ENEMY_EFFECT_VULNERABILITY, effect_vul_modi, StoreOfTowerEffectsUUID.BLOSSOM_EFFECT_VUL_EFFECT)
	effect_vulnerability_effect.is_timebound = false


# signals

func _on_round_end_b():
	_update_sprite_display()
	_emit_can_assign_new_partner()
	_emit_can_unassign_current_partner()

func _on_round_start_b():
	_emit_can_assign_new_partner()
	_emit_can_unassign_current_partner()


func _on_current_health_chaged_b(curr_health):
	_update_sprite_display()
	
	if curr_health > 0:
		_add_effects_to_partner()
	else:
		_remove_benefitting_effects_from_partner()


# sprite display related

func _update_sprite_display():
	if current_health > 0:
		if !is_instance_valid(partner_tower):
			tower_base_sprites.frame = unpaired_frame_index
		else:
			tower_base_sprites.frame = paired_frame_index
	else:
		tower_base_sprites.frame = dead_frame_index


# Partner related

func can_assign_new_partner() -> bool:
	return !is_instance_valid(partner_tower) or !is_round_started

func _emit_can_assign_new_partner():
	emit_signal("can_assign_partner_status_changed", can_assign_new_partner())

func can_unassign_current_partner() -> bool:
	return is_instance_valid(partner_tower) and !is_round_started

func _emit_can_unassign_current_partner():
	emit_signal("can_unassign_current_partner_status_changed" , can_unassign_current_partner())


func assign_new_tower_partner(tower):
	if _can_assign_tower_as_partner(tower):
		
		if is_instance_valid(partner_tower):
			unassign_current_partner()
		
		partner_tower = tower
		_add_effects_to_partner()
		
		if !partner_tower.is_connected("on_tower_no_health", self, "_on_partner_zero_health_reached"):
			partner_tower.connect("on_tower_no_health", self, "_on_partner_zero_health_reached", [], CONNECT_PERSIST)
			partner_tower.connect("tree_exiting", self, "_on_partner_tree_exiting", [], CONNECT_PERSIST)
			partner_tower.connect("tower_not_in_active_map", self, "_on_partner_not_in_map", [], CONNECT_PERSIST)
		
		if partner_tower.current_health <= 0:
			_on_partner_zero_health_reached()
		
		tower_beam_connection_component.attempt_add_connection_to_node(partner_tower)
		
		_partner_changed()
	
	
	is_showing_select_partner_beam = false

func _can_assign_tower_as_partner(tower) -> bool:
	return is_instance_valid(tower) and partner_tower != tower and tower.is_current_placable_in_map() and !tower is get_script() and !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLOSSOM_MARK_EFFECT)


func unassign_current_partner():
	if is_instance_valid(partner_tower):
		if partner_tower.is_connected("on_tower_no_health", self, "_on_partner_zero_health_reached"):
			partner_tower.disconnect("on_tower_no_health", self, "_on_partner_zero_health_reached")
			partner_tower.disconnect("tree_exiting", self, "_on_partner_tree_exiting")
			partner_tower.disconnect("tower_not_in_active_map", self, "_on_partner_not_in_map")
		
		_remove_all_effects_from_partner()
		
		tower_beam_connection_component.remove_connection_of_node(partner_tower)
		
		partner_tower = null
		_partner_changed()


func _partner_changed():
	_emit_can_assign_new_partner()
	_emit_can_unassign_current_partner()
	emit_signal("partner_tower_assigned_changed", partner_tower)
	
	_update_sprite_display()


func _on_partner_tree_exiting():
	unassign_current_partner()

func _on_partner_not_in_map():
	unassign_current_partner()


func _on_self_placed_in_bench():
	unassign_current_partner()

func queue_free():
	unassign_current_partner()
	
	.queue_free()


# partner effects related

func _on_partner_zero_health_reached():
	_attempt_revive_partner()

func _attempt_revive_partner():
	if current_health > 0:
		partner_tower.heal_by_amount(partner_tower.last_calculated_max_health, true)
		take_damage(current_health)


func _add_effects_to_partner():
	if is_instance_valid(partner_tower):
		if !partner_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLOSSOM_MARK_EFFECT):
			partner_tower.add_tower_effect(total_attk_speed_effect)
			partner_tower.add_tower_effect(total_base_damage_effect)
			partner_tower.add_tower_effect(percent_omnivamp_effect)
			partner_tower.add_tower_effect(blossom_mark_effect)
			partner_tower.add_tower_effect(effect_vulnerability_effect)


func _remove_benefitting_effects_from_partner():
	if is_instance_valid(partner_tower):
		if partner_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLOSSOM_TOTAL_ATTK_SPEED_BUFF):
			partner_tower.remove_tower_effect(total_attk_speed_effect)
			partner_tower.remove_tower_effect(total_base_damage_effect)
			partner_tower.remove_tower_effect(percent_omnivamp_effect)
			partner_tower.remove_tower_effect(effect_vulnerability_effect)


func _remove_all_effects_from_partner():
	if is_instance_valid(partner_tower):
		_remove_benefitting_effects_from_partner()
		
		if partner_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.BLOSSOM_MARK_EFFECT):
			partner_tower.remove_tower_effect(blossom_mark_effect)


# Showing/Hiding connection

func _construct_beam_connection_component():
	tower_beam_connection_component = TowerBeamConnectionComponent.new()
	tower_beam_connection_component.owning_node = self
	tower_beam_connection_component.texture_for_beam = Blossom_ConnectionBeamPic
	
	tower_beam_connection_component.connect("showing_connection_mode_changed", self, "_showing_connection_mode_changed", [], CONNECT_PERSIST)


func show_partner_connection():
	tower_beam_connection_component.show_beam_connections()

func hide_partner_connection():
	tower_beam_connection_component.hide_beam_connections()

func is_showing_partner_connection() -> bool:
	return tower_beam_connection_component._is_showing_beam_connections

func _showing_connection_mode_changed(is_showing):
	emit_signal("showing_partner_connection_status_changed", is_showing)



# Partner adding/removing ability

func _construct_abilities():
	# Set Partner Ability
	partner_assign_ability = BaseAbility.new()
	
	partner_assign_ability.is_timebound = true
	partner_assign_ability.connect("ability_activated", self, "_assign_ability_activated", [], CONNECT_PERSIST)
	partner_assign_ability.icon = SetPartner_Pic
	
	partner_assign_ability.set_properties_to_usual_tower_based()
	partner_assign_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	partner_assign_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	partner_assign_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	partner_assign_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	
	partner_assign_ability.tower = self
	
	partner_assign_ability.descriptions = [
		"Assign a partner to Blossom.",
		"If no tower is hovered by your mouse, a prompt is shown to select the member.",
		"This cannot be used when the round is ongoing."
	]
	partner_assign_ability.display_name = "(Re)Assign Partner"
	
	register_ability_to_manager(partner_assign_ability, false)
	partner_assign_activation_clauses = partner_assign_ability.activation_conditional_clauses
	
	
	# Unassign Partner Ability
	partner_unassign_ability = BaseAbility.new()
	
	partner_unassign_ability.is_timebound = true
	partner_unassign_ability.connect("ability_activated", self, "_unassign_ability_activated", [], CONNECT_PERSIST)
	partner_unassign_ability.icon = UnassignPartner_Pic
	
	partner_unassign_ability.set_properties_to_usual_tower_based()
	partner_unassign_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	partner_unassign_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	partner_unassign_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	partner_unassign_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	
	partner_unassign_ability.tower = self
	
	partner_unassign_ability.descriptions = [
		"Unassigns current partner of Blossom",
		"This cannot be used when the round is ongoing."
	]
	partner_unassign_ability.display_name = "Unassign Partner"
	
	register_ability_to_manager(partner_unassign_ability, false)
	partner_unassign_activation_clauses = partner_unassign_ability.activation_conditional_clauses
	
	#
	_link_abilities_to_signals()

func _link_abilities_to_signals():
	connect("can_assign_partner_status_changed", self, "_can_assign_partner_status_changed", [], CONNECT_PERSIST)
	connect("can_unassign_current_partner_status_changed", self, "_can_unassign_partner_status_changed", [], CONNECT_PERSIST)
	
	_can_assign_partner_status_changed(can_assign_new_partner())
	_can_unassign_partner_status_changed(can_unassign_current_partner())


func _can_assign_partner_status_changed(can_assign):
	if can_assign:
		partner_assign_activation_clauses.remove_clause(cannot_assign_new_partner_clause)
	else:
		partner_assign_activation_clauses.attempt_insert_clause(cannot_assign_new_partner_clause)

func _can_unassign_partner_status_changed(can_unassign):
	if can_unassign:
		partner_unassign_activation_clauses.remove_clause(cannot_unassign_curr_partner_clause)
	else:
		partner_unassign_activation_clauses.attempt_insert_clause(cannot_unassign_curr_partner_clause)


func _unassign_ability_activated():
	unassign_current_partner()

func _assign_ability_activated():
	var mouse_hovered_tower = tower_manager.get_tower_on_mouse_hover()
	if is_instance_valid(mouse_hovered_tower):
		assign_new_tower_partner(mouse_hovered_tower)
		
		if !input_prompt_manager.can_prompt():
			input_prompt_manager.cancel_selection()
		
		_assign_cancelled()
	else:
		if input_prompt_manager.can_prompt():
			input_prompt_manager.prompt_select_tower(self, "assign_new_tower_partner", "_assign_cancelled", "_can_assign_tower_as_partner")
			is_showing_select_partner_beam = true
		else:
			_assign_cancelled()
			input_prompt_manager.cancel_selection()
			

func _assign_cancelled():
	is_showing_select_partner_beam = false



##########

func _process(delta):
	update()

func _draw():
	if is_showing_select_partner_beam:
		var mouse_pos = get_global_mouse_position()
		draw_line(Vector2(0, 0), mouse_pos - global_position, Color(19/255.0, 154/255.0, 51/255.0), 3)



# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 1
	.set_heat_module(module)

func _construct_heat_effect():
	var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	attr_mod.flat_modifier = 10
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_HEALTH , attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	_calculate_max_health()
