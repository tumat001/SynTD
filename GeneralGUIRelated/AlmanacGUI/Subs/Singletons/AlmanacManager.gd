extends Node

const Almanac_Category_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_Category_Data.gd")
const Almanac_ItemListEntry_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListEntry_Data.gd")
const Almanac_ItemListPage_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListPage_Data.gd")
const Almanac_MultiStatsData = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_XTypeInfo_MultiStatsData.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const EnemyTypeInformation = preload("res://EnemyRelated/EnemyTypeInformation.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")


const Almanac_Page = preload("res://GeneralGUIRelated/AlmanacGUI/Subs/Almanac_Page/Almanac_Page.gd")

const CategoryBorder_Default = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Line_CategoryBorder/Line_CategoryBorder_LightGray_6x6.png")


signal requested_exit_almanac()

#var main_page : Array = []
#
#var enemy_factions_page : Array = []
#
#var enemy_faction_page__basic : Array = []
#var enemy_faction_page__expert : Array = []
#var enemy_faction_page__faithful : Array = []
#var enemy_faction_page__skirmisher : Array = []
#

const enemy_count_min_for_unobscure : int = 1
const tower_count_min_for_unobscure : int = 1
const syn_count_min_for_unobscure : int = 1
const tidbit_val_min_for_unobscure : int = 1

#

var main_page : Almanac_ItemListPage_Data
var tidbit_option__in_main_page : Almanac_ItemListEntry_Data

var enemy_factions_page : Almanac_ItemListPage_Data

var enemy_faction_page__basic : Almanac_ItemListPage_Data
var enemy_faction_page__expert : Almanac_ItemListPage_Data
var enemy_faction_page__faithful : Almanac_ItemListPage_Data
var enemy_faction_page__skirmisher : Almanac_ItemListPage_Data


var tower_page : Almanac_ItemListPage_Data

var synergy_page : Almanac_ItemListPage_Data

var tidbit_page : Almanac_ItemListPage_Data

#

var tower_multi_stats_data : Almanac_MultiStatsData
var enemy_multi_stats_data : Almanac_MultiStatsData

#

var _all_enemy_item_entry_data_options : Array
var _all_tower_item_entry_data_options : Array
var _all_synergy_item_entry_data_options : Array
var _all_tidbit_item_entry_data_options : Array

#

enum PageIds {
	EXIT_ALMANAC = -1,
	NO_PAGE = 0, # also the default val. If this value is changed, change val in ItemListPage_Data as well
	
	MAIN_PAGE = 1,
	
	#
	ENEMY_FACTION_PAGE = 100,
	
	ENEMY_FACTION_PAGE__BASIC = 101,
	ENEMY_FACTION_PAGE__EXPERT = 102,
	ENEMY_FACTION_PAGE__FAITHFUL = 103,
	ENEMY_FACTION_PAGE__SKIRMISHER = 104,
	
	
	#
	TOWER_PAGE = 200,
	
	#
	SYNERGY_PAGE = 300,
	
	#
	TIDBIT_PAGE = 400,
	
}

enum CategoryIds {
	EMPTY = 1
	
	ENEMY_FACTION__FIRST_HALF = 10
	ENEMY_FACTION__SECOND_HALF = 11
	
	ENEMY_SKIRM_BLUE = 20
	ENEMY_SKIRM_RED = 21
	ENEMY_SKIRM_BOTH = 22
	
	#
	
	TOWER_COLOR__RED = 110
	TOWER_COLOR__ORANGE = 111
	TOWER_COLOR__YELLOW = 112
	TOWER_COLOR__GREEN = 113
	TOWER_COLOR__BLUE = 114
	TOWER_COLOR__VIOLET = 115
	TOWER_COLOR__GRAY = 116
	TOWER_COLOR__BLACK = 117
	TOWER_COLOR__OTHERS = 118
	
	#
	
	SYNERGY_DOMINANT = 200,
	SYNERGY_COMPOSITE = 201,
	
#	ENEMY_TYPE__NORMAL = 20
#	ENEMY_TYPE__ELITE = 21
#	ENEMY_TYPE__BOSS = 22
}

var page_id_to_page_data : Dictionary = {}

#

var enemy_type_to_border_texture_map__normal : Dictionary = {
	EnemyConstants.EnemyTypeInformation.EnemyType.NORMAL : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Line_InnerBorder_EnemyType/Line_EnemyTypeNormal_6x6_Normal.png"),
	EnemyConstants.EnemyTypeInformation.EnemyType.ELITE : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Line_InnerBorder_EnemyType/Line_EnemyTypeElite_6x6_Normal.png"),
	EnemyConstants.EnemyTypeInformation.EnemyType.BOSS : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Line_InnerBorder_EnemyType/Line_EnemyTypeBoss_6x6_Normal.png"),
}
var enemy_type_to_border_texture_map__highlight : Dictionary = {
	EnemyConstants.EnemyTypeInformation.EnemyType.NORMAL : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Line_InnerBorder_EnemyType/Line_EnemyTypeNormal_6x6_Highlighted.png"),
	EnemyConstants.EnemyTypeInformation.EnemyType.ELITE : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Line_InnerBorder_EnemyType/Line_EnemyTypeElite_6x6_Highlighted.png"),
	EnemyConstants.EnemyTypeInformation.EnemyType.BOSS : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/Shared/Line_InnerBorder_EnemyType/Line_EnemyTypeBoss_6x6_Highlighted.png"),
}


var tower_tier_to_border_texture_map__normal : Dictionary = {
	1 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier01OptionPage_6x6_Normal.png"),
	2 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier02OptionPage_6x6_Normal.png"),
	3 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier03OptionPage_6x6_Normal.png"),
	4 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier04OptionPage_6x6_Normal.png"),
	5 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier05OptionPage_6x6_Normal.png"),
	6 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier06OptionPage_6x6_Normal.png"),
}
var tower_tier_to_border_texture_map__highlight : Dictionary = {
	1 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier01OptionPage_6x6_Highlighted.png"),
	2 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier02OptionPage_6x6_Highlighted.png"),
	3 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier03OptionPage_6x6_Highlighted.png"),
	4 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier04OptionPage_6x6_Highlighted.png"),
	5 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier05OptionPage_6x6_Highlighted.png"),
	6 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage/Line_Tier06OptionPage_6x6_Highlighted.png"),
}


