extends "res://MiscRelated/GUI_Category_Related/AdvancedButton/AdvancedButton.gd"

const Tier_1_icon = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/Assets/Tier1_Button.png")
const Tier_2_icon = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/Assets/Tier2_Button.png")
const Tier_3_icon = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/Assets/Tier3_Button.png")
const Tier_4_icon = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/Assets/Tier4_Button.png")
const Tier_5_icon = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/Assets/Tier5_Button.png")
const Tier_6_icon = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/Assets/Tier6_Button.png")

const Frame_Selected_Pic = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/Assets/Tier_Button_SelectedFrame.png")
const Frame_NotSelected_Pic = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationWholeScreenPanel/CombinationTowerTierButton/Assets/Tier_Button_NotSelectedFrame.png")

signal on_clicked()


export(int) var tier : int = -1 setget set_tier
export(bool) var selected : bool = false setget set_selected

onready var tier_icon = $Marginer/TierIcon



func _on_CombinationTowerTierButton_pressed_mouse_event(event : InputEventMouseButton):
	if event.button_index == BUTTON_LEFT:
		emit_signal("on_clicked")

#

func set_tier(arg_tier : int):
	tier = arg_tier
	
	if is_inside_tree():
		if tier == 1:
			tier_icon.texture = Tier_1_icon
		elif tier == 2:
			tier_icon.texture = Tier_2_icon
		elif tier == 3:
			tier_icon.texture = Tier_3_icon
		elif tier == 4:
			tier_icon.texture = Tier_4_icon
		elif tier == 5:
			tier_icon.texture = Tier_5_icon
		elif tier == 6:
			tier_icon.texture = Tier_6_icon


func set_selected(arg_val : bool):
	selected = arg_val
	
	if is_inside_tree():
		if selected:
			texture_normal = Frame_Selected_Pic
		else:
			texture_normal = Frame_NotSelected_Pic




func ready():
	if tier != -1:
		set_tier(tier)
	
	set_selected(selected)
