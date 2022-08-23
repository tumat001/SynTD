extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"

# MODI
# Towers can absorb 1 additional ingredient (2 total)
#
# MAP
# Already has (Striker) in the map.
#
# SHOPS
# 1) Rebound*, Mini Tesla*, Ember*, Time Machine*, Shackled*

var transcript_to_progress_mode : Dictionary = {
	"Welcome to the chapter 3 of the tutorial. Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
	
	"Right click this tower card to view its descriptions and stats." : ProgressMode.CONTINUE,
	"Over here, you can see that tower's Ingredient Effect." : ProgressMode.CONTINUE,
	"Ingredient Effects are bonus stats and special effects that a tower gives\nto its recepient when absorbed." : ProgressMode.CONTINUE,
	"Let's demonstrate that. Buy this tower." : ProgressMode.CONTINUE,
	"Now, press %s or click this color wheel to toggle to Ingredient Mode." % InputMap.get_action_list("game_ingredient_toggle")[0] : ProgressMode.CONTINUE,
	"You are now in the Ingredient Mode." : ProgressMode.CONTINUE,
	"Normally, dragging a tower to another tower just switches their position." : ProgressMode.CONTINUE,
	"But in the Ingredient Mode, the dragged tower gives its Ingredient Effect\nto the tower where it is dropped." : ProgressMode.CONTINUE,
	"Let's try that. Drag Rebound and drop it to Striker." : ProgressMode.ACTION_FROM_PLAYER,
	"Great! Striker absorbed Rebound's Ingredient Effect.\n(You can check this by right clicking Striker and looking at the right side panel.)" : ProgressMode.CONTINUE,
	"Normally, towers can absorb only 1 ingredient. But this can be increased by other means." : ProgressMode.CONTINUE,
	
	"Buy Mini Tesla from the shop." : ProgressMode.ACTION_FROM_PLAYER,
	"Notice that you can't offer Mini Tesla as an ingredient for Striker;\nStriker cannot absorb Mini Tesla." : ProgressMode.CONTINUE,
	"That's because a tower only absorb towers of the same color, and its 'neighbor' colors.\nRed's neighbor colors include Orange and Violet." : ProgressMode.CONTINUE,
	"You can look at the color wheel to quickly see a tower's neighbor colors.\nRed has Orange and Violet beside it." : ProgressMode.CONTINUE,
	"Buy Ember from the shop." : ProgressMode.CONTINUE,
	"Since Ember is an orange tower, Striker can absorb Ember.\nThe reverse is also true." : ProgressMode.CONTINUE,
	
	"Buy Time Machine from the shop." : ProgressMode.ACTION_FROM_PLAYER,
	"Also, buy Shackled from the shop" : ProgressMode.ACTION_FROM_PLAYER,
	"Towers with two colors work exactly the same way." : ProgressMode.CONTINUE,
	"Time machine can absorb yellow and blue towers since those are its colors,\nand can absorb green, orange and violet towers since those are its neighbors." : ProgressMode.CONTINUE,
	"With that said, Time Machine can absorb Mini Tesla, and Shackled." : ProgressMode.CONTINUE,
	
	"That concludes this chapter of the tutorial." : ProgressMode.CONTINUE,
	"(If you are new to the game, and have played chapters 1 and 2,\nyou can now play the game. You now know the game's basics.)" : ProgressMode.CONTINUE,
	"(You can proceed to chapter 4 once you have a bit of a feel for the game,\nor if you just want to.)" : ProgressMode.CONTINUE,
	
}

#
func _init().(StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_03, 
		BreakpointActivation.BEFORE_MAIN_INIT, "Chapter 3: Ingredient Effects"):
	
	pass

func _get_transcript():
	return transcript_to_progress_mode


#

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	

#


