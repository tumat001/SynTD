extends Reference

signal requested_action_advance()
signal requested_action_previous()
signal requested_action_skip()

signal full_reset_triggered()
signal partial_reset_ignore_already_traversed_triggered()

signal dialog_elements_changed(arg_all_dialog_elements)
signal background_elements_changed(arg_all_background_elements)

#

const VECTOR_UNDEFINED = Vector2(-1, -1)
const FLOAT_UNDEFINED = -9570.55

#

var _all_dialog_elements : Array
var _all_background_elements : Array

#

var is_previous_executable : bool
var is_skip_executable : bool

var top_border_texture : Texture
var left_border_texture : Texture
var right_border_texture : Texture
var bottom_border_texture : Texture

var final_dialog_top_left_pos : Vector2 = VECTOR_UNDEFINED  # must be defined
var final_dialog_custom_size : Vector2 = VECTOR_UNDEFINED  # may be left undefined

var time_limit : float

#

##!! NOTE FOR ALL temp_x__y. "__" should only be used once, since it is the separator between metadata and the actual var name
#
## if changing var name, change conditional in "partial_reset" as well
#var temp_curr_val__already_traversed : bool = false  # true if dialog segment is already advanced.
#var temp_default__already_traversed : bool = false

var temp_var__already_traversed : bool = false

##

func advance():
	emit_signal("requested_action_advance")

func previous():
	if is_previous_executable:
		emit_signal("requested_action_previous")

func skip():
	if is_skip_executable:
		emit_signal("requested_action_skip")


#

func full_reset():
	temp_var__already_traversed = false
	
	#temp_curr_val__already_traversed = temp_default__already_traversed
	#for var_properties in get_property_list():
	#	var var_name = var_properties["name"]
	
	emit_signal("full_reset_triggered")

func partial_reset__ignore_already_traversed():
	emit_signal("partial_reset_ignore_already_traversed_triggered")


#########

func add_dialog_element(arg_element):
	_all_dialog_elements.append(arg_element)
	emit_signal("dialog_elements_changed", get_all_dialog_elements())

func get_all_dialog_elements():
	return _all_dialog_elements


func add_background_element(arg_element):
	_all_background_elements.append(arg_element)
	emit_signal("background_elements_changed", get_all_background_elements())

func get_all_background_elements():
	return _all_background_elements

###

func set_all_border_textures(arg_texture : Texture):
	top_border_texture = arg_texture
	left_border_texture = arg_texture
	right_border_texture = arg_texture
	bottom_border_texture = arg_texture



