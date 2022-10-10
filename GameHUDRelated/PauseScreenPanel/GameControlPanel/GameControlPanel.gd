extends MarginContainer


onready var keysum_toggle_ingredient_mode = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer/KeySum_AbsorbIngMode
onready var keysum_sell_tower = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer/KeySum_SellTower

onready var keysum_toggle_round_and_fast_forward = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer2/KeySum_RoundToggle
onready var keysum_refresh_shop = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer2/KeySum_RefreshShop

onready var keysum_toggle_tower_targeting_left = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer3/KeySum_ToggleTowerTargetingLeft
onready var keysum_toggle_tower_targeting_right = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer3/KeySum_ToggleTowerTargetingRight

onready var keysum_combine_towers = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer4/KeySum_CombineTowers
onready var keysum_toggle_description_mode = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer4/KeySum_ToggleDescriptionMode

onready var keysum_show_extra_tower_info = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer10/KeySum_ShowExtraInfoPanel


onready var keysum_tower_ability_01 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer5/KeySum_TowerAbility01
onready var keysum_tower_ability_02 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer5/KeySum_TowerAbility02

onready var keysum_tower_ability_03 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer6/KeySum_TowerAbility03
onready var keysum_tower_ability_04 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer6/KeySum_TowerAbility04

onready var keysum_tower_ability_05 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer7/KeySum_TowerAbility05
onready var keysum_tower_ability_06 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer7/KeySum_TowerAbility06

onready var keysum_tower_ability_07 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer8/KeySum_TowerAbility07
onready var keysum_tower_ability_08 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer8/KeySum_TowerAbility08

onready var keysum_tower_panel_ability_01 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer9/KeySum_TowerPanelAbility01
onready var keysum_tower_panel_ability_02 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer9/KeySum_TowerPanelAbility02

onready var keysum_tower_panel_ability_03 = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/HBoxContainer11/KeySum_TowerPanelAbility03


onready var reset_hotkeys_button = $VBoxContainer/ContentContainer/ScrollContainer/VBoxContainer/MarginContainer/ResetHotkeysButton


var pause_manager
var main_pause_screen_panel
var hub_pause_panel


var all_keysums : Array = []

