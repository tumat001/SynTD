tool

extends MarginContainer


export(Texture) var image : Texture setget set_image
export(String) var text : String setget set_text
export(String) var title : String setget set_title

onready var image_texture_rect = $MarginContainer/HBoxContainer/Image
onready var label = $MarginContainer/HBoxContainer/LabelMarginer/Label
onready var title_label = $MarginContainer/HBoxContainer/TitleMarginer/Title
onready var title_marginer = $MarginContainer/HBoxContainer/TitleMarginer

#

func _ready():
	set_image(image)
	set_text(text)
	set_title(title)

#

func set_image(arg_image):
	image = arg_image
	
	if is_inside_tree():
		image_texture_rect.texture = image

func set_text(arg_text):
	text = arg_text
	
	if is_inside_tree():
		label.text = text

func set_title(arg_text):
	title = arg_text
	
	if is_inside_tree():
		title_label.text = title
		
		title_marginer.visible = title.length() > 0


#




