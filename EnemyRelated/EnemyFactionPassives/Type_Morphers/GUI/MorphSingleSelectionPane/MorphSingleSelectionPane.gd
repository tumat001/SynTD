extends MarginContainer

const AbstractMorph = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/AbstractMorph.gd")


signal ban_button_pressed()
signal re_add_button_pressed()

signal invis_transition_finished()

signal super_highlight_finished()

#

# used by MorphSelectionPanel
const start_invis_transition_duration : float = 0.3

# grey/white
const bare_modulate__normal = Color(156/255.0, 156/255.0, 156/255.0)
const bare_modulate__highlighted = Color(199/255.0, 199/255.0, 199/255.0)
const bare_modulate__background = Color(46/255.0, 46/255.0, 46/255.0, 0.4)

# green
const mender_modulate__normal = Color(17/255.0, 151/255.0, 2/255.0)
const mender_modulate__highlighted = Color(31/255.0, 216/255.0, 3/255.0)
const mender_modulate__background = Color(1/255.0, 45/255.0, 11/255.0, 0.4)

# orange
const fighter_modulate__normal = Color(157/255.0, 59/255.0, 2/255.0)
const fighter_modulate__highlighted = Color(221/255.0, 83/255.0, 3/255.0)
const fighter_modulate__background = Color(55/255.0, 21/255.0, 1/255.0, 0.4)

# blue-blue-blue-green (dark-ish)
const crippler_modulate__normal = Color(2/255.0, 95/255.0, 151/255.0)
const crippler_modulate__highlighted = Color(3/255.0, 127/255.0, 201/255.0)
const crippler_modulate__background = Color(1/255.0, 35/255.0, 56/255.0, 0.4)

# violet
const sorcerer_modulate__normal = Color(55/255.0, 1/255.0, 142/255.0)
const sorcerer_modulate__highlighted = Color(101/255.0, 3/255.0, 201/255.0)
const sorcerer_modulate__background = Color(48/255.0, 1/255.0, 56/255.0, 0.4)

# red
const savage_modulate__normal = Color(146/255.0, 1/255.0, 4/255.0)
const savage_modulate__highlighted = Color(200/255.0, 1/255.0, 4/255.0)
const savage_modulate__background = Color(61/255.0, 1/255.0, 2/255.0, 0.4)


#

## multiplier
#const wildcard_modulate_multiplier__normal = 0.55
#const wildcard_modulate_multiplier__highlighted = 0.8

########

var _current_modulate__normal : Color
var _current_modulate__highlighted : Color

var is_highlighted setget set_is_highlighted

#

var morph : AbstractMorph setget set_morph

##

const marked_as_banned_modulate := Color(0.25, 0.25, 0.25, 1)
const marked_as_unbanned_modulate := Color(1, 1, 1, 1)

var is_morph_marked_as_banned : bool setget set_is_morph_marked_as_banned
#var _is_morph_marked_as_banned_modulate_tween_running : bool
var _morph_marked_as_banned_modulate_tween : SceneTreeTween

var is_bannable : bool setget set_is_bannable

var can_show_cancel_and_re_add_button : bool = true setget set_can_show_cancel_and_re_add_button

#######

var all_borders : Array

onready var left_border = $VBoxContainer/MainBodyContainer/Left
onready var right_border = $VBoxContainer/MainBodyContainer/Right
onready var top_border = $VBoxContainer/MainBodyContainer/Up
onready var down_border = $VBoxContainer/MainBodyContainer/Down

onready var background = $VBoxContainer/MainBodyContainer/Background

onready var cancel_button = $VBoxContainer/CancelButton
onready var re_add_button = $VBoxContainer/ReAddButton

onready var tooltip_body__normal = $VBoxContainer/MainBodyContainer/MarginContainer/VBoxContainer/MarginContainer3/MarginContainer/TooltipBodyNormal
onready var tooltip_body__wildcard = $VBoxContainer/MainBodyContainer/MarginContainer/VBoxContainer/WildcardDescContainer/MarginContainer/TooltipBodyWildcard

