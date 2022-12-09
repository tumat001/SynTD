extends MarginContainer

const RelicStoreBuyHistory = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Classes/RelicStoreBuyHistory.gd")
const RelicHistoryTextureRect_Scene = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Subs/RelicHistoryTextureRect/RelicHistoryTextureRect.tscn")


onready var history_container = $VBoxContainer/MarginContainer/MarginContainer/ScrollContainer/HistoryContainer

func add_buy_history(arg_buy_history : RelicStoreBuyHistory):
	var history_texture_rect = RelicHistoryTextureRect_Scene.instance()
	history_texture_rect.relic_store_buy_history = arg_buy_history
	history_texture_rect.size_flags_horizontal = SIZE_EXPAND | SIZE_SHRINK_CENTER
	
	history_container.add_child(history_texture_rect)


