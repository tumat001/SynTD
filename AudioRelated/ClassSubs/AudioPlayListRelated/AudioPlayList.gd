extends Reference

signal before_play_sound(arg_id, arg_player)
signal on_play_sound(arg_id, arg_player)
signal finished_play_sound(arg_id, arg_player)

signal current_audio_id_and_player_changed(arg_id, arg_player)

signal stream_player_stopped_and_marked_as_inactive(arg_path_name, arg_stream_player)

signal is_playing_changed(arg_is_playing)

####

const NO_AUDIO_PLAYING_ID = -1

#

var playlist_name : String


var player_construction_type : int = AudioManager.PlayerConstructionType.PLAIN
var mask_level = AudioManager.MaskLevel.BGM
var play_adv_param : AudioManager.PlayAdvParams

var autoplay : bool = true
var _autoplay_delay : float = 0.0
var _autoplay_delay_timer : Timer

var rng_to_use : RandomNumberGenerator

var node_pause_mode : int = Node.PAUSE_MODE_INHERIT

var _is_playing : bool

#

var _current_audio_id_playing = NO_AUDIO_PLAYING_ID
var _current_audio_player


var _is_stopped : bool

#

var _all_audio_id_list : Array

var _audio_ids_played : Array


#


func _init(arg_play_adv_param : AudioManager.PlayAdvParams = null, arg_rng_to_use : RandomNumberGenerator = null):
	if arg_play_adv_param == null:
		_construct_default_play_adv_param()
	else:
		play_adv_param = arg_play_adv_param
	
	#
	
	if arg_rng_to_use == null:
		rng_to_use = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	else:
		rng_to_use = arg_rng_to_use



func set_autoplay_delay_with_node_to_host_timer(arg_delay, arg_node_to_host_timer):
	if _autoplay_delay_timer == null:
		_autoplay_delay_timer = Timer.new()
		_autoplay_delay_timer.one_shot = true
		
		arg_node_to_host_timer.add_child(_autoplay_delay_timer)
		

func get_current_audio_id_playing():
	return _current_audio_id_playing

func get_current_audio_player():
	return _current_audio_player


func has_audio_playing():
	return _current_audio_id_playing != NO_AUDIO_PLAYING_ID


#

func linearly_set_current_player_db_to_audiable():
	if has_audio_playing():
		var params = AudioManager.LinearSetAudioParams.new()
		params.pause_at_target_db = false
		params.stop_at_target_db = false
		#params.target_db =
		params.set_target_db_to_custom_standard_of_audio_id(_current_audio_id_playing)
		
		params.time_to_reach_target_db = 1
		
		AudioManager.linear_set_audio_player_volume_using_params(_current_audio_player, params)
		



func linearly_set_current_player_db_to_inaudiable(arg_pause_at_end : bool = false, arg_stop_at_end : bool = true,
		arg_autoplay_to_next : bool = false):
	
	if !_is_stopped:
		var params = AudioManager.LinearSetAudioParams.new()
		params.pause_at_target_db = arg_pause_at_end
		params.stop_at_target_db = arg_stop_at_end
		params.target_db = AudioManager.DECIBEL_VAL__INAUDIABLE
		
		params.time_to_reach_target_db = 1
		
		AudioManager.linear_set_audio_player_volume_using_params(_current_audio_player, params)
		AudioManager.connect("steam_player_stopped_and_marked_as_inactive", self, "_on_steam_player_stopped_and_marked_as_inactive", [arg_autoplay_to_next])
		
		_is_stopped = true

func _on_steam_player_stopped_and_marked_as_inactive(arg_path_name, arg_stream_player, arg_autoplay_to_next):
	if arg_stream_player == _current_audio_player:
		
		_finished_playing_audio(_current_audio_id_playing)
		
		emit_signal("stream_player_stopped_and_marked_as_inactive", arg_path_name, arg_stream_player)
		
		if arg_autoplay_to_next:
			start_play_next_random_audio_in_playlist()
			
		else:
			_set_is_playing(false)
		

#

func _construct_default_play_adv_param():
	play_adv_param = AudioManager.construct_play_adv_params()
	play_adv_param.node_source = AudioManager
	play_adv_param.play_sound_type = AudioManager.PlayerSoundType.BACKGROUND_MUSIC


###

func add_all_audio_ids_to_playlist(arg_ids : Array):
	for id in arg_ids:
		add_audio_id_to_playlist(id)

func add_audio_id_to_playlist(arg_id):
	if !_all_audio_id_list.has(arg_id):
		_all_audio_id_list.append(arg_id)

