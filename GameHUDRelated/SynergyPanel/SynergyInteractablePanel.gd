extends MarginContainer

onready var content_panel = $VBoxContainer/MainContainer/ContentPanel
onready var left_button = $VBoxContainer/ButtonContainer/Marginer2/LeftButton
onready var right_button = $VBoxContainer/ButtonContainer/Marginer/RightButton

# 0 based index
var current_page : int = -1 setget set_current_page


func _ready():
	visible = false

func add_synergy_interactable(control : Control):
	content_panel.add_child(control)
	
	update_display()
	set_current_page(content_panel.get_children().size() - 1)

func has_synergy_interactable(control : Control) -> bool:
	return content_panel.get_children().has(control)


func update_display():
	var content_panel_size = content_panel.get_children().size()
	
	var more_than_two = content_panel_size >= 2
	left_button.visible = more_than_two
	right_button.visible = more_than_two
	
	visible = content_panel_size >= 1


func set_current_page(page : int):
	var total_pages = content_panel.get_children().size()
	
	if page < 0:
		page = total_pages - 1
	elif page >= total_pages:
		page = 0
	
	for i in total_pages:
		content_panel.get_child(i).visible = (page == i)
	
	current_page = page

#

func _on_LeftButton_pressed():
	set_current_page(current_page - 1)


func _on_RightButton_pressed():
	set_current_page(current_page + 1)


