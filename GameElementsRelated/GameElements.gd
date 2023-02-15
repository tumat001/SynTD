extends Node

const BuySellLevelRollPanel = preload("res://GameHUDRelated/BuySellPanel/BuySellLevelRollPanel.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
#const SynergyManager = preload("res://GameElementsRelated/SynergyManager.gd")
const InnerBottomPanel = preload("res://GameElementsRelated/InnerBottomPanel.gd")
const RightSidePanel = preload("res://GameHUDRelated/RightSidePanel/RightSidePanel.gd")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")
#const StageRoundManager = preload("res://GameElementsRelated/StageRoundManager.gd")
const HealthManager = preload("res://GameElementsRelated/HealthManager.gd")
const RoundStatusPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStatusPanel.gd")
const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")
const AbilityManager = preload("res://GameElementsRelated/AbilityManager.gd")
const InputPromptManager = preload("res://GameElementsRelated/InputPromptManager.gd")
const SelectionNotifPanel = preload("res://GameHUDRelated/NotificationPanel/SelectionNotifPanel/SelectionNotifPanel.gd")
const ScreenEffectsManager = preload("res://GameElementsRelated/ScreenEffectsManager.gd")
const SynergyInteractablePanel = preload("res://GameHUDRelated/SynergyPanel/SynergyInteractablePanel.gd")
const WholeScreenGUI = preload("res://GameElementsRelated/WholeScreenGUI.gd")
const RelicManager = preload("res://GameElementsRelated/RelicManager.gd")
const ShopManager = preload("res://GameElementsRelated/ShopManager.gd")
const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")
const GeneralStatsPanel = preload("res://GameHUDRelated/StatsPanel/GeneralStatsPanel.gd")
const TowerEmptySlotNotifPanel = preload("res://GameHUDRelated/NotificationPanel/TowerEmptySlotNotifPanel/TowerEmptySlotNotifPanel.gd")
const RoundDamageStatsPanel = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/RoundDamageStatsPanel.gd")
const MapManager = preload("res://GameElementsRelated/MapManager.gd")
const CombinationManager = preload("res://GameElementsRelated/CombinationManager.gd")
const CombinationTopPanel = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationTopPanel/CombinationTopPanel.gd")
#const GameSettingsManager = preload("res://GameElementsRelated/GameSettingsManager.gd")
const GenericNotifPanel = preload("res://GameHUDRelated/NotificationPanel/GenericPanel/GenericNotifPanel.gd")
const PauseManager = preload("res://GameElementsRelated/PauseManager.gd")
const SellPanel = preload("res://GameHUDRelated/BuySellPanel/SellPanel.gd")
const GameResultManager = preload("res://GameElementsRelated/GameResultManager.gd")
const WholeScreenRelicGeneralStorePanel = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/WholeScreenRelicGeneralStorePanel.gd")
const WholeScreenRelicGeneralStorePanel_Scene = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/WholeScreenRelicGeneralStorePanel.tscn")


const CommonTexture_GoldCoin = preload("res://MiscRelated/CommonTextures/CommonTexture_GoldCoin/CommonTexture_GoldCoin.gd")
const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")


signal before_main_init()
signal before_game_start()

signal unhandled_input(arg_input, any_action_taken_by_game_elements)
signal unhandled_key_input(arg_input, any_action_taken_by_game_elements)

signal before_game_quit()


var panel_buy_sell_level_roll : BuySellLevelRollPanel
var synergy_manager
var inner_bottom_panel : InnerBottomPanel
var right_side_panel : RightSidePanel
var targeting_panel
var tower_inventory_bench
var tower_manager : TowerManager
var gold_manager : GoldManager
var stage_round_manager
var health_manager : HealthManager
var enemy_manager : EnemyManager
var ability_manager : AbilityManager
var input_prompt_manager : InputPromptManager
var screen_effect_manager : ScreenEffectsManager
var relic_manager : RelicManager
var shop_manager : ShopManager
var level_manager : LevelManager
var combination_manager : CombinationManager
var combination_top_panel : CombinationTopPanel
var shared_passive_manager
onready var pause_manager : PauseManager = $PauseManager
onready var game_modifiers_manager = $GameModifiersManager
onready var game_result_manager = $GameResultManager
onready var game_stats_manager = $GameStatsManager

onready var other_node_hoster : Node = $OtherNodeHoster
onready var proj_hoster : Node = $OtherNodeHoster

var round_status_panel : RoundStatusPanel
#var round_info_panel : RoundInfoPanel
var tower_info_panel
var selection_notif_panel : SelectionNotifPanel
var whole_screen_gui : WholeScreenGUI
var general_stats_panel : GeneralStatsPanel
var tower_empty_slot_notif_panel : TowerEmptySlotNotifPanel
var left_panel
var round_damage_stats_panel : RoundDamageStatsPanel
var map_manager : MapManager
#var game_settings_manager : GameSettingsManager
var game_settings_manager
var generic_notif_panel : GenericNotifPanel
var whole_screen_relic_general_store_panel : WholeScreenRelicGeneralStorePanel
onready var sell_panel : SellPanel = $BottomPanel/HBoxContainer/VBoxContainer/HBoxContainer/InnerBottomPanel/SellPanel
onready var color_wheel_gui = $BottomPanel/HBoxContainer/ColorWheelPanel/ColorWheelGUI
onready var tutotial_notif_panel = $TutorialNotifPanel#$NotificationNode/TutorialNotifPanel

onready var top_left_coord_of_map = $TopLeft
onready var bottom_right_coord_of_map = $BottomRight
onready var fov_node = $FOVNode

onready var synergy_interactable_panel : SynergyInteractablePanel = $BottomPanel/HBoxContainer/SynergyInteractablePanel

#

var _middle_coord_of_map : Vector2

# Tutorial related

var can_return_to_round_panel : bool = true

# Particles related
# Gold/Coin display

var gold_sprite_particle_pool_component : AttackSpritePoolComponent
var gold_sprite_particle_timer : Timer
const _delay_per_gold_particle__as_delta : float = 0.15
var gold_det_class_arr : Array

#

const distance_for_angle_range_for_facing_towards_inside_map : float = 50.0
var pos_to_angle_range_for_facing_towards_inside_map : Dictionary   # vector to array map. Array [angle_from, angle_to]


#

var non_essential_rng : RandomNumberGenerator

# Vars to be set by outside of game elements

var game_mode_id : int
var game_mode_type_info
var map_id
var game_modi_ids : Array = []

#

func _ready():
	CommsForBetweenScenes._game_elements_created__before_anything()
	
	#
	
	_calculate_middle_coordinates_of_playable_map()
	
	#
	game_modifiers_manager.game_elements = self
	
	game_mode_id = CommsForBetweenScenes.game_mode_id
	map_id = CommsForBetweenScenes.map_id
	
	# TEST HERE
	#game_mode_id = StoreOfGameMode.Mode.STANDARD_EASY
	
	#map_id = StoreOfMaps.MapsIds.RIDGED
	#
	
	game_mode_type_info = StoreOfGameMode.get_mode_type_info_from_id(game_mode_id)
	game_modi_ids.append_array(game_mode_type_info.game_modi_ids.duplicate())
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	####### MODIFIER LIST START
	# TEMPORARY HERE. MAKE IT BE EDITABLE IN MAP SELECTION
	#game_modi_ids.append(StoreOfGameModifiers.GameModiIds__RedTowerRandomizer)
	
	game_modi_ids.append(StoreOfGameModifiers.GameModiIds__CYDE_Common_Modifiers)
	
	game_modi_ids.append(StoreOfGameModifiers.GameModiIds__CYDE_ExampleStage)
	
	####### MODIFIER LIST END
	
	TowerCompositionColors.reset_synergies_instances_and_curr_tier()
	TowerDominantColors.reset_synergies_instances_and_curr_tier()
	
	
	game_modifiers_manager.add_game_modi_ids(game_modi_ids)
	game_modifiers_manager.add_game_modi_ids__from_game_mode_id(game_mode_id)
	
	
	# particles related
	
	_initialize_gold_particle_pool_component()
	
	#
	emit_signal("before_main_init")
	
	#####
	panel_buy_sell_level_roll = $BottomPanel/HBoxContainer/VBoxContainer/HBoxContainer/InnerBottomPanel/BuySellLevelRollPanel
	synergy_manager = $SynergyManager
	inner_bottom_panel = $BottomPanel/HBoxContainer/VBoxContainer/HBoxContainer/InnerBottomPanel
	right_side_panel = $RightSidePanel
	tower_inventory_bench = $TowerInventoryBench
	tower_manager = $TowerManager
	gold_manager = $GoldManager
	stage_round_manager = $StageRoundManager
	health_manager = $HealthManager
	enemy_manager = $EnemyManager
	ability_manager = $AbilityManager
	input_prompt_manager = $InputPromptManager
	screen_effect_manager = $ScreenEffectsManager
	whole_screen_gui = $WholeScreenGUI
	relic_manager = $RelicManager
	shop_manager = $ShopManager
	level_manager = $LevelManager
	general_stats_panel = $BottomPanel/HBoxContainer/VBoxContainer/GeneralStatsPanel
	left_panel = $LeftsidePanel
	map_manager = $MapManager
	combination_manager = $CombinationManager
	combination_top_panel = $CombinationTopPanel
	shared_passive_manager = $SharedPassiveManager
	#game_settings_manager = $GameSettingsManager
	game_settings_manager = GameSettingsManager
	
	game_modifiers_manager = $GameModifiersManager
	generic_notif_panel = $NotificationNode/GenericNotifPanel
	
	selection_notif_panel = $NotificationNode/SelectionNotifPanel
	tower_empty_slot_notif_panel = $NotificationNode/TowerEmptySlotNotifPanel
	
	#
	
	map_manager.set_chosen_map_id(map_id)
	
	#
	
	targeting_panel = right_side_panel.tower_info_panel.targeting_panel
	tower_info_panel = right_side_panel.tower_info_panel
	tower_info_panel.game_settings_manager = game_settings_manager
	
	round_status_panel = right_side_panel.round_status_panel
	round_status_panel.enemy_manager = enemy_manager
	round_status_panel.game_settings_manager = game_settings_manager
	round_status_panel.game_elements = self
	#round_info_panel = round_status_panel.round_info_panel
	
	# map manager
	map_manager.fov_node = fov_node
	
	# tower manager
	tower_manager.right_side_panel = right_side_panel
	tower_manager.tower_stats_panel = right_side_panel.tower_info_panel.tower_stats_panel
	tower_manager.active_ing_panel = right_side_panel.tower_info_panel.active_ing_panel
	tower_manager.targeting_panel = targeting_panel
	
	tower_manager.gold_manager = gold_manager
	tower_manager.stage_round_manager = stage_round_manager
	
	tower_inventory_bench.tower_manager = tower_manager
	tower_manager.map_manager = map_manager
	
	tower_manager.tower_inventory_bench = tower_inventory_bench
	tower_manager.inner_bottom_panel = inner_bottom_panel
	tower_manager.synergy_manager = synergy_manager
	tower_manager.tower_info_panel = right_side_panel.tower_info_panel
	tower_manager.input_prompt_manager = input_prompt_manager
	tower_manager.game_elements = self
	tower_manager.level_manager = level_manager
	tower_manager.left_panel = left_panel
	tower_manager.relic_manager = relic_manager
	
	
	# syn manager
	synergy_manager.tower_manager = tower_manager
	synergy_manager.game_elements = self
	synergy_manager.left_panel = left_panel
	
	# gold manager
	gold_manager.connect("current_gold_changed", panel_buy_sell_level_roll, "_update_tower_cards_buyability_based_on_gold_and_clauses")
	gold_manager.stage_round_manager = stage_round_manager
	
	# relic manager
	relic_manager.stage_round_manager = stage_round_manager
	
	# stage round manager related
	stage_round_manager.round_status_panel = right_side_panel.round_status_panel
	
	stage_round_manager.connect("round_started", tower_manager, "_round_started")
	stage_round_manager.connect("round_ended", tower_manager, "_round_ended")
	#stage_round_manager.connect("round_ended", round_info_panel, "set_stageround")
	stage_round_manager.enemy_manager = enemy_manager
	stage_round_manager.gold_manager = gold_manager
	
	map_manager.stage_round_manager = stage_round_manager
	
	# health manager
	#health_manager.round_info_panel = round_info_panel
	health_manager.game_elements = self
	
	# Enemy manager
	enemy_manager.stage_round_manager = stage_round_manager
	enemy_manager.map_manager = map_manager
	enemy_manager.set_spawn_paths(map_manager.base_map.get_all_enemy_paths())
	enemy_manager.health_manager = health_manager
	enemy_manager.game_elements = self
	
	# Ability manager
	ability_manager.stage_round_manager = stage_round_manager
	ability_manager.ability_panel = round_status_panel.ability_panel
	tower_manager.ability_manager = ability_manager
	
	# Input Prompt manager
	input_prompt_manager.selection_notif_panel = selection_notif_panel
	
	# Selection Notif panel
	selection_notif_panel.visible = false
	
	# Generic Notif Panel
	generic_notif_panel.visible = false
	
	# Tutorial Notif Panel
	tutotial_notif_panel.visible = false
	
	# Whole screen GUI
	whole_screen_gui.game_elements = self
	whole_screen_gui.screen_effect_manager = screen_effect_manager
	
	# Leftside panel
	left_panel.whole_screen_gui = whole_screen_gui
	left_panel.tower_manager = tower_manager
	left_panel.game_settings_manager = game_settings_manager
	
	# Level manager
	level_manager.game_elements = self
	level_manager.stage_round_manager = stage_round_manager
	level_manager.gold_manager = gold_manager
	level_manager.relic_manager = relic_manager
	
	# Shop manager
	shop_manager.game_elements = self
	shop_manager.stage_round_manager = stage_round_manager
	shop_manager.buy_sell_level_roll_panel = panel_buy_sell_level_roll
	shop_manager.level_manager = level_manager
	shop_manager.tower_manager = tower_manager
	shop_manager.gold_manager = gold_manager
	
	shop_manager.add_towers_per_refresh_amount_modifier(ShopManager.TowersPerShopModifiers.BASE_AMOUNT, 5)
	
	
	# Gold relic stats panel
	general_stats_panel.game_elements = self
	general_stats_panel.gold_manager = gold_manager
	general_stats_panel.relic_manager = relic_manager
	general_stats_panel.shop_manager = shop_manager
	general_stats_panel.level_manager = level_manager
	general_stats_panel.stage_round_manager = stage_round_manager
	general_stats_panel.right_side_panel = right_side_panel
	
	# buy sell reroll
	panel_buy_sell_level_roll.gold_manager = gold_manager
	panel_buy_sell_level_roll.relic_manager = relic_manager
	panel_buy_sell_level_roll.level_manager = level_manager
	panel_buy_sell_level_roll.shop_manager = shop_manager
	panel_buy_sell_level_roll.tower_manager = tower_manager
	panel_buy_sell_level_roll.tower_inventory_bench = tower_inventory_bench
	panel_buy_sell_level_roll.combination_manager = combination_manager
	panel_buy_sell_level_roll.game_settings_manager = game_settings_manager
	
	
	# whole screen relic general store panel
	whole_screen_relic_general_store_panel = WholeScreenRelicGeneralStorePanel_Scene.instance()
	whole_screen_gui.add_control_but_dont_show(whole_screen_relic_general_store_panel)
	whole_screen_relic_general_store_panel.set_managers_using_game_elements(self)
	
	relic_manager.whole_screen_relic_general_store_panel = whole_screen_relic_general_store_panel
	relic_manager.whole_screen_gui = whole_screen_gui
	
	tower_manager.whole_screen_relic_general_store_panel = whole_screen_relic_general_store_panel
	
	level_manager.whole_screen_relic_general_store_panel = whole_screen_relic_general_store_panel
	
	# tower empty slot notif panel
	tower_empty_slot_notif_panel.tower_manager = tower_manager
	tower_empty_slot_notif_panel.synergy_manager = synergy_manager
	tower_empty_slot_notif_panel.all_properties_set()
	
	# round damage stats panel
	round_damage_stats_panel = right_side_panel.round_damage_stats_panel
	round_damage_stats_panel.set_tower_manager(tower_manager)
	round_damage_stats_panel.set_stage_round_manager(stage_round_manager)
	
	# combination manager
	combination_manager.tower_manager = tower_manager
	combination_manager.combination_top_panel = combination_top_panel
	combination_manager.game_elements = self
	combination_manager.whole_screen_relic_general_store_panel = whole_screen_relic_general_store_panel
	combination_manager.relic_manager = relic_manager
	
	# shared passive manager
	shared_passive_manager.game_elements = self
	
	# combination top panel
	combination_top_panel.whole_screen_gui = whole_screen_gui
	combination_top_panel.combination_manager = combination_manager
	combination_top_panel.game_settings_manager = game_settings_manager
	
	# pause manager
	pause_manager.game_elements = self
	pause_manager.screen_effect_manager = screen_effect_manager
	
	# game result manager
	game_result_manager.set_health_manager(health_manager)
	game_result_manager.set_stage_round_manager(stage_round_manager)
	game_result_manager.whole_screen_gui = whole_screen_gui
	game_result_manager.game_elements = self
	
	round_status_panel.set_game_result_manager(game_result_manager)
	round_damage_stats_panel.multiple_tower_damage_stats_container.set_game_result_manager(game_result_manager)
	
	# game stats manager
	game_stats_manager.stage_round_manager = stage_round_manager
	game_stats_manager.tower_manager = tower_manager
	game_stats_manager.combination_manager = combination_manager
	game_stats_manager.game_result_manager = game_result_manager
	game_stats_manager.game_elements = self
	game_stats_manager.synergy_manager = synergy_manager
	game_stats_manager.whole_screen_gui = whole_screen_gui
	game_stats_manager.set_multiple_tower_damage_stats_container(right_side_panel.round_damage_stats_panel.multiple_tower_damage_stats_container)
	
	# StatsManager related
	
	StatsManager.connect_signals_with_game_elements(self)
	StatsManager.connect_signals_with_stage_round_manager(stage_round_manager)
	StatsManager.connect_signals_with_enemy_manager(enemy_manager)
	StatsManager.connect_signals_with_tower_manager(tower_manager)
	StatsManager.connect_signals_with_synergy_manager(synergy_manager)
	
	###
	gold_manager.increase_gold_by(3, GoldManager.IncreaseGoldSource.START_OF_GAME)
	health_manager.starting_health = 150
	health_manager.set_health(150)
	
	map_manager.make_base_map_apply_changes_to_game_elements(self)
	synergy_manager.before_game_start__synergies_this_game_initialize()
	
	emit_signal("before_game_start")
	
	#GAME START
	shop_manager.finalize_towers_in_shop()
	
	stage_round_manager.set_game_mode(game_mode_id)
	stage_round_manager.end_round(true)
	
	# FOR TESTING ------------------------------------
	
	#todo
	gold_manager.increase_gold_by(1000, GoldManager.IncreaseGoldSource.ENEMY_KILLED)
	level_manager.current_level = LevelManager.LEVEL_2
	relic_manager.increase_relic_count_by(3, RelicManager.IncreaseRelicSource.ROUND)



# From bottom panel
func _on_BuySellLevelRollPanel_level_up():
	level_manager.level_up_with_spend_currency__from_game_elements()


var even : bool = false
func _on_BuySellLevelRollPanel_reroll():
	
	shop_manager.roll_towers_in_shop_with_cost()
	
#	#todo
#	if !even:
#		panel_buy_sell_level_roll.update_new_rolled_towers([
#			Towers.BOUNDED,
#			Towers.PING,
#			Towers.ACCUMULAE,
#			Towers.OUTREACH,
#			Towers.CELESTIAL,
#			Towers.SEEDER,
#		])
#	else:
#		panel_buy_sell_level_roll.update_new_rolled_towers([
#			Towers.PESTILENCE,
#			Towers.ACCUMULAE,
#			Towers.WAVE,
#			Towers.BIOMORPH,
#			Towers.TESLA,
#			Towers.SPIKE
#		])
#	even = !even


func _on_BuySellLevelRollPanel_tower_bought(tower_id):
	if !tower_inventory_bench.is_bench_full():
		tower_inventory_bench.insert_tower(tower_id, tower_inventory_bench._find_empty_slot(), true)


# Inputs related

#func _on_ColorWheelSprite_pressed():
#	tower_manager._toggle_ingredient_combine_mode()

func _on_ColorWheelGUI_color_wheel_left_mouse_released():
	tower_manager._toggle_ingredient_combine_mode()



func _unhandled_input(event):
	var any_action_taken : bool = false
	
	if event is InputEventMouseButton:
		if event.pressed and (event.button_index == BUTTON_RIGHT or event.button_index == BUTTON_LEFT):
			if right_side_panel.panel_showing != right_side_panel.Panels.ROUND and can_return_to_round_panel:
				tower_manager._show_round_panel()
				any_action_taken = true
	
	emit_signal("unhandled_input", event, any_action_taken)


func _unhandled_key_input(event):
	var any_action_taken : bool = false
	
	if !event.echo and event.pressed:
		if if_allow_key_inputs_due_to_conditions(): #put conditions here, as tutorials use this as well
			if event.is_action_pressed("game_ingredient_toggle"):
				tower_manager._toggle_ingredient_combine_mode()
				any_action_taken = true
				
			elif event.is_action_pressed("game_round_toggle"):
				#right_side_panel.round_status_panel._on_RoundStatusButton_pressed()
				right_side_panel.round_status_panel.start_round_or_speed_toggle()
				any_action_taken = true
				
			elif event.is_action_pressed("ui_cancel"):
				_esc_no_wholescreen_gui_pressed()
				any_action_taken = true
				
			elif event.is_action_pressed("game_tower_sell"):
				_sell_hovered_tower()
				any_action_taken = true
				
			elif event.is_action_pressed("game_shop_refresh"):
				#_on_BuySellLevelRollPanel_reroll()
				panel_buy_sell_level_roll._on_RerollButton_pressed()
				any_action_taken = true
				
			elif event.is_action("game_ability_01"):
				round_status_panel.ability_panel.activate_ability_at_index(0)
				any_action_taken = true
			elif event.is_action("game_ability_02"):
				round_status_panel.ability_panel.activate_ability_at_index(1)
				any_action_taken = true
			elif event.is_action("game_ability_03"):
				round_status_panel.ability_panel.activate_ability_at_index(2)
				any_action_taken = true
			elif event.is_action("game_ability_04"):
				round_status_panel.ability_panel.activate_ability_at_index(3)
				any_action_taken = true
			elif event.is_action("game_ability_05"):
				round_status_panel.ability_panel.activate_ability_at_index(4)
				any_action_taken = true
			elif event.is_action("game_ability_06"):
				round_status_panel.ability_panel.activate_ability_at_index(5)
				any_action_taken = true
			elif event.is_action("game_ability_07"):
				round_status_panel.ability_panel.activate_ability_at_index(6)
				any_action_taken = true
			elif event.is_action("game_ability_08"):
				round_status_panel.ability_panel.activate_ability_at_index(7)
				any_action_taken = true
				
				
			elif event.is_action("game_tower_targeting_left"):
				targeting_panel.cycle_targeting_left()
				any_action_taken = true
			elif event.is_action("game_tower_targeting_right"):
				targeting_panel.cycle_targeting_right()
				any_action_taken = true
				
				
			elif event.is_action("game_combine_combinables"):
				combination_manager.on_combination_activated()
				any_action_taken = true
				
			elif event.is_action("game_description_mode_toggle"):
				game_settings_manager.toggle_descriptions_mode()
				any_action_taken = true
				
				
			elif event.is_action("game_tower_panel_ability_01"):
				tower_info_panel.activate_tower_panel_ability_01()
				any_action_taken = true
				
			elif event.is_action("game_tower_panel_ability_02"):
				tower_info_panel.activate_tower_panel_ability_02()
				any_action_taken = true
				
			elif event.is_action("game_tower_panel_ability_03"):
				tower_info_panel.activate_tower_panel_ability_03()
				any_action_taken = true
				
			elif event.is_action("game_show_tower_extra_info_panel"):
				if right_side_panel.panel_showing == right_side_panel.Panels.TOWER_INFO:
					tower_info_panel._on_TowerNameAndPicPanel_show_extra_tower_info()
					any_action_taken = true
			
			
		else: # if there is wholescreen gui
			if event.scancode == KEY_ESCAPE:
				_esc_with_wholescreen_gui_pressed()
				any_action_taken = true
	
	emit_signal("unhandled_key_input", event, any_action_taken)

func if_allow_key_inputs_due_to_conditions():
	return !is_instance_valid(whole_screen_gui.current_showing_control) and !pause_manager.has_any_visible_control()



#

func _esc_no_wholescreen_gui_pressed():
	if input_prompt_manager.is_in_selection_mode():
		input_prompt_manager.cancel_selection()
		
	else:
		#tower_info_panel.destroy_extra_info_panel__called_from_outside()
		tower_manager.drop_currently_dragged_tower_if_any()
		pause_manager.pause_game__and_show_hub_pause_panel()
		

func _sell_hovered_tower():
	var tower = tower_manager.get_tower_on_mouse_hover()
	if is_instance_valid(tower) and !tower.is_being_dragged:
		tower.sell_tower()

#

func _esc_with_wholescreen_gui_pressed():
	_hide_current_control_from_whole_screen_gui()

func _on_WholeScreenGUI_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			_hide_current_control_from_whole_screen_gui()

func _hide_current_control_from_whole_screen_gui():
	if whole_screen_gui.currently_escapable_from_game_elements:
		whole_screen_gui.hide_control(whole_screen_gui.current_showing_control)





####

func get_top_left_coordinates_of_playable_map() -> Vector2:
	return top_left_coord_of_map.global_position

func get_bot_right_coordinates_of_playable_map() -> Vector2:
	return bottom_right_coord_of_map.global_position

func get_playable_map_size() -> Vector2:
	return get_bot_right_coordinates_of_playable_map() - get_top_left_coordinates_of_playable_map()


func get_middle_coordinates_of_playable_map() -> Vector2:
	return _middle_coord_of_map

func _calculate_middle_coordinates_of_playable_map():
	_middle_coord_of_map = Vector2(_get_average(top_left_coord_of_map.global_position.x, bottom_right_coord_of_map.global_position.x), _get_average(top_left_coord_of_map.global_position.y, bottom_right_coord_of_map.global_position.y))


func _get_average(arg_x : float, arg_y : float) -> float:
	return (arg_x + arg_y) / 2


#

func get_fov_node():
	return fov_node

#

func get_rect_gradient_texture__based_on_play_map() -> GradientTexture2D:
	var texture = GradientTexture2D.new()
	
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(1.2, 1.2)
	
	texture.flags = GradientTexture2D.FLAG_MIPMAPS | GradientTexture2D.FLAG_FILTER
	
	var playable_map_size : Vector2 = get_playable_map_size()
	texture.width = playable_map_size.x
	texture.height = playable_map_size.y
	
	return texture


func construct_gradient_two_color(arg_color_start_center, arg_color_end):
	var gradient = Gradient.new()
	# we use set_color because default starts with two colors
	gradient.set_color(0, arg_color_start_center)
	gradient.set_color(1, arg_color_end)
	
	gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_LINEAR
	
	return gradient

###

func _enter_tree():
	CommsForBetweenScenes.current_game_elements = self
	


############# Particles related ##################

class ParticlesDetClass extends Reference:
	var pos : Vector2
	var curr_amount_of_repeats : int

# Gold related

func _initialize_gold_particle_pool_component():
	gold_sprite_particle_pool_component = AttackSpritePoolComponent.new()
	gold_sprite_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	gold_sprite_particle_pool_component.node_to_listen_for_queue_free = self
	gold_sprite_particle_pool_component.source_for_funcs_for_attk_sprite = self
	gold_sprite_particle_pool_component.func_name_for_creating_attack_sprite = "_create_gold_particle"
	gold_sprite_particle_pool_component.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_gold_particle_properties_when_get_from_pool_after_add_child"
	
	gold_sprite_particle_timer = Timer.new()
	gold_sprite_particle_timer.one_shot = false
	gold_sprite_particle_timer.connect("timeout", self, "_on_gold_particle_timer_timeout", [], CONNECT_PERSIST)
	add_child(gold_sprite_particle_timer)
	gold_sprite_particle_timer.paused = true
	

func _create_gold_particle():
	var particle = CommonTexture_GoldCoin.create_coin_particle()
	
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	
	return particle

func _set_gold_particle_properties_when_get_from_pool_after_add_child(arg_particle):
	pass

#

func display_gold_particles(arg_pos : Vector2, arg_repeat_count : int):
	if arg_repeat_count != 0:
		var particle_det_class := ParticlesDetClass.new()
		particle_det_class.pos = arg_pos
		particle_det_class.curr_amount_of_repeats = arg_repeat_count
		
		_add_to_gold_det_class_arr(particle_det_class)

func _add_to_gold_det_class_arr(arg_particle_det_class):
	gold_det_class_arr.append(arg_particle_det_class)
	
	if gold_sprite_particle_timer.paused:
		gold_sprite_particle_timer.paused = false
		gold_sprite_particle_timer.start(_delay_per_gold_particle__as_delta)

func _remove_from_gold_det_class_arr(arg_particle_det_class):
	gold_det_class_arr.erase(arg_particle_det_class)
	if gold_det_class_arr.size() == 0 and !gold_sprite_particle_timer.paused:
		gold_sprite_particle_timer.paused = true

func _on_gold_particle_timer_timeout():
	for particle_det_class in gold_det_class_arr:
		_display_gold_particle_on_pos(particle_det_class.pos)
		particle_det_class.curr_amount_of_repeats -= 1
		if particle_det_class.curr_amount_of_repeats <= 0:
			gold_det_class_arr.erase(particle_det_class)

func _display_gold_particle_on_pos(arg_pos : Vector2):
	var particle = gold_sprite_particle_pool_component.get_or_create_attack_sprite_from_pool()
	particle.global_position = arg_pos
	particle.visible = true
	
	particle.reset_for_another_use()

##


func is_pos_inside_of_playable_map(arg_pos : Vector2):
	var top_left = get_top_left_coordinates_of_playable_map()
	var bot_right = get_bot_right_coordinates_of_playable_map()
	
	return (arg_pos.x >= top_left.x and arg_pos.x <= bot_right.x) and (arg_pos.y >= top_left.y and arg_pos.y <= bot_right.y)


func get_rand_rad_angle_facing_towards_inside_of_playable_map(arg_source_pos : Vector2, arg_rng_to_use : RandomNumberGenerator = non_essential_rng):
	var angle_range = calculate_and_store_angle_range_for_facing_towards_inside_of_playable_map(arg_source_pos)
	
	return non_essential_rng.randf_range(angle_range[0], angle_range[1])

func calculate_and_store_angle_range_for_facing_towards_inside_of_playable_map(arg_source_pos : Vector2):
	var angle_range : Array = _calculate_angle_range_for_facing_towards_inside_of_playable_map(arg_source_pos)
	pos_to_angle_range_for_facing_towards_inside_map[arg_source_pos] = angle_range
	
	return angle_range

func _calculate_angle_range_for_facing_towards_inside_of_playable_map(arg_source_pos : Vector2) -> Array:
	var from_angle : float = 0
	var to_angle : float = 2 * PI
	
	if is_pos_inside_of_playable_map(arg_source_pos):
		
		# top
		if !is_pos_inside_of_playable_map(arg_source_pos + Vector2(0, -distance_for_angle_range_for_facing_towards_inside_map)):
			var dist_to_top = arg_source_pos.distance_to(Vector2(0, get_top_left_coordinates_of_playable_map().y))
			var left_dist = sqrt(_num_squared(distance_for_angle_range_for_facing_towards_inside_map) + _num_squared(dist_to_top))
			
			var left_pos = arg_source_pos + Vector2(left_dist, dist_to_top)
			var right_pos = arg_source_pos + Vector2(-left_dist, dist_to_top)
			
			var angle_to_left = arg_source_pos.angle_to_point(left_pos)
			var angle_to_right = arg_source_pos.angle_to_point(right_pos)
			
			#bucket = [angle_to_right, angle_to_left]
			
			from_angle = _get_highest_from_angle(from_angle, angle_to_right)
			to_angle = _get_lowest_from_angle(to_angle, angle_to_left)
			
		# bottom
		if !is_pos_inside_of_playable_map(arg_source_pos + Vector2(0, distance_for_angle_range_for_facing_towards_inside_map)):
			var dist_to_bot = arg_source_pos.distance_to(Vector2(0, get_bot_right_coordinates_of_playable_map().y))
			var left_dist = sqrt(_num_squared(distance_for_angle_range_for_facing_towards_inside_map) + _num_squared(dist_to_bot))
			
			var left_pos = arg_source_pos + Vector2(left_dist, dist_to_bot)
			var right_pos = arg_source_pos + Vector2(-left_dist, dist_to_bot)
			
			var angle_to_left = arg_source_pos.angle_to_point(left_pos)
			var angle_to_right = arg_source_pos.angle_to_point(right_pos)
			
			#bucket = [angle_to_left, angle_to_right]
			
			from_angle = _get_highest_from_angle(from_angle, angle_to_left)
			to_angle = _get_lowest_from_angle(to_angle, angle_to_right)
			
		# left
		if !is_pos_inside_of_playable_map(arg_source_pos + Vector2(-distance_for_angle_range_for_facing_towards_inside_map, 0)):
			var dist_to_left = arg_source_pos.distance_to(Vector2(0, get_top_left_coordinates_of_playable_map().x))
			var top_dist = sqrt(_num_squared(distance_for_angle_range_for_facing_towards_inside_map) + _num_squared(dist_to_left))
			
			var top_pos = arg_source_pos + Vector2(dist_to_left, top_dist)
			var bot_pos = arg_source_pos + Vector2(dist_to_left, -top_dist)
			
			var angle_to_top = arg_source_pos.angle_to_point(top_pos)
			var angle_to_bot = arg_source_pos.angle_to_point(bot_pos)
			
			#bucket = [angle_to_top, angle_to_bot]
			
			from_angle = _get_highest_from_angle(from_angle, angle_to_top)
			to_angle = _get_lowest_from_angle(to_angle, angle_to_bot)
			
		# right
		if !is_pos_inside_of_playable_map(arg_source_pos + Vector2(distance_for_angle_range_for_facing_towards_inside_map, 0)):
			var dist_to_right = arg_source_pos.distance_to(Vector2(0, get_bot_right_coordinates_of_playable_map().x))
			var top_dist = sqrt(_num_squared(distance_for_angle_range_for_facing_towards_inside_map) + _num_squared(dist_to_right))
			
			var top_pos = arg_source_pos + Vector2(dist_to_right, top_dist)
			var bot_pos = arg_source_pos + Vector2(dist_to_right, -top_dist)
			
			var angle_to_top = arg_source_pos.angle_to_point(top_pos)
			var angle_to_bot = arg_source_pos.angle_to_point(bot_pos)
			
			#bucket = [angle_to_bot, angle_to_top]
			
			from_angle = _get_highest_from_angle(from_angle, angle_to_bot)
			to_angle = _get_lowest_from_angle(to_angle, angle_to_top)
		
		
		
	# if pos is already outside of playable map
	else:
		
		# top
		if is_pos_inside_of_playable_map(arg_source_pos + Vector2(0, distance_for_angle_range_for_facing_towards_inside_map)):
			var dist_to_top = arg_source_pos.distance_to(Vector2(0, get_top_left_coordinates_of_playable_map().y))
			var left_dist = sqrt(_num_squared(distance_for_angle_range_for_facing_towards_inside_map) + _num_squared(dist_to_top))
			
			var left_pos = arg_source_pos + Vector2(left_dist, dist_to_top)
			var right_pos = arg_source_pos + Vector2(-left_dist, dist_to_top)
			
			var angle_to_left = arg_source_pos.angle_to_point(left_pos)
			var angle_to_right = arg_source_pos.angle_to_point(right_pos)
			
			#bucket = [angle_to_right, angle_to_left]
			
			from_angle = _get_highest_from_angle(from_angle, angle_to_right)
			to_angle = _get_lowest_from_angle(to_angle, angle_to_left)
			
		# bottom
		if is_pos_inside_of_playable_map(arg_source_pos + Vector2(0, -distance_for_angle_range_for_facing_towards_inside_map)):
			var dist_to_bot = arg_source_pos.distance_to(Vector2(0, get_bot_right_coordinates_of_playable_map().y))
			var left_dist = sqrt(_num_squared(distance_for_angle_range_for_facing_towards_inside_map) + _num_squared(dist_to_bot))
			
			var left_pos = arg_source_pos + Vector2(left_dist, dist_to_bot)
			var right_pos = arg_source_pos + Vector2(-left_dist, dist_to_bot)
			
			var angle_to_left = arg_source_pos.angle_to_point(left_pos)
			var angle_to_right = arg_source_pos.angle_to_point(right_pos)
			
			#bucket = [angle_to_left, angle_to_right]
			
			from_angle = _get_highest_from_angle(from_angle, angle_to_left)
			to_angle = _get_lowest_from_angle(to_angle, angle_to_right)
			
		# left
		if is_pos_inside_of_playable_map(arg_source_pos + Vector2(distance_for_angle_range_for_facing_towards_inside_map, 0)):
			var dist_to_left = arg_source_pos.distance_to(Vector2(0, get_top_left_coordinates_of_playable_map().x))
			var top_dist = sqrt(_num_squared(distance_for_angle_range_for_facing_towards_inside_map) + _num_squared(dist_to_left))
			
			var top_pos = arg_source_pos + Vector2(dist_to_left, top_dist)
			var bot_pos = arg_source_pos + Vector2(dist_to_left, -top_dist)
			
			var angle_to_top = arg_source_pos.angle_to_point(top_pos)
			var angle_to_bot = arg_source_pos.angle_to_point(bot_pos)
			
			#bucket = [angle_to_top, angle_to_bot]
			
			from_angle = _get_highest_from_angle(from_angle, angle_to_top)
			to_angle = _get_lowest_from_angle(to_angle, angle_to_bot)
			
		# right
		if is_pos_inside_of_playable_map(arg_source_pos + Vector2(-distance_for_angle_range_for_facing_towards_inside_map, 0)):
			var dist_to_right = arg_source_pos.distance_to(Vector2(0, get_bot_right_coordinates_of_playable_map().x))
			var top_dist = sqrt(_num_squared(distance_for_angle_range_for_facing_towards_inside_map) + _num_squared(dist_to_right))
			
			var top_pos = arg_source_pos + Vector2(dist_to_right, top_dist)
			var bot_pos = arg_source_pos + Vector2(dist_to_right, -top_dist)
			
			var angle_to_top = arg_source_pos.angle_to_point(top_pos)
			var angle_to_bot = arg_source_pos.angle_to_point(bot_pos)
			
			#bucket = [angle_to_bot, angle_to_top]
			
			from_angle = _get_highest_from_angle(from_angle, angle_to_bot)
			to_angle = _get_lowest_from_angle(to_angle, angle_to_top)
		
	
	
	var bucket = [from_angle, to_angle]
	return bucket


func _num_squared(arg_num) -> float:
	return arg_num * arg_num

func _convert_rad_angle_to_angle_with_negative(arg_angle : float):
	if arg_angle > 0:
		return arg_angle - (2 * PI)
	
	return arg_angle

func _convert_rad_angle_to_angle_with_positive(arg_angle : float):
	if arg_angle < 0:
		return arg_angle + (2 * PI)
	
	return arg_angle


func _get_lowest_from_angle(arg_curr_lowest : float, arg_candidate_angle : float):
	if arg_curr_lowest < arg_candidate_angle:
		return arg_curr_lowest
	else:
		return arg_candidate_angle

func _get_highest_from_angle(arg_curr_highest : float, arg_candidate_angle : float):
	if arg_curr_highest > arg_candidate_angle:
		return arg_curr_highest
	else:
		return arg_candidate_angle

###########

# called by HubPausePanel
func quit_game():
	emit_signal("before_game_quit")
	
	pause_manager.unpause_game__accessed_for_scene_change()
	CommsForBetweenScenes.goto_starting_screen(self)

####

# used by dialog whole screen panel
func add_child_to_below_below_screen_effects_manager(arg_node):
	add_child(arg_node)
	move_child(arg_node, screen_effect_manager.get_position_in_parent() - 1)