func remove_audio_id_from_playlist(arg_id) -> bool:
	if _current_audio_id_playing != arg_id:
		_all_audio_id_list.erase(arg_id)
		return true
		
	else:
		return false

func clear_all_audio_ids_from_playlist() -> bool:
	if _current_audio_id_playing != NO_AUDIO_PLAYING_ID:
		return false
	else:
		for id in _all_audio_id_list:
			remove_audio_id_from_playlist(id)
		
		return true


func set_audio_ids_of_playlist(arg_ids : Array):
	if _current_audio_id_playing != NO_AUDIO_PLAYING_ID:
		return false
		
	else:
		for id in _all_audio_id_list:
			if !arg_ids.has(id):
				remove_audio_id_from_playlist(id)
		
		for id in arg_ids:
			if !_all_audio_id_list.has(id):
				add_audio_id_to_playlist(id)
		
		return true

###

func _on_player_finished(arg_player, arg_path_name, arg_id):
	_finished_playing_audio(arg_id)
	emit_signal("finished_play_sound", arg_id, arg_player)
	
	if autoplay and !_is_stopped:
		if _autoplay_delay <= 0:
			start_play_next_random_audio_in_playlist()
			
		else:
			_autoplay_delay_timer.connect("timeout", self, "_on_autoplay_delay_timer_timeout", [arg_player, arg_path_name, arg_id], CONNECT_ONESHOT)
		
	else:
		_set_current_audio_id_playing__and_current_player(NO_AUDIO_PLAYING_ID, null)


func _finished_playing_audio(arg_id):
	attempt_reset_audios_played_history__except_for(arg_id)

#

func attempt_reset_audios_played_history__except_for(arg_id):
	if _audio_ids_played.size() == _all_audio_id_list.size():
		_audio_ids_played.clear()
		
		if arg_id != NO_AUDIO_PLAYING_ID:
			_audio_ids_played.append(arg_id)

#

func _on_autoplay_delay_timer_timeout(arg_player, arg_path_name, arg_id):
	if autoplay and !_is_stopped:
		start_play_next_random_audio_in_playlist()
	else:
		_set_current_audio_id_playing__and_current_player(NO_AUDIO_PLAYING_ID, null)

#

func start_play_next_random_audio_in_playlist():
	var audio_id_to_play = get_random_unplayed_audio_id()
	
	_play_sound(audio_id_to_play)
	
	return audio_id_to_play

func get_random_unplayed_audio_id():
	var candidates = []
	for audio_id in _all_audio_id_list:
		if !_audio_ids_played.has(audio_id):
			candidates.append(audio_id)
	
	return StoreOfRNG.randomly_select_one_element(candidates, rng_to_use)


func start_play_audio_id(arg_audio_id):
	if !_all_audio_id_list.has(arg_audio_id):
		add_audio_id_to_playlist(arg_audio_id)
	
	_play_sound(arg_audio_id)

#############

func _play_sound(arg_id):
	if _autoplay_delay_timer.time_left != 0:
		_autoplay_delay_timer.stop()
	
	_audio_ids_played.append(arg_id)
	
	_set_is_playing(true)
	_is_stopped = false
	
	#
	
	var file_path = StoreOfAudio.get_audio_file_path_of_id(arg_id)
	
	var player = AudioManager.get_available_or_construct_new_audio_stream_player(arg_id, player_construction_type, node_pause_mode)
	emit_signal("before_play_sound", arg_id, player)
	
	_set_current_audio_id_playing__and_current_player(arg_id, player)
	player.stream_paused = false
	
	AudioManager.play_sound__with_provided_stream_player(arg_id, player, mask_level, play_adv_param)
	emit_signal("on_play_sound", arg_id, player)
	
	player.connect("finished", self, "_on_player_finished", [player, file_path, arg_id], CONNECT_ONESHOT)
	

###########

func _set_current_audio_id_playing__and_current_player(arg_id, arg_player):
	_current_audio_id_playing = arg_id
	_current_audio_player = arg_player
	
	if _current_audio_player == null:
		if AudioManager.is_connected("steam_player_stopped_and_marked_as_inactive", self, "_on_steam_player_stopped_and_marked_as_inactive"):
			AudioManager.disconnect("steam_player_stopped_and_marked_as_inactive", self, "_on_steam_player_stopped_and_marked_as_inactive")
	
	
	emit_signal("current_audio_id_and_player_changed", _current_audio_id_playing, _current_audio_player)

func _set_is_playing(arg_is_playing):
	_is_playing = arg_is_playing
	
	emit_signal("is_playing_changed", _is_playing)


#


