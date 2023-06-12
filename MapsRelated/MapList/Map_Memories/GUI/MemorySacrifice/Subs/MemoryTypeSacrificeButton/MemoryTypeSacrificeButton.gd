extends MarginContainer

const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")



const modulate_enabled = Color(1, 1, 1, 1)
const modulate_disabled = Color(0.4, 0.4, 0.4, 1)

#

class ConstructorParams:
	
	const ROW_NORMAL = 0
	const ROW_BELOW = 1
	
	var descriptions
	
	var descriptions_func_source
	var descriptions_func_name
	
	var header_left_text : String
	
	var image_normal : Texture
	var image_hovered : Texture
	
	
	var on_click_func_source
	var on_click_func_name
	
	
	var condition_func_source
	var condition_func_name
	
	var row_index : int = ROW_NORMAL


var descriptions

var descriptions_func_source
var descriptions_func_name

var header_left_text : String

var image_normal : Texture
var image_hovered : Texture


var on_click_func_source
var on_click_func_name


var _condition_func_source
var _condition_func_name

#

onready var button = $AdvancedButtonWithTooltip

######

func set_prop_based_on_constructor(arg_constructor : ConstructorParams):
	descriptions = arg_constructor.descriptions
	
	descriptions_func_source = arg_constructor.descriptions_func_source
	descriptions_func_name = arg_constructor.descriptions_func_name
	
	header_left_text = arg_constructor.header_left_text
	
	set_image_normal(arg_constructor.image_normal)
	set_image_hovered(arg_constructor.image_hovered)
	
	on_click_func_source = arg_constructor.on_click_func_source
	on_click_func_name = arg_constructor.on_click_func_name
	
	set_condition_func_source_and_name(arg_constructor.condition_func_source, arg_constructor.condition_func_name)

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

func set_condition_func_source_and_name(arg_func_source, arg_func_name):
	_condition_func_source = arg_func_source
	_condition_func_name = arg_func_name
	
	update_is_enabled_based_on_conditions()

func update_is_enabled_based_on_conditions():
	var is_passed = true
	
	if _condition_func_source != null:
		is_passed = _condition_func_source.call(_condition_func_name)
	
	####
	
	button.disabled = !is_passed
	if is_passed:
		modulate = modulate_enabled
	else:
		modulate = modulate_disabled

######

func _on_AdvancedButtonWithTooltip_about_tooltip_construction_requested():
	var a_tooltip = BaseTowerSpecificTooltip_Scene.instance()
	
	if descriptions_func_source == null:
		a_tooltip.descriptions = descriptions
	else:
		a_tooltip.descriptions = descriptions_func_source.call(descriptions_func_name) 
	
	a_tooltip.header_left_text = header_left_text
	
	button.display_requested_about_tooltip(a_tooltip)