var tidbit_tier_to_border_texture_map__normal : Dictionary = {
	1 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier01OptionPage_6x6_Normal.png"),
	2 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier02OptionPage_6x6_Normal.png"),
	#TODO
	#3 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier03OptionPage_6x6_Normal.png"),
	4 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier04OptionPage_6x6_Normal.png"),
	5 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier05OptionPage_6x6_Normal.png"),
	6 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier06OptionPage_6x6_Normal.png"),
}
var tidbit_tier_to_border_texture_map__highlight : Dictionary = {
	1 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier01OptionPage_6x6_Highlighted.png"),
	2 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier02OptionPage_6x6_Highlighted.png"),
	3 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier03OptionPage_6x6_Highlighted.png"),
	4 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier04OptionPage_6x6_Highlighted.png"),
	5 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier05OptionPage_6x6_Highlighted.png"),
	6 : preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage/Line_Tier06OptionPage_6x6_Highlighted.png"),
}

#

var any_page_category_empty : Almanac_Category_Data

var _color_id_to_tower_page_category_map : Dictionary
var others_color_page_category : Almanac_Category_Data

#var enemy_type__normal_category : Almanac_Category_Data
#var enemy_type__elite_category : Almanac_Category_Data
#var enemy_type__boss_category : Almanac_Category_Data

#

var almanac_page_gui : Almanac_Page setget set_almanac_page_gui

##

#func _ready():
func _on_singleton_initialize():
	call_deferred("_deferred_ready")

func _deferred_ready():
	_construct_shared_categories()
	_construct_tower_type_info_multi_stats_data()
	_construct_enemy_type_info_multi_stats_data()
	#
	
	_construct_main_page()
	
	_construct_enemy_factions_page()
	#
	_construct_enemy_faction_basic_page()
	_construct_enemy_faction_expert_page()
	_construct_enemy_faction_faithful_page()
	_construct_enemy_faction_skirmisher_page()
	
	#########
	
	_construct_tower_page()
	
	#########
	
	_construct_synergy_page()
	
	#########
	
	_construct_tidbit_page()
	

#

func set_almanac_page_gui(arg_page : Almanac_Page):
	almanac_page_gui = arg_page
	
	if almanac_page_gui.is_ready:
		almanac_page_gui.set_almanac_item_list_page_data(main_page)
	else:
		almanac_page_gui.connect("is_ready_finished", self, "_on_almanac_page_is_ready_finished", [], CONNECT_ONESHOT)


func _on_almanac_page_is_ready_finished():
	almanac_page_gui.set_almanac_item_list_page_data(main_page)

#

func _on_option_pressed__go_to_page_id_to_go_to(button, type_info, arg_option):
	var page_id = arg_option.page_id_to_go_to
	if page_id_to_page_data.has(page_id):
		_transfer_to_page(page_id_to_page_data[page_id])
		almanac_page_gui.hide_right_side_container()

func _on_page__requested_return_to_assigned_page_id(arg_page, arg_page_id_to_go_to):
	if page_id_to_page_data.has(arg_page_id_to_go_to):
		_transfer_to_page(page_id_to_page_data[arg_page_id_to_go_to])
		almanac_page_gui.hide_right_side_container()
	elif arg_page_id_to_go_to == PageIds.EXIT_ALMANAC:
		almanac_page_gui.hide_right_side_container()
		emit_signal("requested_exit_almanac")

func _transfer_to_page(arg_page):
	almanac_page_gui.set_almanac_item_list_page_data(arg_page)
	
	if arg_page.has_at_least_one_non_page_entry_data:
		var first_unobscured_option = arg_page.get_first_unobscured_almanac_item_list_entry_data()
		
		call_deferred("_deferred_right_side_init_of_transfer_page", first_unobscured_option)

func _deferred_right_side_init_of_transfer_page(first_unobscured_option):
	if first_unobscured_option != null:
		if first_unobscured_option.get_x_type_info_classification() == first_unobscured_option.TypeInfoClassification.TOWER:
			almanac_page_gui.configure_almanac_x_type_info_panel(first_unobscured_option, tower_multi_stats_data, first_unobscured_option.get_x_type_info(), first_unobscured_option.button_associated)
		elif first_unobscured_option.get_x_type_info_classification() == first_unobscured_option.TypeInfoClassification.ENEMY:
			almanac_page_gui.configure_almanac_x_type_info_panel(first_unobscured_option, enemy_multi_stats_data, first_unobscured_option.get_x_type_info(), first_unobscured_option.button_associated)

func _on_option_pressed__display_enemy_info(button, type_info, arg_option):
	if !arg_option.is_obscured:
		almanac_page_gui.configure_almanac_x_type_info_panel(arg_option, enemy_multi_stats_data, arg_option.get_x_type_info(), button)
	
#	if type_info == Almanac_ItemListEntry_Data.TypeInfoClassification.ENEMY:
#		almanac_page_gui.configure_almanac_x_type_info_panel(arg_option, enemy_multi_stats_data)
#	elif type_info == Almanac_ItemListEntry_Data.TypeInfoClassification.TOWER:
#		almanac_page_gui.configure_almanac_x_type_info_panel(arg_option, tower_multi_stats_data)
#

##


func update_state_of__all_options():
	_update_state_of__enemy_option()
	_update_state_of__tower_option()
	_update_state_of__synergy_option()
	_update_state_of__tidbit_option()
	
	##
	
	_update_tidbit_option_in_main_page_visibility()

func _update_state_of__enemy_option():
	for item_entry_data in _all_enemy_item_entry_data_options:
		item_entry_data.is_obscured = !StatsManager.if_enemy_killed_by_damage_count_is_at_least_x(item_entry_data.get_x_type_info().get_id__for_almanac_use(), enemy_count_min_for_unobscure)
		item_entry_data.is_hidden = item_entry_data.calculate_is_hidden__from_source_only()

func _update_state_of__tower_option():
	for item_entry_data in _all_tower_item_entry_data_options:
		item_entry_data.is_obscured = !StatsManager.if_tower_played_count_per_round_is_at_least_x(item_entry_data.get_x_type_info().get_id__for_almanac_use(), tower_count_min_for_unobscure)
		item_entry_data.is_hidden = item_entry_data.calculate_is_hidden__from_source_only()

func _update_state_of__synergy_option():
	for item_entry_data in _all_synergy_item_entry_data_options:
		item_entry_data.is_obscured = !StatsManager.if_synergy_id_has_at_least_x_play_count(item_entry_data.get_x_type_info().get_id__for_almanac_use(), syn_count_min_for_unobscure)
		item_entry_data.is_hidden = item_entry_data.calculate_is_hidden__from_source_only()

func _update_state_of__tidbit_option():
	for item_entry_data in _all_tidbit_item_entry_data_options:
		item_entry_data.is_obscured = !StatsManager.if_tidbit_id_has_at_least_x_val(item_entry_data.get_x_type_info().get_id__for_almanac_use(), tidbit_val_min_for_unobscure)
		item_entry_data.is_hidden = item_entry_data.calculate_is_hidden__from_source_only()


