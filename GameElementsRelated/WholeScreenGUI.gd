extends MarginContainer

const ScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/ScreenTintEffect.gd")
const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")


const reservation_control_metadata := "WHOLE_SCREEN_GUI__CONTROL"
const reservation_make_background_dark_metadata := "WHOLE_SCREEN_GUI__MAKE_BACKGROUND_DARK"
const reservation_escapable_by_game_elements_metadata := "WHOLE_SCREEN_GUI__ESCAPABLE_BY_GAME_ELEMENTS"
const reservation_fade_in_metadata := "WHOLE_SCREEN_GUI__FADE_IN"
const reservation_fade_out_metadata := "WHOLE_SCREEN_GUI__FADE_OUT"


signal hide_process_of_control_complete(arg_control)
signal show_process_of_control_complete(arg_control)


const background_color : Color = Color(0, 0, 0, 0.8)

var game_elements
var screen_effect_manager

var current_showing_control : Control
var currently_escapable_from_game_elements : bool = true

#

const fade_in_duration : float = 0.25
const fade_out_duration : float = 0.25

const fade_in_rate_per_sec : float = 1 / fade_in_duration
const fade_out_rate_per_sec : float = -1 / fade_out_duration

var _current_fade_a_per_sec : float

#

var advanced_queue : AdvancedQueue

#

func _ready():
	visible = false
	
	advanced_queue = AdvancedQueue.new(false)
	advanced_queue.connect("entertained_reservation", self, "_on_queue_entertained_reservation", [], CONNECT_PERSIST)
	advanced_queue.connect("no_reservations_left", self, "_on_queue_no_reservations_left", [], CONNECT_PERSIST)
	advanced_queue.connect("reservation_removed_or_deferred", self, "_on_queue_reservation_removed_or_deferred", [], CONNECT_PERSIST)
	
	advanced_queue.connect("request_advance_queue_reservation", self, "_on_request_advance_queue_reservation", [], CONNECT_PERSIST)

#

func queue_control(control : Control, reservation : AdvancedQueue.Reservation, 
		make_background_dark : bool = true, escapable_by_esc : bool = true,
		fade_in : bool = true, fade_out : bool = true):
	
	if current_showing_control != control:
		reservation.metadata_map[reservation_control_metadata] = control
		reservation.metadata_map[reservation_make_background_dark_metadata] = make_background_dark
		reservation.metadata_map[reservation_escapable_by_game_elements_metadata] = escapable_by_esc
		reservation.metadata_map[reservation_fade_in_metadata] = fade_in
		reservation.metadata_map[reservation_fade_out_metadata] = fade_out
		
	#	if current_showing_control != null:
	#		hide_control(current_showing_control)
	#
	#	#
		if !has_control(control):
			add_child(control)
	#
	#	current_showing_control = control
		control.visible = false
		
		
		advanced_queue.queue_reservation(reservation)



func _on_queue_entertained_reservation(arg_reservation : AdvancedQueue.Reservation):
	var control = arg_reservation.metadata_map[reservation_control_metadata]
	
	if is_instance_valid(control):
		if current_showing_control != null:
			hide_control(current_showing_control, true, false)
		
		#
		if !has_control(control):
			add_child(control)
		
		current_showing_control = control
		control.modulate.a = 0
		control.visible = true
		currently_escapable_from_game_elements = arg_reservation.metadata_map[reservation_escapable_by_game_elements_metadata]
		
		#
		visible = true
		
		if arg_reservation.metadata_map[reservation_make_background_dark_metadata]:
			var screen_effect = ScreenTintEffect.new()
			screen_effect.is_timebounded = false
			#screen_effect.fade_in_duration = 0.05
			#screen_effect.fade_out_duration = 0.05
			screen_effect.tint_color = background_color
			screen_effect.ins_uuid = StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI
			screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
			screen_effect_manager.add_screen_tint_effect(screen_effect)
			
		else:
			screen_effect_manager.destroy_screen_tint_effect(StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI)
		
		game_elements.synergy_manager.allow_start_color_aesthetic_display_clauses.attempt_insert_clause(game_elements.synergy_manager.AllowStartColorAestheticDisplay.WHOLE_SCREEN_GUI_IS_OPEN)
		
		_start_fade_in_of_current_control()
		
	else:
		advanced_queue.entertain_next_reservation_in_line()

