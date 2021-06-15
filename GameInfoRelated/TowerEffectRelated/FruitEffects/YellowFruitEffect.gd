extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


func _init().(StoreOfTowerEffectsUUID.ING_YELLOW_FRUIT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_YellowFruit.png")
	description = "The tower is worth 1 more gold per round when active in the map."



func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_round_end", self, "_attempt_increase_base_gold_cost"):
		tower.connect("on_round_end", self, "_attempt_increase_base_gold_cost", [tower], CONNECT_PERSIST)


# increase gold value
func _attempt_increase_base_gold_cost(tower):
	if tower.is_current_placable_in_map():
		tower._base_gold_cost += 1


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_round_end", self, "_attempt_increase_base_gold_cost"):
		tower.disconnect("on_round_end", self, "_attempt_increase_base_gold_cost")