## Shared stuffs ## 

func _construct_shared_categories():
	any_page_category_empty = Almanac_Category_Data.new()
	any_page_category_empty.border_texture = CategoryBorder_Default
	any_page_category_empty.cat_type_id = CategoryIds.EMPTY
	
	#
	
	var red_page_category = Almanac_Category_Data.new()
	red_page_category.border_texture = CategoryBorder_Default
	red_page_category.cat_type_id = CategoryIds.TOWER_COLOR__RED
	red_page_category.border_modulate = Color(218/255.0, 2/255.0, 5/255.0)
	red_page_category.cat_text = "Red Towers"
	_color_id_to_tower_page_category_map[TowerColors.RED] = red_page_category
	
	var orange_page_category = Almanac_Category_Data.new()
	orange_page_category.border_texture = CategoryBorder_Default
	orange_page_category.cat_type_id = CategoryIds.TOWER_COLOR__ORANGE
	orange_page_category.border_modulate = Color(255/255.0, 128/255.0, 0/255.0)
	orange_page_category.cat_text = "Orange Towers"
	_color_id_to_tower_page_category_map[TowerColors.ORANGE] = orange_page_category
	
	var yellow_page_category = Almanac_Category_Data.new()
	yellow_page_category.border_texture = CategoryBorder_Default
	yellow_page_category.cat_type_id = CategoryIds.TOWER_COLOR__YELLOW
	yellow_page_category.border_modulate = Color(232/255.0, 253/255.0, 0/255.0)
	yellow_page_category.cat_text = "Yellow Towers"
	_color_id_to_tower_page_category_map[TowerColors.YELLOW] = yellow_page_category
	
	var green_page_category = Almanac_Category_Data.new()
	green_page_category.border_texture = CategoryBorder_Default
	green_page_category.cat_type_id = CategoryIds.TOWER_COLOR__GREEN
	green_page_category.border_modulate = Color(30/255.0, 218/255.0, 2/255.0)
	green_page_category.cat_text = "Green Towers"
	_color_id_to_tower_page_category_map[TowerColors.GREEN] = green_page_category
	
	var blue_page_category = Almanac_Category_Data.new()
	blue_page_category.border_texture = CategoryBorder_Default
	blue_page_category.cat_type_id = CategoryIds.TOWER_COLOR__BLUE
	blue_page_category.border_modulate = Color(2/255.0, 58/255.0, 218/255.0)
	blue_page_category.cat_text = "Blue Towers"
	_color_id_to_tower_page_category_map[TowerColors.BLUE] = blue_page_category
	
	var violet_page_category = Almanac_Category_Data.new()
	violet_page_category.border_texture = CategoryBorder_Default
	violet_page_category.cat_type_id = CategoryIds.TOWER_COLOR__VIOLET
	violet_page_category.border_modulate = Color(163/255.0, 77/255.0, 253/255.0)
	violet_page_category.cat_text = "Violet Towers"
	_color_id_to_tower_page_category_map[TowerColors.VIOLET] = violet_page_category
	
	var gray_page_category = Almanac_Category_Data.new()
	gray_page_category.border_texture = CategoryBorder_Default
	gray_page_category.cat_type_id = CategoryIds.TOWER_COLOR__GRAY
	gray_page_category.border_modulate = Color(133/255.0, 133/255.0, 133/255.0)
	gray_page_category.cat_text = "Gray Towers"
	_color_id_to_tower_page_category_map[TowerColors.GRAY] = gray_page_category
	
	var black_page_category = Almanac_Category_Data.new()
	black_page_category.border_texture = CategoryBorder_Default
	black_page_category.cat_type_id = CategoryIds.TOWER_COLOR__BLACK
	black_page_category.border_modulate = Color(20/255.0, 20/255.0, 20/255.0)
	black_page_category.cat_text = "Black Towers"
	_color_id_to_tower_page_category_map[TowerColors.BLACK] = black_page_category
	
	
	others_color_page_category = Almanac_Category_Data.new()
	others_color_page_category.border_texture = CategoryBorder_Default
	others_color_page_category.cat_type_id = CategoryIds.TOWER_COLOR__OTHERS
	others_color_page_category.cat_text = "Other Towers"
	others_color_page_category.border_modulate = Color(222/255.0, 222/255.0, 222/255.0)
	
	
#	enemy_type__normal_category = Almanac_Category_Data.new()
#	enemy_type__normal_category.border_texture = CategoryBorder_Default
#	enemy_type__normal_category.cat_type_id = CategoryIds.ENEMY_TYPE__NORMAL
#	enemy_type__normal_category.cat_text = "Normal Enemies"
#
#	enemy_type__elite_category = Almanac_Category_Data.new()
#	enemy_type__elite_category.border_texture = CategoryBorder_Default
#	enemy_type__elite_category.cat_type_id = CategoryIds.ENEMY_TYPE__NORMAL
#	enemy_type__elite_category.cat_text = "Elite Enemies"
#

