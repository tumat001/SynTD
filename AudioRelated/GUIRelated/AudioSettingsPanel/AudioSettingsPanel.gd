extends MarginContainer

const AudioBusVolumePanel = preload("res://AudioRelated/GUIRelated/AudioSettingsPanel/Subs/AudioBusVolumePanel/AudioBusVolumePanel.gd")



var is_shade_background_visible : bool = true setget set_shade_background_visible

onready var audio_bus_volume_panel__background = $MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/AudioBusVolumePanel_Background
onready var audio_bus_volume_panel__sound_fx = $MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/AudioBusVolumePanel_SoundFX

onready var shade_background = $ShadeBackground


func _ready():
	var audio_properties__sound_fx = AudioBusVolumePanel.AudioProperties.new()
	audio_properties__sound_fx.audio_bus_display_name = "Sound Effects"
	audio_properties__sound_fx.bus_player_type_volume__variable_name = "bus__sound_fx_volume"
	audio_properties__sound_fx.bus_player_type_volume_changed__signal = "bus__sound_fx_volume_changed"
	audio_properties__sound_fx.bus_player_type_mute__variable_name = "bus__sound_fx_bus_mute"
	audio_properties__sound_fx.bus_player_type_mute_changed__signal = "bus__sound_fx_mute_changed"
	
	var audio_properties__background = AudioBusVolumePanel.AudioProperties.new()
	audio_properties__background.audio_bus_display_name = "Background Music"
	audio_properties__background.bus_player_type_volume__variable_name = "bus__background_music_volume"
	audio_properties__background.bus_player_type_volume_changed__signal = "bus__background_music_volume_changed"
	audio_properties__background.bus_player_type_mute__variable_name = "bus__background_music_bus_mute"
	audio_properties__background.bus_player_type_mute_changed__signal = "bus__background_music_mute_changed"
	
	###
	
	audio_bus_volume_panel__sound_fx.set_audio_properties(audio_properties__sound_fx)
	audio_bus_volume_panel__background.set_audio_properties(audio_properties__background)
	
	#
	
	set_shade_background_visible(is_shade_background_visible)

func set_shade_background_visible(arg_val):
	is_shade_background_visible = arg_val

	if is_inside_tree():
		shade_background.visible = arg_val


