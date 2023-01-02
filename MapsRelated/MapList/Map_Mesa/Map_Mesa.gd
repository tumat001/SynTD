extends "res://MapsRelated/BaseMap.gd"

const Mesa_ChoiceDetails = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/Subs/Mesa_ChoiceDetails.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const ScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/ScreenTintEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")

const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")
const StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")

const Sandstorm_AbilityPic = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/Assets/Ability_Sandstorm_Icon.png")

const Mesa_WholeScreenChoices_Scene = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI/WholeScreen/Mesa_WholeScreenChoices.tscn")
const Mesa_WholeScreenChoices = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI/WholeScreen/Mesa_WholeScreenChoices.gd")


var game_elements

var choice_details__duned : Mesa_ChoiceDetails
var choice_details__sandstorm : Mesa_ChoiceDetails
var choice_details__treasure : Mesa_ChoiceDetails

var all_choice_details : Array

var choice_prompt_stageround_id : String = "11"

var reservation_for_whole_screen_gui
var mesa_whole_screen_choices : Mesa_WholeScreenChoices

#

const sandstorm_damage : float = 0.75
const sandstorm_base_cooldown : float = 40.0
const sandstorm_slow_amount : float = -35.0
const sandstorm_slow_duration : float = 5.0

var sandstorm_ability : BaseAbility

#

const treasure_relic_amount : int = 1
const treasure_gold_amount : int = 12

const treasure_stageround_id_given : String = "61"

var _treasure_given : bool

#

func _apply_map_specific_changes_to_game_elements(arg_game_elements):
	._apply_map_specific_changes_to_game_elements(arg_game_elements)
	
	arg_game_elements.enemy_manager.current_path_to_spawn_pattern = arg_game_elements.enemy_manager.PathToSpawnPattern.SWITCH_PER_SPAWN
	
	game_elements = arg_game_elements
	_initialize_mesa_choice_details()
	
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end__for_choices", [], CONNECT_PERSIST)

######

func _initialize_mesa_choice_details():
	choice_details__duned = Mesa_ChoiceDetails.new(self)
	choice_details__duned.icon = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/Choice_Duned_Icon.png")
	choice_details__duned.choice_name = "Duned"
	
	choice_details__duned.border_texture_normal = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/RedLine_7x7.png")
	choice_details__duned.border_texture_highlighted = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/RedLine_7x7_Highlighted.png")
	
	choice_details__duned.on_chosen_method_name = "_on_duned_choice_selected"
	
	var plain_fragment__duned = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Duned")
	var plain_fragment__bonus_base_damage = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BASE_DAMAGE, "bonus base damage")
	
	choice_details__duned.descriptions = [
		["Gain a |0|, a long ranged, colorless tower that can see through terrain. Does not take tower slots.", [plain_fragment__duned]],
		["Duned gains |0| based on the stage number.", [plain_fragment__bonus_base_damage]]
	]
	
	all_choice_details.append(choice_details__duned)
	
	#########
	
	choice_details__sandstorm = Mesa_ChoiceDetails.new(self)
	choice_details__sandstorm.icon = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/Choice_Sandstorm_Icon.png")
	choice_details__sandstorm.choice_name = "Sandstorm"
	
	choice_details__sandstorm.border_texture_normal = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/BrownLine_7x7.png")
	choice_details__sandstorm.border_texture_highlighted = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/BrownLine_7x7_Highlighted.png")
	
	choice_details__sandstorm.on_chosen_method_name = "_on_sandstorm_choice_selected"
	
	var plain_fragment__sandstorm = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Sandstorm")
	var plain_fragment__slows = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "slows")
	
	var interpreter_for_sandstorm_dmg = TextFragmentInterpreter.new()
	interpreter_for_sandstorm_dmg.display_body = false
	
	var ins_for_sandstorm_dmg = []
	ins_for_sandstorm_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", sandstorm_damage))
	
	interpreter_for_sandstorm_dmg.array_of_instructions = ins_for_sandstorm_dmg
	
	
	choice_details__sandstorm.descriptions = [
		["Gain |0|, an ability that |1| all enemies by %s%% for %s seconds, and deals |2|." % [-sandstorm_slow_amount, sandstorm_slow_duration], [plain_fragment__sandstorm, plain_fragment__slows, interpreter_for_sandstorm_dmg]],
		"Cooldown: %s s." % sandstorm_base_cooldown
	]
	
	all_choice_details.append(choice_details__sandstorm)
	
	
	#####
	
	choice_details__treasure = Mesa_ChoiceDetails.new(self)
	choice_details__treasure.icon = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/Choice_Chest_Icon.png")
	choice_details__treasure.choice_name = "Treasure"
	
	choice_details__treasure.border_texture_normal = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/YellowLine_7x7.png")
	choice_details__treasure.border_texture_highlighted = preload("res://MapsRelated/MapList/Map_Mesa/BehaviorSpecific/GUI_Assets/YellowLine_7x7_Highlighted.png")
	
	choice_details__treasure.on_chosen_method_name = "_on_treasure_choice_selected"
	
	
	var plain_fragment__x_relic = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.RELIC, "%s relic" % treasure_relic_amount)
	var plain_fragment__x_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s gold" % treasure_gold_amount)
	
	var stage_and_round_with_dash = StageRound.convert_stageround_id_to_stage_and_round_string_with_dash(treasure_stageround_id_given)
	
	
	choice_details__treasure.descriptions = [
		["Gain |0| and |1| at stage-round: %s." % [stage_and_round_with_dash], [plain_fragment__x_relic, plain_fragment__x_gold]]
	]
	
	all_choice_details.append(choice_details__treasure)
	

