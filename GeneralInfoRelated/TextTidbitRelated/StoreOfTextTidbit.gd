extends Node

const TextTidbitTypeInfo = preload("res://GeneralInfoRelated/TextTidbitRelated/TextTidbitTypeInfo.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")



enum TidbitId {
	
	ORANGE_12 = 1,
	
}

#

var tidbit_id_to_info_singleton_map : Dictionary

#

#func _init():

func _on_singleton_initialize():
	_initialize_tidbit_map()

func _initialize_tidbit_map():
	# ORANGE 12
	_construct_tidbit__orange_12()
	

func _construct_tidbit__orange_12():
	var tidbit = TextTidbitTypeInfo.new()
	
	var orange_tower_count_for_activation : int = TowerDominantColors.get_synergy_with_id(TowerDominantColors.SynergyID__Orange).number_of_towers_in_tier[0]
	var plain_fragment__max_orange_synergy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COLOR_ORANGE, "%s orange synergy" % orange_tower_count_for_activation)
	
	tidbit.descriptions = [
		"Beyond all limitations.",
		"",
		["Gained from activating |0|.", [plain_fragment__max_orange_synergy]]
	]
	
	tidbit.id = TidbitId.ORANGE_12
	tidbit.name = "%s Orange" % orange_tower_count_for_activation
	tidbit.atlased_image = load("res://GeneralGUIRelated/AlmanacGUI/Assets/TidbitPage_RightSide/Icons/TidbitIcon_Orange12.png")
	tidbit.tidbit_tier = 6
	
	tidbit_id_to_info_singleton_map[tidbit.id] = tidbit

######




