extends MarginContainer

const ButtonGroup_Custom = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/ButtonGroup.gd")

#

signal on_tutorial_toggled(arg_descs, arg_mode_id)

onready var tutorial_chapter01_button = $ContentContainer/ScrollContainer/MarginContainer/VBoxContainer/Tutorial_Chapter01
onready var tutorial_chapter02_button = $ContentContainer/ScrollContainer/MarginContainer/VBoxContainer/Tutorial_Chapter02

var tutorial_button_to_tutorial_descriptions_map : Dictionary = {}
var tutorial_button_to_tutorial_game_mode_id : Dictionary = {}
var tutorial_button_group : ButtonGroup_Custom

#

func _ready():
	_initialize_descriptions()
	
	tutorial_button_group = ButtonGroup_Custom.new()
	
	tutorial_chapter01_button.configure_self_with_button_group(tutorial_button_group)
	tutorial_chapter01_button.connect("toggle_mode_changed", self, "_on_tutorial_button_toggle_mode_changed", [tutorial_chapter01_button])
	
	tutorial_chapter02_button.configure_self_with_button_group(tutorial_button_group)
	tutorial_chapter02_button.connect("toggle_mode_changed", self, "_on_tutorial_button_toggle_mode_changed", [tutorial_chapter02_button])
	

func _initialize_descriptions():
	var desc_for_tutorial_chapter_01 = [
		"(Playthrough available for this chapter! Click at the button below.)",
		"",
		"What to expect here: Buying, moving & selling towers, starting rounds & fast forward, viewing tower stats & description, leveling up, and refreshing the shop of towers.",
		"-----------",
		"",
		"Tower cards appear in the shop, displaying the tower's information. Left click the tower card to buy that tower.",
		"Bought towers appear in your bench. Benched towers do not attack. Towers must first be placed in the map for them to do work.",
		"Towers can be moved to tower slots by dragging them to their destination.",
		"Towers in the map can only be moved when the round is not ongoing.",
		"The number of towers you can play is equal to your player level (except for level 10).",
		"",
		"To start a round, press %s, or click the round button (found at the bottom right side)" % InputMap.get_action_list("game_round_toggle")[0].as_text(),
		"Pressing %s or clicking the round button during the round toggles fast forward and normal speed." % InputMap.get_action_list("game_round_toggle")[0].as_text(),
		"",
		"Right clicking a tower displays their stats, among other things.",
		"Clicking the tiny blue info icon displays that towers description.",
		"Right clicking tower cards (in the shop) display the featured tower's stat, description, and among other things.",
		"",
		"Gold is gained every end of the round. You also gain 1 gold for every 10 gold you have, up to 5 gold.",
		"Gold is spent to level up and to refresh (or reroll) the shop.",
		"As stated, leveling up increases the number of towers you can play.",
		"Refreshing the shop restocks the shop with different towers.",
		"",
		"You can sell a tower by pressing %s while hovering on the tower you want to sell. You can also drag the tower to the bottom panel (where the shop is)." % InputMap.get_action_list("game_shop_refresh")[0],
		"",
	]
	var desc_for_tutorial_chapter_02 = [
		"(Playthrough available for this chapter! Click at the button below.)",
		"",
		"What to expect here: Tower tiers, How to activate synergies.",
		"-----------",
		"",
		"There are 6 tower tiers. The higher tiers are in general more powerful than the lower tiers. Higher player levels allow you to get higher tier towers.",
		"",
		"Towers have tower color(s). Towers contribute to their color synergy(ies) if placed in the map. Different synergies have different number requirements. For example, the Orange synergy needs 3 towers to activate. Additionally, more orange towers can allow the orange synergy to be even stronger.",
		"There are two types of synergies: Dominant and Composite/Group. Dominant synergies are composed of one color. Composite synergies are composed of many colors. There can only be one dominant synergy, and only one composite synergy. Attempting to have more than one cancels one or both of them out (depending on the number of towers contributing to the synergy.).",
		"",
	]
	
	tutorial_button_to_tutorial_descriptions_map[tutorial_chapter01_button] = desc_for_tutorial_chapter_01
	tutorial_button_to_tutorial_game_mode_id[tutorial_chapter01_button] = StoreOfGameMode.Mode.TUTORIAL_CHAPTER_01
	
	tutorial_button_to_tutorial_descriptions_map[tutorial_chapter02_button] = desc_for_tutorial_chapter_02
	tutorial_button_to_tutorial_game_mode_id[tutorial_chapter02_button] = StoreOfGameMode.Mode.TUTORIAL_CHAPTER_02
	

#

func _on_tutorial_button_toggle_mode_changed(arg_val, arg_button):
	if arg_val:
		var descs = tutorial_button_to_tutorial_descriptions_map[arg_button]
		var mode_id = -1
		if tutorial_button_to_tutorial_game_mode_id.has(arg_button):
			mode_id = tutorial_button_to_tutorial_game_mode_id[arg_button]
		
		emit_signal("on_tutorial_toggled", descs, mode_id)



