
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")


signal disconnect_from_battery(me)

signal module_turned_on(first_time_per_round)
signal module_turned_off()

signal attempt_turn_module_on(me)
signal attempt_turn_module_off(me)

var energy_consumption_per_round : int = 1

var is_turned_on : bool

var module_effect_descriptions : Array = []

var tower_connected_to : AbstractTower setget _set_tower_connected_to

# Setter

func _set_tower_connected_to(arg_tower : AbstractTower):
	# Old if existing
	if tower_connected_to != null:
		tower_connected_to.disconnect("tower_in_queue_free", self, "_tower_connected_in_queue_free")
		tower_connected_to.disconnect("tower_not_in_active_map", self, "_tower_not_active_in_map")
	
	# New incomming
	if arg_tower != null:
		tower_connected_to = arg_tower
		tower_connected_to.connect("tower_in_queue_free", self, "_tower_connected_in_queue_free")
		tower_connected_to.connect("tower_not_in_active_map", self, "_tower_not_active_in_map")


# Tower signals

func _tower_connected_in_queue_free(arg_tower):
	attempt_turn_off()
	disconnect_from_battery()

func _tower_not_active_in_map():
	attempt_turn_off()

# Attempt

func attempt_turn_on():
	call_deferred("emit_signal", "attempt_turn_module_on", self)

func attempt_turn_off():
	call_deferred("emit_signal", "attempt_turn_module_off", self)


# Battery called functions

func module_turn_on(first_time_per_round : bool):
	is_turned_on = true
	call_deferred("emit_signal", "module_turned_on", first_time_per_round)

func module_turn_off():
	is_turned_on = false
	call_deferred("emit_signal", "module_turned_off")



# Call this when queue freeing the tower

func disconnect_from_battery():
	emit_signal("disconnect_from_battery", self)
