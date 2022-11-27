extends Area2D

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")

signal on_tower_entered(tower)
signal on_tower_exited(tower)

signal on_tower_in_range_entered_map(tower)
signal on_tower_in_range_exited_map(tower)

signal showing_range()
signal hiding_range()


signal on_tower_entered_range_while_in_map_or_entered_map_while_in_range(tower)
signal on_tower_exited_range_or_exited_map_while_in_range(tower)

signal on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health(tower)
signal on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health(tower)


var _all_towers_in_range : Array = []

var all_towers_in_range__in_map__with_non_zero_health : Array = []

var _make_towers_glow : bool = false

var detection_range : float setget update_range
var can_display_range : bool
var displaying_range : bool

var can_display_circle_arc : bool = false
var circle_arc_color : Color = Color(1, 1, 1, 1)
var circle_range_color : Color = Color(0.75, 0.75, 0.75, 0.1)

const range_module_default_circle_range_color : Color = Color(0.2, 0.2, 0.2, 0.125)


onready var coll_shape = $CollShape

# 

func _ready():
	var shape := CircleShape2D.new()
	shape.radius = detection_range
	
	coll_shape.shape = shape



# Range related

func show_range():
	displaying_range = true
	update() #calls _draw()
	
	emit_signal("showing_range")

func hide_range():
	displaying_range = false
	update()
	
	emit_signal("hiding_range")

func _draw():
	if displaying_range:
		if can_display_range:
			draw_circle(Vector2(0, 0), detection_range, circle_range_color)
		
		if can_display_circle_arc:
			draw_circle_arc(Vector2(0, 0), detection_range, 0, 360, circle_arc_color)



func update_range(arg_detection_range : float):
	detection_range = arg_detection_range
	
	if is_inside_tree():
		coll_shape.shape.set_deferred("radius", detection_range)
		update()



# Tower detection related

func _on_TowerDetectingRangeModule_area_entered(area):
	if area is AbstractTower:
		if area.get_script() != get_parent().get_script():
			_all_towers_in_range.append(area)
			
			if _make_towers_glow:
				_apply_glow_to_tower(area)
			
			#
			if !area.is_connected("tower_active_in_map", self, "_emit_tower_in_range_placed_in_map"):
				area.connect("tower_active_in_map", self, "_emit_tower_in_range_placed_in_map", [area], CONNECT_PERSIST)
				area.connect("tower_not_in_active_map", self, "_emit_tower_in_range_placed_not_in_map", [area], CONNECT_PERSIST)
			
			call_deferred("emit_signal", "on_tower_entered", area)
			
			####
			
			if area.is_current_placable_in_map():
				emit_signal("on_tower_entered_range_while_in_map_or_entered_map_while_in_range", area)
				
				if area.current_health > 0:
					_update_vars_and_emit_on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health(area)
			
			if !area.is_connected("on_current_health_changed", self, "_on_tower_current_health_changed"):
				area.connect("on_current_health_changed", self, "_on_tower_current_health_changed", [area], CONNECT_PERSIST)

func _on_TowerDetectingRangeModule_area_exited(area):
	if area is AbstractTower:
		if _make_towers_glow:
			_unapply_glow_to_tower(area)
		
		_all_towers_in_range.erase(area)
		
		#
		if area.is_connected("tower_active_in_map", self, "_emit_tower_in_range_placed_in_map"):
			area.disconnect("tower_active_in_map", self, "_emit_tower_in_range_placed_in_map")
			area.disconnect("tower_not_in_active_map", self, "_emit_tower_in_range_placed_not_in_map")
		
		call_deferred("emit_signal", "on_tower_exited", area)
		
		####
		
		emit_signal("on_tower_exited_range_or_exited_map_while_in_range", area)
		_update_vars_and_emit_on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health(area)
		
		if area.is_connected("on_current_health_changed", self, "_on_tower_current_health_changed"):
			area.disconnect("on_current_health_changed", self, "_on_tower_current_health_changed")


