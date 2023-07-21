extends Node

const BaseMode_StageRound = preload("res://GameplayRelated/StagesAndRoundsRelated/BaseMode_StageRounds.gd")

const AudioSettingsPanel = preload("res://AudioRelated/GUIRelated/AudioSettingsPanel/AudioSettingsPanel.gd")
const AudioSettingsPanel_Scene = preload("res://AudioRelated/GUIRelated/AudioSettingsPanel/AudioSettingsPanel.tscn")

const AdvancedQueue = preload("res://MiscRelated/QueueRelated/AdvancedQueue.gd")

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")


#

signal after_bgm_playlists_resetted()

###

var reservation_for_whole_screen_gui
var audio_settings_panel : AudioSettingsPanel

var game_result_manager setget set_game_result_manager
var stage_round_manager setget set_stage_round_manager
var game_elements setget set_game_elements
var round_status_panel setget set_round_status_panel


enum BlockChangeAudioPlaylistClauseIds {
	TUTORIAL = 0,
}
var can_change_audio_playlist_conditional_clauses : ConditionalClauses
var last_calculated_can_change_audio_playlist : bool

######

func _init():
	can_change_audio_playlist_conditional_clauses = ConditionalClauses.new()
	can_change_audio_playlist_conditional_clauses.connect("clause_inserted", self, "_on_can_change_audio_playlist_conditional_clauses_updated", [], CONNECT_PERSIST)
	can_change_audio_playlist_conditional_clauses.connect("clause_removed", self, "_on_can_change_audio_playlist_conditional_clauses_updated", [], CONNECT_PERSIST)
	_update_last_calculated_can_change_audio_playlist()
	

func _on_can_change_audio_playlist_conditional_clauses_updated(arg_clause_id):
	_update_last_calculated_can_change_audio_playlist()

func _update_last_calculated_can_change_audio_playlist():
	last_calculated_can_change_audio_playlist = can_change_audio_playlist_conditional_clauses.is_passed


#

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	stage_round_manager.connect("stageround_state_changed", self, "_on_stageround_state_changed", [], CONNECT_PERSIST)

func set_game_elements(arg_elements):
	game_elements = arg_elements
	
	game_elements.connect("before_game_quit", self, "_on_before_game_quit", [], CONNECT_PERSIST)
	
	_initialize_queue_reservation()
	_initialize_audio_panel()

func set_game_result_manager(arg_manager):
	game_result_manager = arg_manager
	
	game_result_manager.connect("game_result_decided", self, "_on_game_result_decided", [], CONNECT_PERSIST)

func set_round_status_panel(arg_panel):
	round_status_panel = arg_panel
	
	round_status_panel.connect("audio_button_pressed", self, "_on_audio_button_pressed", [], CONNECT_PERSIST)

###

func _initialize_queue_reservation():
	reservation_for_whole_screen_gui = AdvancedQueue.Reservation.new(self)
	reservation_for_whole_screen_gui.on_entertained_method = "_on_queue_reservation_entertained"

func _initialize_audio_panel():
	audio_settings_panel = AudioSettingsPanel_Scene.instance()
	audio_settings_panel.is_shade_background_visible = false
	
	game_elements.whole_screen_gui.add_control_but_dont_show(audio_settings_panel)

#####


func reset_bgm_playlists():
	StoreOfAudio.reset_bgm_playlists__using_any_faction_any_map_lists()
	
	emit_signal("after_bgm_playlists_resetted")

########

func _on_stageround_state_changed(arg_curr_stageround, arg_state):
	if last_calculated_can_change_audio_playlist:
		if arg_state == BaseMode_StageRound.StageRoundState.STARTING or arg_state == BaseMode_StageRound.StageRoundState.EARLY:
			StoreOfAudio.BGM_playlist_catalog.start_play_audio_play_list(StoreOfAudio.BGM_EARLY_STAGES_PLAYLIST_ID)
			
		elif arg_state == BaseMode_StageRound.StageRoundState.MID:
			StoreOfAudio.BGM_playlist_catalog.start_play_audio_play_list(StoreOfAudio.BGM_MID_STAGES_PLAYLIST_ID)
			
		elif arg_state == BaseMode_StageRound.StageRoundState.LATE:
			StoreOfAudio.BGM_playlist_catalog.start_play_audio_play_list(StoreOfAudio.BGM_LATE_STAGES_PLAYLIST_ID)
			
		elif arg_state == BaseMode_StageRound.StageRoundState.FINALE:
			StoreOfAudio.BGM_playlist_catalog.start_play_audio_play_list(StoreOfAudio.BGM_FINALE_STAGES_PLAYLIST_ID)
			
	

func _on_before_game_quit():
	StoreOfAudio.BGM_playlist_catalog.stop_play()
	
	

func _on_game_result_decided():
	if game_result_manager.game_result != game_result_manager.GameResult.VICTORY:
		StoreOfAudio.BGM_playlist_catalog.stop_play()
	



#########

func _on_audio_button_pressed():
	game_elements.whole_screen_gui.queue_control(audio_settings_panel, reservation_for_whole_screen_gui, true, true)
	




