extends "res://GameInfoRelated/SharedTowerPassiveRelated/AbstractSharedTowerPassive.gd"

const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")


const ScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/ScreenTintEffect.gd")

const SolarSpirit_NoDebuff_AbilityIcon = preload("res://TowerRelated/Color_Green/LaNature/Assets/Ability/SolarSpirit_NoDebuff_AbilityIcon.png")
const SolarSpirit_WithDebuff_AbilityIcon = preload("res://TowerRelated/Color_Green/LaNature/Assets/Ability/SolarSpirit_WithDebuff_AbilityIcon.png")
const TorrentialTempest_NoDebuff_AbilityIcon = preload("res://TowerRelated/Color_Green/LaNature/Assets/Ability/TorrentialTempest_NoDebuff_AbilityIcon.png")
const TorrentialTempest_WithDebuff_AbilityIcon = preload("res://TowerRelated/Color_Green/LaNature/Assets/Ability/TorrentialTempest_WithDebuff_AbilityIcon.png")

const SolarSpirit_StatusBarIcon = preload("res://TowerRelated/Color_Green/LaNature/Assets/StatusBarIcons/SolarSpirit_StatusBarIcon.png")
const TorrentialTempest_StatusBarIcon = preload("res://TowerRelated/Color_Green/LaNature/Assets/StatusBarIcons/TorrentialTempest_StatusBarIcon.png")
const TorrentialTempest_TowerDebuff_StatusBarIcon = preload("res://TowerRelated/Color_Green/LaNature/Assets/StatusBarIcons/TorrentialTempest_DebuffToTowers_StatusBarIcon.png")

const solar_spirit_ability_name : String = "Solar Spirit"
const solar_spirit_base_attk_speed_percent : float = 50.0
const solar_spirit_bonus_attk_speed_per_use : float = 5.0
const solar_spirit_attk_speed_buff_duration : float = 8.0

const solar_spirit_debuff_count_threshold_inclusive : int = 4
const solar_spirit_base_self_damage_percent : float = 10.0
const solar_spirit_bonus_self_damage_per_use : float = 10.0
const solar_spirit_self_damage_max : float = 90.0

var current_solar_spirit_consecutive_uses : int
var solar_spirit_ability : BaseAbility

var solar_spirit_attk_speed_modi : PercentModifier
var solar_spirit_attk_speed_effect : TowerAttributesEffect


const torrential_tempest_ability_name : String = "Torrential Tempest"
const torrential_tempest_base_slow_percent : float = -50.0
const torrential_tempest_bonus_slow_per_use : float = -5.0
const torrential_tempest_max_slow_amount : float = -90.0
const torrential_tempest_slow_duration : float = 8.0

const torrential_tempest_debuff_count_threshold_inclusive : int = 4
const torrential_tempest_base_attk_speed_debuff_amount : float = -30.0
const torrential_tempest_bonus_attk_speed_per_use : float = -5.0
const torrential_tempest_attk_speed_debuff_max : float = -80.0
const torrential_tempest_debuff_duration : float = 8.0

var current_torrential_tempest_consecutive_uses : int
var torrential_tempest_ability : BaseAbility

var torrential_tempest_attk_speed_debuff_modi : PercentModifier
var torrential_tempest_attk_speed_debuff_effect : TowerAttributesEffect

var torrential_tempest_enemy_slow_modi : PercentModifier
var torrential_tempest_enemy_slow_effect : EnemyAttributesEffect

const ability_base_cooldowns : float = 45.0

#

var shared_passive_manager
var game_elements : GameElements

#

func _init():
	passive_id = StoreOfSharedPassiveUuid.LA_NATURE_ABILITIES

#

func _apply_passive_to_game_elements(arg_game_elements : GameElements):
	game_elements = arg_game_elements
	shared_passive_manager = arg_game_elements.shared_passive_manager
	
	game_elements.tower_manager.connect("tower_added", self, "_on_new_tower_added", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end", [], CONNECT_PERSIST)
	game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST)
	
	#
	
	_construct_and_connect_abilities()
	_construct_effects()
	
	_update_ability_display_and_activation_status()
	_update_counter_decrease_clause_of_abilities()


