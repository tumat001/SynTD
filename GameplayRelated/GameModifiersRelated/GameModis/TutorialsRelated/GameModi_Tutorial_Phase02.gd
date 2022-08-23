extends "res://GameplayRelated/GameModifiersRelated/GameModis/TutorialsRelated/BaseGameModi_Tutorial.gd"

# NOTE TO DEV: Start at level 4.
# Towers in shop:
# Shop 1: Simplex*, ember*, entropy*, striker*
# Shop 2: Spike, sprinkler, simplex, coal launcher
# Shop 3: Flameburst*, spike, rebound, mini tesla
# Shop 4: pinecone, time machine, scatter*, transmutator
# Shop 5: vacuum, cannon, railgun*, sprinkler
var transcript_to_progress_mode : Dictionary = {
	
	"Welcome to the chapter 2 of the tutorial. Click anywhere or press Enter to continue." : ProgressMode.CONTINUE,
	
	"First, buy all the towers in the shop." : ProgressMode.ACTION_FROM_PLAYER,
	"Right now, you have tier 1 towers, which is the weakest tier." : ProgressMode.CONTINUE,
	"Leveling up allows you to gain higher tier towers." : ProgressMode.CONTINUE,
	"Level up by clicking this button." : ProgressMode.ACTION_FROM_PLAYER,
	
	"Now that you've leveled up, there is a higher chance to find better towers." : ProgressMode.CONTINUE,
	"As indicated by this panel, you now have a %s%% chance of finding a tier 3 tower, and a %s%% for a tier 2 tower." : ProgressMode.CONTINUE,
	"Let's refresh the shop to get a tier 3 or 2 tower. (Press %s or click this button.)" % InputMap.get_action_list("game_shop_refresh")[0] : ProgressMode.ACTION_FROM_PLAYER,
	"Tough luck! We didn't get what we want. Refresh the shop again." : ProgressMode.ACTION_FROM_PLAYER,
	"Nice! Buy that tier 3 tower." : ProgressMode.ACTION_FROM_PLAYER,
	"In general, higher tier towers are much stronger than lower tier ones." : ProgressMode.CONTINUE,
	"Let's place all those towers in the map, and start the round." : ProgressMode.ACTION_FROM_PLAYER,
	
	
	"Now we proceed to synergies. Take your time understanding the next passages." : ProgressMode.CONTINUE,
	"Each tower has their own tower color. Towers contribute to building a synergy if placed in the map." : ProgressMode.CONTINUE,
	"Right now, we have 2 orange towers. To activate the orange synergy, we need 3." : ProgressMode.CONTINUE,
	"You can read the orange synergy's description by hovering this." : ProgressMode.CONTINUE,
	"Refresh the shop to hopefully find an orange tower." : ProgressMode.ACTION_FROM_PLAYER,
	"There's an orange tower! Buy it and place it in the map." : ProgressMode.ACTION_FROM_PLAYER,
	"The orange synergy is now activated since you have 3 orange towers." : ProgressMode.CONTINUE,
	"A single colored synergy is called a \"Dominant Synergy\".\nYou can only have one active at a time." : ProgressMode.CONTINUE,
	"Attempting to play two dominant synergies kills you instantly!" : ProgressMode.CONTINUE,
	"Just kidding. Attempting to play two dominant synergies cancels out the weaker synergy,\nor both of them if they are equal in number." : ProgressMode.CONTINUE,
	"For example, having 3 orange towers and 3 yellow towers diables both synergies.\nbut having 4 orange instead of 3 allows orange to be active despite the 3 yellows." : ProgressMode.CONTINUE,
	"Likewise, having 4 yellows against 3 oranges makes the yellow synergy to be active." : ProgressMode.CONTINUE,
	
	# do composite syns next.
	"Recall that a single colored synergy is called a \"Dominant Synergy\"\n consisting of a singluar color.": ProgressMode.CONTINUE,
	"Now, there is another type of synergy called a \"Composite Synergy\", or \"Group Synergy\".": ProgressMode.CONTINUE,
	"\"Composite Synergies\" involve multiple colors.": ProgressMode.CONTINUE,
	"Just like \"Dominant Synergies\", you can only have one of it at a time,\nand will deactivate other weaker \"Composite Synergies\"." : ProgressMode.CONTINUE,
	"The catch is, \"Composite Synergies\" can work with \"Dominant Synergies\".\nThey do not cancel each other out.": ProgressMode.CONTINUE,
	"If we look here, we can see that we are 1 yellow tower off of activating OrangeYR synergy.": ProgressMode.CONTINUE,
	"Refresh the shop to see if we get a yellow tower." : ProgressMode.ACTION_FROM_PLAYER,
	"We got a yellow tower! Buy it!" : ProgressMode.ACTION_FROM_PLAYER,
	"Now activate the OrangeYR (Orange Yellow Red) synergy\nby placing Railgun in the map." : ProgressMode.ACTION_FROM_PLAYER,
	"With this setup, we have both Orange synergy activated,\nand OrangeYR synergy activated." : ProgressMode.CONTINUE,
	
	"There are more synergies out there waiting to be played." : ProgressMode.CONTINUE,
	"That concludes this chapter of the tutorial." : ProgressMode.CONTINUE,
	"(If you are new to the game, proceed to chapter 3.)" : ProgressMode.CONTINUE,
}

#
func _init().(StoreOfGameModifiers.GameModiIds.MODI_TUTORIAL_PHASE_02, 
		BreakpointActivation.BEFORE_MAIN_INIT, "Chapter 2: Tower Tiers and Synergies"):
	
	pass

func _get_transcript():
	return transcript_to_progress_mode


#

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	

func _unapply_game_modifier_from_elements(arg_elements : GameElements):
	._unapply_game_modifier_from_elements(arg_elements)
	

#


