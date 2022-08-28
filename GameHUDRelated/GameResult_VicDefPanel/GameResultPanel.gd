extends MarginContainer

signal option_view_battlefield_selected()
signal option_main_menu_selected()



onready var vic_left_border_panel = $HBoxContainer/MarginContainer/LeftBorder/VicLeftBorder
onready var vic_right_border_panel = $HBoxContainer/MarginContainer2/RightBorder/VicRightBorder
onready var def_left_border_panel = $HBoxContainer/MarginContainer/LeftBorder/DefLeftBorder
onready var def_right_border_panel = $HBoxContainer/MarginContainer2/RightBorder/DefRightBorder

onready var game_result_label = $HBoxContainer/MiddleContainer/ContentContainer/VBoxContainer/GameResultLabel

onready var view_battlefield_button = $HBoxContainer/MiddleContainer/ContentContainer/VBoxContainer/ButtonsContainer/ViewButton
onready var main_menu_button = $HBoxContainer/MiddleContainer/ContentContainer/VBoxContainer/ButtonsContainer/MainMenuButton

func display_as_victory():
	game_result_label.text = "Victory"
	vic_left_border_panel.visible = true
	vic_right_border_panel.visible = true
	def_left_border_panel.visible = false
	def_right_border_panel.visible = false

func display_as_defeat():
	game_result_label.text = "Defeat"
	vic_left_border_panel.visible = false
	vic_right_border_panel.visible = false
	def_left_border_panel.visible = true
	def_right_border_panel.visible = true

###

func _ready():
	view_battlefield_button.connect("on_button_released_with_button_left", self, "_on_view_battlefield_selected")
	main_menu_button.connect("on_button_released_with_button_left", self, "_on_main_menu_selected")

func _on_view_battlefield_selected():
	emit_signal("option_view_battlefield_selected")

func _on_main_menu_selected():
	emit_signal("option_main_menu_selected")


