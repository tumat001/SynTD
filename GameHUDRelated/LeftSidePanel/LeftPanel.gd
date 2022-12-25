extends MarginContainer

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const ColorSynergyChecker = preload("res://GameInfoRelated/ColorSynergyChecker.gd")

const TowerWithColorShowPanel = preload("res://GameHUDRelated/WholeScreenTowerShowPanel/TowerWithColorShowPanel.gd")
const TowerWithColorShowPanel_Scene = preload("res://GameHUDRelated/WholeScreenTowerShowPanel/TowerWithColorShowPanel.tscn")

const WholeScreenGUI = preload("res://GameElementsRelated/WholeScreenGUI.gd")

const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")



signal on_single_syn_tooltip_shown(synergy)
signal on_single_syn_tooltip_hidden(synergy)

var active_synergies_res : Array = []
var non_active_dominant_synergies_res : Array = []
var non_active_composite_synergies_res : Array = []

var game_settings_manager setget set_game_settings_manager
var whole_screen_gui : WholeScreenGUI
var tower_manager

#

var _tower_with_color_show_panel


# queue related

var reservation_for_whole_screen_gui


#

onready var active_and_nonactive_syn_displayer = $VBoxContainer/ScrollContainer/ActiveAndNonActiveSynergyDisplayer
onready var scroll_container = $VBoxContainer/ScrollContainer


#

func _init():
	_initialize_queue_reservation()

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	#reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	#reservation_for_whole_screen_gui.on_removed_method


#####


func set_game_settings_manager(arg_manager):
	game_settings_manager = arg_manager
	
	if is_inside_tree():
		active_and_nonactive_syn_displayer.game_settings_manager = game_settings_manager

func _ready():
	active_and_nonactive_syn_displayer.connect("on_single_syn_tooltip_shown", self, "_on_single_syn_displayer_tooltip_shown", [], CONNECT_PERSIST)
	active_and_nonactive_syn_displayer.connect("on_single_syn_tooltip_hidden", self, "_on_single_syn_displayer_tooltip_hidden", [], CONNECT_PERSIST)
	active_and_nonactive_syn_displayer.connect("on_single_syn_displayer_pressed", self, "_on_single_syn_displayer_pressed", [], CONNECT_PERSIST)
	
	active_and_nonactive_syn_displayer.game_settings_manager = game_settings_manager
	
	update_synergy_displayers()


func update_synergy_displayers():
	active_and_nonactive_syn_displayer.active_synergies_res = active_synergies_res
	active_and_nonactive_syn_displayer.non_active_dominant_synergies_res = non_active_dominant_synergies_res
	active_and_nonactive_syn_displayer.non_active_composite_synergies_res = non_active_composite_synergies_res
	
	active_and_nonactive_syn_displayer.update_display()
	
	yield(get_tree(), "idle_frame")
	scroll_container.scroll_vertical = scroll_container.get_v_scrollbar().max_value


#

func _on_single_syn_displayer_tooltip_shown(syn):
	emit_signal("on_single_syn_tooltip_shown", syn)

func _on_single_syn_displayer_tooltip_hidden(syn):
	emit_signal("on_single_syn_tooltip_hidden", syn)

#

func _on_single_syn_displayer_pressed(event, syn_check_result):
	if event.pressed and event.button_index == BUTTON_LEFT:
		var panel = whole_screen_gui.get_control_with_script(TowerWithColorShowPanel)
		if !is_instance_valid(panel) or panel == null:
			_tower_with_color_show_panel = TowerWithColorShowPanel_Scene.instance()
			_tower_with_color_show_panel.tower_manager = tower_manager
			_tower_with_color_show_panel.game_settings_manager = game_settings_manager
		
		#whole_screen_gui.show_control(_tower_with_color_show_panel)
		whole_screen_gui.queue_control(_tower_with_color_show_panel, reservation_for_whole_screen_gui)
		_tower_with_color_show_panel.show_towers_with_colors(syn_check_result.synergy.colors_required)

#

func get_single_syn_displayer_with_synergy_name(arg_syn_name : String):
	return active_and_nonactive_syn_displayer.get_single_syn_displayer_with_synergy_name(arg_syn_name)

