extends MarginContainer


onready var tooltip_body = $MarginContainer/VBoxContainer/ScrollContainer/TooltipBody
onready var play_button = $MarginContainer/VBoxContainer/PlayButton


var pre_game_screen
var mode_id : int


func set_descriptions(arg_descriptions : Array):
	tooltip_body.descriptions = arg_descriptions
	tooltip_body.update_display()

func set_game_mode_id_of_play_button(arg_mode_id : int):
	mode_id = arg_mode_id
	
	if arg_mode_id == -1:
		play_button.visible = false
	else:
		play_button.visible = true
		


func _on_PlayButton_on_button_released_with_button_left():
	if mode_id != -1:
		CommsForBetweenScenes.map_id = StoreOfMaps.MapsIds.RIVERSIDE
		CommsForBetweenScenes.game_mode_id = mode_id
		
		CommsForBetweenScenes.goto_game_elements(pre_game_screen)

