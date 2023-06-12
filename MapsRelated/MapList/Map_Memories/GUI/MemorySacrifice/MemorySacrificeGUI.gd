extends Control


const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")

const MemoryTypeSacrificeButton = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/Subs/MemoryTypeSacrificeButton/MemoryTypeSacrificeButton.gd")
const MemoryTypeSacrificeButton_Scene = preload("res://MapsRelated/MapList/Map_Memories/GUI/MemorySacrifice/Subs/MemoryTypeSacrificeButton/MemoryTypeSacrificeButton.tscn")



const ESCAPABLE_BY_ESC : bool = false

###

var reservation_for_whole_screen_gui

var game_elements

####

onready var memory_sacrifice_h_container = $MainContainer/VBoxContainer/SacrificeContainer/MarginContainer/VBoxContainer/MemorySacrificeHContainer
onready var other_slots_below_mem_sac_h_container = $MainContainer/VBoxContainer/SacrificeContainer/MarginContainer/VBoxContainer/OtherSlots

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
		if i > curr_button_count:
			button = MemoryTypeSacrificeButton_Scene.instance()
			memory_sacrifice_h_container.add_child(button)
		else:
			button = curr_buttons[i]
		
		if i > param_count:
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
		if i > curr_button_count:
			button = MemoryTypeSacrificeButton_Scene.instance()
			other_slots_below_mem_sac_h_container.add_child(button)
		else:
			button = curr_buttons[i]
		
		if i > param_count:
			button.set_prop_based_on_constructor(arg_params[i])
			button.visible = true
		else:
			button.visible = false


func show_gui():
	game_elements.whole_screen_gui.queue_control(self, reservation_for_whole_screen_gui, true, ESCAPABLE_BY_ESC)
	

func hide_gui():
	game_elements.whole_screen_gui.hide_control(self)
	