func _construct_tower_type_info_multi_stats_data():
	tower_multi_stats_data = Almanac_MultiStatsData.new()
	
	# Base dmg
	var interpreter_for_main_attk = TextFragmentInterpreter.new()
	interpreter_for_main_attk.tower_info_to_use_for_tower_stat_fragments = null
	interpreter_for_main_attk.display_body = true
	interpreter_for_main_attk.display_header = false
	
	var ins = []
	ins.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1, -1))
	ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
	ins.append(TowerStatTextFragment.new(null, null, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1)) # stat basis does not matter here
	
	interpreter_for_main_attk.array_of_instructions = ins
	
	#var plain_fragment__abilities = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "abilities")
	
	#
	
	var name__base_dmg = "Base Damage"
	var icon__base_dmg = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage_RightSide/TowerPageRightSideIcon_BaseDmg.png")
	var var_name__base_dmg = "base_damage"
	var descriptions__base_dmg = [
		"Represents the strength of the tower's attacks. Contributes to the total damage from a main attack.",
		"",
		["Main attacks usually deal |0|.", [interpreter_for_main_attk]]
	]
	
	tower_multi_stats_data.add_x_type_info_data(name__base_dmg, icon__base_dmg, var_name__base_dmg, descriptions__base_dmg)
	
	#
	
	var name__dmg_type = "Damage Type"
	var icon__dmg_type = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage_RightSide/TowerPageRightSideIcon_DmgType.png")
	var var_name__dmg_type = "base_damage_type"
	var descriptions__dmg_type = [
		"The damage type of the tower's main attack.",
	]
	var var_value_converter_method_name__dmg_type = "_convert_dmg_type_to_proper_val"
	
	tower_multi_stats_data.add_x_type_info_data(name__dmg_type, icon__dmg_type, var_name__dmg_type, descriptions__dmg_type, var_value_converter_method_name__dmg_type, self)
	
	#
	
	var name__attk_speed = "Attack Speed"
	var icon__attk_speed = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage_RightSide/TowerPageRightSideIcon_AttkSpeed.png")
	var var_name__attk_speed = "base_attk_speed"
	var descriptions__attk_speed = [
		"The number of main attacks fired per second.",
	]
	
	tower_multi_stats_data.add_x_type_info_data(name__attk_speed, icon__attk_speed, var_name__attk_speed, descriptions__attk_speed)
	
	#
	
	var name__range = "Range"
	var icon__range = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage_RightSide/TowerPageRightSideIcon_Range.png")
	var var_name__range = "base_range"
	var descriptions__range = [
		"The radius for detecting enemies. Larger range leads to a larger detection area.",
	]
	
	tower_multi_stats_data.add_x_type_info_data(name__range, icon__range, var_name__range, descriptions__range)
	
	#
	
	var name__on_hit_dmg = "On Hit Damage"
	var icon__on_hit_dmg = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/TowerPage_RightSide/TowerPageRightSideIcon_OnHitDmg.png")
	var var_name__on_hit_dmg = "base_on_hit_damage"
	var descriptions__on_hit_dmg = [
		"The amount of extra damage added on top of main attacks. All towers have no base on hit damage, but can get bonuses from other sources.",
		"On hit damages have their own damage type.",
		"",
		["Main attacks usually deal |0|.", [interpreter_for_main_attk]]
	]
	
	tower_multi_stats_data.add_x_type_info_data(name__on_hit_dmg, icon__on_hit_dmg, var_name__on_hit_dmg, descriptions__on_hit_dmg)
	
	

func _convert_dmg_type_to_proper_val(arg_val, x_type_info):
	return DamageType.get_name_of_damage_type(arg_val)

#

func _construct_enemy_type_info_multi_stats_data():
	enemy_multi_stats_data = Almanac_MultiStatsData.new()
	
	# Health
	var name__health = "Health"
	var icon__health = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyPage_RightSide/EnemyPageRightSideIcon_Health.png")
	var var_name__health = "base_health"
	var descriptions__health = [
		"The amount of damage the enemy can take before going down.",
		"Health scales based on the stage and round."
	]
	var var_value_converter_method_name__health = "_convert_enemy_val_to_proper_val"
	
	enemy_multi_stats_data.add_x_type_info_data(name__health, icon__health, var_name__health, descriptions__health, var_value_converter_method_name__health, self)
	
	
	var name__mov_speed = "Mov Speed"
	var icon__mov_speed = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyPage_RightSide/EnemyPageRightSideIcon_MovSpeed.png")
	var var_name__mov_speed = "base_movement_speed"
	var descriptions__mov_speed = [
		"The speed of the enemy."
	]
	enemy_multi_stats_data.add_x_type_info_data(name__mov_speed, icon__mov_speed, var_name__mov_speed, descriptions__mov_speed)
	
	
	var name__armor = "Armor"
	var icon__armor = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyPage_RightSide/EnemyPageRightSideIcon_Armor.png")
	var var_name__armor = "base_armor"
	var desc_func_name__armor = "_get_desc_for_base_armor"
	enemy_multi_stats_data.add_x_type_info_data(name__armor, icon__armor, var_name__armor, null, null, null, desc_func_name__armor, self)
	
	
	var name__toughness = "Toughness"
	var icon__toughness = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyPage_RightSide/EnemyPageRightSideIcon_Toughness.png")
	var var_name__toughness = "base_toughness"
	var desc_func_name__toughness = "_get_desc_for_base_toughness"
	enemy_multi_stats_data.add_x_type_info_data(name__toughness, icon__toughness, var_name__toughness, null, null, null, desc_func_name__toughness, self)
	
	
	var name__resistance = "Resistance"
	var icon__resistance = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyPage_RightSide/EnemyPageRightSideIcon_Resistance.png")
	var var_name__resistance = "base_resistance"
	var desc_func_name__resistance = "_get_desc_for_base_resistance"
	enemy_multi_stats_data.add_x_type_info_data(name__resistance, icon__resistance, var_name__resistance, null, null, null, desc_func_name__resistance, self)
	
	
	var name__player_dmg = "Player Damage"
	var icon__player_dmg = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyPage_RightSide/EnemyPageRightSideIcon_PlayerDamage.png")
	var var_name__player_dmg = "base_player_damage"
	var descriptions__player_dmg = [
		"The baseline amount of damage the enemy deals to the player health when escaping."
	]
	var var_value_converter_method_name__player_dmg = "_convert_enemy_val_to_proper_val"
	
	enemy_multi_stats_data.add_x_type_info_data(name__player_dmg, icon__player_dmg, var_name__player_dmg, descriptions__player_dmg, var_value_converter_method_name__player_dmg, self)
	


func _convert_enemy_val_to_proper_val(arg_val, x_type_info):
	var val = arg_val
	
	if val == EnemyTypeInformation.VALUE_DETERMINED_BY_OTHER_FACTORS:
		val = "Value Varies"
	
	return val

func _get_desc_for_base_armor(x_type_info):
	var plain_fragment__physical_damage = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.PHYSICAL_DAMAGE, "physical damage")
	var multiplier = AbstractEnemy.calculate_multiplier_from_total_armor_or_tou(x_type_info.base_armor)
	var reduc = 100 - (100 * multiplier)
	
	return [
		["The damage reduction of the enemy against |0|.", [plain_fragment__physical_damage]],
		"",
		"Percentage reduction: %d%%" % reduc
	]

func _get_desc_for_base_toughness(x_type_info):
	var plain_fragment__ele_damage = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ELEMENTAL_DAMAGE, "elemental damage")
	var multiplier = AbstractEnemy.calculate_multiplier_from_total_armor_or_tou(x_type_info.base_toughness)
	var reduc = 100 - (100 * multiplier)
	
	return [
		["The damage reduction of the enemy against |0|.", [plain_fragment__ele_damage]],
		"",
		"Percentage reduction: %d%%" % reduc
	]

func _get_desc_for_base_resistance(x_type_info):
	var plain_fragment__physical_damage = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.PHYSICAL_DAMAGE, "physical damage")
	var plain_fragment__ele_damage = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ELEMENTAL_DAMAGE, "elemental damage")
	var multiplier = AbstractEnemy.calculate_multiplier_from_total_res(x_type_info.base_resistance)
	var reduc = 100 - (100 * multiplier)
	
	return [
		["The damage reduction of the enemy against both |0| and |1|.", [plain_fragment__physical_damage, plain_fragment__ele_damage]],
		"Percentage reduction with armor or toughness stacks multiplicatively.",
		"",
		"Percentage reduction: %d%%" % reduc
	]

