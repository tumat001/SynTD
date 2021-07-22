extends "res://MiscRelated/GUI_Category_Related/BaseTowerSpecificInfoPanel/BaseTowerSpecificInfoPanel.gd"

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")
const Hero = preload("res://TowerRelated/Color_White/Hero/Hero.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")
const Hero_WholeScreenGUI = preload("res://TowerRelated/Color_White/Hero/HeroGUI_Related/Hero_WholeScreenGUI.gd")
const Hero_WholeScreenGUI_Scene = preload("res://TowerRelated/Color_White/Hero/HeroGUI_Related/Hero_WholeScreenGUI.tscn")
const WholeScreenGUI = preload("res://GameElementsRelated/WholeScreenGUI.gd")

var hero : Hero setget set_hero

func set_hero(arg_hero : Hero):
	hero = arg_hero


func _construct_about_tooltip() -> BaseTooltip:
	var tooltip : BaseTowerSpecificTooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.header_left_text = "Hero"
	tooltip.descriptions = hero.get_self_description_in_info_panel()
	
	return tooltip


#

static func should_display_self_for(tower) -> bool:
	return tower.tower_id == Towers.HERO

#

func _on_ShowHeroGUI_pressed_mouse_event(event):
	if event.button_index == BUTTON_LEFT:
		var whole_screen_gui : WholeScreenGUI = hero.game_elements.whole_screen_gui
		var hero_gui = whole_screen_gui.get_control_with_script(Hero_WholeScreenGUI)
		if hero_gui == null:
			hero_gui = Hero_WholeScreenGUI_Scene.instance()
		
		whole_screen_gui.show_control(hero_gui)
		hero_gui.hero = hero


