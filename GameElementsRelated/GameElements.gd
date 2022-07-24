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
const RoundInfoPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel/RoundInfoPanel.gd")
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

var round_status_panel : RoundStatusPanel
var round_info_panel : RoundInfoPanel
var tower_info_panel
var selection_notif_panel : SelectionNotifPanel
var whole_screen_gui : WholeScreenGUI
var general_stats_panel : GeneralStatsPanel
var tower_empty_slot_notif_panel : TowerEmptySlotNotifPanel
var left_panel
var round_damage_stats_panel : RoundDamageStatsPanel
var map_manager : MapManager

onready var top_left_coord_of_map = $TopLeft
onready var bottom_right_coord_of_map = $BottomRight

onready var synergy_interactable_panel : SynergyInteractablePanel = $BottomPanel/HBoxContainer/SynergyInteractablePanel

# Called when the node enters the scene tree for the first time.
func _ready():
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
	
	selection_notif_panel = $NotificationNode/SelectionNotifPanel
	tower_empty_slot_notif_panel = $NotificationNode/TowerEmptySlotNotifPanel
	
	targeting_panel = right_side_panel.tower_info_panel.targeting_panel
	tower_info_panel = right_side_panel.tower_info_panel
	
	round_status_panel = right_side_panel.round_status_panel
	round_info_panel = round_status_panel.round_info_panel
	
	# map manager
	
	
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
	gold_manager.connect("current_gold_changed", panel_buy_sell_level_roll, "_update_tower_cards_buyability_based_on_gold")
	gold_manager.stage_round_manager = stage_round_manager
	
	# relic manager
	relic_manager.stage_round_manager = stage_round_manager
	
	# stage round manager related
	stage_round_manager.round_status_panel = right_side_panel.round_status_panel
	
	stage_round_manager.connect("round_started", tower_manager, "_round_started")
	stage_round_manager.connect("round_ended", tower_manager, "_round_ended")
	stage_round_manager.connect("round_ended", round_info_panel, "set_stageround")
	stage_round_manager.enemy_manager = enemy_manager
	stage_round_manager.gold_manager = gold_manager
	
	# health manager
	health_manager.round_info_panel = round_info_panel
	
	# Enemy manager
	enemy_manager.stage_round_manager = stage_round_manager
	enemy_manager.map_manager = map_manager
	enemy_manager.set_spawn_paths(map_manager.base_map.get_all_enemy_paths())
	enemy_manager.connect("no_enemies_left", round_status_panel, "_update_round_ended")
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
	
	# Whole screen GUI
	whole_screen_gui.game_elements = self
	whole_screen_gui.screen_effect_manager = screen_effect_manager
	
	# Leftside panel
	left_panel.whole_screen_gui = whole_screen_gui
	left_panel.tower_manager = tower_manager
	
	# Shop manager
	shop_manager.game_elements = self
	shop_manager.stage_round_manager = stage_round_manager
	shop_manager.buy_sell_level_roll_panel = panel_buy_sell_level_roll
	shop_manager.level_manager = level_manager
	shop_manager.tower_manager = tower_manager
	shop_manager.gold_manager = gold_manager
	
	shop_manager.add_towers_per_refresh_amount_modifier(ShopManager.TowersPerShopModifiers.BASE_AMOUNT, 5)
	
	
	# Level manager
	level_manager.game_elements = self
	level_manager.stage_round_manager = stage_round_manager
	level_manager.gold_manager = gold_manager
	level_manager.relic_manager = relic_manager
	
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
	
	# shared passive manager
	shared_passive_manager.game_elements = self
	
	#GAME START
	stage_round_manager.set_game_mode_to_normal()
	stage_round_manager.end_round(true)
	
	gold_manager.increase_gold_by(3, GoldManager.IncreaseGoldSource.ENEMY_KILLED)
	health_manager.starting_health = 150
	health_manager.set_health(150)
	
	
	gold_manager.increase_gold_by(400, GoldManager.IncreaseGoldSource.ENEMY_KILLED)
	level_manager.current_level = LevelManager.LEVEL_7
	#level_manager.current_level = LevelManager.LEVEL_3
	
	relic_manager.increase_relic_count_by(3, RelicManager.IncreaseRelicSource.ROUND)



# From bottom panel
func _on_BuySellLevelRollPanel_level_up():
	level_manager.level_up_with_spend_currency()


