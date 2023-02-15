extends "res://PreGameRelated/PreGameModifiers/BasePreGameModifier.gd"

#const Cyde_CommonModifiers = preload("res://CYDE_SPECIFIC_ONLY/DialogRelated/GameModifiers/CommonModifiers/Cyde_CommonModifiers.gd")


func _init().(BreakpointActivation.BEFORE_SINGLETONS_INITIALIZE):
	
	pass


func _apply_pre_game_modifier():
	pass
	#CommsForBetweenScenes.connect("game_elements_created", self, "_on_game_elements_created")
	
	#StoreOfGameModifiers.add_game_modifier(Cyde_CommonModifiers.id_name, "res://CYDE_SPECIFIC_ONLY/DialogRelated/GameModifiers/CommonModifiers/Cyde_CommonModifiers.gd")
	
	#StoreOfMaps.set_map_is_available_from_menu(StoreOfMaps.MapsId_Enchant, false)


#func _on_game_elements_created(arg_game_elements):
#	arg_game_elements.game_modi_ids.append(Cyde_CommonModifiers.id_name)
#
