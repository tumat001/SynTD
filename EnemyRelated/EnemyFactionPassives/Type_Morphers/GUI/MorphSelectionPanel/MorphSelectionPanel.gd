extends MarginContainer

const MorphSingleSelectionPane = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/GUI/MorphSingleSelectionPane/MorphSingleSelectionPane.gd")

#


signal morph_selected_from_random_roll(arg_morph, arg_morph_single_pane)
signal morph_selected_from_random_roll__animation_done(arg_morph, arg_morph_single_pane)


#

const hbox_separation_for_morph_single_selection_panes : int = 20

#

var all_morph_single_selection_panes : Array
var _current_index_to_morph_pane : Dictionary

var morpher_general_rng : RandomNumberGenerator

#

var _hbox_x_size_during_current_roll : float
var size_of_single_selection_pane : float

var _previous_pane

#

var parent_container_of_single_selection_panes : Control
onready var morph_single_selection_pane_01 = $VBoxContainer/ContentPanel/VBoxContainer/HBoxContainer/MorphSingleSelectionPane01
onready var morph_single_selection_pane_02 = $VBoxContainer/ContentPanel/VBoxContainer/HBoxContainer/MorphSingleSelectionPane02
onready var morph_single_selection_pane_03 = $VBoxContainer/ContentPanel/VBoxContainer/HBoxContainer/MorphSingleSelectionPane03

onready var hbox_for_morph_selection_panes = $VBoxContainer/ContentPanel/VBoxContainer/HBoxContainer


onready var arrow_slider_control = $VBoxContainer/ContentPanel/VBoxContainer/TopPanel/MarginContainer/ArrowSliderControl
onready var main_label = $VBoxContainer/ContentPanel/VBoxContainer/TopPanel/MainLabel

onready var confirm_button = $VBoxContainer/ConfirmPanel/ConfirmButton

#

func _ready():
	size_of_single_selection_pane = morph_single_selection_pane_01.rect_size.x
	
	morpher_general_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.MORPHERS_GEN_PURPOSE)
	
	
	parent_container_of_single_selection_panes = morph_single_selection_pane_01.get_parent()
	
	all_morph_single_selection_panes.append(morph_single_selection_pane_01)
	all_morph_single_selection_panes.append(morph_single_selection_pane_02)
	all_morph_single_selection_panes.append(morph_single_selection_pane_03)
	
	for pane in all_morph_single_selection_panes:
		pane.connect("ban_button_pressed", self, "_on_morph_single_selection_pane__ban_button_pressed", [pane])
		pane.connect("re_add_button_pressed", self, "_on_morph_single_selection_pane__re_add_button_pressed", [pane])
	
	arrow_slider_control.visible = false
	

###

func set_morphs(arg_morphs : Array):
	reset_for_another_use()
	
	morph_single_selection_pane_01.set_morph(arg_morphs[0])
	morph_single_selection_pane_02.set_morph(arg_morphs[1])
	morph_single_selection_pane_03.set_morph(arg_morphs[2])
	
	
	

func reset_for_another_use():
	for morph_single_pane in all_morph_single_selection_panes:
		morph_single_pane.reset_for_another_use()
	
	hbox_for_morph_selection_panes.add_constant_override("separation", hbox_separation_for_morph_single_selection_panes)
	
	main_label.visible = true
	arrow_slider_control.visible = false
	confirm_button.visible = true


###

func _on_morph_single_selection_pane__ban_button_pressed(arg_pane):
	for pane in all_morph_single_selection_panes:
		pane.is_bannable = false
	

func _on_morph_single_selection_pane__re_add_button_pressed(arg_pane):
	for pane in all_morph_single_selection_panes:
		pane.is_bannable = true
	
	


#####

