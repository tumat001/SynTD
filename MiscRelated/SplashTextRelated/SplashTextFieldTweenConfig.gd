extends Reference



var scene_tree_tween : SceneTreeTween setget set_scene_tree_tween

var lifetime_to_start

####

var _current_lifetime
var _has_started : bool = false

###########

func set_scene_tree_tween(arg_tween):
	scene_tree_tween.stop()

func delta(arg_delta):
	_current_lifetime += arg_delta
	
	if !_has_started and _current_lifetime >= lifetime_to_start:
		_has_started = true
		
		var excess = _current_lifetime - lifetime_to_start
		scene_tree_tween.play()
		scene_tree_tween.custom_step(excess)


func reset():
	_current_lifetime = 0
	_has_started = false
	
	if scene_tree_tween != null and scene_tree_tween.is_valid():
		scene_tree_tween.stop()
	
