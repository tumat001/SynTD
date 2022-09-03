extends MarginContainer


onready var godot_license_link_button = $MarginContainer/ContentContainer/VBoxContainer/LinkButton

func _ready():
	visible = false



#

func show_panel():
	visible = true

func _unhandled_input(event):
	if event is InputEventKey:
		if !event.echo and event.pressed:
			if event.is_action("ui_cancel"):
				hide_panel()
		
		accept_event()
		
	elif event is InputEventMouseButton:
		hide_panel()


func hide_panel():
	visible = false

##

func _on_LinkButton_pressed():
	OS.shell_open(godot_license_link_button.text)