func _on_ConfirmButton_pressed():
	for pane in all_morph_single_selection_panes:
		if pane.is_morph_marked_as_banned:
			pane.start_invis_transition()
			break
	
	
	var sepa_tweener = create_tween()
	sepa_tweener.connect("finished", self, "_on_hbox_for_single_panes_separation_transition_finished", [], CONNECT_ONESHOT)
	sepa_tweener.tween_method(hbox_for_morph_selection_panes, "add_constant_override", hbox_separation_for_morph_single_selection_panes, 0, morph_single_selection_pane_01.start_invis_transition_duration, ["separation"])
	

func _on_hbox_for_single_panes_separation_transition_finished():
	call_deferred("start_randomize_roll")
	


func start_randomize_roll():
	_update_index_to_morph_single_selection_pane_map()
	
	_hbox_x_size_during_current_roll = hbox_for_morph_selection_panes.rect_size.x
	
	arrow_slider_control.rect_position.x = hbox_for_morph_selection_panes.rect_position.x
	arrow_slider_control.set_slider_width(_hbox_x_size_during_current_roll)
	arrow_slider_control.visible = true
	arrow_slider_control.connect("arrow_position_changed", self, "_on_arrow_position_changed")
	arrow_slider_control.connect("arrow_reached_final_pos", self, "_on_arrow_final_pos_reached")
	
	confirm_button.visible = false
	
	print("arrow slider width: %s. hbox width: %s" % [arrow_slider_control.rect_size.x, _hbox_x_size_during_current_roll])
	
	
	var rand_x_pos = morpher_general_rng.randi_range(0, _hbox_x_size_during_current_roll)
	arrow_slider_control.perform_arrow_slide_with_speed_on_final_x_pos__slide_right(1400, rand_x_pos, 5)
	

func _on_arrow_position_changed(arg_pos : Vector2, arg_global_pos : Vector2):
	var pane = _get_morph_single_selection_pane_under_arrow()
	if _previous_pane != pane:
		pane.set_is_highlighted(true)
		if is_instance_valid(_previous_pane):
			_previous_pane.set_is_highlighted(false)
	

func _on_arrow_final_pos_reached(arg_pos : Vector2, arg_global_pos : Vector2):
	_end_of_randomize_roll()


func _get_morph_single_selection_pane_under_arrow() -> MorphSingleSelectionPane:
	var x_pos = arrow_slider_control.get_arrow_x_pos()
	var i = int(floor(x_pos / size_of_single_selection_pane))
	
	return _current_index_to_morph_pane[i]

func _update_index_to_morph_single_selection_pane_map():
	_current_index_to_morph_pane.clear()
	
	var curr_i : int = 0
	for pane in all_morph_single_selection_panes:
		if pane.visible:
			_current_index_to_morph_pane[curr_i] = pane
			curr_i += 1
	

#

func _end_of_randomize_roll():
	var pane = _get_morph_single_selection_pane_under_arrow()
	
	emit_signal("morph_selected_from_random_roll", pane.morph, pane)
	
	_start_end_of_randomize_roll_animation(pane)

func _start_end_of_randomize_roll_animation(arg_selected_pane : MorphSingleSelectionPane):
	
	arrow_slider_control.disconnect("arrow_position_changed", self, "_on_arrow_position_changed")
	arrow_slider_control.disconnect("arrow_reached_final_pos", self, "_on_arrow_final_pos_reached")
	
	arrow_slider_control.visible = false
	
	#
	
	for pane in all_morph_single_selection_panes:
		if pane != arg_selected_pane and pane.visible:
			pane.start_invis_transition()
	
	arg_selected_pane.connect("super_highlight_finished", self, "_on_morph_pane_super_highlight_finished", [arg_selected_pane], CONNECT_ONESHOT)
	arg_selected_pane.start_super_highlight_transition(0.65)

func _on_morph_pane_super_highlight_finished(arg_selected_pane : MorphSingleSelectionPane):
	emit_signal("morph_selected_from_random_roll__animation_done", arg_selected_pane.morph, arg_selected_pane)
	

