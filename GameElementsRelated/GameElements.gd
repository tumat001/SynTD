extends Node

const BuySellLevelRollPanel = preload("res://GameHUDRelated/BuySellPanel/BuySellLevelRollPanel.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const InMapPlacablesManager = preload("res://GameElementsRelated/InMapPlacablesManager.gd")
#const SynergyManager = preload("res://GameElementsRelated/SynergyManager.gd")
const InnerBottomPanel = preload("res://GameElementsRelated/InnerBottomPanel.gd")
const RightSidePanel = preload("res://GameHUDRelated/RightSidePanel/RightSidePanel.gd")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")
const StageRoundManager = preload("res://GameElementsRelated/StageRoundManager.gd")
const HealthManager = preload("res://GameElementsRelated/HealthManager.gd")
const RoundStatusPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStatusPanel.gd")
const RoundInfoPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel/RoundInfoPanel.gd")
const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")
const AbilityManager = preload("res://GameElementsRelated/AbilityManager.gd")
const InputPromptManager = preload("res://GameElementsRelated/InputPromptManager.gd")
const SelectionNotifPanel = preload("res://GameHUDRelated/NotificationPanel/SelectionNotifPanel/SelectionNotifPanel.gd")
const ScreenEffectsManager = preload("res://GameElementsRelated/ScreenEffectsManager.gd")

var panel_buy_sell_level_roll : BuySellLevelRollPanel
var in_map_placables_manager : InMapPlacablesManager
var synergy_manager
var inner_bottom_panel : InnerBottomPanel
var right_side_panel : RightSidePanel
var targeting_panel
var tower_inventory_bench
var tower_manager : TowerManager
var gold_manager : GoldManager
var stage_round_manager : StageRoundManager
var health_manager : HealthManager
var enemy_manager : EnemyManager
var ability_manager : AbilityManager
var input_prompt_manager : InputPromptManager
var screen_effect_manager : ScreenEffectsManager

var round_status_panel : RoundStatusPanel
var round_info_panel : RoundInfoPanel
var selection_notif_panel : SelectionNotifPanel

onready var extra_side_panel : MarginContainer = $BottomPanel/HBoxContainer/ExtraSidePanel

# Called when the node enters the scene tree for the first time.
func _ready():
	panel_buy_sell_level_roll = $BottomPanel/HBoxContainer/VBoxContainer/HBoxContainer/InnerBottomPanel/BuySellLevelRollPanel
	in_map_placables_manager = $MapManager/InMapPlacablesManager
	synergy_manager = $SynergyManager
	synergy_manager.left_panel = $LeftsidePanel
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
	
	targeting_panel = right_side_panel.tower_info_panel.targeting_panel
	
	round_status_panel = right_side_panel.round_status_panel
	round_info_panel = round_status_panel.round_info_panel
	selection_notif_panel = $SelectionNotifPanel
	
	panel_buy_sell_level_roll.gold_manager = gold_manager
	
	# tower manager
	tower_manager.right_side_panel = right_side_panel
	tower_manager.tower_stats_panel = right_side_panel.tower_info_panel.tower_stats_panel
	tower_manager.active_ing_panel = right_side_panel.tower_info_panel.active_ing_panel
	tower_manager.targeting_panel = targeting_panel
	
	tower_manager.gold_manager = gold_manager
	tower_manager.stage_round_manager = stage_round_manager
	
	tower_inventory_bench.tower_manager = tower_manager
	tower_manager.in_map_placables_manager = in_map_placables_manager
	
	tower_manager.tower_inventory_bench = tower_inventory_bench
	tower_manager.inner_bottom_panel = inner_bottom_panel
	tower_manager.synergy_manager = synergy_manager
	tower_manager.tower_info_panel = right_side_panel.tower_info_panel
	tower_manager.input_prompt_manager = input_prompt_manager
	
	# syn manager
	synergy_manager.tower_manager = tower_manager
	synergy_manager.game_elements = self
	
	# gold manager
	gold_manager.gold_amount_label = $BottomPanel/HBoxContainer/VBoxContainer/GoldPanel/MarginContainer3/MarginContainer2/GoldAmountLabel
	gold_manager.connect("current_gold_changed", panel_buy_sell_level_roll, "_update_tower_cards_buyability_based_on_gold")
	
	# stage round manager related
	stage_round_manager.round_status_panel = right_side_panel.round_status_panel
	
	stage_round_manager.connect("round_started", tower_manager, "_round_started")
	stage_round_manager.connect("round_ended", tower_manager, "_round_ended")
	stage_round_manager.connect("round_ended", round_info_panel, "set_stageround")
	stage_round_manager.connect("end_of_round_gold_earned", gold_manager, "increase_gold_by")
	stage_round_manager.enemy_manager = enemy_manager
	
	# health manager
	health_manager.round_info_panel = round_info_panel
	
	# Enemy manager
	enemy_manager.set_spawn_paths([$EnemyPath])
	enemy_manager.connect("no_enemies_left", round_status_panel, "_update_round_ended")
	enemy_manager.health_manager = health_manager
	
	# Ability manager
	ability_manager.stage_round_manager = stage_round_manager
	ability_manager.ability_panel = round_status_panel.ability_panel
	tower_manager.ability_manager = ability_manager
	
	# Input Prompt manager
	input_prompt_manager.selection_notif_panel = selection_notif_panel
	
	# Selection Notif panel
	selection_notif_panel.visible = false
	
	
	#GAME START
	stage_round_manager.set_game_mode_to_normal()
	stage_round_manager.end_round()
	gold_manager.increase_gold_by(40, GoldManager.IncreaseGoldSource.ENEMY_KILLED)
	health_manager.set_health(150)
	
	


# From bottom panel
func _on_BuySellLevelRollPanel_level_down():
	#for tower in tower_manager.get_all_towers():
	#	if tower.ingredient_active_limit != 0:
	#		tower.set_active_ingredient_limit(tower.ingredient_active_limit - 2)
	pass


func _on_BuySellLevelRollPanel_level_up():
	#for tower in tower_manager.get_all_towers():
	#	tower.set_active_ingredient_limit(tower.ingredient_active_limit + 2)
	
	pass


var even : bool = false
func _on_BuySellLevelRollPanel_reroll():
	# TODO REPLACE THIS SOON
	if !even:
		panel_buy_sell_level_roll.update_new_rolled_towers([
			Towers.CHAOS,
			Towers.RE,
			Towers.TESLA,
			Towers.PING,
			Towers.ORB,
		])
	else:
		panel_buy_sell_level_roll.update_new_rolled_towers([
			Towers.IMPALE,
			Towers.IEU,
			Towers._704,
			Towers.ROYAL_FLAME,
			Towers.SPIKE,
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
			if right_side_panel.panel_showing == right_side_panel.Panels.TOWER_INFO:
				tower_manager._show_round_panel()


func _unhandled_key_input(event):
	if !event.echo and event.pressed:
		if event.is_action_pressed("game_ingredient_toggle"):
			tower_manager._toggle_ingredient_combine_mode()
			
		elif event.is_action_pressed("game_round_toggle"):
			right_side_panel.round_status_panel._on_RoundStatusButton_pressed()
			
		elif event.scancode == KEY_ESCAPE:
			_esc_pressed()
			
		elif event.is_action_pressed("game_tower_sell"):
			_sell_hovered_tower()
			
			
			
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
		


func _esc_pressed():
	if input_prompt_manager.current_selection_mode != InputPromptManager.SelectionMode.NONE:
		input_prompt_manager.cancel_selection()

func _sell_hovered_tower():
	var tower = tower_manager.get_tower_on_mouse_hover()
	if tower != null and !tower.is_being_dragged:
		tower.sell_tower()


