extends MarginContainer

#const HeroInfoPanel = preload("res://TowerRelated/Color_White/Hero/HeroInfoPanel_Related/HeroInfoPanel.gd")
const Hero_WholeScreenGUI = preload("res://TowerRelated/Color_White/Hero/HeroGUI_Related/Hero_WholeScreenGUI.gd")
const Hero_WholeScreenGUI_Scene = preload("res://TowerRelated/Color_White/Hero/HeroGUI_Related/Hero_WholeScreenGUI.tscn")

var hero setget set_hero

var _can_spend_relic : bool = false
var _can_spend_gold : bool = false

onready var level_up_gold_button = $MarginContainer/HBoxContainer/LevelUp_Gold
onready var level_up_relic_button = $MarginContainer/HBoxContainer/LevelUp_Relic

func _ready():
	level_up_gold_button.visible = false
	level_up_relic_button.visible = false

func set_hero(arg_hero):
	hero = arg_hero
	
	
	connect("item_rect_changed", self, "_on_item_rect_changed", [], CONNECT_PERSIST)
	_on_item_rect_changed()
	

func set_spend_relics_for_level_up_visible(arg_val):
	_can_spend_relic = arg_val
	
	level_up_relic_button.visible = arg_val
	_update_gui_visibility()

func set_spend_gold_for_level_up_visible(arg_val):
	_can_spend_gold = arg_val
	
	level_up_gold_button.visible = arg_val
	_update_gui_visibility()

#

func _update_gui_visibility():
	if !_can_spend_relic and !_can_spend_gold:
		visible = false
	else:
		visible = true
	
	rect_size = Vector2(0, 0)

#

func _on_item_rect_changed():
	var hero_size = hero.get_current_anim_size()
	var x_pos = -(rect_size.x / 2)
	var y_pos = (hero_size.y / 4) + 10
	
	rect_position = Vector2(x_pos, y_pos)


#

func _on_LevelUp_Gold_button_up():
	show_whole_screen_gui(hero)
	hero._attempt_spend_gold_and_xp_for_level_up()

func _on_LevelUp_Relic_button_up():
	show_whole_screen_gui(hero)
	hero._attempt_spend_one_relic_for_level_up__from_hero_gui()


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

#