func _on_queue_no_reservations_left():
	#screen_effect_manager.destroy_screen_tint_effect(StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI)
	screen_effect_manager.force_fade_out_screen_tint_effect(StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI)
	
	game_elements.synergy_manager.allow_start_color_aesthetic_display_clauses.remove_clause(game_elements.synergy_manager.AllowStartColorAestheticDisplay.WHOLE_SCREEN_GUI_IS_OPEN)
	
	current_showing_control = null
	currently_escapable_from_game_elements = true
	
	visible = false

func _on_queue_reservation_removed_or_deferred(arg_res : AdvancedQueue.Reservation):
	if is_instance_valid(current_showing_control):
		current_showing_control.visible = false
	current_showing_control = null
	currently_escapable_from_game_elements = true
	
	#
	
	#advanced_queue.entertain_next_reservation_in_line()


#############

#func show_control(control : Control, make_background_dark : bool = true):
#	if current_showing_control != null:
#		hide_control(current_showing_control)#, false)
#
#	#
#	if !has_control(control):
#		add_child(control)
#
#	current_showing_control = control
#	control.visible = true
#	visible = true
#
#	if make_background_dark:
#		var screen_effect = ScreenTintEffect.new()
#		screen_effect.is_timebounded = false
#		#screen_effect.fade_in_duration = 0.05
#		#screen_effect.fade_out_duration = 0.05
#		screen_effect.tint_color = background_color
#		screen_effect.ins_uuid = StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI
#		screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
#		screen_effect_manager.add_screen_tint_effect(screen_effect)

func hide_control(control : Control, update_vis : bool = true, can_advance_queue_reservation_line : bool = true):
	if is_instance_valid(control):
		var current_control_is_to_hide : bool = control == current_showing_control
		
		#control.visible = false
		#screen_effect_manager.destroy_screen_tint_effect(StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI)
		#current_showing_control = null
		#currently_escapable_from_game_elements = true
		
		#visible = false
		
		if current_control_is_to_hide and can_advance_queue_reservation_line:
			advanced_queue.complete_reservation_status_of_current()
			#advanced_queue.entertain_next_reservation_in_line()


#func instant_hide_control(control : Control, update_vis : bool = true, can_advance_queue_reservation_line : bool = true):
#	if is_instance_valid(control):
#		var current_control_is_to_hide : bool = control == current_showing_control
#
#		control.visible = false
#		#screen_effect_manager.destroy_screen_tint_effect(StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI)
#		current_showing_control = null
#		currently_escapable_from_game_elements = true
#
#		#visible = false
#
#		if current_control_is_to_hide and can_advance_queue_reservation_line:
#			advanced_queue.complete_reservation_status_of_current()
#
#			#advanced_queue.entertain_next_reservation_in_line()


func add_control_but_dont_show(control : Control):
	if !has_control(control):
		add_child(control)
		
		control.visible = false

#

func has_control(control : Control) -> bool:
	return get_children().has(control)

func has_control_with_script(script : Reference) -> bool:
	for child in get_children():
		if child.get_script() == script:
			return true
	
	return false

func get_control_with_script(script : Reference) -> Control:
	for child in get_children():
		if child.get_script() == script:
			return child
	
	return null

#

func _on_request_advance_queue_reservation():
	if is_instance_valid(current_showing_control):
		_start_fade_out_of_current_control()
		
	else:
		advanced_queue.entertain_next_reservation_in_line()
		_start_fade_in_of_current_control()
		

func _start_fade_out_of_current_control():
	_current_fade_a_per_sec = fade_out_rate_per_sec
	set_process(true)

func _end_of_fade_out_of_current_control():
	_current_fade_a_per_sec = 0
	current_showing_control.visible = false
	set_process(false)
	
	emit_signal("hide_process_of_control_complete", current_showing_control)
	advanced_queue.entertain_next_reservation_in_line()

func _start_fade_in_of_current_control():
	_current_fade_a_per_sec = fade_in_rate_per_sec
	set_process(true)

func _end_of_fade_in_of_current_control():
	_current_fade_a_per_sec = 0
	set_process(false)
	
	emit_signal("show_process_of_control_complete", current_showing_control)


func _process(delta):
	if is_instance_valid(current_showing_control):
		current_showing_control.modulate.a += _current_fade_a_per_sec * delta
		
		if current_showing_control.modulate.a >= 1:
			current_showing_control.modulate.a = 1
			_end_of_fade_in_of_current_control()
			
		elif current_showing_control.modulate.a <= 0:
			current_showing_control.modulate.a = 0
			_end_of_fade_out_of_current_control()
			

