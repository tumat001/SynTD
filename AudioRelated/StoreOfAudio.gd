extends Node

const AudioPlayList = preload("res://AudioRelated/ClassSubs/AudioPlayListRelated/AudioPlayList.gd")
const AudioPlayListCatalog = preload("res://AudioRelated/ClassSubs/AudioPlayListRelated/AudioPlayListCatalog.gd")

#

const BGM_AUDIO_NAME_ID_PREFIX = "BGM_"
const BGM_AUDIO_FOLDER_PATH = "res://AudioRelated/Audios/BGMs/"

const BGM_XSTAGE_STRING_IDENTIFIER__EARLY = "EarlyStage"
const BGM_XSTAGE_STRING_IDENTIFIER__MID = "MiddleStage"
const BGM_XSTAGE_STRING_IDENTIFIER__LATE = "LateStage"
const BGM_XSTAGE_STRING_IDENTIFIER__FINALE = "LastRound"


# DONT CHANGE NAMES of ids -- used for finding files by its name
# SIMILARLY, do not change file names
enum AudioIds {
	
	###################
	####### BGM #######
	###################
	
	# special
	BGM_LastRound_AnyFaction_AnyMap_01 = 1000
	BGM_LastRound_AnyFaction_AnyMap_02 = 1001
	BGM_LastRound_AnyFaction_AnyMap_03 = 1002
	
	# early stages
	BGM_EarlyStage_AnyFaction_TechyMaps_01 = 1100
	BGM_EarlyStage_AnyFaction_AnyMap_01 = 1101
	BGM_EarlyStage_AnyFaction_AnyMap_02 = 1102
	
	# mid
	BGM_MiddleStage_AnyFaction_AnyMap_01 = 1200
	BGM_MiddleStage_AnyFaction_AnyMap_02 = 1201
	BGM_MiddleStage_AnyFaction_AnyMap_03 = 1202
	
	
	# mid/late
	
	# late
	BGM_LateStage_AnyFaction_AnyMap_01 = 1400
	BGM_LateStage_AnyFaction_AnyMap_02 = 1401
	BGM_LateStage_AnyFaction_AnyMap_03 = 1402
	
	
	
	####################
	
}

var _audio_id_to_file_path_map := {
	#NOTE: BGMs accounted for
}
var _file_path_to_audio_id_map := {}


# If not defined, then default 0.0 is used.
var _audio_id_to_custom_standard_db_map := {
	
}


#

const BGM_EARLY_STAGES_PLAYLIST_ID = 1
const BGM_MID_STAGES_PLAYLIST_ID = 2
const BGM_LATE_STAGES_PLAYLIST_ID = 3
const BGM_FINALE_STAGES_PLAYLIST_ID = 4

var _all_BGM_x_stages_playlist : Array
var BGM_early_stages_playlist : AudioPlayList
var BGM_mid_stages_playlist : AudioPlayList
var BGM_late_stages_playlist : AudioPlayList
var BGM_finale_stages_playlist : AudioPlayList
var BGM_playlist_catalog : AudioPlayListCatalog

const BGM_early_stages_ids__any_faction_any_map_list = []
const BGM_mid_stages_ids__any_faction_any_map_list = []
const BGM_late_stages_ids__any_faction_any_map_list = []
const BGM_finale_stages_ids__any_faction_any_map_list = []

const BGM_ANY_FACTION_STRING_IDENTIFIER = "AnyFaction"
const BGM_ANY_MAP_STRING_IDENTIFIER = "AnyMap"

#

func _init():
	_add_bgm_file_names_to_file_path_map()
	
	var string_id_to_list_map : Dictionary = {
		BGM_XSTAGE_STRING_IDENTIFIER__EARLY : BGM_early_stages_ids__any_faction_any_map_list,
		BGM_XSTAGE_STRING_IDENTIFIER__MID : BGM_mid_stages_ids__any_faction_any_map_list,
		BGM_XSTAGE_STRING_IDENTIFIER__LATE : BGM_late_stages_ids__any_faction_any_map_list,
		BGM_XSTAGE_STRING_IDENTIFIER__FINALE : BGM_finale_stages_ids__any_faction_any_map_list,
		
	}
	_initialize_bgm_any_faction_any_map_list_with_string_identifier(string_id_to_list_map)
	

func _ready():
	_initialize_bgm_stages_playlist()

func _on_singleton_initialize():
	pass
	


#

