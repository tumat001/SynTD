extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


func _init().(StoreOfTowerEffectsUUID.ING_YELLOW_FRUIT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_YellowFruit.png")
	
	var plain_fragment__on_round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
	var plain_fragment__sell_value = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "3 more gold")
	
	description = ["|0|: The tower is worth |1| (when active in the map).", [plain_fragment__on_round_end, plain_fragment__sell_value]]



func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_round_end", self, "_attempt_increase_base_gold_cost"):
		tower.connect("on_round_end", self, "_attempt_increase_base_gold_cost", [tower], CONNECT_PERSIST)


# increase gold value
func _attempt_increase_base_gold_cost(tower):
	if tower.is_current_placable_in_map():
		tower._base_gold_cost += 3


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_round_end", self, "_attempt_increase_base_gold_cost"):
		tower.disconnect("on_round_end", self, "_attempt_increase_base_gold_cost")


