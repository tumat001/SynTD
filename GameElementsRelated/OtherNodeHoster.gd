extends Node


func _enter_tree():
	CommsForBetweenScenes.current_game_elements__other_node_hoster = self