#### MAIN PAGE ######

func _construct_main_page():
	var tower_option = Almanac_ItemListEntry_Data.new()
	tower_option.border_texture__normal = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/Line_TowerOptionPage_6x6_Normal.png")
	tower_option.border_texture__highlighted = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/Line_TowerOptionPage_6x6_Highlighted.png")
	tower_option.add_texture_to_texture_list(preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/TowerOption_MainMenu_Icon_40x40.png"))
	tower_option.set_x_type_info_classification(Almanac_ItemListEntry_Data.TypeInfoClassification.PAGE)
	tower_option.footer_text = "Towers"
	tower_option.page_id_to_go_to = PageIds.TOWER_PAGE
	tower_option.connect("button_associated_pressed", self, "_on_option_pressed__go_to_page_id_to_go_to", [tower_option], CONNECT_PERSIST)
	
	
	var enemy_option = Almanac_ItemListEntry_Data.new()
	enemy_option.border_texture__normal = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/Line_EnemyOptionPage_6x6_Normal.png")
	enemy_option.border_texture__highlighted = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/Line_EnemyOptionPage_6x6_Highlighted.png")
	enemy_option.add_texture_to_texture_list(preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/EnemyOption_MainMenu_Icon_40x40.png"))
	enemy_option.set_x_type_info_classification(Almanac_ItemListEntry_Data.TypeInfoClassification.PAGE)
	enemy_option.footer_text = "Enemies"
	enemy_option.page_id_to_go_to = PageIds.ENEMY_FACTION_PAGE
	enemy_option.connect("button_associated_pressed", self, "_on_option_pressed__go_to_page_id_to_go_to", [enemy_option], CONNECT_PERSIST)
	
	
	var synergy_option = Almanac_ItemListEntry_Data.new()
	synergy_option.border_texture__normal = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/Line_SynergyOptionPage_6x6_Normal.png")
	synergy_option.border_texture__highlighted = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/Line_SynergyOptionPage_6x6_Highlighted.png")
	synergy_option.add_texture_to_texture_list(preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/SynergyOption_MainMenu_Icon_40x40.png"))
	synergy_option.set_x_type_info_classification(Almanac_ItemListEntry_Data.TypeInfoClassification.PAGE)
	synergy_option.footer_text = "Synergies"
	synergy_option.page_id_to_go_to = PageIds.SYNERGY_PAGE
	synergy_option.connect("button_associated_pressed", self, "_on_option_pressed__go_to_page_id_to_go_to", [synergy_option], CONNECT_PERSIST)
	
	
	tidbit_option__in_main_page = Almanac_ItemListEntry_Data.new()
	tidbit_option__in_main_page.border_texture__normal = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/Line_TidbitOptionPage_6x6_Normal.png")
	tidbit_option__in_main_page.border_texture__highlighted = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/Line_TidbitOptionPage_6x6_Highlighted.png")
	tidbit_option__in_main_page.add_texture_to_texture_list(preload("res://GeneralGUIRelated/AlmanacGUI/Assets/MainMenu/TidbitOption_MainMenu_Icon_40x40.png"))
	tidbit_option__in_main_page.set_x_type_info_classification(Almanac_ItemListEntry_Data.TypeInfoClassification.PAGE)
	tidbit_option__in_main_page.footer_text = "Tidbits"
	tidbit_option__in_main_page.page_id_to_go_to = PageIds.TIDBIT_PAGE
	tidbit_option__in_main_page.connect("button_associated_pressed", self, "_on_option_pressed__go_to_page_id_to_go_to", [tidbit_option__in_main_page], CONNECT_PERSIST)
	
	if StatsManager.is_stats_loaded:
		_update_tidbit_option_in_main_page_visibility()
	else:
		if !StatsManager.is_connected("stats_loaded", self, "_on_stats_manager_stats_loaded__for_pages_not_options"):
			StatsManager.connect("stats_loaded", self, "_on_stats_manager_stats_loaded__for_pages_not_options", [], CONNECT_ONESHOT)
	
	
	#
	main_page = Almanac_ItemListPage_Data.new()
	main_page.add_almanac_item_list_entry_data_to_category(tower_option, any_page_category_empty)
	main_page.add_almanac_item_list_entry_data_to_category(enemy_option, any_page_category_empty)
	main_page.add_almanac_item_list_entry_data_to_category(synergy_option, any_page_category_empty)
	main_page.add_almanac_item_list_entry_data_to_category(tidbit_option__in_main_page, any_page_category_empty)
	main_page.page_id_to_return_to = PageIds.EXIT_ALMANAC
	main_page.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.MAIN_PAGE] = main_page

func _update_tidbit_option_in_main_page_visibility():
	tidbit_option__in_main_page.is_hidden = !StatsManager.if_tidbit_map_has_at_least_one_tidbit_with_non_zero_val()



#### ENEMY FACTION PAGE ########

func _construct_enemy_factions_page():
	var enemy_fac_first_half_category_empty = Almanac_Category_Data.new()
	enemy_fac_first_half_category_empty.border_texture = CategoryBorder_Default
	enemy_fac_first_half_category_empty.cat_type_id = CategoryIds.ENEMY_FACTION__FIRST_HALF
	enemy_fac_first_half_category_empty.cat_text = "First Half Factions"
	
	var enemy_fac_sec_half_category_empty = Almanac_Category_Data.new()
	enemy_fac_sec_half_category_empty.border_texture = CategoryBorder_Default
	enemy_fac_sec_half_category_empty.cat_type_id = CategoryIds.ENEMY_FACTION__SECOND_HALF
	enemy_fac_sec_half_category_empty.cat_text = "Second Half Factions"
	
	#
	
	var basic_option = Almanac_ItemListEntry_Data.new()
	basic_option.border_texture__normal = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/Line_FactionBasicOptionPage_6x6_Normal.png")
	basic_option.border_texture__highlighted = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/Line_FactionBasicOptionPage_6x6_Highlighted.png")
	basic_option.add_texture_to_texture_list(preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/EnemyFacBasicOption_FactionsPage_Icon_40x40.png"))
	basic_option.set_x_type_info_classification(Almanac_ItemListEntry_Data.TypeInfoClassification.PAGE)
	basic_option.footer_text = "Basic"
	basic_option.page_id_to_go_to = PageIds.ENEMY_FACTION_PAGE__BASIC
	basic_option.connect("button_associated_pressed", self, "_on_option_pressed__go_to_page_id_to_go_to", [basic_option], CONNECT_PERSIST)
	
	var expert_option = Almanac_ItemListEntry_Data.new()
	expert_option.border_texture__normal = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/Line_FactionExpertOptionPage_6x6_Normal.png")
	expert_option.border_texture__highlighted = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/Line_FactionExpertOptionPage_6x6_Highlighted.png")
	expert_option.add_texture_to_texture_list(preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/EnemyFacExpertOption_FactionsPage_Icon_40x40.png"))
	expert_option.set_x_type_info_classification(Almanac_ItemListEntry_Data.TypeInfoClassification.PAGE)
	expert_option.footer_text = "Expert"
	expert_option.page_id_to_go_to = PageIds.ENEMY_FACTION_PAGE__EXPERT
	expert_option.connect("button_associated_pressed", self, "_on_option_pressed__go_to_page_id_to_go_to", [expert_option], CONNECT_PERSIST)
	
	var faithful_option = Almanac_ItemListEntry_Data.new()
	faithful_option.border_texture__normal = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/Line_FactionFaithfulOptionPage_6x6_Normal.png")
	faithful_option.border_texture__highlighted = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/Line_FactionFaithfulOptionPage_6x6_Highlighted.png")
	faithful_option.add_texture_to_texture_list(preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/EnemyFacFaithfulOption_FactionsPage_Icon_40x40.png"))
	faithful_option.set_x_type_info_classification(Almanac_ItemListEntry_Data.TypeInfoClassification.PAGE)
	faithful_option.footer_text = "Expert"
	faithful_option.page_id_to_go_to = PageIds.ENEMY_FACTION_PAGE__FAITHFUL
	faithful_option.connect("button_associated_pressed", self, "_on_option_pressed__go_to_page_id_to_go_to", [faithful_option], CONNECT_PERSIST)
	
	var skirmisher_option = Almanac_ItemListEntry_Data.new()
	skirmisher_option.border_texture__normal = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/Line_FactionSkirmisherOptionPage_6x6_Normal.png")
	skirmisher_option.border_texture__highlighted = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/Line_FactionSkirmisherOptionPage_6x6_Highlighted.png")
	skirmisher_option.add_texture_to_texture_list(preload("res://GeneralGUIRelated/AlmanacGUI/Assets/EnemyFactionPage/EnemyFacSkirmisherOption_FactionsPage_Icon_40x40.png"))
	skirmisher_option.set_x_type_info_classification(Almanac_ItemListEntry_Data.TypeInfoClassification.PAGE)
	skirmisher_option.footer_text = "Expert"
	skirmisher_option.page_id_to_go_to = PageIds.ENEMY_FACTION_PAGE__SKIRMISHER
	skirmisher_option.connect("button_associated_pressed", self, "_on_option_pressed__go_to_page_id_to_go_to", [skirmisher_option], CONNECT_PERSIST)
	
	
	enemy_factions_page = Almanac_ItemListPage_Data.new()
	enemy_factions_page.add_almanac_item_list_entry_data_to_category(basic_option, enemy_fac_first_half_category_empty)
	
	enemy_factions_page.add_almanac_item_list_entry_data_to_category(expert_option, enemy_fac_sec_half_category_empty)
	enemy_factions_page.add_almanac_item_list_entry_data_to_category(faithful_option, enemy_fac_sec_half_category_empty)
	enemy_factions_page.add_almanac_item_list_entry_data_to_category(skirmisher_option, enemy_fac_sec_half_category_empty)
	enemy_factions_page.page_id_to_return_to = PageIds.MAIN_PAGE
	enemy_factions_page.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.ENEMY_FACTION_PAGE] = enemy_factions_page
	

## BASIC
func _construct_enemy_faction_basic_page():
	enemy_faction_page__basic = Almanac_ItemListPage_Data.new()
	enemy_faction_page__basic.page_id_to_return_to = PageIds.ENEMY_FACTION_PAGE
	enemy_faction_page__basic.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.ENEMY_FACTION_PAGE__BASIC] = enemy_faction_page__basic
	
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.BASIC, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.PAIN, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.HEALER, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.DASH, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.BRUTE, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.WIZARD, enemy_faction_page__basic, any_page_category_empty)
	

## EXPERT
func _construct_enemy_faction_expert_page():
	enemy_faction_page__expert = Almanac_ItemListPage_Data.new()
	enemy_faction_page__expert.page_id_to_return_to = PageIds.ENEMY_FACTION_PAGE
	enemy_faction_page__expert.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.ENEMY_FACTION_PAGE__EXPERT] = enemy_faction_page__expert
	
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.EXPERIENCED, enemy_faction_page__expert, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.ASSASSIN, enemy_faction_page__expert, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.ENCHANTRESS, enemy_faction_page__expert, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.CHARGE, enemy_faction_page__expert, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.FIEND, enemy_faction_page__expert, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.MAGUS, enemy_faction_page__expert, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.GRANDMASTER, enemy_faction_page__expert, any_page_category_empty)
	