#

func _on_new_tower_added(arg_new_tower):
	if arg_new_tower.tower_id == Towers.LA_NATURE:
		_update_ability_display_and_activation_status()
		
		arg_new_tower.connect("tower_not_in_active_map", self, "_on_la_nature_not_in_active_map", [arg_new_tower], CONNECT_PERSIST)
		arg_new_tower.connect("tower_active_in_map", self, "_on_la_nature_active_in_map", [arg_new_tower], CONNECT_PERSIST)
		arg_new_tower.connect("on_tower_no_health", self, "_on_la_nature_lost_all_health", [arg_new_tower], CONNECT_PERSIST)
		arg_new_tower.connect("on_current_health_changed", self, "_on_la_nature_curr_health_changed", [arg_new_tower], CONNECT_PERSIST)
		arg_new_tower.connect("tree_exiting", self, "_on_la_nature_tree_exiting", [], CONNECT_PERSIST)

func _on_la_nature_not_in_active_map(arg_la_nature):
	_update_ability_display_and_activation_status()
	_update_counter_decrease_clause_of_abilities()
	

func _on_la_nature_active_in_map(arg_la_nature):
	_update_ability_display_and_activation_status()
	_update_counter_decrease_clause_of_abilities()

func _on_la_nature_lost_all_health(arg_la_nature):
	_update_ability_display_and_activation_status()
	_update_counter_decrease_clause_of_abilities()

func _on_la_nature_curr_health_changed(new_health_val, arg_la_nature):
	_update_ability_display_and_activation_status()
	_update_counter_decrease_clause_of_abilities()

func _on_la_nature_tree_exiting():
	_update_ability_display_and_activation_status()
	_update_counter_decrease_clause_of_abilities()

#

func _if_at_least_one_la_nature_is_active_and_alive_in_map() -> bool:
	var all_active_and_alive_towers = game_elements.tower_manager.get_all_active_and_alive_towers_except_in_queue_free()
	for tower in all_active_and_alive_towers:
		if tower.tower_id == Towers.LA_NATURE:
			return true
	
	return false

func _if_at_least_one_la_nature_is_active_in_map() -> bool:
	var all_active_towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in all_active_towers:
		if tower.tower_id == Towers.LA_NATURE:
			return true
	
	return false

#

func _construct_and_connect_abilities():
	solar_spirit_ability = BaseAbility.new()
	
	solar_spirit_ability.is_timebound = true
	solar_spirit_ability.connect("ability_activated", self, "_solar_spirit_ability_activated", [], CONNECT_PERSIST)
	solar_spirit_ability.icon = SolarSpirit_NoDebuff_AbilityIcon
	
	solar_spirit_ability.descriptions_source = self
	solar_spirit_ability.descriptions_source_func_name = "_get_solar_spirit_descriptions"
	solar_spirit_ability.display_name = solar_spirit_ability_name
	
	solar_spirit_ability.set_properties_to_auto_castable()
	solar_spirit_ability.auto_cast_func = "_solar_spirit_ability_activated"
	
	_register_ability_to_manager(solar_spirit_ability)
	
	#
	
	torrential_tempest_ability = BaseAbility.new()
	
	torrential_tempest_ability.is_timebound = true
	torrential_tempest_ability.connect("ability_activated", self, "_torrential_tempest_ability_activated", [], CONNECT_PERSIST)
	torrential_tempest_ability.icon = TorrentialTempest_NoDebuff_AbilityIcon
	
	torrential_tempest_ability.descriptions_source = self
	torrential_tempest_ability.descriptions_source_func_name = "_get_torrential_tempest_descriptions"
	torrential_tempest_ability.display_name = torrential_tempest_ability_name
	
	torrential_tempest_ability.set_properties_to_auto_castable()
	torrential_tempest_ability.auto_cast_func = "_torrential_tempest_ability_activated"
	
	_register_ability_to_manager(torrential_tempest_ability)


func _register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	game_elements.ability_manager.add_ability(ability, add_to_panel)


