extends MarginContainer


const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")


const modulate_enabled = Color(1, 1, 1, 1)
const modulate_disabled = Color(0.4, 0.4, 0.4, 1)


class ConstructorParams:
	
	var show_descs : bool = true
	
	var descriptions
	
	var descriptions_func_source
	var descriptions_func_name
	
	var header_left_text : String
	
	var image_normal : Texture   # 19x19
	var image_hovered : Texture   # 19x19
	
	var condition_visible__func_source
	var condition_visible__func_name
	var condition_visible__func_param
	
	var on_click__func_source
	var on_click__func_name
	


var show_descs : bool

var descriptions

var descriptions_func_source
var descriptions_func_name

var header_left_text : String

var image_normal : Texture setget set_image_normal
var image_hovered : Texture setget set_image_hovered


var on_click_func_source
var on_click_func_name


var _condition_visible_func_source
var _condition_visible_func_name
var _condition_visible_func_param


#

onready var button = $AdvancedButtonWithTooltip

######


func set_prop_based_on_constructor(arg_constructor : ConstructorParams):
	show_descs = arg_constructor.show_descs
	
	descriptions = arg_constructor.descriptions
	
	descriptions_func_source = arg_constructor.descriptions_func_source
	descriptions_func_name = arg_constructor.descriptions_func_name
	
	header_left_text = arg_constructor.header_left_text
	
	set_image_normal(arg_constructor.image_normal)
	set_image_hovered(arg_constructor.image_hovered)
	
	on_click_func_source = arg_constructor.on_click__func_source
	on_click_func_name = arg_constructor.on_click__func_name
	
	set_condition_func_source_and_name(arg_constructor.condition_visible__func_source, arg_constructor.condition_visible__func_name, arg_constructor.condition_visible__func_param)


######

func _ready():
	set_image_normal(image_normal)
	set_image_hovered(image_hovered)


####

func set_image_normal(arg_val):
	image_normal = arg_val
	
	if is_inside_tree():
		button.texture_normal = arg_val

func set_image_hovered(arg_val):
	image_hovered = arg_val
	
	if is_inside_tree():
		button.texture_hover = arg_val


###

func set_condition_func_source_and_name(arg_func_source, arg_func_name, arg_func_param):
	_condition_visible_func_source = arg_func_source
	_condition_visible_func_name = arg_func_name
	_condition_visible_func_param = arg_func_param
	
	update_is_visible_based_on_conditions()

func update_is_visible_based_on_conditions():
	var is_passed = true
	
	if _condition_visible_func_source != null:
		is_passed = _condition_visible_func_source.call(_condition_visible_func_name, _condition_visible_func_param)
	
	####
	var is_vis = is_passed
	
	button.disabled = !is_passed
	visible = is_passed
	if is_passed:
		pass
		#modulate = modulate_enabled
	else:
		pass
		#modulate = modulate_disabled
	
	return is_vis

######

func _on_AdvancedButtonWithTooltip_about_tooltip_construction_requested():
	if show_descs:
		var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
		
		if descriptions_func_source == null:
			a_tooltip.descriptions = descriptions
		else:
			a_tooltip.descriptions = descriptions_func_source.call(descriptions_func_name) 
		
		a_tooltip.header_left_text = header_left_text
		
		button.display_requested_about_tooltip(a_tooltip)


#

func _on_AdvancedButtonWithTooltip_pressed_mouse_event(event):
	if on_click_func_source != null:
		on_click_func_source.call(on_click_func_name)
	