#####

func _on_round_end__for_choices(arg_stageround : StageRound):
	if StageRound.is_stageround_id_higher_or_equal_than_second_param(arg_stageround.id, choice_prompt_stageround_id):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end__for_choices")
		
		_initialize_queue_reservation()
		_initialize_and_show_mesa_whole_screen_choices()

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	#reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	#reservation_for_whole_screen_gui.on_removed_method

func _initialize_and_show_mesa_whole_screen_choices():
	if !is_instance_valid(mesa_whole_screen_choices):
		mesa_whole_screen_choices = Mesa_WholeScreenChoices_Scene.instance()
		mesa_whole_screen_choices.set_choices(all_choice_details)
	
	game_elements.whole_screen_gui.queue_control(mesa_whole_screen_choices, reservation_for_whole_screen_gui, true, false)



#########

func _on_duned_choice_selected():
	_summon_duned_tower()
	_on_any_choice_selected()

func _on_sandstorm_choice_selected():
	_construct_and_add_sandstorm_ability()
	_on_any_choice_selected()

func _on_treasure_choice_selected():
	_listen_for_stage_round_changes_for_treasure()
	_on_any_choice_selected()


func _on_any_choice_selected():
	game_elements.whole_screen_gui.connect("hide_process_of_control_complete", self, "_on_hide_process_of_control_complete", [], CONNECT_PERSIST)
	game_elements.whole_screen_gui.hide_control(mesa_whole_screen_choices)
	

func _on_hide_process_of_control_complete(arg_control):
	if arg_control == mesa_whole_screen_choices:
		mesa_whole_screen_choices.call_deferred("queue_free")

###

func _summon_duned_tower():
	 game_elements.tower_inventory_bench.insert_tower_from_last(Towers.DUNED)
	

func _construct_and_add_sandstorm_ability():
	sandstorm_ability = BaseAbility.new()
	
	sandstorm_ability.is_timebound = true
	sandstorm_ability.connect("ability_activated", self, "_on_sandstorm_ability_activated", [], CONNECT_PERSIST)
	
	sandstorm_ability.icon = Sandstorm_AbilityPic
	
	
	#var plain_fragment__sandstorm = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Sandstorm")
	var plain_fragment__slow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "Slow")
	
	var interpreter_for_sandstorm_dmg = TextFragmentInterpreter.new()
	interpreter_for_sandstorm_dmg.display_body = false
	
	var ins_for_sandstorm_dmg = []
	ins_for_sandstorm_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", sandstorm_damage))
	
	interpreter_for_sandstorm_dmg.array_of_instructions = ins_for_sandstorm_dmg
	
	sandstorm_ability.display_name = "Sandstorm"
	sandstorm_ability.descriptions = [
		["|0| all enemies by %s%% for %s seconds, and deal |1|." % [-sandstorm_slow_amount, sandstorm_slow_duration], [plain_fragment__slow, interpreter_for_sandstorm_dmg]],
		"Cooldown: %s s." % sandstorm_base_cooldown
	]
	
	sandstorm_ability.set_properties_to_auto_castable()
	sandstorm_ability.auto_cast_func = "_on_sandstorm_ability_activated"
	
	register_ability_to_manager(sandstorm_ability)
	
	###


