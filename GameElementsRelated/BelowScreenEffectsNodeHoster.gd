extends Node


func _enter_tree():
	CommsForBetweenScenes.current_game_elements__node_hoster_below_screen_effects_mngr = self
	
