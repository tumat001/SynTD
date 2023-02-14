extends Node

const WholeLoadingScreen = preload("res://SingletonForCommsRelated/BetweenScenesRelated/WholeLoadingScreen.gd")
const WholeLoadingScreen_Scene = preload("res://SingletonForCommsRelated/BetweenScenesRelated/WholeLoadingScreen.tscn")

const game_elements_path : String = "res://GameElementsRelated/GameElements.tscn"

#

signal game_elements_created(arg_game_elements)

#

var map_id
var game_mode_id : int

#

var loader
var wait_frames : int
var time_max = 100 #msec
var whole_loading_screen : WholeLoadingScreen

var _curr_path_for_load : String

#

var current_game_elements
var current_game_elements__other_node_hoster
var current_game_elements__proj_hoster
var current_game_elements__node_hoster_below_screen_effects_mngr

#

func _ready():
	set_process(false)
	
	_load_defaults()
	_initialize_whole_loading_screen()


func _load_defaults():
	map_id = StoreOfMaps.default_map_id_for_empty
	game_mode_id = StoreOfGameMode.Mode.STANDARD_NORMAL

func _initialize_whole_loading_screen():
	whole_loading_screen = WholeLoadingScreen_Scene.instance()
	add_child(whole_loading_screen)


#

func goto_scene(arg_path, arg_scene_to_remove):
	_curr_path_for_load = arg_path
	call_deferred("_deferred_goto_scene", arg_path, arg_scene_to_remove)

func _deferred_goto_scene(arg_path, arg_scene_to_remove):
	var root = get_tree().get_root()
	#var curr_scene = root.get_child(root.get_child_count() - 1)
	var curr_scene = arg_scene_to_remove
	
	loader = ResourceLoader.load_interactive(arg_path)
	if loader == null:
		print("error returned")
		return
	
	set_process(true)
	
	curr_scene.queue_free()
	
	whole_loading_screen.show_loading_screen()
	
	wait_frames = 1


#

func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	
	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return
	
	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()
		
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
			
		else: # Error during loading.
			#show_error()
			print("error returned")
			loader = null
			break


func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	
	whole_loading_screen.set_progress_ratio(progress)


func set_new_scene(scene_resource):
	var current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	
	whole_loading_screen.hide_loading_screen()

#######

func goto_game_elements(arg_scene_to_remove : Node):
	goto_scene(game_elements_path, arg_scene_to_remove)

func goto_starting_screen(arg_scene_to_remove : Node):
	goto_scene("res://PreGameHUDRelated/PreGameScreen.tscn", arg_scene_to_remove)


## GAME ELEMENTS related

# called by GE
func _game_elements_created__before_anything():
	emit_signal("game_elements_created", current_game_elements)


func ge_add_child_to_other_node_hoster(arg_node):
	current_game_elements__other_node_hoster.add_child(arg_node)

func deferred_ge_add_child_to_other_node_hoster(arg_node):
	current_game_elements__other_node_hoster.call_deferred("add_child", arg_node)


func ge_add_child_to_proj_hoster(arg_node):
	current_game_elements__proj_hoster.add_child(arg_node)

func deferred_ge_add_child_to_proj_hoster(arg_node):
	current_game_elements__proj_hoster.call_deferred("add_child", arg_node)


func ge_add_child_to_below_screen_effects_node_hoster(arg_node):
	current_game_elements__node_hoster_below_screen_effects_mngr.add_child(arg_node)

func deferred_ge_add_child_to_below_screen_effects_node_hoster(arg_node):
	current_game_elements__node_hoster_below_screen_effects_mngr.call_deferred("add_child", arg_node)

