extends Node


enum GameModiIds {
	
	MODI_TUTORIAL_PHASE_01 = -10
}


static func get_game_modifier_from_id(arg_id):
	
	if arg_id == GameModiIds.MODI_TUTORIAL_PHASE_01:
		var script = load("res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/GameModi_Tutorial_Phase01.gd")
		return script.new()
	
	return null

