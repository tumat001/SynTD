extends MarginContainer


signal round_start_pressed
signal round_fast_forward_pressed
signal round_normal_speed_pressed


const pic_round_start_button = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundStartButton.png")
const pic_round_fast_forward_button = preload("res://GameHUDRelated/RightSidePanel/RoundStartPanel/RoundFastForwardButton.png")

onready var round_status_button : TextureButton = $VBoxContainer/MarginContainer/RoundStatusButton

var round_started : bool
var round_fast_forwarded : bool


# TODO:
# For now, the round ended is triggered by this panel,
# which should be removed in the end.. The round ended
# signal/trigger should come from the enemymanager
signal round_ended_pressed

func _update_round_started():
	emit_signal("round_start_pressed")
	round_status_button.texture_normal = pic_round_fast_forward_button
	round_started = true

# TODO TEMPORARY
func _update_round_ended():
	emit_signal("round_ended_pressed")
	round_status_button.texture_normal = pic_round_start_button
	round_started = false

func _update_fast_forwarded():
	pass

func _update_normal_speed():
	pass


func _on_RoundStatusButton_pressed():
	if !round_started:
		_update_round_started()
	else:
		if round_fast_forwarded:
			pass
		else:
			pass
		
		# TODO TEMPORARY
		_update_round_ended()
