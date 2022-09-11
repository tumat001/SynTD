extends MarginContainer

const ButtonGroup_Custom = preload("res://MiscRelated/PlayerGUI_Category_Related/ButtonToggleStandard/ButtonGroup.gd")
const CombinationManager = preload("res://GameElementsRelated/CombinationManager.gd")

#

signal on_tutorial_toggled(arg_descs, arg_mode_id)

onready var tutorial_chapter01_button = $ContentContainer/ScrollContainer/MarginContainer/VBoxContainer/Tutorial_Chapter01
onready var tutorial_chapter01_01_button = $ContentContainer/ScrollContainer/MarginContainer/VBoxContainer/Tutorial_Chapter01_01
onready var tutorial_chapter02_button = $ContentContainer/ScrollContainer/MarginContainer/VBoxContainer/Tutorial_Chapter02
onready var tutorial_chapter03_button = $ContentContainer/ScrollContainer/MarginContainer/VBoxContainer/Tutorial_Chapter03
onready var tutorial_chapter04_button = $ContentContainer/ScrollContainer/MarginContainer/VBoxContainer/Tutorial_Chapter04

var tutorial_button_to_tutorial_descriptions_map : Dictionary = {}
var tutorial_button_to_tutorial_game_mode_id : Dictionary = {}
var tutorial_button_group : ButtonGroup_Custom

#

func _ready():
	_initialize_descriptions()
	
	tutorial_button_group = ButtonGroup_Custom.new()
	
	tutorial_chapter01_button.configure_self_with_button_group(tutorial_button_group)
	tutorial_chapter01_button.connect("toggle_mode_changed", self, "_on_tutorial_button_toggle_mode_changed", [tutorial_chapter01_button])
	
	tutorial_chapter01_01_button.configure_self_with_button_group(tutorial_button_group)
	tutorial_chapter01_01_button.connect("toggle_mode_changed", self, "_on_tutorial_button_toggle_mode_changed", [tutorial_chapter01_01_button])
	
	tutorial_chapter02_button.configure_self_with_button_group(tutorial_button_group)
	tutorial_chapter02_button.connect("toggle_mode_changed", self, "_on_tutorial_button_toggle_mode_changed", [tutorial_chapter02_button])
	
	tutorial_chapter03_button.configure_self_with_button_group(tutorial_button_group)
	tutorial_chapter03_button.connect("toggle_mode_changed", self, "_on_tutorial_button_toggle_mode_changed", [tutorial_chapter03_button])
	
	tutorial_chapter04_button.configure_self_with_button_group(tutorial_button_group)
	tutorial_chapter04_button.connect("toggle_mode_changed", self, "_on_tutorial_button_toggle_mode_changed", [tutorial_chapter04_button])
	
	


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
	var desc_for_tutorial_chapter_01_01 = [
		"(Playthrough available for this chapter! Click at the button below.)",
		"",
		"What to expect here: Tower tiers, Gold mechanics, Rounds, Player health.",
		"-----------",
		"",
		"There are 6 tower tiers. The higher tiers are in general more powerful than the lower tiers. Higher player levels allow you to get higher tier towers.",
		"",
		"Gold is gained at the end of round. The baseline amount of gold increases as the rounds progress. You also gain 1 gold every 10 gold that you have, up to 5 bonus gold.",
		"You additionally gain bonus gold based on your win or lose streak, so if you find yourself winning, then winning more allows you to gain more gold (and same for losing).",
		"",
		"The game ends at round 9-4. If you survive after that round, you win the game.",
		"",
		"You start with 150 health. Once it reaches 0, you lose.",
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
	var desc_for_tutorial_chapter_03 = [
		"(Playthrough available for this chapter! Click at the button below.)",
		"",
		"What to expect here: Absorbtion, and Ingredient Effects.",
		"-----------",
		"",
		"Most towers have an ingredient effect, which is an effect that gives bonus stats and special buffs/modifiers. Towers do not give themselves the effect of their ingredient effect.",
		"Towers can make use of other tower's ingredient effect by absorbing them, gaining its effects.",
		"Pressing %s toggles ingredient mode, which is a mode where dragging a tower to another tower (the recepient) gives the dragged tower's ingredient effect to its recepient." % InputMap.get_action_list("game_ingredient_toggle")[0].as_text(),
		"",
		"There are limitations however. Receiving towers can only absorb other towers who share tower colors, or if the dragged tower's colors is one of the receiving tower's neighbor colors. As an example, Red's neighbor colors are Orange and Violet. Yellow's neighbor colors are Orange and Green.",
		"An example: Striker (a red tower) cannot absorb Sprinkler (a blue tower). Striker (a red tower) can absorb Ember (an orange tower).",
		"",
		"In a normal game, towers can only absorb one (1) ingredient, so spend that limit wisely. There are ways to change that however.",
		""
	]
	
	var same_towers_needed_for_combi : int = CombinationManager.base_combination_amount
	var desc_for_tutorial_chapter_04 = [
		"(Playthrough available for this chapter! Click at the button below.)",
		"",
		"What to expect here: Combination.",
		"-----------",
		"",
		"Get %s of the same tower to combine them, sacrificing them to apply their ingredient effect to towers. Affects existing and future towers bought." % str(same_towers_needed_for_combi),
		"Press %s to combine towers." % InputMap.get_action_list("game_combine_combinables")[0].as_text(),
		"Combination applies the combined tower's ingredient effect to towers with tiers who are below, equal, and 1 tier above the combined tower. For example, combining a tier 3 tower gives its ingredient effect tiers 1, 2, 3, and 4 only.",
		"",
	]
	
	
	tutorial_button_to_tutorial_descriptions_map[tutorial_chapter01_button] = desc_for_tutorial_chapter_01
	tutorial_button_to_tutorial_game_mode_id[tutorial_chapter01_button] = StoreOfGameMode.Mode.TUTORIAL_CHAPTER_01
	
	tutorial_button_to_tutorial_descriptions_map[tutorial_chapter01_01_button] = desc_for_tutorial_chapter_01_01
	tutorial_button_to_tutorial_game_mode_id[tutorial_chapter01_01_button] = StoreOfGameMode.Mode.TUTORIAL_CHAPTER_01_01
	
	
	tutorial_button_to_tutorial_descriptions_map[tutorial_chapter02_button] = desc_for_tutorial_chapter_02
	tutorial_button_to_tutorial_game_mode_id[tutorial_chapter02_button] = StoreOfGameMode.Mode.TUTORIAL_CHAPTER_02
	
	tutorial_button_to_tutorial_descriptions_map[tutorial_chapter03_button] = desc_for_tutorial_chapter_03
	tutorial_button_to_tutorial_game_mode_id[tutorial_chapter03_button] = StoreOfGameMode.Mode.TUTORIAL_CHAPTER_03
	
	tutorial_button_to_tutorial_descriptions_map[tutorial_chapter04_button] = desc_for_tutorial_chapter_04
	tutorial_button_to_tutorial_game_mode_id[tutorial_chapter04_button] = StoreOfGameMode.Mode.TUTORIAL_CHAPTER_04
	

#

func _on_tutorial_button_toggle_mode_changed(arg_val, arg_button):
	if arg_val:
		var descs = tutorial_button_to_tutorial_descriptions_map[arg_button]
		var mode_id = -1
		if tutorial_button_to_tutorial_game_mode_id.has(arg_button):
			mode_id = tutorial_button_to_tutorial_game_mode_id[arg_button]
		
		emit_signal("on_tutorial_toggled", descs, mode_id)



