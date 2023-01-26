extends Node

const Almanac_Category_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_Category_Data.gd")
const Almanac_ItemListEntry_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListEntry_Data.gd")
const Almanac_ItemListPage_Data = preload("res://GeneralGUIRelated/AlmanacGUI/DataClasses/Almanac_ItemListPage_Data.gd")

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

var main_page : Almanac_ItemListPage_Data

var enemy_factions_page : Almanac_ItemListPage_Data

var enemy_faction_page__basic : Almanac_ItemListPage_Data
var enemy_faction_page__expert : Almanac_ItemListPage_Data
var enemy_faction_page__faithful : Almanac_ItemListPage_Data
var enemy_faction_page__skirmisher : Almanac_ItemListPage_Data

#

enum PageIds {
	EXIT_ALMANAC = -1,
	
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
	
}

enum CategoryIds {
	EMPTY = 1
	
	ENEMY_FACTION__FIRST_HALF = 10
	ENEMY_FACTION__SECOND_HALF = 11
	
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

#

var any_page_category_empty : Almanac_Category_Data

#var enemy_type__normal_category : Almanac_Category_Data
#var enemy_type__elite_category : Almanac_Category_Data
#var enemy_type__boss_category : Almanac_Category_Data

#

var almanac_page_gui : Almanac_Page setget set_almanac_page_gui

##

func _init():
	
	_construct_shared_categories()
	#
	
	_construct_main_page()
	
	_construct_enemy_factions_page()
	
	_construct_enemy_faction_basic_page()

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

func _on_page__requested_return_to_assigned_page_id(arg_page, arg_page_id_to_go_to):
	if page_id_to_page_data.has(arg_page_id_to_go_to):
		_transfer_to_page(page_id_to_page_data[arg_page_id_to_go_to])
	elif arg_page_id_to_go_to == PageIds.EXIT_ALMANAC:
		emit_signal("requested_exit_almanac")

func _transfer_to_page(arg_page):
	almanac_page_gui.set_almanac_item_list_page_data(arg_page)

#

func _on_option_pressed__display_enemy_info(button, type_info, arg_option):
	pass

## Shared stuffs ## 

func _construct_shared_categories():
	any_page_category_empty = Almanac_Category_Data.new()
	any_page_category_empty.border_texture = CategoryBorder_Default
	any_page_category_empty.cat_type_id = CategoryIds.EMPTY
	
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
	
	
	#
	main_page = Almanac_ItemListPage_Data.new()
	main_page.add_almanac_item_list_entry_data_to_category(tower_option, any_page_category_empty)
	main_page.add_almanac_item_list_entry_data_to_category(enemy_option, any_page_category_empty)
	main_page.add_almanac_item_list_entry_data_to_category(synergy_option, any_page_category_empty)
	main_page.page_id_to_return_to = PageIds.EXIT_ALMANAC
	main_page.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.MAIN_PAGE] = main_page
	

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
	

func _construct_enemy_faction_basic_page():
	enemy_faction_page__basic = Almanac_ItemListPage_Data.new()
	enemy_faction_page__basic.page_id_to_return_to = PageIds.ENEMY_FACTION_PAGE
	enemy_factions_page.connect("requested_return_to_assigned_page_id", self, "_on_page__requested_return_to_assigned_page_id", [], CONNECT_PERSIST)
	
	page_id_to_page_data[PageIds.ENEMY_FACTION_PAGE__BASIC] = enemy_faction_page__basic
	
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.BASIC, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.PAIN, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.HEALER, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.CHARGE, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.BRUTE, enemy_faction_page__basic, any_page_category_empty)
	_construct_and_add_enemy_option_for_enemy(EnemyConstants.Enemies.WIZARD, enemy_faction_page__basic, any_page_category_empty)
	

func _construct_and_add_enemy_option_for_enemy(arg_enemy_id, arg_page_to_add_to, arg_category_to_use):
	var type_info = EnemyConstants.enemy_id_info_type_singleton_map[arg_enemy_id]
	
	var enemy_option = Almanac_ItemListEntry_Data.new()
	enemy_option.border_texture__normal = enemy_type_to_border_texture_map__normal[type_info.enemy_type]
	enemy_option.border_texture__highlighted = enemy_type_to_border_texture_map__highlight[type_info.enemy_type]
	enemy_option.set_x_type_info(type_info)
	enemy_option.connect("button_associated_pressed", self, "_on_option_pressed__display_enemy_info", [enemy_option], CONNECT_PERSIST)
	
	arg_page_to_add_to