onready var for_wildcard_label = $VBoxContainer/MainBodyContainer/MarginContainer/VBoxContainer/ForWildcardLabel
onready var wildcard_desc_container = $VBoxContainer/MainBodyContainer/MarginContainer/VBoxContainer/WildcardDescContainer

onready var morph_name_label = $VBoxContainer/MainBodyContainer/MarginContainer/VBoxContainer/MarginContainer2/MorphNameLabel

onready var enemy_icon = $VBoxContainer/MainBodyContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/EnemyIcon
onready var morph_icon = $VBoxContainer/MainBodyContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/MorphIcon

onready var main_body_container = $VBoxContainer/MainBodyContainer

#######

func _ready():
	all_borders.append(left_border)
	all_borders.append(right_border)
	all_borders.append(top_border)
	all_borders.append(down_border)
	
	reset_for_another_use()


func set_morpher_enemy_border_type(arg_id):
	if arg_id == EnemyConstants.Enemies.BARE:
		set_modulate_configurations(bare_modulate__normal, bare_modulate__highlighted)
		background.modulate = bare_modulate__background
		
	elif arg_id == EnemyConstants.Enemies.MENDER:
		set_modulate_configurations(mender_modulate__normal, mender_modulate__highlighted)
		background.modulate = mender_modulate__background
		
	elif arg_id == EnemyConstants.Enemies.FIGHTER:
		set_modulate_configurations(fighter_modulate__normal, fighter_modulate__highlighted)
		background.modulate = fighter_modulate__background
		
	elif arg_id == EnemyConstants.Enemies.CRIPPLER:
		set_modulate_configurations(crippler_modulate__normal, crippler_modulate__highlighted)
		background.modulate = crippler_modulate__background
		
	elif arg_id == EnemyConstants.Enemies.SORCERER:
		set_modulate_configurations(sorcerer_modulate__normal, sorcerer_modulate__highlighted)
		background.modulate = sorcerer_modulate__background
		
	elif arg_id == EnemyConstants.Enemies.SAVAGE:
		set_modulate_configurations(savage_modulate__normal, savage_modulate__highlighted)
		background.modulate = savage_modulate__background
		
	


func set_modulate_configurations(arg_normal_modulate, arg_highlighted_modulate):
	_current_modulate__normal = arg_normal_modulate
	_current_modulate__highlighted = arg_highlighted_modulate
	
	_update_border_modulate__based_on_configs()

func set_is_highlighted(arg_val):
	is_highlighted = arg_val
	
	_update_border_modulate__based_on_configs()


func _update_border_modulate__based_on_configs():
	var modulate_to_use = _current_modulate__normal
	if is_highlighted:
		modulate_to_use = _current_modulate__highlighted
	
	for border in all_borders:
		border.modulate = modulate_to_use
	

#

func set_morph(arg_morph):
	morph = arg_morph
	
	if morph != null:
		if morph.has_wildcard_descriptions():
			tooltip_body__wildcard.descriptions = morph.get_wildcard_descriptions_to_use__based_on_settings()
			tooltip_body__wildcard.update_display()
			
			wildcard_desc_container.visible = true
			for_wildcard_label.visible = true
		else:
			wildcard_desc_container.visible = false
			for_wildcard_label.visible = false
		
		
		tooltip_body__normal.descriptions = morph.get_descriptions_to_use__based_on_settings()
		tooltip_body__normal.update_display()
		
		morph_name_label.text = morph.morph_name
		
		enemy_icon.texture = morph.enemy_based_icon
		morph_icon.texture = morph.morph_based_icon
		
		#
		
		set_morpher_enemy_border_type(morph.main_enemy_morpher_id)

