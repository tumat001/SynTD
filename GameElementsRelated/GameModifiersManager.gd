extends Node

const BaseGameModifier = preload("res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd")
const GameModeTypeInformation = preload("res://GameplayRelated/GameModeRelated/GameModeTypeInformation.gd")

var game_elements setget set_game_manager

var _game_modi_ids_at_before_main_init__to_modi_map := {}
var _game_modi_ids_at_before_game_start__to_modi_map := {}

#

func set_game_manager(arg_manager):
	game_elements = arg_manager
	game_elements.connect("before_main_init", self, "_apply_game_modifiers__before_main_init", [], CONNECT_ONESHOT)
	game_elements.connect("before_game_start", self, "_apply_game_modifiers__before_game_start", [], CONNECT_ONESHOT)


func add_game_modi_ids(arg_ids : Array):
	for id in arg_ids:
		var modi = StoreOfGameModifiers.get_game_modifier_from_id(id)
		if modi.breakpoint_activation == BaseGameModifier.BreakpointActivation.BEFORE_MAIN_INIT:
			_game_modi_ids_at_before_main_init__to_modi_map[id] = modi
		elif modi.breakpoint_activation == BaseGameModifier.BreakpointActivation.BEFORE_GAME_START:
			_game_modi_ids_at_before_game_start__to_modi_map[id] = modi

func add_game_modi_ids__from_game_mode_id(arg_game_mode_id : int):
	var game_mode_type_info : GameModeTypeInformation = StoreOfGameMode.get_mode_type_info_from_id(arg_game_mode_id)
	add_game_modi_ids(game_mode_type_info.game_modi_ids)

#


func _apply_game_modifiers__before_main_init():
	_apply_game_modifiers_to_game_elements(_game_modi_ids_at_before_main_init__to_modi_map.values())

func _apply_game_modifiers__before_game_start():
	_apply_game_modifiers_to_game_elements(_game_modi_ids_at_before_game_start__to_modi_map.values())

#

func _apply_game_modifiers_to_game_elements(arg_game_modis : Array):
	for modi in arg_game_modis:
		_apply_game_modifier_to_game_elements(modi)


func _apply_game_modifier_to_game_elements(arg_game_modifier):
	if arg_game_modifier != null:
		arg_game_modifier._apply_game_modifier_to_elements(game_elements)

