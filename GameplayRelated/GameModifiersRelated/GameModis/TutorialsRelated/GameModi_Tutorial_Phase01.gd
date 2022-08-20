extends "res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd"


enum ProgressMode {
	CONTINUE = 0,
	ACTION_FROM_PLAYER = 1,
}

var transcript_to_progress_mode : Dictionary = {
	"Welcome to Random Tower Defense! Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
	"In a tower defense game, you place towers to defeat the enemies." : ProgressMode.CONTINUE,
	"Click this \"tower card\" to buy the displayed tower." : ProgressMode.ACTION_FROM_PLAYER,
	"When you buy towers, they appear in your bench. Towers in your bench do not attack. You need to place them in the map." : ProgressMode.CONTINUE,
	"Drag the tower to this tower slot to activate them, allowing them to attack enemies!" : ProgressMode.ACTION_FROM_PLAYER,
	"Good job! Now this tower is ready to defend." : ProgressMode.CONTINUE,
	"Press %s to start the round." % InputMap.get_action_list("game_round_toggle")[0] : ProgressMode.CONTINUE,
	
}

#
func _init().(StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_01, 
		BreakpointActivation.BEFORE_GAME_START, "TutorialPhase01"):
	
	pass

#

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	pass

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	pass

#

func _show_transcript_msg_at_index(arg_index):
	pass
	

