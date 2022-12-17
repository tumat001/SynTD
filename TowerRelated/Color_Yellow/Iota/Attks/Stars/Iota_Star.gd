extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"

const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const Star_BeamPic_01 = preload("res://TowerRelated/Color_Yellow/Iota/Attks/StarBeam/Iota_StarBeam_Yellow.png")


signal on_star_state_changed(arg_self, arg_state)
signal on_star_lifetime_expired()
signal on_request_configure_self_for_crash(arg_self)


enum StarState {
	Idle = 0,
	Crash = 1,
	Beam = 2,
}

var current_star_state : int = -1 setget set_current_star_state
var current_star_lifetime : float

var star_beam
var current_target_for_beam setget set_current_target_for_beam

var iota_tower setget set_iota_tower

var has_homing_component_attached : bool

#

func set_iota_tower(arg_tower):
	iota_tower = arg_tower
	
	iota_tower.connect("all_stars_crash_to_target", self, "_on_iota_tower_command_all_to_turn_to_crash", [], CONNECT_ONESHOT)
	iota_tower.connect("all_stars_beam_to_target", self, "_on_iota_tower_command_all_to_turn_to_beam")
	
	iota_tower.connect("on_tower_no_health", self, "_on_tower_no_health_i", [], CONNECT_DEFERRED)
	iota_tower.connect("on_tower_healed_from_no_health", self, "_on_tower_healed_from_no_health_i", [], CONNECT_DEFERRED)
	

func set_current_star_state(arg_state):
	var old_state = current_star_state
	
	current_star_state = arg_state
	
	if is_inside_tree():
		_update_star_state()
	
	emit_signal("on_star_state_changed", self, current_star_state, old_state)

func _update_star_state():
	bullet_sprite.frame = current_star_state
	
	if current_star_state != StarState.Beam:
		_hide_star_beam()
	
	apply_damage_instance_on_hit = (current_star_state == StarState.Crash)
	decrease_pierce = (current_star_state == StarState.Crash)
	
	if current_star_state == StarState.Crash:
		emit_signal("on_request_configure_self_for_crash", self)
		#call_deferred("emit_signal", "on_request_configure_self_for_crash", self)

func set_current_target_for_beam(arg_target):
	if is_instance_valid(current_target_for_beam):
		if current_target_for_beam.is_connected("tree_exiting", self, "_on_curr_target_tree_exiting"):
			current_target_for_beam.disconnect("tree_exiting", self, "_on_curr_target_tree_exiting")
		_hide_star_beam()
	
	current_target_for_beam = arg_target
	
	if is_inside_tree() and is_instance_valid(current_target_for_beam):
		current_target_for_beam.connect("tree_exiting", self, "_on_curr_target_tree_exiting")
		
		if current_star_state == StarState.Beam:
			if !is_instance_valid(star_beam):
				_construct_star_beam()
			else:
				star_beam.visible = iota_tower.is_dead_for_the_round

func _construct_star_beam():
	star_beam = BeamAesthetic_Scene.instance()
	star_beam.set_texture_as_default_anim(Star_BeamPic_01)
	star_beam.visible = false
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(star_beam)


func _on_curr_target_tree_exiting():
	_hide_star_beam()

func _hide_star_beam():
	if is_instance_valid(star_beam):
		star_beam.visible = false


#

func _ready():
	_update_star_state()
	
	set_current_target_for_beam(current_target_for_beam)


func _process(delta):
	current_star_lifetime -= delta
	if current_star_lifetime <= 0:
		set_current_star_state(StarState.Crash)
	
	if current_star_state == StarState.Beam:
		if is_instance_valid(current_target_for_beam):
			_update_beam_pos_and_dest()
	
	if speed == 0:
		speed_inc_per_sec = 0

#

func _update_beam_pos_and_dest():
	if is_instance_valid(star_beam):
		#star_beam.visible = true
		star_beam.global_position = global_position
		
		if !iota_tower.is_dead_for_the_round:
			star_beam.update_destination_position(current_target_for_beam.global_position)


func queue_free():
	.queue_free()
	
	if is_instance_valid(star_beam):
		star_beam.queue_free()

#

func _on_iota_tower_command_all_to_turn_to_crash():
	set_current_star_state(StarState.Crash)

func _on_iota_tower_command_all_to_turn_to_beam(arg_target):
	set_current_star_state(StarState.Beam)
	set_current_target_for_beam(arg_target)


func _curr_star_target_changed(arg_target):
	if current_star_state == StarState.Crash:
		#call_deferred("emit_signal", "on_request_configure_self_for_crash", self)
		emit_signal("on_request_configure_self_for_crash", self)
	elif current_star_state == StarState.Beam:
		
		set_current_target_for_beam(arg_target)


#

func _on_tower_no_health_i():
	_hide_star_beam()

func _on_tower_healed_from_no_health_i():
	if current_star_state != StarState.Beam:
		_hide_star_beam()
	else:
		if is_instance_valid(star_beam):
			star_beam.visible = true


