extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
#const Hero = preload("res://TowerRelated/Color_White/Hero/Hero.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const Hero_WholeScreenGUI = preload("res://TowerRelated/Color_White/Hero/HeroGUI_Related/Hero_WholeScreenGUI.gd")
const Hero_WholeScreenGUI_Scene = preload("res://TowerRelated/Color_White/Hero/HeroGUI_Related/Hero_WholeScreenGUI.tscn")
const WholeScreenGUI = preload("res://GameElementsRelated/WholeScreenGUI.gd")

const Hero_NormalPic = preload("res://TowerRelated/Color_White/Hero/HeroInfoPanel_Related/Assets/HeroButtonImage.png")
const Hero_LvlUpPic = preload("res://TowerRelated/Color_White/Hero/HeroInfoPanel_Related/Assets/HeroButtonImage_WithSpendables.png")

var hero setget set_hero

onready var show_hero_gui_button = $VBoxContainer/BodyMarginer/MarginContainer/ShowHeroGUI

#


# FOR INFO PANEL
func LISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.connect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")
	
func UNLISTEN_TO_INFO_PANEL_SIGNALS(arg_info_panel):
	arg_info_panel.disconnect("on_tower_panel_ability_01_activate", self, "_on_tower_panel_ability_01_pressed")
	

func _on_tower_panel_ability_01_pressed():
	show_whole_screen_gui(hero)
	#_show_whole_screen_gui()


#

#

func set_hero(arg_hero):
	if is_instance_valid(hero):
		hero.disconnect("notify_xp_cap_of_level_reached", self, "_hero_reached_xp_cap_of_level")
	
	hero = arg_hero
	
	if is_instance_valid(hero):
		hero.connect("notify_xp_cap_of_level_reached", self, "_hero_reached_xp_cap_of_level")
		
		_hero_reached_xp_cap_of_level()


func _hero_reached_xp_cap_of_level():
	if hero.notify_xp_cap_of_level_reached:
		show_hero_gui_button.texture_normal = Hero_LvlUpPic
	else:
		show_hero_gui_button.texture_normal = Hero_NormalPic



func _construct_about_tooltip() -> BaseTooltip:
	var tooltip : BaseTowerSpecificTooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = "Hero"
	tooltip.descriptions = hero.get_self_description_in_info_panel()
	tooltip.header_right_text = "Hotkey: %s" % InputMap.get_action_list("game_tower_panel_ability_01")[0].as_text()
	
	return tooltip


#

static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.HERO

#

func _on_ShowHeroGUI_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		show_whole_screen_gui(hero)
		#_show_whole_screen_gui()


# shared with HeroInfoPanel # if this method is changed, change the one in specified as well
static func show_whole_screen_gui(hero):
	if is_instance_valid(hero):
		var whole_screen_gui = hero.game_elements.whole_screen_gui
		var hero_gui = whole_screen_gui.get_control_with_script(Hero_WholeScreenGUI)
		if !is_instance_valid(hero_gui):
			hero_gui = Hero_WholeScreenGUI_Scene.instance()
		
		#whole_screen_gui.show_control(hero_gui)
		whole_screen_gui.queue_control(hero_gui, hero.reservation_for_whole_screen_gui)
		hero_gui.hero = hero

