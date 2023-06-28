extends MarginContainer


const default_width : float = 200.0

#onready var notif_label = $VBoxContainer/BodyMarginer/LabelMarginer/VBoxContainer/Label

onready var notif_tooltip_body = $VBoxContainer/BodyMarginer/LabelMarginer/VBoxContainer/TooltipBody

onready var enter_label = $VBoxContainer/BodyMarginer/LabelMarginer/VBoxContainer/EnterLabel

onready var main_container = $VBoxContainer


func _ready():
	#notif_tooltip_body.custom_horizontal_size_flags_for_descs = SIZE_EXPAND | SIZE_SHRINK_CENTER
	notif_tooltip_body.bbcode_align_mode = notif_tooltip_body.BBCodeAlignMode.CENTER


func show_notif_tooltip_body_with_msg(arg_message,
		arg_vis__of_enter_label : bool,
		arg_width_to_use : float = default_width):
	
	main_container.rect_min_size.x = default_width
	main_container.rect_size.x = default_width
	
	notif_tooltip_body.descriptions = arg_message
	notif_tooltip_body.update_display()
	
	set_visibiliy__of_enter_label(arg_vis__of_enter_label)


func set_visibiliy__of_enter_label(arg_val):
	enter_label.visible = arg_val
	