## FAITHFUL
func _construct_enemy_faction_faithful_page():
	enemy_faction_page__faithful = Almanac_ItemListPage_Data.new()
	enemy_faction_page__faithful.page_id_to_return_to = PageIds.ENEMY_FACTION_PAGE
	enemy_faction_page__faithful.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.ENEMY_FACTION_PAGE__FAITHFUL] = enemy_faction_page__faithful
	
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.DEITY, enemy_faction_page__faithful, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.BELIEVER, enemy_faction_page__faithful, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.CROSS_BEARER, enemy_faction_page__faithful, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.PRIEST, enemy_faction_page__faithful, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.SACRIFICER, enemy_faction_page__faithful, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.SEER, enemy_faction_page__faithful, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.DVARAPALA, enemy_faction_page__faithful, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.PROVIDENCE, enemy_faction_page__faithful, any_page_category_empty)
	

## SKIRMISHER
func _construct_enemy_faction_skirmisher_page():
	enemy_faction_page__skirmisher = Almanac_ItemListPage_Data.new()
	enemy_faction_page__skirmisher.page_id_to_return_to = PageIds.ENEMY_FACTION_PAGE
	enemy_faction_page__skirmisher.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.ENEMY_FACTION_PAGE__SKIRMISHER] = enemy_faction_page__skirmisher
	
	
	var skirm_blue_page_category = Almanac_Category_Data.new()
	skirm_blue_page_category.border_texture = CategoryBorder_Default
	skirm_blue_page_category.cat_type_id = CategoryIds.ENEMY_SKIRM_BLUE
	skirm_blue_page_category.cat_text = "Blue Sided"
	skirm_blue_page_category.cat_description = [
		"Blue Skirmishers appear and traverse in the standard path normally."
	]
	
	var skirm_red_page_category = Almanac_Category_Data.new()
	skirm_red_page_category.border_texture = CategoryBorder_Default
	skirm_red_page_category.cat_type_id = CategoryIds.ENEMY_SKIRM_RED
	skirm_red_page_category.cat_text = "Red Sided"
	skirm_red_page_category.cat_description = [
		"Red Skirmishers appear and traverse in the standard path but reversed (Enters at Blue side exit, exits at Blue side entrance)."
	]
	
	var skirm_both_page_category = Almanac_Category_Data.new()
	skirm_both_page_category.border_texture = CategoryBorder_Default
	skirm_both_page_category.cat_type_id = CategoryIds.ENEMY_SKIRM_BOTH
	skirm_both_page_category.cat_text = "Dual Sided"
	skirm_both_page_category.cat_description = [
		"These Skirmishers can appear as Blue and Red."
	]
	
	# BLUE
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.SMOKE, enemy_faction_page__skirmisher, skirm_blue_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.BLESSER, enemy_faction_page__skirmisher, skirm_blue_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.PROXIMITY, enemy_faction_page__skirmisher, skirm_blue_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.RALLIER, enemy_faction_page__skirmisher, skirm_blue_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.COSMIC, enemy_faction_page__skirmisher, skirm_blue_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.ASCENDER, enemy_faction_page__skirmisher, skirm_blue_page_category)
	
	# RED
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.BLASTER, enemy_faction_page__skirmisher, skirm_red_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.DANSEUR, enemy_faction_page__skirmisher, skirm_red_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.TOSSER, enemy_faction_page__skirmisher, skirm_red_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.ARTILLERY, enemy_faction_page__skirmisher, skirm_red_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.FINISHER, enemy_faction_page__skirmisher, skirm_red_page_category)
	
	# BOTH
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.RUFFIAN, enemy_faction_page__skirmisher, skirm_both_page_category)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.HOMERUNNER, enemy_faction_page__skirmisher, skirm_both_page_category)
	

