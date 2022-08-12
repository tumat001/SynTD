extends PathFollow2D



var tower_to_orbit
#var orbit_speed


func set_tower_to_orbit(arg_tower):
	tower_to_orbit = arg_tower


#func _on_orbit_speed_changed_by_tower(arg_val):
#	orbit_speed = arg_val


func _on_offset_to_add(arg_val):
	offset += arg_val