func set_is_morph_marked_as_banned(arg_val):
	is_morph_marked_as_banned = arg_val
	
	if is_morph_marked_as_banned:
		#main_body_container.modulate = marked_as_banned_modulate
		#_is_morph_marked_as_banned_modulate_tween_running = true
		_morph_marked_as_banned_modulate_tween = create_tween()
		#_morph_marked_as_banned_modulate_tween.connect("finished", self, "_on_morph_marked_as_banned_modulate_tween_finished")
		_morph_marked_as_banned_modulate_tween.tween_property(main_body_container, "modulate", marked_as_banned_modulate, 0.3)
		
		#cancel_button.visible = false
		#re_add_button.visible = true
		
	else:
		#main_body_container.modulate = marked_as_unbanned_modulate
		#_is_morph_marked_as_banned_modulate_tween_running = true
		_morph_marked_as_banned_modulate_tween = create_tween()
		#_morph_marked_as_banned_modulate_tween.connect("finished", self, "_on_morph_marked_as_banned_modulate_tween_finished")
		_morph_marked_as_banned_modulate_tween.tween_property(main_body_container, "modulate", marked_as_unbanned_modulate, 0.3)
		#cancel_button.visible = true
		#re_add_button.visible = false
		
	
	update_re_add_button_visibility()
	update_cancel_button_visibility()

#func _on_morph_marked_as_banned_modulate_tween_finished():
#	_is_morph_marked_as_banned_modulate_tween_running = false


func set_is_bannable(arg_val):
	is_bannable = arg_val
	
	if is_bannable:
		pass
	else:
		pass
	
	update_cancel_button_visibility()

func set_can_show_cancel_and_re_add_button(arg_val):
	can_show_cancel_and_re_add_button = arg_val
	
	update_cancel_button_visibility()
	update_re_add_button_visibility()

#

func update_cancel_button_visibility():
	cancel_button.visible = !is_morph_marked_as_banned and is_bannable and can_show_cancel_and_re_add_button

func update_re_add_button_visibility():
	re_add_button.visible = is_morph_marked_as_banned and can_show_cancel_and_re_add_button

#

func reset_for_another_use():
	set_is_morph_marked_as_banned(false)
	set_is_highlighted(false)
	set_is_bannable(true)
	
	set_can_show_cancel_and_re_add_button(true)

#######

func _on_CancelButton_pressed():
	set_is_morph_marked_as_banned(true)
	emit_signal("ban_button_pressed")

func _on_ReAddButton_pressed():
	set_is_morph_marked_as_banned(false)
	emit_signal("re_add_button_pressed")


##

func start_invis_transition():
	#if _is_morph_marked_as_banned_modulate_tween_running:
	#	_morph_marked_as_banned_modulate_tween.
	
	var target_modulate = main_body_container.modulate
	target_modulate.a = 0
	
	var modulate_tween = create_tween()
	modulate_tween.connect("finished", self, "_on_invis_modulate_tween_finished")
	modulate_tween.tween_property(main_body_container, "modulate", target_modulate, start_invis_transition_duration)
	

func _on_invis_modulate_tween_finished():
	emit_signal("invis_transition_finished")
	

##

func start_super_highlight_transition(arg_duration):
	var target_modulate = Color(1.5, 1.5, 1.5, 1)
	
	var modulate_tween = create_tween()
	modulate_tween.connect("finished", self, "_on_super_highlight_transition_modulate_tween_finished")
	modulate_tween.tween_property(main_body_container, "modulate", target_modulate, arg_duration)

func _on_super_highlight_transition_modulate_tween_finished():
	emit_signal("super_highlight_finished")
	


###

func set_visibility_of_enemy_and_morph_icon(arg_val):
	enemy_icon.visible = arg_val
	morph_icon.visible = arg_val

func get_enemy_and_morph_icon_global_pos():
	return [enemy_icon.rect_global_position, morph_icon.rect_global_position]
	


