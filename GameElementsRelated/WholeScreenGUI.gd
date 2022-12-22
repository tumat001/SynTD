extends MarginContainer

const ScreenTintEffect = preload("res://MiscRelated/ScreenEffectsRelated/ScreenTintEffect.gd")
const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")


const reservation_control_metadata := "WHOLE_SCREEN_GUI__CONTROL"
const background_color : Color = Color(0, 0, 0, 0.8)

var game_elements
var screen_effect_manager

var current_showing_control : Control

#

var advanced_queue : AdvancedQueue

#

func _ready():
	visible = false
	
	advanced_queue = AdvancedQueue.new()
	advanced_queue.connect("entertained_reservation", self, "")


#

func queue_control(control : Control, reservation : AdvancedQueue.Reservation, make_background_dark : bool = true):
	
	reservation.metadata_map[reservation_control_metadata] = control
	
#	if current_showing_control != null:
#		hide_control(current_showing_control)
#
#	#
#	if !has_control(control):
#		add_child(control)
#
#	current_showing_control = control
#	control.visible = true
	
	
	visible = true
	
	if make_background_dark:
		var screen_effect = ScreenTintEffect.new()
		screen_effect.is_timebounded = false
		#screen_effect.fade_in_duration = 0.05
		#screen_effect.fade_out_duration = 0.05
		screen_effect.tint_color = background_color
		screen_effect.ins_uuid = StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI
		screen_effect.custom_z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
		screen_effect_manager.add_screen_tint_effect(screen_effect)
	
	advanced_queue.queue_reservation(reservation)



func _on_queue_entertained_reservation(arg_reservation):
	pass

func _on_queue_no_reservations_left():
	pass

func _on_queue_reservation_removed_or_deferred(arg_res):
	pass


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


func hide_control(control : Control, update_vis : bool = true):
	if is_instance_valid(control):
		control.visible = false
		screen_effect_manager.destroy_screen_tint_effect(StoreOfScreenEffectsUUID.WHOLE_SCREEN_GUI)
		current_showing_control = null
		
		visible = false

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