func get_all_towers_in_range() -> Array:
	return _all_towers_in_range.duplicate(false)

func get_all_in_map_towers_in_range() -> Array:
	var bucket : Array = []
	
	for tower in _all_towers_in_range:
		if tower.is_current_placable_in_map():
			bucket.append(tower)
	
	return bucket

func get_all_in_map_and_active_towers_in_range() -> Array:
	var bucket : Array = []
	
	for tower in _all_towers_in_range:
		if tower.is_current_placable_in_map() and !tower.last_calculated_disabled_from_attacking:
			bucket.append(tower)
	
	return bucket


# Signal related

func _emit_tower_in_range_placed_in_map(tower):
	emit_signal("on_tower_in_range_entered_map", tower)
	
	if tower.is_current_placable_in_map():
		emit_signal("on_tower_entered_range_while_in_map_or_entered_map_while_in_range", tower)
		
		if tower.current_health > 0:
			_update_vars_and_emit_on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health(tower)

func _emit_tower_in_range_placed_not_in_map(tower):
	emit_signal("on_tower_in_range_exited_map", tower)
	emit_signal("on_tower_exited_range_or_exited_map_while_in_range", tower)
	_update_vars_and_emit_on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health(tower)

func _on_tower_current_health_changed(arg_health, arg_tower):
	if arg_health <= 0:
		_update_vars_and_emit_on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health(arg_tower)
	else:
		if !arg_tower.is_connected("on_current_health_changed", self, "_on_tower_current_health_changed"):
			arg_tower.connect("on_current_health_changed", self, "_on_tower_current_health_changed", [arg_tower], CONNECT_PERSIST)
		
		_update_vars_and_emit_on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health(arg_tower)


func _update_vars_and_emit_on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health(arg_tower):
	if !all_towers_in_range__in_map__with_non_zero_health.has(arg_tower):
		all_towers_in_range__in_map__with_non_zero_health.append(arg_tower)
	emit_signal("on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health", arg_tower)

func _update_vars_and_emit_on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health(arg_tower):
	all_towers_in_range__in_map__with_non_zero_health.erase(arg_tower)
	emit_signal("on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health", arg_tower)

# Glow related

func glow_all_towers_in_range():
	_make_towers_glow = true
	for tower in _all_towers_in_range:
		_apply_glow_to_tower(tower)

func _apply_glow_to_tower(tower : AbstractTower):
	if tower.current_placable is InMapAreaPlacable or tower.is_being_dragged:
		tower.set_tower_base_modulate(AbstractTower.TowerModulateIds.TOWER_DETECTING_RANGE_MODULE, Color(1.5, 1.5, 1.5, 1))



func unglow_all_towers_in_range():
	_make_towers_glow = false
	for tower in _all_towers_in_range:
		_unapply_glow_to_tower(tower)

func _unapply_glow_to_tower(tower : AbstractTower):
	tower.remove_tower_base_modulate(AbstractTower.TowerModulateIds.TOWER_DETECTING_RANGE_MODULE)


#

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 2)


#

func mirror_tower_range_module_range_changes(arg_tower):
	if !arg_tower.is_connected("final_range_changed", self, "_mirrored_tower_range_module_range_changed"):
		arg_tower.connect("final_range_changed", self, "_mirrored_tower_range_module_range_changed", [arg_tower], CONNECT_PERSIST)
	
	_mirrored_tower_range_module_range_changed(arg_tower)

func _mirrored_tower_range_module_range_changed(arg_tower):
	if is_instance_valid(arg_tower.range_module):
		update_range(arg_tower.range_module.last_calculated_final_range)

#

func get_targets_based_on_params(arg_towers : Array, arg_targeting : int,
		arg_num_of_targets : int, arg_pos : Vector2, arg_include_invis : bool):
	
	return Targeting.enemies_to_target(arg_towers, arg_targeting, arg_num_of_targets, arg_pos, arg_include_invis)


