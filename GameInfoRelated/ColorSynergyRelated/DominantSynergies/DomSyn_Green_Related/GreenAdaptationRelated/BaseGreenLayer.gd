

signal on_current_active_green_paths_changed(new_paths)
signal on_available_green_paths_changed(new_paths)
signal on_current_active_limit_changed(new_limit)
signal on_path_activated(activated_path)
signal on_tier_of_syn_changed(new_tier)



var green_layer_name : String

var _original_green_paths : Array

var _current_active_green_paths : Array = []
var _current_untaken_green_paths : Array = []

var available_green_paths : Array = []

var tier_to_activate : int
var current_active_limit : int setget set_current_active_limit
var dom_syn_green setget set_dom_syn_green

#

# ORDER OF ORIGINAL GREEN PATHS MATTER
func _init(arg_tier_to_activate : int, arg_limit : int, arg_name : String, 
		arg_syn, arg_original_green_paths : Array):
	tier_to_activate = arg_tier_to_activate
	green_layer_name = arg_name
	current_active_limit = arg_limit
	_original_green_paths = arg_original_green_paths
	
	for path in _original_green_paths:
		_current_untaken_green_paths.append(path)
		path.connect("on_path_activated", self, "_on_path_activated", [path], CONNECT_PERSIST)
	
	set_dom_syn_green(arg_syn)

#

func set_dom_syn_green(arg):
	dom_syn_green = arg
	
	dom_syn_green.connect("synergy_applied", self, "_dom_syn_tier_applied", [dom_syn_green.game_elements], CONNECT_PERSIST)
	dom_syn_green.connect("synergy_removed", self, "_dom_syn_removed", [dom_syn_green.game_elements], CONNECT_PERSIST)

func set_current_active_limit(new_limit : int):
	current_active_limit = new_limit
	call_deferred("on_current_active_limit_changed", new_limit)

#

func _dom_syn_tier_applied(tier, arg_game_elements):
	_update_available_path_state(tier)
	emit_signal("on_tier_of_syn_changed", tier)

func _dom_syn_removed(tier, arg_game_elements):
	_update_available_path_state(dom_syn_green.SYN_INACTIVE)
	emit_signal("on_tier_of_syn_changed", dom_syn_green.SYN_INACTIVE)


func _update_available_path_state(tier):
	if if_meets_tier_requirements(tier):
		if current_active_limit > _current_active_green_paths.size():
			available_green_paths.clear()
			for path in _current_untaken_green_paths:
				available_green_paths.append(path)
			
			call_deferred("emit_signal", "on_available_green_paths_changed", available_green_paths)
			
			return
	
	# else
	available_green_paths.clear()
	call_deferred("emit_signal", "on_available_green_paths_changed", available_green_paths)


#

func attempt_activate_available_green_path(path):
	if can_activate_path(path):
		path.call_deferred("activate_path_with_green_syn", dom_syn_green)

func _on_path_activated(path):
	if available_green_paths.has(path):
		_current_untaken_green_paths.erase(path)
		_current_active_green_paths.append(path)
		
		emit_signal("on_path_activated", path)
		_update_available_path_state(dom_syn_green.curr_tier)
		emit_signal("on_current_active_green_paths_changed", _current_active_green_paths)



func get_current_active_green_paths():
	return _current_active_green_paths

func can_activate_path(path) -> bool:
	return available_green_paths.has(path)


func if_meets_tier_requirements(tier : int = dom_syn_green.curr_tier) -> bool:
	return tier_to_activate >= tier and tier != dom_syn_green.SYN_INACTIVE