func _add_bgm_file_names_to_file_path_map():
	for audio_name in AudioIds.keys():
		if audio_name.begins_with(BGM_AUDIO_NAME_ID_PREFIX):
			var file_name = BGM_AUDIO_FOLDER_PATH + audio_name.trim_prefix(BGM_AUDIO_NAME_ID_PREFIX) + ".mp3"
			
			var audio_id = AudioIds[audio_name]
			_audio_id_to_file_path_map[audio_id] = file_name
			_file_path_to_audio_id_map[file_name] = audio_id

func _initialize_bgm_any_faction_any_map_list_with_string_identifier(arg_string_identifier_to_list_to_add_to_map : Dictionary):
	for audio_name in AudioIds.keys():
		if audio_name.begins_with(BGM_AUDIO_NAME_ID_PREFIX):
			if audio_name.find(BGM_ANY_FACTION_STRING_IDENTIFIER) != -1 and audio_name.find(BGM_ANY_MAP_STRING_IDENTIFIER) != -1:
				for string_id in arg_string_identifier_to_list_to_add_to_map.keys():
					if audio_name.find(string_id) != -1:
						var list_to_add_to = arg_string_identifier_to_list_to_add_to_map[string_id]
						list_to_add_to.append(AudioIds[audio_name])



func reset_bgm_playlists__using_any_faction_any_map_lists():
	BGM_early_stages_playlist.set_audio_ids_of_playlist(BGM_early_stages_ids__any_faction_any_map_list)
	BGM_mid_stages_playlist.set_audio_ids_of_playlist(BGM_mid_stages_ids__any_faction_any_map_list)
	BGM_late_stages_playlist.set_audio_ids_of_playlist(BGM_late_stages_ids__any_faction_any_map_list)
	BGM_finale_stages_playlist.set_audio_ids_of_playlist(BGM_finale_stages_ids__any_faction_any_map_list)
	

#######

func _initialize_bgm_stages_playlist():
	BGM_early_stages_playlist = AudioPlayList.new()
	BGM_mid_stages_playlist = AudioPlayList.new()
	BGM_late_stages_playlist = AudioPlayList.new()
	BGM_finale_stages_playlist = AudioPlayList.new()
	
	BGM_early_stages_playlist.playlist_name = "Early Stages Playlist"
	BGM_mid_stages_playlist.playlist_name = "Middle Stages Playlist"
	BGM_late_stages_playlist.playlist_name = "Late Stages Playlist"
	BGM_finale_stages_playlist.playlist_name = "Finale Playlist"
	
	
	_all_BGM_x_stages_playlist.append(BGM_early_stages_playlist)
	_all_BGM_x_stages_playlist.append(BGM_mid_stages_playlist)
	_all_BGM_x_stages_playlist.append(BGM_late_stages_playlist)
	_all_BGM_x_stages_playlist.append(BGM_finale_stages_playlist)
	
	
	BGM_playlist_catalog = AudioPlayListCatalog.new()
	BGM_playlist_catalog.add_audio_play_list(BGM_EARLY_STAGES_PLAYLIST_ID, BGM_early_stages_playlist)
	BGM_playlist_catalog.add_audio_play_list(BGM_MID_STAGES_PLAYLIST_ID, BGM_mid_stages_playlist)
	BGM_playlist_catalog.add_audio_play_list(BGM_LATE_STAGES_PLAYLIST_ID, BGM_late_stages_playlist)
	BGM_playlist_catalog.add_audio_play_list(BGM_FINALE_STAGES_PLAYLIST_ID, BGM_finale_stages_playlist)
	
	for playlist in _all_BGM_x_stages_playlist:
		playlist.set_autoplay_delay_with_node_to_host_timer(1, self)
		playlist.node_pause_mode = Node.PAUSE_MODE_PROCESS

#######

func get_audio_file_path_of_id(arg_id):
	if _audio_id_to_file_path_map.has(arg_id):
		return _audio_id_to_file_path_map[arg_id]
	else:
		
		print("StoreOfAudio error: audio file path of id not found: %s" % [arg_id])

func get_audio_id_custom_standard_db(arg_id):
	if _audio_id_to_custom_standard_db_map.has(arg_id):
		return _audio_id_to_custom_standard_db_map[arg_id]
	else:
		return AudioManager.DECIBEL_VAL__STANDARD


func get_audio_id_from_file_path(arg_path):
	if _file_path_to_audio_id_map.has(arg_path):
		return _file_path_to_audio_id_map[arg_path]
	else:
		print("StoreOfAudio error: audio id of file path not found: %s" % [arg_path])
	


###############


