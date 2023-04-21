extends MarginContainer


var is_available : bool setget set_is_available

onready var image_slot__left = $HBoxContainer/MorphImageSlotPanel_Left
onready var image_slot__right = $HBoxContainer/MorphImageSlotPanel_Right


func set_image_of_left_slot(arg_texture):
	image_slot__left.set_image(arg_texture)

func set_image_of_right_slot(arg_texture):
	image_slot__right.set_image(arg_texture)

###

func set_rect_size_of_slots(arg_size : Vector2):
	image_slot__left.set_slot_size(arg_size)
	image_slot__right.set_slot_size(arg_size)

#

func set_is_available(arg_val : bool):
	is_available = arg_val

###

func get_global_pos_of_left():
	return image_slot__left.rect_global_position

func get_global_pos_of_right():
	return image_slot__right.rect_global_position