func register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	game_elements.ability_manager.add_ability(ability, add_to_panel)


func _on_sandstorm_ability_activated():
	var ap_scaling : float = sandstorm_ability.get_potency_to_use(1)
	
	game_elements.enemy_manager.add_effect_to_apply_on_enemy_spawn__time_reduced_by_process(_construct_sandstorm_slow_effect(ap_scaling))
	
	#
	
	var dmg_modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.MAP_MESA__SANDSTORM_DMG)
	dmg_modi.flat_modifier = sandstorm_damage * ap_scaling
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.MAP_MESA__SANDSTORM_DMG, dmg_modi, DamageType.ELEMENTAL)
	var dmg_instance : DamageInstance = DamageInstance.new()
	dmg_instance.on_hit_damages[StoreOfTowerEffectsUUID.MAP_MESA__SANDSTORM_DMG] = on_hit_dmg
	dmg_instance.on_hit_effects[StoreOfEnemyEffectsUUID.MAP_MESA__SANDSTORM_SLOW] = _construct_sandstorm_slow_effect(ap_scaling)
	
	var sandstorm_screen_effect = ScreenTintEffect.new()
	sandstorm_screen_effect.main_duration = sandstorm_slow_duration - 1.25
	sandstorm_screen_effect.fade_in_duration = 0.5
	sandstorm_screen_effect.fade_out_duration = 0.5
	sandstorm_screen_effect.tint_color = Color(153.0 / 255.0, 99/255.0, 67/255.0, 0.45)
	sandstorm_screen_effect.ins_uuid = StoreOfScreenEffectsUUID.MAP_MESA__SANDSTORM
	sandstorm_screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS
	game_elements.screen_effect_manager.add_screen_tint_effect(sandstorm_screen_effect)
	
	for enemy in game_elements.enemy_manager.get_all_targetable_and_invisible_enemies():
		call_deferred("_apply_sandstorm_slow_to_enemy", enemy, dmg_instance)
	
	sandstorm_ability.start_time_cooldown(sandstorm_base_cooldown)


func _construct_sandstorm_slow_effect(ap_scaling):
	var sandstorm_slow_modifier = PercentModifier.new(StoreOfEnemyEffectsUUID.MAP_MESA__SANDSTORM_SLOW)
	sandstorm_slow_modifier.percent_amount = sandstorm_slow_amount * ap_scaling
	sandstorm_slow_modifier.percent_based_on = PercentType.BASE
	
	var sandstorm_slow_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, sandstorm_slow_modifier, StoreOfEnemyEffectsUUID.MAP_MESA__SANDSTORM_SLOW)
	sandstorm_slow_effect.is_timebound = true
	sandstorm_slow_effect.time_in_seconds = sandstorm_slow_duration
	
	return sandstorm_slow_effect

func _apply_sandstorm_slow_to_enemy(arg_enemy, arg_dmg_instance):
	arg_enemy.hit_by_damage_instance(arg_dmg_instance)


#########

func _listen_for_stage_round_changes_for_treasure():
	game_elements.stage_round_manager.connect("round_ended", self, "_on_round_end__monitor_for_treasure", [], CONNECT_PERSIST)
	

func _on_round_end__monitor_for_treasure(arg_stageround : StageRound):
	if !_treasure_given and StageRound.is_stageround_id_higher_or_equal_than_second_param(arg_stageround.id, treasure_stageround_id_given):
		_treasure_given = true
		
		game_elements.gold_manager.increase_gold_by(treasure_gold_amount, game_elements.gold_manager.IncreaseGoldSource.MAP_SPECIFIC_BEHAVIOR)
		game_elements.relic_manager.increase_relic_count_by(treasure_relic_amount, game_elements.relic_manager.IncreaseRelicSource.MAP_SPECIFIC_BEHAVIOR)
		
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_end__monitor_for_treasure")