func _construct_effects():
	solar_spirit_attk_speed_modi = PercentModifier.new(StoreOfTowerEffectsUUID.LA_NATURE_SOLAR_SPIRIT_BONUS_ATTK_SPEED)
	solar_spirit_attk_speed_modi.percent_based_on = PercentType.BASE
	
	solar_spirit_attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, solar_spirit_attk_speed_modi, StoreOfTowerEffectsUUID.LA_NATURE_SOLAR_SPIRIT_BONUS_ATTK_SPEED)
	solar_spirit_attk_speed_effect.is_timebound = true
	solar_spirit_attk_speed_effect.time_in_seconds = solar_spirit_attk_speed_buff_duration
	solar_spirit_attk_speed_effect.status_bar_icon = SolarSpirit_StatusBarIcon
	
	#
	
	torrential_tempest_attk_speed_debuff_modi = PercentModifier.new(StoreOfTowerEffectsUUID.LA_NATURE_TORRENTIAL_TEMPEST_ATTK_SPEED_SLOW)
	torrential_tempest_attk_speed_debuff_modi.percent_based_on = PercentType.BASE
	
	torrential_tempest_attk_speed_debuff_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, torrential_tempest_attk_speed_debuff_modi, StoreOfTowerEffectsUUID.LA_NATURE_TORRENTIAL_TEMPEST_ATTK_SPEED_SLOW)
	torrential_tempest_attk_speed_debuff_effect.is_timebound = true
	torrential_tempest_attk_speed_debuff_effect.time_in_seconds = torrential_tempest_debuff_duration
	torrential_tempest_attk_speed_debuff_effect.status_bar_icon = TorrentialTempest_TowerDebuff_StatusBarIcon
	
	#
	
	torrential_tempest_enemy_slow_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.LA_NATURE_TORRENTIAL_TEMPEST_MOV_SPEED_SLOW)
	torrential_tempest_enemy_slow_modi.percent_based_on = PercentType.BASE
	
	torrential_tempest_enemy_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, torrential_tempest_enemy_slow_modi, StoreOfEnemyEffectsUUID.LA_NATURE_TORRENTIAL_TEMPEST_MOV_SPEED_SLOW)
	torrential_tempest_enemy_slow_effect.is_timebound = true
	torrential_tempest_enemy_slow_effect.time_in_seconds = torrential_tempest_slow_duration
	torrential_tempest_enemy_slow_effect.status_bar_icon = TorrentialTempest_StatusBarIcon
	torrential_tempest_enemy_slow_effect.is_from_enemy = false




#

func _update_ability_display_and_activation_status():
	if _if_at_least_one_la_nature_is_active_and_alive_in_map():
		solar_spirit_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ACTIVE_LA_NATURES)
		solar_spirit_ability.activation_conditional_clauses.remove_clause(BaseAbility.ActivationClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ALIVE_LA_NATURES)
		torrential_tempest_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ACTIVE_LA_NATURES)
		torrential_tempest_ability.activation_conditional_clauses.remove_clause(BaseAbility.ActivationClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ALIVE_LA_NATURES)
		
		
	elif _if_at_least_one_la_nature_is_active_in_map():
		solar_spirit_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ACTIVE_LA_NATURES)
		solar_spirit_ability.activation_conditional_clauses.attempt_insert_clause(BaseAbility.ActivationClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ALIVE_LA_NATURES)
		torrential_tempest_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ACTIVE_LA_NATURES)
		torrential_tempest_ability.activation_conditional_clauses.attempt_insert_clause(BaseAbility.ActivationClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ALIVE_LA_NATURES)
		
		
	else:
		solar_spirit_ability.should_be_displaying_clauses.attempt_insert_clause(BaseAbility.ShouldBeDisplayingClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ACTIVE_LA_NATURES)
		solar_spirit_ability.activation_conditional_clauses.attempt_insert_clause(BaseAbility.ActivationClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ALIVE_LA_NATURES)
		torrential_tempest_ability.should_be_displaying_clauses.attempt_insert_clause(BaseAbility.ShouldBeDisplayingClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ACTIVE_LA_NATURES)
		torrential_tempest_ability.activation_conditional_clauses.attempt_insert_clause(BaseAbility.ActivationClauses.PASSIVE_BEHAVIOR__LA_NATURE__NO_ALIVE_LA_NATURES)


