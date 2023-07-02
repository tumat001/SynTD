extends Control


const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")

const MemoryTypeSacrificeButton = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/Subs/MemoryTypeSacrificeButton/MemoryTypeSacrificeButton.gd")
const MemoryTypeSacrificeButton_Scene = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/Subs/MemoryTypeSacrificeButton/MemoryTypeSacrificeButton.tscn")

const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")



const ESCAPABLE_BY_ESC : bool = false

#todo then make a mini dialog near the GSSB (small button) to indicate the need to do sacrifice action
#todo hide/disable round start (and its button), and possibly add the ability to replace the start button to the "sacrifice"/"recall" buttons

##

signal select_later_clicked()

###

var reservation_for_whole_screen_gui

var game_elements

####

onready var memory_sacrifice_h_container = $MainContainer/VBoxContainer/SacrificeContainer/MarginContainer/VBoxContainer/MemorySacrificeHContainer
onready var other_slots_below_mem_sac_h_container = $MainContainer/VBoxContainer/SacrificeContainer/MarginContainer/VBoxContainer/OtherSlots

onready var button_within_player_button_gui = $MainContainer/MiscButtonsContainer/SelectLaterButton/AdvancedButtonWithTooltip

######

func initialize_gui(arg_game_elements):
	game_elements = arg_game_elements
	
	_initialize_queue_reservation()

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"
	


########

func configure_to_mem_sacrifice_button_construction_params(arg_params : Array):
	var curr_buttons = memory_sacrifice_h_container.get_children()
	
	var curr_button_count = memory_sacrifice_h_container.get_child_count()
	var param_count = arg_params.size()
	
	var max_i = max(curr_button_count, param_count)
	
	for i in max_i:
		var button
		if i >= curr_button_count:
			button = MemoryTypeSacrificeButton_Scene.instance()
			memory_sacrifice_h_container.add_child(button)
		else:
			button = curr_buttons[i]
		
		if i < param_count:
			button.set_prop_based_on_constructor(arg_params[i])
			button.visible = true
		else:
			button.visible = false


func configure_to_mem_sacrifice_button_construction_params__in_other_slots(arg_params : Array):
	var curr_buttons = other_slots_below_mem_sac_h_container.get_children()
	
	var curr_button_count = other_slots_below_mem_sac_h_container.get_child_count()
	var param_count = arg_params.size()
	
	var max_i = max(curr_button_count, param_count)
	
	for i in max_i:
		var button
		if i >= curr_button_count:
			button = MemoryTypeSacrificeButton_Scene.instance()
			other_slots_below_mem_sac_h_container.add_child(button)
		else:
			button = curr_buttons[i]
		
		if i < param_count:
			button.set_prop_based_on_constructor(arg_params[i])
			button.visible = true
		else:
			button.visible = false


func show_gui():
	game_elements.whole_screen_gui.queue_control(self, reservation_for_whole_screen_gui, true, ESCAPABLE_BY_ESC)
	

func hide_gui():
	game_elements.whole_screen_gui.hide_control(self)
	



func _on_SelectLaterButton_on_button_released_with_button_left():
	emit_signal("select_later_clicked")
	

func _on_AdvancedButtonWithTooltip_about_tooltip_construction_requested():
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	
	a_tooltip.descriptions = [
		"Click this if you want to view the battlefield, buy towers, etc, to prepare your sacrifice."
	]
	
	button_within_player_button_gui.display_requested_about_tooltip(a_tooltip)


