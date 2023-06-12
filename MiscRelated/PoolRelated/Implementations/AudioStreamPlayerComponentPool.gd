extends "res://MiscRelated/PoolRelated/GenericPool.gd"


func _init():
	connect("resource_created", self, "_on_audio_stream_player_created", [], CONNECT_PERSIST)

func _on_audio_stream_player_created(arg_stream : AudioStreamPlayer):
	arg_stream.connect("finished", self, "_on_stream_player_finished", [arg_stream])
	

func _on_stream_player_finished(arg_stream):
	declare_resource_as_available(arg_stream)
	