#

func _construct_and_add_enemy_option_for_enemy(arg_enemy_id, arg_page_to_add_to, arg_category_to_use):
	var type_info = EnemyConstants.enemy_id_info_type_singleton_map[arg_enemy_id]
	
	var enemy_option = Almanac_ItemListEntry_Data.new()
	enemy_option.border_texture__normal = enemy_type_to_border_texture_map__normal[type_info.enemy_type]
	enemy_option.border_texture__highlighted = enemy_type_to_border_texture_map__highlight[type_info.enemy_type]
	enemy_option.set_x_type_info(type_info, Almanac_ItemListEntry_Data.TypeInfoClassification.ENEMY)
	enemy_option.connect("button_associated_pressed", self, "_on_option_pressed__display_enemy_info", [enemy_option], CONNECT_PERSIST)
	
	if StatsManager.is_stats_loaded:
		enemy_option.is_obscured = !StatsManager.if_enemy_killed_by_damage_count_is_at_least_x(arg_enemy_id, enemy_count_min_for_unobscure)
	else:
		if !StatsManager.is_connected("stats_loaded", self, "_on_stats_manager_stats_loaded"):
			StatsManager.connect("stats_loaded", self, "_on_stats_manager_stats_loaded", [], CONNECT_ONESHOT)
	
	_all_enemy_item_entry_data_options.append(enemy_option)
	
	arg_page_to_add_to.add_almanac_item_list_entry_data_to_category(enemy_option, arg_category_to_use)


func _on_stats_manager_stats_loaded():
	update_state_of__all_options()

func _on_stats_manager_stats_loaded__for_pages_not_options():
	_update_tidbit_option_in_main_page_visibility()


######

func _construct_tower_page():
	tower_page = Almanac_ItemListPage_Data.new()
	tower_page.page_id_to_return_to = PageIds.MAIN_PAGE
	tower_page.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.TOWER_PAGE] = tower_page
	
	##
	
	_construct_tower_category_with_towers__with_color(TowerColors.RED, tower_page)
	_construct_tower_category_with_towers__with_color(TowerColors.ORANGE, tower_page)
	_construct_tower_category_with_towers__with_color(TowerColors.YELLOW, tower_page)
	_construct_tower_category_with_towers__with_color(TowerColors.GREEN, tower_page)
	_construct_tower_category_with_towers__with_color(TowerColors.BLUE, tower_page)
	_construct_tower_category_with_towers__with_color(TowerColors.VIOLET, tower_page)
	_construct_tower_category_with_towers__with_color(TowerColors.BLACK, tower_page)
	_construct_tower_category_with_towers__with_color(TowerColors.GRAY, tower_page)
	

func _construct_tower_category_with_towers__with_color(arg_color : int, arg_page_to_add_to):
	var tower_type_info_list : Array = []
	for tower_id in Towers.tower_color_to_tower_id_map[arg_color]:
		var tower_type_info = Towers.tower_id_info_type_singleton_map[tower_id]
		tower_type_info_list.append(tower_type_info)
		#_construct_tower_option_for_tower(tower_id, )
	
	tower_type_info_list.sort_custom(self, "_sort_tower_type_info_list")
	
	
	for tower_type_info in tower_type_info_list:
		
		if tower_type_info.colors.size() > 0:
			var cat = _get_color_category_based_on_tower_color_id(arg_color)
			_construct_tower_option_for_tower(tower_type_info, cat, arg_page_to_add_to)
		else:
			_construct_tower_option_for_tower(tower_type_info, others_color_page_category, arg_page_to_add_to)

static func _sort_tower_type_info_list(tower_type_a, tower_type_b):
	if tower_type_a.tower_tier != tower_type_b.tower_tier:
		return tower_type_a.tower_tier < tower_type_b.tower_tier
	else:
		return tower_type_a.tower_name < tower_type_b.tower_name



func _get_color_category_based_on_tower_color_id(arg_id):
	if _color_id_to_tower_page_category_map.has(arg_id):
		return _color_id_to_tower_page_category_map[arg_id]
	else:
		return others_color_page_category

func _construct_tower_option_for_tower(type_info, arg_category_to_use, arg_page_to_add_to):
	var tower_option = Almanac_ItemListEntry_Data.new()
	tower_option.border_texture__normal = tower_tier_to_border_texture_map__normal[type_info.tower_tier]
	tower_option.border_texture__highlighted = tower_tier_to_border_texture_map__highlight[type_info.tower_tier]
	tower_option.set_x_type_info(type_info, Almanac_ItemListEntry_Data.TypeInfoClassification.TOWER)
	tower_option.connect("button_associated_pressed", self, "_on_option_pressed__display_tower_info", [tower_option], CONNECT_PERSIST)
	
	if StatsManager.is_stats_loaded:
		tower_option.is_obscured = !StatsManager.if_tower_played_count_per_round_is_at_least_x(type_info.get_id__for_almanac_use(), tower_count_min_for_unobscure)
	else:
		if !StatsManager.is_connected("stats_loaded", self, "_on_stats_manager_stats_loaded"):
			StatsManager.connect("stats_loaded", self, "_on_stats_manager_stats_loaded", [], CONNECT_ONESHOT)
	
	_all_tower_item_entry_data_options.append(tower_option)
	
	arg_page_to_add_to.add_almanac_item_list_entry_data_to_category(tower_option, arg_category_to_use)
	

