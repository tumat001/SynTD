# Assumes that the control_to_match_border is rectangular in shape

extends Control

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")
const BorderShine_Orbit_Scene = preload("res://MiscRelated/GUI_Category_Related/BorderShine/OtherRels/BorderShine_Orbit.tscn")
const BorderShine_Orbit = preload("res://MiscRelated/GUI_Category_Related/BorderShine/OtherRels/BorderShine_Orbit.gd")

const _number_of_shine : int = 2 # will always be 2. If changed then change code.
#const _time_to_reach_next_point : float = 1.0

var control_to_match_border : Control setget set_control_to_match_border
var speed_of_border_shine_unit_offset : float = 0.5 # revolution per 1 / x sec

var border_shine_trail_color : Color = Color(1, 1, 1, 0.6)
var border_trail_component : MultipleTrailsForNodeComponent
var border_shine_trail_length : float = 5
var border_shine_trail_width : float = 3
var _all_trails : Array
var _all_orbits : Array
var _all_points : Array
var _path_length : float

var _initialized : bool = false

var show_border_shine : bool = false setget set_show_border_shine


#

func set_control_to_match_border(arg_control):
	control_to_match_border = arg_control
	
	if is_inside_tree() and control_to_match_border != null:
		update_border_size()


func update_border_size():
	rect_size = control_to_match_border.rect_size
	rect_global_position = control_to_match_border.rect_global_position
	
	var point_pos_01 = Vector2(0, 0)
	var point_pos_02 = Vector2(rect_size.x, 0)
	var point_pos_03 = Vector2(rect_size.x, rect_size.y)
	var point_pos_04 = Vector2(0, rect_size.y)
	
	_all_points.append(point_pos_01)
	_all_points.append(point_pos_02)
	_all_points.append(point_pos_03)
	_all_points.append(point_pos_04)
	
	_path_length = (rect_size.x * 2) + (rect_size.y * 2)
	
	if !_initialized:
		_initialized = true
		
		_initialize_border_trail_compo()
		_initialize_path_follow_2ds()

##

func _ready():
	set_control_to_match_border(control_to_match_border)
	
	set_show_border_shine(show_border_shine)

func _initialize_path_follow_2ds():
	var border_follow_01 = BorderShine_Orbit_Scene.instance()
	border_follow_01.texture = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/WhiteLine_7x7.png")
	add_child(border_follow_01)
	#border_trail_component.create_trail_for_node(border_follow_01)
	border_follow_01.current_target_point_local = _all_points[1]
	border_follow_01.current_target_point_idx = 1
	border_follow_01.connect("corner_turned", self, "_on_corner_turned", [border_follow_01])
	_all_orbits.append(border_follow_01)
	
	var border_follow_02 = BorderShine_Orbit_Scene.instance()
	border_follow_02.texture = preload("res://PreGameHUDRelated/MapSelectionScreen/Assets/WhiteLine_7x7.png")
	add_child(border_follow_02)
	border_follow_02.rect_position = rect_size
	#border_trail_component.create_trail_for_node(border_follow_02)
	border_follow_02.current_target_point_local = _all_points[3]
	border_follow_02.current_target_point_idx = 3
	border_follow_02.connect("corner_turned", self, "_on_corner_turned", [border_follow_02])
	_all_orbits.append(border_follow_02)
	

func _initialize_border_trail_compo():
	border_trail_component = MultipleTrailsForNodeComponent.new()
	border_trail_component.node_to_host_trails = self
	border_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	border_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	

func _trail_before_attached_to_node(arg_trail, arg_node):
	if !_all_trails.has(arg_trail):
		_all_trails.append(arg_trail)
	
	arg_trail.max_trail_length = border_shine_trail_length
	arg_trail.trail_color = border_shine_trail_color
	arg_trail.width = border_shine_trail_width
	arg_trail.z_index = 1
	


#

func _process(delta):
	for border_orbit in _all_orbits:
		border_orbit.move_unit_distance(speed_of_border_shine_unit_offset * delta, _path_length)


func _on_corner_turned(arg_border_oribt : BorderShine_Orbit):
	var next_orbit_idx = arg_border_oribt.current_target_point_idx + 1
	if next_orbit_idx >= _all_points.size():
		next_orbit_idx = 0
	arg_border_oribt.current_target_point_idx = next_orbit_idx
	arg_border_oribt.current_target_point_local = _all_points[next_orbit_idx]
	


#

func set_show_border_shine(arg_val):
	show_border_shine = arg_val
	
	var mod_a = 0
	if arg_val:
		mod_a = border_shine_trail_color.a
	
	for trail in _all_trails:
		trail.modulate.a = mod_a

