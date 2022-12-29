extends Node


const MapPassage_Laser_Starting_01_and_03 = preload("res://MapsRelated/MapList/Map_Passage/Assets_MapComponents/PathLaserBeam/MapPassage_LaserBeam_Starting_0_and_2.png")

#

signal beam_fully_started()
signal beam_fully_ended()


const laser_duration_of_starting : float = 0.25
const laser_duration_of_ending : float = laser_duration_of_starting  # for simplicity's sake, make these two durations the same

const laser_frame_count : int = 8

const laser_anim_name__ended = "Ended"
const laser_anim_name__ending = "Ending"
const laser_anim_name__started = "Started"
const laser_anim_name__starting = "Starting"

#

var laser_size_x : float
var laser_size_y : float

var _current_middle_meet_point : Vector2

var _current_laser_01_x_offset_target : float
var _current_laser_01_x_offset_per_sec : float
# laser 2 will be negative of laser 01

var _current_scale_target : float
var _current_scale_per_sec : float


var is_laser_during_animation : bool


#

onready var laser_point_01 = $LaserPoint01
onready var laser_point_02 = $LaserPoint02

onready var laser_01 = $Laser01
onready var laser_02 = $Laser02

#

func _ready():
	set_physics_process(false)
	
	laser_01.visible = false
	laser_02.visible = false
	
	laser_01.scale.x = 0
	laser_02.scale.x = 0
	
	laser_size_x = MapPassage_Laser_Starting_01_and_03.get_size().x
	laser_size_y = MapPassage_Laser_Starting_01_and_03.get_size().y
	
	laser_01.frames.set_animation_speed(laser_anim_name__ending, laser_frame_count / laser_duration_of_ending)
	laser_01.frames.set_animation_speed(laser_anim_name__starting, laser_frame_count / laser_duration_of_starting)
	laser_02.frames.set_animation_speed(laser_anim_name__ending, laser_frame_count / laser_duration_of_ending)
	laser_02.frames.set_animation_speed(laser_anim_name__starting, laser_frame_count / laser_duration_of_starting)


func start_show():
	if !is_laser_during_animation:
		is_laser_during_animation = true
		
		_configure_properties_of_lasers()
		
		laser_01.play(laser_anim_name__starting)
		laser_01.visible = true
		laser_02.play(laser_anim_name__starting)
		laser_02.visible = true
		
		set_physics_process(true)

func _configure_properties_of_lasers():
	_current_middle_meet_point = (laser_point_01.global_position + laser_point_02.global_position) / 2
	
	laser_01.global_position = laser_point_01.global_position
	laser_02.global_position = laser_point_02.global_position
	
	laser_01.rotation_degrees = _get_angle(_current_middle_meet_point, laser_01.global_position)
	laser_01.offset.y = 1
	
	laser_02.rotation_degrees = _get_angle(_current_middle_meet_point, laser_02.global_position)

	_current_scale_target = (laser_point_01.global_position.distance_to(laser_point_02.global_position) / laser_size_x) / 2
	_current_scale_per_sec = _current_scale_target / laser_duration_of_ending
	
	#
	
	laser_01.offset.x = 0
	laser_02.offset.x = 0
	
	_current_laser_01_x_offset_target = (laser_point_01.global_position.distance_to(_current_middle_meet_point) / (_current_scale_target)) / 2
	_current_laser_01_x_offset_per_sec = _current_laser_01_x_offset_target / laser_duration_of_starting
	
	

func _get_angle(destination_pos : Vector2, source_pos : Vector2):
	var dx = destination_pos.x - source_pos.x
	var dy = destination_pos.y - source_pos.y
	
	return rad2deg(atan2(dy, dx))

#

func _physics_process(delta):
	laser_01.scale.x += _current_scale_per_sec * delta
	laser_02.scale.x += _current_scale_per_sec * delta
	
	laser_01.offset.x += _current_laser_01_x_offset_per_sec * delta
	laser_02.offset.x += _current_laser_01_x_offset_per_sec * delta
	
	if laser_01.scale.x >= _current_scale_target:
		# started
		laser_01.scale.x = _current_scale_target
		laser_02.scale.x = _current_scale_target
		
		laser_01.offset.x = _current_laser_01_x_offset_target
		laser_02.offset.x = _current_laser_01_x_offset_target
		
		laser_01.play(laser_anim_name__started)
		laser_02.play(laser_anim_name__started)
		
		is_laser_during_animation = false
		
		set_physics_process(false)
		emit_signal("beam_fully_started")


#

func start_hide():
	is_laser_during_animation = true
	
	laser_01.play(laser_anim_name__ending)
	laser_01.visible = true
	laser_02.play(laser_anim_name__ending)
	laser_02.visible = true
	
	laser_01.connect("animation_finished", self, "_on_animation_for_ending_finished", [], CONNECT_ONESHOT)


func _on_animation_for_ending_finished():
	laser_01.visible = false
	laser_02.visible = false
	
	laser_01.scale.x = 0
	laser_02.scale.x = 0
	
	is_laser_during_animation = false
	emit_signal("beam_fully_ended")
