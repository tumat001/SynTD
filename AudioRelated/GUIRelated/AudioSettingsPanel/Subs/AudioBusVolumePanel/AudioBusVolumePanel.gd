extends MarginContainer



class AudioProperties:
	
	var audio_bus_display_name
	
	# from audio manager
	var bus_player_type_volume__variable_name
	var bus_player_type_volume_changed__signal
	
	var bus_player_type_mute__variable_name
	var bus_player_type_mute_changed__signal
	

var _audio_properties : AudioProperties


onready var slider_standard = $SliderStandard

##

func set_audio_properties(arg_properties : AudioProperties):
	_audio_properties = arg_properties
	
	if is_inside_tree():
		_update_display_based_on_properties()

func _ready():
	if _audio_properties != null:
		_update_display_based_on_properties()
	
	slider_standard.connect("value_changed", self, "_on_slider_value_changed", [], CONNECT_PERSIST)


func _update_display_based_on_properties():
	slider_standard.set_label_text(_audio_properties.audio_bus_display_name)
	
	AudioManager.connect(_audio_properties.bus_player_type_volume_changed__signal, self, "_on_bus_player_type_volume_changed")
	AudioManager.connect(_audio_properties.bus_player_type_mute_changed__signal, self, "_on_bus_player_type_mute_changed")
	_update_slider_based_on_volume()
	


func _on_bus_player_type_volume_changed(arg_val):
	_update_slider_based_on_volume()

func _on_bus_player_type_mute_changed(arg_val):
	_update_slider_based_on_volume()

func _update_slider_based_on_volume():
	var volume_db = AudioManager.get(_audio_properties.bus_player_type_volume__variable_name)
	var amount = _convert_volume_db_into_100_to_0_range(volume_db)
	
	if AudioManager.get(_audio_properties.bus_player_type_mute__variable_name):
		amount = 0
	
	slider_standard.set_value(amount)


func _convert_volume_db_into_100_to_0_range(arg_db):
	return db2linear(arg_db) * 100
	



#

func _on_slider_value_changed(arg_val):
	var db = linear2db(arg_val / 100)
	if arg_val == 0:
		db = -80
	
	AudioManager.set(_audio_properties.bus_player_type_volume__variable_name, db)
	
	if arg_val == 0:
		AudioManager.set(_audio_properties.bus_player_type_mute__variable_name, true)
	else:
		AudioManager.set(_audio_properties.bus_player_type_mute__variable_name, false)

