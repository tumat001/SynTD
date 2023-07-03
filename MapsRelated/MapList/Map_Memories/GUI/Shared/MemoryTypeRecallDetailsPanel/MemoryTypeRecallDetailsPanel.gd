# used for displaying info about the recall memory
# primarily designed as a tooltip-able control

extends MarginContainer


class ConstructorParams:
	
	var descriptions
	
	var descriptions_func_source
	var descriptions_func_name
	var descriptions_func_param
	
	var header_text : String
	
	
	#
	
	const WARNING_HEADER_TEXT__NOTE = "Note:"
	
	var warning_header_text : String = WARNING_HEADER_TEXT__NOTE
	
	var warning_desc_func_source
	var warning_desc_func_name
	var warning_desc_func_param
	
	var warning_update_signal_source
	var warning_update_signal_name
	
	#
	
	var tower_type_infos_to_show : Array
	
	func set_tower_type_infos_to_show__with_tower_ids(arg_ids):
		var bucket = []
		for id in arg_ids:
			if Towers.tower_id_info_type_singleton_map.has(id):
				var tower_type_info = Towers.tower_id_info_type_singleton_map[id]
				bucket.append(tower_type_info)
		
		tower_type_infos_to_show = bucket
	


var descriptions = []

var descriptions_func_source
var descriptions_func_name
var descriptions_func_param

var header_text : String


var warning_header_text : String

var warning_desc_func_source
var warning_desc_func_name
var warning_desc_func_param

var warning_update_signal_source
var warning_update_signal_name


var tower_type_infos_to_show : Array


####

onready var name_label = $VBoxContainer/MainInfoPanel/MarginContainer/VBoxContainer/NameLabel
onready var tower_icon_collection_panel = $VBoxContainer/MainInfoPanel/MarginContainer/VBoxContainer/TowerIconMarginer/TowerIconCollectionPanel
onready var main_tooltip_body = $VBoxContainer/MainInfoPanel/MarginContainer/VBoxContainer/MainTooltipBody
onready var warning_tooltip_body = $VBoxContainer/WarningInfoPanel/MarginContainer/VBoxContainer/WarningTooltipBody
onready var warning_header_label = $VBoxContainer/WarningInfoPanel/MarginContainer/VBoxContainer/HBoxContainer/WarningHeaderLabel

onready var warning_info_panel = $VBoxContainer/WarningInfoPanel


######

func set_prop_based_on_constructor(arg_constructor : ConstructorParams):
	descriptions = arg_constructor.descriptions
	
	descriptions_func_source = arg_constructor.descriptions_func_source
	descriptions_func_name = arg_constructor.descriptions_func_name
	descriptions_func_param = arg_constructor.descriptions_func_param
	
	header_text = arg_constructor.header_text
	
	warning_header_text = arg_constructor.warning_header_text
	
	set_warning_func_source_and_name_and_param(arg_constructor)
	
	set_warning_update_signal__for_update(arg_constructor.warning_update_signal_source, arg_constructor.warning_update_signal_name)
	
	tower_type_infos_to_show = arg_constructor.tower_type_infos_to_show
	
	#
	
	if is_inside_tree():
		update_display()

#

func _ready():
	main_tooltip_body.bbcode_align_mode = main_tooltip_body.BBCodeAlignMode.CENTER
	warning_tooltip_body.bbcode_align_mode = warning_tooltip_body.BBCodeAlignMode.CENTER
	
	update_display()


func update_display():
	update_main_info_descs()
	
	name_label.text = header_text
	
	warning_header_label.text = warning_header_text
	
	tower_icon_collection_panel.set_tower_icon_array__using_tower_type_infos(tower_type_infos_to_show)
	tower_icon_collection_panel.visible = tower_type_infos_to_show.size() != 0


func update_main_info_descs():
	if descriptions.size() != 0:
		main_tooltip_body.descriptions = descriptions
		main_tooltip_body.update_display()
		
	elif descriptions_func_source != null:
		var descs = descriptions_func_source.call(descriptions_func_name, descriptions_func_param)
		main_tooltip_body.descriptions = descs
		main_tooltip_body.update_display()
		
	
	


#

func set_warning_func_source_and_name_and_param(arg_constructor : ConstructorParams):
	warning_desc_func_source = arg_constructor.warning_desc_func_source
	warning_desc_func_name = arg_constructor.warning_desc_func_name
	warning_desc_func_param = arg_constructor.warning_desc_func_param
	
	if is_inside_tree():
		update_warning_tooltip_body_display()


func update_warning_tooltip_body_display():
	var desc : Array = []
	
	if warning_desc_func_source != null and warning_desc_func_name != null:
		desc = warning_desc_func_source.call(warning_desc_func_name, warning_desc_func_param)
		
	
	if desc.size() != 0:
		warning_tooltip_body.descriptions = desc
		warning_tooltip_body.update_display()
		warning_info_panel.visible = true
		
	else:
		warning_info_panel.visible = false
	


#

func set_warning_update_signal__for_update(arg_source, arg_signal_name):
	if warning_update_signal_source != null:
		warning_update_signal_source.disconnect(warning_update_signal_name, self, "update_warning_tooltip_body_display")
	
	warning_desc_func_source = arg_source
	warning_desc_func_name = arg_signal_name
	
	if warning_update_signal_source != null and warning_update_signal_name.length() != 0:
		warning_update_signal_source.connect(warning_update_signal_name, self, "update_warning_tooltip_body_display", [], CONNECT_PERSIST)