var even : bool = false
func _on_BuySellLevelRollPanel_reroll():
	
	#shop_manager.roll_towers_in_shop_with_cost()
	if !even:
		panel_buy_sell_level_roll.update_new_rolled_towers([
			Towers.WAVE,
			Towers.LEADER,
			Towers.TRANSPORTER,
			Towers.REAPER,
			Towers.SHOCKER,
			Towers.ADEPT,
		])
	else:
		panel_buy_sell_level_roll.update_new_rolled_towers([
			Towers.ACCUMULAE,
			Towers.CHAOS,
			Towers.HEXTRIBUTE,
			Towers.PESTILENCE,
			Towers.BREWD,
			Towers.TIME_MACHINE
		])
	even = !even


func _on_BuySellLevelRollPanel_tower_bought(tower_id):
	if !tower_inventory_bench.is_bench_full():
		tower_inventory_bench.insert_tower(tower_id)


# Inputs related

func _on_ColorWheelSprite_pressed():
	tower_manager._toggle_ingredient_combine_mode()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and (event.button_index == BUTTON_RIGHT or event.button_index == BUTTON_LEFT):
			if right_side_panel.panel_showing != right_side_panel.Panels.ROUND:
				tower_manager._show_round_panel()


func _unhandled_key_input(event):
	if !event.echo and event.pressed:
		if whole_screen_gui.current_showing_control == null:
			if event.is_action_pressed("game_ingredient_toggle"):
				tower_manager._toggle_ingredient_combine_mode()
				
			elif event.is_action_pressed("game_round_toggle"):
				right_side_panel.round_status_panel._on_RoundStatusButton_pressed()
				
			elif event.scancode == KEY_ESCAPE:
				_esc_no_wholescreen_gui_pressed()
				
			elif event.is_action_pressed("game_tower_sell"):
				_sell_hovered_tower()
				
			elif event.is_action_pressed("game_shop_refresh"):
				_on_BuySellLevelRollPanel_reroll()
				
			elif event.is_action("game_ability_01"):
				round_status_panel.ability_panel.activate_ability_at_index(0)
			elif event.is_action("game_ability_02"):
				round_status_panel.ability_panel.activate_ability_at_index(1)
			elif event.is_action("game_ability_03"):
				round_status_panel.ability_panel.activate_ability_at_index(2)
			elif event.is_action("game_ability_04"):
				round_status_panel.ability_panel.activate_ability_at_index(3)
			elif event.is_action("game_ability_05"):
				round_status_panel.ability_panel.activate_ability_at_index(4)
			elif event.is_action("game_ability_06"):
				round_status_panel.ability_panel.activate_ability_at_index(5)
			elif event.is_action("game_ability_07"):
				round_status_panel.ability_panel.activate_ability_at_index(6)
			elif event.is_action("game_ability_08"):
				round_status_panel.ability_panel.activate_ability_at_index(7)
				
				
			elif event.is_action("game_tower_targeting_left"):
				targeting_panel.cycle_targeting_left()
			elif event.is_action("game_tower_targeting_right"):
				targeting_panel.cycle_targeting_right()
				
				
			elif event.is_action("game_combine_combinables"):
				combination_manager.on_combination_activated()
				
			
		else: # if there is wholescreen gui
			if event.scancode == KEY_ESCAPE:
				_esc_with_wholescreen_gui_pressed()


#

func _esc_no_wholescreen_gui_pressed():
	if input_prompt_manager.is_in_selection_mode():
		input_prompt_manager.cancel_selection()

func _sell_hovered_tower():
	var tower = tower_manager.get_tower_on_mouse_hover()
	if tower != null and !tower.is_being_dragged:
		tower.sell_tower()

#

func _esc_with_wholescreen_gui_pressed():
	_hide_current_control_from_whole_screen_gui()

func _on_WholeScreenGUI_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			_hide_current_control_from_whole_screen_gui()

func _hide_current_control_from_whole_screen_gui():
	whole_screen_gui.hide_control(whole_screen_gui.current_showing_control)


#

func get_middle_coordinates_of_playable_map() -> Vector2:
	return Vector2(_get_average(top_left_coord_of_map.global_position.x, bottom_right_coord_of_map.global_position.x), _get_average(top_left_coord_of_map.global_position.y, bottom_right_coord_of_map.global_position.y))

func _get_average(arg_x : float, arg_y : float) -> float:
	return (arg_x + arg_y) / 2
