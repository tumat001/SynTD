extends Area2D

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")

signal on_tower_entered(tower)
signal on_tower_exited(tower)

var _all_towers_in_range : Array = []

var _make_towers_glow : bool = false

var detection_range : float setget update_range
var can_display_range : bool
var displaying_range : bool


# Range related

func show_range():
	displaying_range = true
	update() #calls _draw()

func hide_range():
	displaying_range = false
	update()

func _draw():
	if displaying_range:
		if can_display_range:
			var color : Color = Color.gray
			color.a = 0.1
			draw_circle(Vector2(0, 0), detection_range, color)


func update_range(arg_detection_range : float):
	detection_range = arg_detection_range
	$CollShape.shape.set_deferred("radius", detection_range)
	update()



# Tower detection related

func _on_TowerDetectingRangeModule_area_entered(area):
	if area is AbstractTower:
		if area.get_script() != get_parent().get_script():
			_all_towers_in_range.append(area)
			
			if _make_towers_glow:
				_apply_glow_to_tower(area)
			
			call_deferred("emit_signal", "on_tower_entered", area)


func _on_TowerDetectingRangeModule_area_exited(area):
	if area is AbstractTower:
		if _make_towers_glow:
			_unapply_glow_to_tower(area)
		
		_all_towers_in_range.erase(area)
		
		call_deferred("emit_signal", "on_tower_exited", area)


func get_all_towers_in_range() -> Array:
	return _all_towers_in_range.duplicate(false)

func get_all_in_map_towers_in_range() -> Array:
	var bucket : Array = []
	
	for tower in _all_towers_in_range:
		if tower.current_placable is InMapAreaPlacable:
			bucket.append(tower)
	
	return bucket

# Glow related

func glow_all_towers_in_range():
	_make_towers_glow = true
	for tower in _all_towers_in_range:
		_apply_glow_to_tower(tower)

func _apply_glow_to_tower(tower : AbstractTower):
	if tower.current_placable is InMapAreaPlacable or tower.is_being_dragged:
		tower.set_tower_sprite_modulate(Color(1.5, 1.5, 1.5, 1))



func unglow_all_towers_in_range():
	_make_towers_glow = false
	for tower in _all_towers_in_range:
		_unapply_glow_to_tower(tower)

func _unapply_glow_to_tower(tower : AbstractTower):
	tower.set_tower_sprite_modulate(Color(1, 1, 1, 1))

