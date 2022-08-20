extends MarginContainer


onready var title_label = $VBoxContainer/TitleLabel
onready var progress_bar = $VBoxContainer/ProgressBar


func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")
	visible = false

func _on_visibility_changed():
	set_process_input(visible)


#

func show_loading_screen():
	visible = true
	set_progress_ratio(0)


func set_progress_ratio(arg_ratio : float):
	progress_bar.set_progress_ratio(arg_ratio)


func hide_loading_screen():
	set_progress_ratio(0)
	visible = false


