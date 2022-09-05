extends Node


enum IncreaseHealthSource {
	
	TOWER = 100,
	SYNERGY = 200,
	
}

enum DecreaseHealthSource {
	
	TOWER = 100,
	ENEMY = 110,
	SYNERGY = 200,
	
}

signal starting_health_changed(arg_val)
signal current_health_changed(current_health)
signal zero_health_reached()


var starting_health : float setget set_starting_health
var current_health : float setget set_health
#var round_info_panel : RoundInfoPanel

#

func set_health(health : float):
	current_health = health
	
	_health_changed()
	_check_if_no_health_remaining()


func increase_health_by(increase : float, increase_source : int):
	current_health += increase
	
	_health_changed()

func decrease_health_by(decrease : float, decrease_source : int):
	current_health -= decrease
	
	_health_changed()
	_check_if_no_health_remaining()


func _health_changed():
	call_deferred("emit_signal", "current_health_changed", current_health)
	#round_info_panel.set_health_display(current_health)

func _check_if_no_health_remaining():
	if current_health <= 0:
		call_deferred("emit_signal", "zero_health_reached")

#

func set_starting_health(arg_val):
	starting_health = arg_val
	
	emit_signal("starting_health_changed", arg_val)


