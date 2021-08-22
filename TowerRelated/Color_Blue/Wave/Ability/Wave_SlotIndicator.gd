extends MarginContainer

const Wave_ActiveSlot_Pic = preload("res://TowerRelated/Color_Blue/Wave/Ability/Wave_ActiveSlot.png")
const Wave_EmptySlot_Pic = preload("res://TowerRelated/Color_Blue/Wave/Ability/Wave_EmptySlot.png")

onready var slot_trect = $SlotPic

#

func set_slot_active():
	slot_trect.texture = Wave_ActiveSlot_Pic

func set_slot_empty():
	slot_trect.texture = Wave_EmptySlot_Pic
