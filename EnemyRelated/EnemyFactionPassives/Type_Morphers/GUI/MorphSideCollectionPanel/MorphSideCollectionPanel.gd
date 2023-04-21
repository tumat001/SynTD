extends MarginContainer

const MorphDuoImageSlotPanel = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/GUI/MorphSideCollectionPanel/Subs/MorphDuoImageSlotPanel.gd")
const MorphDuoImageSlotPanel_Scene = preload("res://EnemyRelated/EnemyFactionPassives/Type_Morphers/GUI/MorphSideCollectionPanel/Subs/MorphDuoImageSlotPanel.tscn")


#

onready var vbox_for_duo_img_panel = $MarginContainer/VBoxContainer

#

func set_duo_image_slot_count_and_size(arg_count : int, arg_img_slot_size : Vector2):
	for i in arg_count:
		var panel = MorphDuoImageSlotPanel_Scene.instance()
		
		vbox_for_duo_img_panel.add_child(panel)
		
		panel.set_rect_size_of_slots(arg_img_slot_size)
		panel.is_available = true


func _get_available_duo_image_slot() -> MorphDuoImageSlotPanel:
	for panel in vbox_for_duo_img_panel.get_children():
		if panel.is_available:
			return panel
	
	return null


#

func set_available_duo_image_slot_images(arg_left_image, arg_right_image):
	var duo_slot : MorphDuoImageSlotPanel = _get_available_duo_image_slot()
	
	duo_slot.set_image_of_left_slot(arg_left_image)
	duo_slot.set_image_of_right_slot(arg_right_image)
	duo_slot.is_available = false

func get_global_poses_of_duo_image_slot_images() -> Array:
	var duo_slot = _get_available_duo_image_slot()
	
	return [duo_slot.get_global_pos_of_left(), duo_slot.get_global_pos_of_right()]