func _ready():
	keysum_toggle_ingredient_mode.set_key_name_text("Toggle Absorb\nIngredient Mode")
	keysum_toggle_ingredient_mode.set_action_name("game_ingredient_toggle")
	all_keysums.append(keysum_toggle_ingredient_mode)
	
	keysum_sell_tower.set_key_name_text("Sell Tower")
	keysum_sell_tower.set_action_name("game_tower_sell")
	all_keysums.append(keysum_sell_tower)
	
	keysum_toggle_round_and_fast_forward.set_key_name_text("Round Start\n& Fast Forward")
	keysum_toggle_round_and_fast_forward.set_action_name("game_round_toggle")
	all_keysums.append(keysum_toggle_round_and_fast_forward)
	
	keysum_refresh_shop.set_key_name_text("Refresh Shop")
	keysum_refresh_shop.set_action_name("game_shop_refresh")
	all_keysums.append(keysum_refresh_shop)
	
	keysum_toggle_tower_targeting_left.set_key_name_text("Toggle Tower\nTargeting Left")
	keysum_toggle_tower_targeting_left.set_action_name("game_tower_targeting_left")
	all_keysums.append(keysum_toggle_tower_targeting_left)
	
	keysum_toggle_tower_targeting_right.set_key_name_text("Toggle Tower\nTargeting Right")
	keysum_toggle_tower_targeting_right.set_action_name("game_tower_targeting_right")
	all_keysums.append(keysum_toggle_tower_targeting_right)
	
	keysum_combine_towers.set_key_name_text("Combine\nCombinable Towers")
	keysum_combine_towers.set_action_name("game_combine_combinables")
	all_keysums.append(keysum_combine_towers)
	
	keysum_toggle_description_mode.set_key_name_text("Toggle\nDescription Mode")
	keysum_toggle_description_mode.set_action_name("game_description_mode_toggle")
	all_keysums.append(keysum_toggle_description_mode)
	
	keysum_show_extra_tower_info.set_key_name_text("Show Extra Info\nof Tower")
	keysum_show_extra_tower_info.set_action_name("game_show_tower_extra_info_panel")
	all_keysums.append(keysum_show_extra_tower_info)
	
	
	var highest_rect_x = 0
	var highest_rect_y = 0
	for keysum in all_keysums:
		
		
		var rect_size_of_keysum : Vector2 = keysum.rect_size
		if rect_size_of_keysum.x > highest_rect_x:
			highest_rect_x = rect_size_of_keysum.x
		
		if rect_size_of_keysum.y > highest_rect_y:
			highest_rect_y = rect_size_of_keysum.y
	
	for keysum in all_keysums:
		keysum.rect_min_size = Vector2(highest_rect_x, highest_rect_y)
	
	
	#
	
	keysum_tower_ability_01.set_key_name_text("Ability Slot 1")
	keysum_tower_ability_01.set_action_name("game_ability_01")
	all_keysums.append(keysum_tower_ability_01)
	
	keysum_tower_ability_02.set_key_name_text("Ability Slot 2")
	keysum_tower_ability_02.set_action_name("game_ability_02")
	all_keysums.append(keysum_tower_ability_02)
	
	keysum_tower_ability_03.set_key_name_text("Ability Slot 3")
	keysum_tower_ability_03.set_action_name("game_ability_03")
	all_keysums.append(keysum_tower_ability_03)
	
	keysum_tower_ability_04.set_key_name_text("Ability Slot 4")
	keysum_tower_ability_04.set_action_name("game_ability_04")
	all_keysums.append(keysum_tower_ability_04)
	
	keysum_tower_ability_05.set_key_name_text("Ability Slot 5")
	keysum_tower_ability_05.set_action_name("game_ability_05")
	all_keysums.append(keysum_tower_ability_05)
	
	keysum_tower_ability_06.set_key_name_text("Ability Slot 6")
	keysum_tower_ability_06.set_action_name("game_ability_06")
	all_keysums.append(keysum_tower_ability_06)
	
	keysum_tower_ability_07.set_key_name_text("Ability Slot 7")
	keysum_tower_ability_07.set_action_name("game_ability_07")
	all_keysums.append(keysum_tower_ability_07)
	
	keysum_tower_ability_08.set_key_name_text("Ability Slot 8")
	keysum_tower_ability_08.set_action_name("game_ability_08")
	all_keysums.append(keysum_tower_ability_08)
	
	
	keysum_tower_panel_ability_01.set_key_name_text("Selected Tower\nAbility Slot 1")
	keysum_tower_panel_ability_01.set_action_name("game_tower_panel_ability_01")
	all_keysums.append(keysum_tower_panel_ability_01)
	
	keysum_tower_panel_ability_02.set_key_name_text("Selected Tower\nAbility Slot 2")
	keysum_tower_panel_ability_02.set_action_name("game_tower_panel_ability_02")
	all_keysums.append(keysum_tower_panel_ability_02)
	
	keysum_tower_panel_ability_03.set_key_name_text("Selected Tower\nAbility Slot 3")
	keysum_tower_panel_ability_03.set_action_name("game_tower_panel_ability_03")
	all_keysums.append(keysum_tower_panel_ability_03)
	
	
	#
	
	reset_hotkeys_button.connect("on_button_released_with_button_left", self, "_reset_controls_to_defaults")
	
	######
	
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST)
	
	set_process_unhandled_key_input(false)
	
	#
	
	for keysum in all_keysums:
		keysum.can_prompt_change_input_event_key_mapping = true
		
		keysum.node_to_parent_for_input_key_dialog = pause_manager
		keysum.node_to_parent__show_control_func_name = "show_control"
		keysum.node_to_parent__remove_control_func_name = "remove_control"
		

#

func _reset_controls_to_defaults():
	InputMap.load_from_globals()
	for keysum in all_keysums:
		keysum.refresh()
	GameSaveManager.save_game_controls__input_map()



#

func _on_visibility_changed():
	set_process_unhandled_key_input(visible)

#

func _unhandled_key_input(event : InputEventKey):
	if !event.echo and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			
			_on_exit_panel()
	
	accept_event()

###

# name matters!
func _on_exit_panel():
	main_pause_screen_panel.show_control_at_content_panel(hub_pause_panel)

func _is_a_dialog_visible__for_main():
	for keysum in all_keysums:
		if is_instance_valid(keysum.input_dialog) and keysum.input_dialog.visible:
			return true
	
	return false
	
