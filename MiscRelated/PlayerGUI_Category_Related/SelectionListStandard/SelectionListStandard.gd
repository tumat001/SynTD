extends MarginContainer


signal stopped_and_hid_from_display()

var tooltip_owner : Control setget set_tooltip_owner
var pos_as_anchor : Vector2

const x_scale_growth_per_sec : float = 5.0
const y_scale_growth_per_sec : float = 5.0

var listen_for_attempted_cancel : bool = true  # if true, will exit itself when ESC or clicked outside of it
var is_mouse_inside_self : bool = false

var _is_in_anim : bool = false

#

onready var scroll_container = $VBoxContainer/Content/ContentMarginer/ScrollContainer
onready var content_list = $VBoxContainer/Content/ContentMarginer/ScrollContainer/ContentList
onready var header_label = $VBoxContainer/Header/TextContainer/HeaderLabel

#

func set_tooltip_owner(arg_owner : Control):
	if is_instance_valid(tooltip_owner):
		if tooltip_owner.is_connected("visibility_changed", self, "_tooltip_owner_visibility_changed"):
			tooltip_owner.disconnect("visibility_changed", self, "_tooltip_owner_visibility_changed")
			#tooltip_owner.disconnect("mouse_exited", self, "_tooltip_owner_mouse_exited")
			tooltip_owner.disconnect("tree_exiting", self, "_tooltip_owner_in_destruction")
	
	tooltip_owner = arg_owner
	
	if is_instance_valid(tooltip_owner):
		if !tooltip_owner.is_connected("visibility_changed", self, "_tooltip_owner_visibility_changed"):
			tooltip_owner.connect("visibility_changed", self, "_tooltip_owner_visibility_changed")
			#tooltip_owner.connect("mouse_exited", self, "_tooltip_owner_mouse_exited", [], CONNECT_ONESHOT)
			tooltip_owner.connect("tree_exiting", self, "_tooltip_owner_in_destruction", [], CONNECT_ONESHOT)


func _tooltip_owner_visibility_changed():
	#visible = tooltip_owner.visible
	if !visible:
		stop_and_hide_display()

func _tooltip_owner_in_destruction():
	tooltip_owner = null
	stop_and_hide_display()



func set_node_to_anchor_to(arg_node):
	pos_as_anchor = arg_node.rect_global_position + (arg_node.rect_size / 2)
	update_position()

func set_pos_to_anchor_to(arg_pos):
	pos_as_anchor = arg_pos
	update_position()


func update_position():
	rect_min_size.y = 0
	rect_size.y = 0
	
	var new_position : Vector2 = pos_as_anchor
	new_position.x += 20
	
	var tooltip_height : float = rect_size.y
	if new_position.y + tooltip_height + 20 > get_viewport().get_visible_rect().size.y:
		var new_y_pos = new_position.y - tooltip_height
		
		if new_y_pos < 0:
			new_y_pos = new_position.y
			
			# if newly adjusted position makes tooltip dip below
			if new_y_pos + tooltip_height + 20 > get_viewport().get_visible_rect().size.y:
				new_y_pos = 20
		
		new_position.y = new_y_pos
	
	var tooltip_width : float = rect_size.x
	if new_position.x + tooltip_width + 20 > get_viewport().get_visible_rect().size.x:
		new_position.x -= tooltip_width + 20
	
	set_position(new_position, true)


#

func _process(delta):
	if rect_scale.x < 1:
		rect_scale.x += x_scale_growth_per_sec * delta
	
	if rect_scale.x >= 1:
		rect_scale.x = 1
		
		if rect_scale.y < 1:
			rect_scale.y += y_scale_growth_per_sec * delta
		
		if rect_scale.y >= 1:
			rect_scale.y = 1
			_on_fully_displayed_and_scaled()

func _on_fully_displayed_and_scaled():
	scroll_container.modulate.a = 1
	header_label.modulate.a = 1
	
	rect_scale.x = 1
	rect_scale.y = 1


#

func start_display_anim():
	if !_is_in_anim:
		_is_in_anim = true
		set_process_unhandled_input(true)
		
		visible = true
		
		scroll_container.modulate.a = 0
		header_label.modulate.a = 0
		
		rect_scale.x = 0
		rect_scale.y = 0


func stop_and_hide_display():
	_is_in_anim = false
	visible = false
	set_process_unhandled_input(false)
	
	emit_signal("stopped_and_hid_from_display")

#

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("visibility_changed", self, "_on_visibility_changed")
	
	if listen_for_attempted_cancel:
		set_process_unhandled_input(false)

func _unhandled_input(event):
	if visible:
		if event is InputEventKey:
			if !event.echo and event.pressed:
				if event.is_action("ui_cancel"):
					stop_and_hide_display()
					accept_event()
			
			
		elif event is InputEventMouseButton:
			if event.pressed and (event.button_index == BUTTON_RIGHT or event.button_index == BUTTON_LEFT):
				stop_and_hide_display()
				accept_event()



func _on_mouse_entered():
	is_mouse_inside_self = true

func _on_mouse_exited():
	is_mouse_inside_self = false

func _on_visibility_changed():
	if !visible:
		is_mouse_inside_self = false


##

func add_child_to_list(arg_node : Node):
	content_list.add_child(arg_node)


