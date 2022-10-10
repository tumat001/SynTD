extends Reference

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const CommonTextures_TargetParticle_Pic = preload("res://MiscRelated/CommonTextures/CommonTextures_TargetParticle.png")

enum ShowParticleConditions {
	ALWAYS,
	ON_RANGE_DISPLAY_NOT_DRAGGED,
}


var _source
var _source_tower_provider_func_name : String
var show_particle_conditions : int = ShowParticleConditions.ON_RANGE_DISPLAY_NOT_DRAGGED

var tower_particle_indicator : SpriteFrames

var _tower_particle_map : Dictionary = {}

var _is_showing_particles : bool = false

var destroy_particles_on_tower_source_on_bench : bool = true
var update_state_when_destroying_particles : bool = true

var destroy_particles_on_tower_target_on_bench : bool = true

#

func get_towers_with_particle_indicators():
	return _tower_particle_map.keys().duplicate()


#

func set_tower_particle_indicator_as_texture(arg_texture : Texture):
	var sf = SpriteFrames.new()
	sf.add_frame("default", arg_texture)
	
	tower_particle_indicator = sf

func set_tower_particle_indicator_to_usual_properties():
	set_tower_particle_indicator_as_texture(CommonTextures_TargetParticle_Pic)

#

# arg_source is a tower
func set_source_and_provider_func_name(arg_source, arg_tower_provider_func_name : String):
	_source_tower_provider_func_name = arg_tower_provider_func_name
	
	if is_instance_valid(_source):
		if _source is AbstractTower:
			if _source.is_connected("tree_exiting", self, "_tower_source_queue_freed"):
				_source.disconnect("tree_exiting", self, "_tower_source_queue_freed", [], CONNECT_PERSIST)
				_source.disconnect("tower_not_in_active_map", self, "_tower_source_benched", [], CONNECT_PERSIST)
			
			if _source.is_connected("on_tower_toggle_showing_range", self, "_on_tower_showing_ranges_changed"):
				_source.disconnect("on_tower_toggle_showing_range", self, "_on_tower_showing_ranges_changed")
				_source.disconnect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_drag")
				_source.disconnect("tower_being_dragged", self, "_on_tower_being_dragged")
	
	_source = arg_source
	
	if is_instance_valid(_source):
		if _source is AbstractTower:
			if !_source.is_connected("tree_exiting", self, "_tower_source_queue_freed"):
				_source.connect("tree_exiting", self, "_tower_source_queue_freed", [], CONNECT_PERSIST)
				_source.connect("tower_not_in_active_map", self, "_tower_source_benched", [], CONNECT_PERSIST)
			
			if show_particle_conditions == ShowParticleConditions.ON_RANGE_DISPLAY_NOT_DRAGGED:
				if !_source.is_connected("on_tower_toggle_showing_range", self, "_on_tower_showing_ranges_changed"):
					_source.connect("on_tower_toggle_showing_range", self, "_on_tower_showing_ranges_changed", [], CONNECT_PERSIST)
					_source.connect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_drag", [], CONNECT_PERSIST)
					_source.connect("tower_being_dragged", self, "_on_tower_being_dragged", [], CONNECT_PERSIST)


func _on_tower_showing_ranges_changed(is_showing : bool):
	_update_particle_state()

func _on_tower_dropped_from_drag(tower_self):
	_update_particle_state()

func _on_tower_being_dragged(tower_self):
	_update_particle_state()


func _update_particle_state():
	if is_instance_valid(_source) and (!(_source is AbstractTower) or (_source is AbstractTower and _source.is_showing_ranges and !_source.is_being_dragged and _source.is_current_placable_in_map())):
		if _source.has_method(_source_tower_provider_func_name):
			show_indicators_to_towers(_source.call(_source_tower_provider_func_name))
	else:
		destroy_indicators_from_towers()



#

func _tower_source_queue_freed():
	destroy_indicators_from_towers()

func _tower_source_benched():
	if destroy_particles_on_tower_source_on_bench:
		destroy_indicators_from_towers()


#

func show_indicators_to_towers(arg_towers, remove_tower_indicators_from_prev_existing : bool = true):
	_is_showing_particles = true
	
	if typeof(arg_towers) != TYPE_ARRAY:
		arg_towers = [arg_towers]
	
	var towers_not_in_new_arg : Array = []
	
	for tower in arg_towers:
		if is_instance_valid(tower):
			if !_tower_particle_map.has(tower):
				var particle = _construct_particle_indicator()
				
				tower.add_child(particle)
				_tower_particle_map[tower] = particle
				
				if !tower.is_connected("tree_exiting", self, "_tower_target_queue_freed"):
					tower.connect("tree_exiting", self, "_tower_target_queue_freed", [tower], CONNECT_PERSIST)
					tower.connect("tower_not_in_active_map", self, "_tower_target_benched", [tower], CONNECT_PERSIST)
				
			elif remove_tower_indicators_from_prev_existing:
				towers_not_in_new_arg.append(tower)
	
	
	destroy_indicators_from_towers(towers_not_in_new_arg)


func _construct_particle_indicator():
	var attk_sprite = AttackSprite_Scene.instance()
	attk_sprite.has_lifetime = false
	attk_sprite.frames = tower_particle_indicator
	
	return attk_sprite


func destroy_indicators_from_towers(arg_towers = _tower_particle_map.keys().duplicate()):
	for tower in arg_towers:
		if is_instance_valid(tower) and tower.is_connected("tree_exiting", self, "_tower_target_queue_freed"):
			tower.disconnect("tree_exiting", self, "_tower_target_queue_freed")
			tower.disconnect("tower_not_in_active_map", self, "_tower_target_benched")
		
		call_deferred("_destroy_particle_associated_with_tower", tower, false)
	
	if _tower_particle_map.size() == 0:
		_is_showing_particles = false


#

func _tower_target_queue_freed(tower):
	_destroy_particle_associated_with_tower(tower)

func _tower_target_benched(tower):
	if destroy_particles_on_tower_target_on_bench:
		_destroy_particle_associated_with_tower(tower)


func _destroy_particle_associated_with_tower(tower, update_state : bool = true):
	if _tower_particle_map.has(tower):
		var particle = _tower_particle_map[tower]
		if is_instance_valid(particle):
			particle.queue_free()
	
	_tower_particle_map.erase(tower)
	
	
	if _is_showing_particles and update_state and update_state_when_destroying_particles:
		call_deferred("_update_particle_state")


#


