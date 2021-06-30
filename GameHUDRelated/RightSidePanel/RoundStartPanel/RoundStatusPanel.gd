extends MarginContainer

const RoundInfoPanel = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundInfoPanel/RoundInfoPanel.gd")
const AbilityPanel = preload("res://GameHUDRelated/AbilityPanel/AbilityPanel.gd")

signal round_start_pressed
signal round_fast_forward_pressed
signal round_normal_speed_pressed


const pic_round_start_button = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStartButton.png")
const pic_round_fast_forward_button = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundFastForwardButton.png")
const pic_round_normal_speed_button = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundNormalSpeedButton.png")

onready var round_status_button : TextureButton = $VBoxContainer/MarginContainer/RoundStatusButton
onready var round_info_panel : RoundInfoPanel = $VBoxContainer/RoundInfoPanel
onready var ability_panel : AbilityPanel = $VBoxContainer/AbilityPanel

var round_started : bool
var round_fast_forwarded : bool



func _update_round_started():
	emit_signal("round_start_pressed")
	if round_fast_forwarded:
		_update_fast_forwarded()
	else:
		_update_normal_speed()
	
	round_started = true


func _update_round_ended():
	round_status_button.texture_normal = pic_round_start_button
	round_started = false
	
	Engine.time_scale = 1.0


func _update_fast_forwarded():
	round_fast_forwarded = true
	round_status_button.texture_normal = pic_round_fast_forward_button
	Engine.time_scale = 2.0

func _update_normal_speed():
	round_fast_forwarded = false
	round_status_button.texture_normal = pic_round_normal_speed_button
	Engine.time_scale = 1.0


func _on_RoundStatusButton_pressed():
	if !round_started:
		_update_round_started()
	else:
		if round_fast_forwarded:
			_update_normal_speed()
		else:
			_update_fast_forwarded()
