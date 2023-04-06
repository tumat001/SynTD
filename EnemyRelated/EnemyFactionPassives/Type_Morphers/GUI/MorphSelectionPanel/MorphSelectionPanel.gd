extends MarginContainer



const hbox_separation_for_morph_single_selection_panes : int = 20


var all_morph_single_selection_panes : Array


var parent_container_of_single_selection_panes : Control
onready var morph_single_selection_pane_01 = $VBoxContainer/ContentPanel/VBoxContainer/HBoxContainer/MorphSingleSelectionPane01
onready var morph_single_selection_pane_02 = $VBoxContainer/ContentPanel/VBoxContainer/HBoxContainer/MorphSingleSelectionPane02
onready var morph_single_selection_pane_03 = $VBoxContainer/ContentPanel/VBoxContainer/HBoxContainer/MorphSingleSelectionPane03

onready var hbox_for_morph_selection_panes = $VBoxContainer/ContentPanel/VBoxContainer/HBoxContainer


onready var arrow_slider_control = $VBoxContainer/ContentPanel/VBoxContainer/TopPanel/MarginContainer/ArrowSliderControl
onready var main_label = $VBoxContainer/ContentPanel/VBoxContainer/TopPanel/MainLabel

#

func _ready():
	parent_container_of_single_selection_panes = morph_single_selection_pane_01.get_parent()
	
	all_morph_single_selection_panes.append(morph_single_selection_pane_01)
	all_morph_single_selection_panes.append(morph_single_selection_pane_02)
	all_morph_single_selection_panes.append(morph_single_selection_pane_03)
	
	for pane in all_morph_single_selection_panes:
		pane.connect("ban_button_pressed", self, "_on_morph_single_selection_pane__ban_button_pressed", [pane])
		pane.connect("re_add_button_pressed", self, "_on_morph_single_selection_pane__re_add_button_pressed", [pane])
	

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
	pass
	# todo set slider size/width
	