func _on_option_pressed__display_tower_info(button, type_info, arg_option):
	if !arg_option.is_obscured:
		almanac_page_gui.configure_almanac_x_type_info_panel(arg_option, tower_multi_stats_data, arg_option.get_x_type_info(), button)
	

##############

func _construct_synergy_page():
	synergy_page = Almanac_ItemListPage_Data.new()
	synergy_page.page_id_to_return_to = PageIds.MAIN_PAGE
	synergy_page.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.SYNERGY_PAGE] = synergy_page
	
	##
	
	var dom_syn_page_category = Almanac_Category_Data.new()
	dom_syn_page_category.border_texture = CategoryBorder_Default
	dom_syn_page_category.cat_type_id = CategoryIds.SYNERGY_DOMINANT
	dom_syn_page_category.cat_text = "Dominant Synergy"
	dom_syn_page_category.cat_description = [
		"Color synergies with only one color."
	]
	
	var compo_syn_page_category = Almanac_Category_Data.new()
	compo_syn_page_category.border_texture = CategoryBorder_Default
	compo_syn_page_category.cat_type_id = CategoryIds.SYNERGY_COMPOSITE
	compo_syn_page_category.cat_text = "Composite Synergy"
	compo_syn_page_category.cat_description = [
		"Color synergies with more than one color."
	]
	
	#
	
	for syn_id in TowerDominantColors.available_synergy_ids:
		_construct_synergy_option__with_category(TowerDominantColors.get_synergy_with_id(syn_id), dom_syn_page_category, synergy_page)
	for syn_id in TowerCompositionColors.available_synergy_ids:
		_construct_synergy_option__with_category(TowerCompositionColors.get_synergy_with_id(syn_id), compo_syn_page_category, synergy_page)
	

func _construct_synergy_option__with_category(arg_syn, arg_category_to_use, arg_page_to_add_to):
	var syn_option = Almanac_ItemListEntry_Data.new()
	syn_option.border_texture__normal = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/SynergyPage_RightSide/Line_SynergyOptionBorder_6x6_Normal.png")
	syn_option.border_texture__highlighted = preload("res://GeneralGUIRelated/AlmanacGUI/Assets/SynergyPage_RightSide/Line_SynergyOptionBorder_6x6_Highlighted.png")
	syn_option.set_x_type_info(arg_syn, Almanac_ItemListEntry_Data.TypeInfoClassification.SYNERGY)
	syn_option.connect("button_associated_pressed", self, "_on_option_pressed__display_syn_info", [syn_option], CONNECT_PERSIST)
	
	if StatsManager.is_stats_loaded:
		syn_option.is_obscured = !StatsManager.if_synergy_id_has_at_least_x_play_count(arg_syn.get_id__for_almanac_use(), syn_count_min_for_unobscure)
	else:
		if !StatsManager.is_connected("stats_loaded", self, "_on_stats_manager_stats_loaded"):
			StatsManager.connect("stats_loaded", self, "_on_stats_manager_stats_loaded", [], CONNECT_ONESHOT)
	
	_all_synergy_item_entry_data_options.append(syn_option)
	
	arg_page_to_add_to.add_almanac_item_list_entry_data_to_category(syn_option, arg_category_to_use)
	

func _on_option_pressed__display_syn_info(button, type_info, arg_option):
	if !arg_option.is_obscured:
		almanac_page_gui.configure_almanac_x_type_info_panel(arg_option, tower_multi_stats_data, arg_option.get_x_type_info(), button)
	

##########

func _construct_tidbit_page():
	tidbit_page = Almanac_ItemListPage_Data.new()
	tidbit_page.page_id_to_return_to = PageIds.MAIN_PAGE
	tidbit_page.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.TIDBIT_PAGE] = tidbit_page
	
	#########
	
	for id in StoreOfTextTidbit.TidbitId.values():
		var tidbit = StoreOfTextTidbit.tidbit_id_to_info_singleton_map[id]
		
		_construct_option_for_tidbit(tidbit, any_page_category_empty, tidbit_page)



func _construct_option_for_tidbit(arg_tidbit, arg_category_to_use, arg_page_to_add_to):
	var tidbit_option = Almanac_ItemListEntry_Data.new()
	tidbit_option.border_texture__normal = tidbit_tier_to_border_texture_map__normal[arg_tidbit.tidbit_tier] #preload("res://GeneralGUIRelated/AlmanacGUI/Assets/SynergyPage_RightSide/Line_SynergyOptionBorder_6x6_Normal.png")
	tidbit_option.border_texture__highlighted = tidbit_tier_to_border_texture_map__highlight[arg_tidbit.tidbit_tier]
	tidbit_option.set_x_type_info(arg_tidbit, Almanac_ItemListEntry_Data.TypeInfoClassification.TEXT_TIDBIT)
	tidbit_option.connect("button_associated_pressed", self, "_on_option_pressed__display_tidbit_info", [tidbit_option], CONNECT_PERSIST)
	
	if StatsManager.is_stats_loaded:
		_update_tidbit_option_status(tidbit_option, arg_tidbit)
	else:
		if !StatsManager.is_connected("stats_loaded", self, "_on_stats_manager_stats_loaded"):
			StatsManager.connect("stats_loaded", self, "_on_stats_manager_stats_loaded", [], CONNECT_ONESHOT)
	
	_all_tidbit_item_entry_data_options.append(tidbit_option)
	
	arg_page_to_add_to.add_almanac_item_list_entry_data_to_category(tidbit_option, arg_category_to_use)

func _update_tidbit_option_status(tidbit_option, arg_tidbit):
	tidbit_option.is_obscured = !StatsManager.if_tidbit_id_has_at_least_x_val(arg_tidbit.get_id__for_almanac_use(), tidbit_val_min_for_unobscure)

func _on_option_pressed__display_tidbit_info(button, type_info, arg_option):
	if !arg_option.is_obscured:
		almanac_page_gui.configure_almanac_x_type_info_panel(arg_option, tower_multi_stats_data, arg_option.get_x_type_info(), button)
	

##########################