#

func _on_round_end(curr_stageround):
	_update_counter_decrease_clause_of_abilities()

func _on_round_start(curr_stageround):
	_update_counter_decrease_clause_of_abilities()

func _update_counter_decrease_clause_of_abilities():
	if _if_at_least_one_la_nature_is_active_in_map() and game_elements.stage_round_manager.round_started:
		solar_spirit_ability.counter_decrease_clauses.remove_clause(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
		torrential_tempest_ability.counter_decrease_clauses.remove_clause(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
		
	else:
		solar_spirit_ability.counter_decrease_clauses.attempt_insert_clause(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
		torrential_tempest_ability.counter_decrease_clauses.attempt_insert_clause(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
		

#

func _solar_spirit_ability_activated():
	solar_spirit_ability.on_ability_before_cast_start(ability_base_cooldowns)
	
	var final_ap_scale : float = solar_spirit_ability.get_potency_to_use(1)
	
	#
	
	_give_solar_spirit_buffs_to_towers(final_ap_scale)
	if _if_solar_spirit_consecutive_use_count_is_on_or_beyond_threshold():
		_give_solar_spirit_self_damage_to_towers(final_ap_scale)
	
	#
	
	current_solar_spirit_consecutive_uses += 1
	current_torrential_tempest_consecutive_uses = 0
	
	solar_spirit_ability.start_time_cooldown(ability_base_cooldowns)
	torrential_tempest_ability.start_time_cooldown(ability_base_cooldowns)
	
	solar_spirit_ability.on_ability_after_cast_ended(ability_base_cooldowns)
	
	
	# Icon switch
	if _if_solar_spirit_consecutive_use_count_is_on_or_beyond_threshold():
		solar_spirit_ability.icon = SolarSpirit_WithDebuff_AbilityIcon
	torrential_tempest_ability.icon = TorrentialTempest_NoDebuff_AbilityIcon
	
	# Screen tint
	var solar_spirit_screen_effect = ScreenTintEffect.new()
	solar_spirit_screen_effect.main_duration = 1.5
	solar_spirit_screen_effect.fade_in_duration = 0.5
	solar_spirit_screen_effect.fade_out_duration = 0.5
	solar_spirit_screen_effect.tint_color = Color(1.0, 128.0 / 255.0, 0, 0.15)
	solar_spirit_screen_effect.ins_uuid = StoreOfScreenEffectsUUID.LA_NATURE__SOLAR_SPIRIT
	solar_spirit_screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS
	game_elements.screen_effect_manager.add_screen_tint_effect(solar_spirit_screen_effect)
	

func _give_solar_spirit_buffs_to_towers(arg_scale : float):
	for tower in game_elements.tower_manager.get_all_active_and_alive_towers_except_in_queue_free():
		var amount = _get_current_attack_speed_from_solar_spirit()
		solar_spirit_attk_speed_modi.percent_amount = amount * arg_scale
		
		tower.add_tower_effect(solar_spirit_attk_speed_effect._get_copy_scaled_by(1))

func _give_solar_spirit_self_damage_to_towers(arg_scale : float):
	for tower in game_elements.tower_manager.get_all_active_and_alive_towers_except_in_queue_free():
		var damage_percent_amount = _get_current_self_damage_from_solar_spirit()
		
		tower.take_damage(arg_scale * tower.last_calculated_max_health * (damage_percent_amount) / 100)



#

func _torrential_tempest_ability_activated():
	torrential_tempest_ability.on_ability_before_cast_start(ability_base_cooldowns)
	
	var final_ap_scale : float = torrential_tempest_ability.get_potency_to_use(1)
	
	#
	
	_give_torrential_tempest_slow_to_all_enemies(final_ap_scale)
	if _if_torrential_tempest_consecutive_use_count_is_on_or_beyond_threshold():
		_give_torrential_tempest_attk_speed_debuff_to_towers(final_ap_scale)
	
	#
	
	current_torrential_tempest_consecutive_uses += 1
	current_solar_spirit_consecutive_uses = 0
	
	solar_spirit_ability.start_time_cooldown(ability_base_cooldowns)
	torrential_tempest_ability.start_time_cooldown(ability_base_cooldowns)
	
	torrential_tempest_ability.on_ability_after_cast_ended(ability_base_cooldowns)
	
	
	# Icon
	if _if_torrential_tempest_consecutive_use_count_is_on_or_beyond_threshold():
		torrential_tempest_ability.icon = TorrentialTempest_WithDebuff_AbilityIcon
	solar_spirit_ability.icon = SolarSpirit_NoDebuff_AbilityIcon
	
	# Screen Tint
	var torrential_tempest_screen_effect = ScreenTintEffect.new()
	torrential_tempest_screen_effect.main_duration = 1.5
	torrential_tempest_screen_effect.fade_in_duration = 0.5
	torrential_tempest_screen_effect.fade_out_duration = 0.5
	torrential_tempest_screen_effect.tint_color = Color(77.0 / 255.0, 108.0 / 255.0, 253.0 / 255.0, 0.15)
	torrential_tempest_screen_effect.ins_uuid = StoreOfScreenEffectsUUID.LA_NATURE__TORRENTIAL_TEMPEST
	torrential_tempest_screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS
	game_elements.screen_effect_manager.add_screen_tint_effect(torrential_tempest_screen_effect)
	


func _give_torrential_tempest_slow_to_all_enemies(arg_scale : float):
	for enemy in game_elements.enemy_manager.get_all_targetable_and_invisible_enemies():
		var amount = _get_current_enemy_slow_from_torrential_tempest()
		torrential_tempest_enemy_slow_modi.percent_amount = amount * arg_scale
		
		enemy._add_effect(torrential_tempest_enemy_slow_effect)

func _give_torrential_tempest_attk_speed_debuff_to_towers(arg_scale : float):
	for tower in game_elements.tower_manager.get_all_active_and_alive_towers_except_in_queue_free():
		var amount = _get_current_tower_attk_speed_debuff_from_torrential_tempest()
		torrential_tempest_attk_speed_debuff_modi.percent_amount = amount * arg_scale
		
		tower.add_tower_effect(torrential_tempest_attk_speed_debuff_effect._get_copy_scaled_by(1))



# Solar Spirit desc and calcs

func _if_solar_spirit_consecutive_use_count_is_on_or_beyond_threshold():
	return current_solar_spirit_consecutive_uses >= solar_spirit_debuff_count_threshold_inclusive - 1

func _get_current_attack_speed_from_solar_spirit():
	return solar_spirit_base_attk_speed_percent + (solar_spirit_bonus_attk_speed_per_use * current_solar_spirit_consecutive_uses)

func _get_current_self_damage_from_solar_spirit():
	if !_if_solar_spirit_consecutive_use_count_is_on_or_beyond_threshold():
		return 0
	else:
		var amount = solar_spirit_base_self_damage_percent + (solar_spirit_bonus_self_damage_per_use * (current_solar_spirit_consecutive_uses - (solar_spirit_debuff_count_threshold_inclusive - 1)))
		if amount > solar_spirit_self_damage_max:
			amount = solar_spirit_self_damage_max
		
		return amount

func _get_solar_spirit_descriptions() -> Array:
	# ins start
	var interpreter_for_base_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_base_attk_speed.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_base_attk_speed.display_body = false
	
	var ins_for_base_attk_speed = []
	ins_for_base_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", solar_spirit_base_attk_speed_percent, true))
	
	interpreter_for_base_attk_speed.array_of_instructions = ins_for_base_attk_speed
	
	#
	var interpreter_for_attk_speed_per_stack = TextFragmentInterpreter.new()
	interpreter_for_attk_speed_per_stack.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_attk_speed_per_stack.display_body = false
	
	var ins_for_attk_speed_per_stack = []
	ins_for_attk_speed_per_stack.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "", solar_spirit_bonus_attk_speed_per_use, true))
	
	interpreter_for_attk_speed_per_stack.array_of_instructions = ins_for_attk_speed_per_stack
	
	#
	var interpreter_for_curr_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_curr_attk_speed.tower_to_use_for_tower_stat_fragments = self
	interpreter_for_curr_attk_speed.display_body = false
	
	var ins_for_curr_attk_speed = []
	ins_for_curr_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", _get_current_attack_speed_from_solar_spirit(), true))
	
	interpreter_for_curr_attk_speed.array_of_instructions = ins_for_curr_attk_speed
	
	
	# ins end
	
	return [
		["Imbue the solar spirit onto all towers, giving them |0| for %s seconds." % [str(solar_spirit_attk_speed_buff_duration)], [interpreter_for_base_attk_speed]],
		["Each consecutive use of Solar Spirit increases the attack speed buff by |0|.", [interpreter_for_attk_speed_per_stack]],
		"After the 3rd consecutive use, damage all towers by %s%% of their max health, increasing by %s per use, up to %s%%." % [str(solar_spirit_base_self_damage_percent), str(solar_spirit_bonus_self_damage_per_use), str(solar_spirit_self_damage_max)],
		"",
		"Shares cooldown with Torrential Tempest. Cooldown: %s s" % [str(ability_base_cooldowns)],
		"",
		"Number of consecutive use: %s" % [str(current_solar_spirit_consecutive_uses)],
		["Current attack speed buff: |0|", [interpreter_for_curr_attk_speed]],
		"Current self damage: %s%%" % [str(_get_current_self_damage_from_solar_spirit())]
	]


# Torrential Tempest desc and calcs

func _if_torrential_tempest_consecutive_use_count_is_on_or_beyond_threshold():
	return current_torrential_tempest_consecutive_uses >= torrential_tempest_debuff_count_threshold_inclusive - 1

func _get_current_enemy_slow_from_torrential_tempest():
	var amount = torrential_tempest_base_slow_percent + (torrential_tempest_bonus_slow_per_use * (current_torrential_tempest_consecutive_uses))
	if amount < torrential_tempest_max_slow_amount:
		amount = torrential_tempest_max_slow_amount
	
	return amount

func _get_current_tower_attk_speed_debuff_from_torrential_tempest():
	if !_if_torrential_tempest_consecutive_use_count_is_on_or_beyond_threshold():
		return 0
	else:
		var amount = torrential_tempest_base_attk_speed_debuff_amount + (torrential_tempest_bonus_attk_speed_per_use * (current_torrential_tempest_consecutive_uses - (torrential_tempest_debuff_count_threshold_inclusive - 1)))
		if amount < torrential_tempest_attk_speed_debuff_max:
			amount = torrential_tempest_attk_speed_debuff_max
		
		return amount

func _get_torrential_tempest_descriptions() -> Array:
	return [
		"Summon a tempest that slows all enemies by %s%% for %s seconds" % [str(-torrential_tempest_base_slow_percent), str(torrential_tempest_slow_duration)],
		"Each consecutive use of Torrential Tempest increases the slow by %s, up to %s" % [str(-torrential_tempest_bonus_slow_per_use), str(-torrential_tempest_max_slow_amount)],
		"After the 3rd consecutive use, slow the attack speed of all towers by %s%%, increasing by %s per use, up to %s%%." % [str(-torrential_tempest_base_attk_speed_debuff_amount), str(-torrential_tempest_bonus_attk_speed_per_use), str(-torrential_tempest_attk_speed_debuff_max)],
		"",
		"Shares cooldown with Solar Spirit. Cooldown: %s s" % [str(ability_base_cooldowns)],
		"",
		"Number of consecutive use: %s" % [str(current_torrential_tempest_consecutive_uses)],
		"Current enemy mov slow: %s%%" % [str(-_get_current_enemy_slow_from_torrential_tempest())],
		"Current tower attk speed slow: %s%%" % [str(-_get_current_tower_attk_speed_debuff_from_torrential_tempest())]
	]


############

# USED ONLY WHEN UN-LOADING GAME, not to be used when conditions are not met
func _remove_passive_from_game_elements(arg_game_elements : GameElements):
	game_elements.tower_manager.disconnect("tower_added", self, "_on_new_tower_added")
	game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end")
	game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_start")
	
	

#



