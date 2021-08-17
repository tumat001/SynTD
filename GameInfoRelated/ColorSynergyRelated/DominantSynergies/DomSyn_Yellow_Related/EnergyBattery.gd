
const EnergyModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/EnergyModule.gd")
const StageRoundManager = preload("res://GameElementsRelated/StageRoundManager.gd")

# This also means that some values (may have) changed
signal display_output_changed
signal energy_overflow


var max_energy_capacity : int setget _set_max_energy_capacity
var current_energy_amount : int  setget _set_current_energy

var recharge_rate_per_round_from_main : int
var recharge_rate_per_round_from_comple : int

var _connected_energy_modules : Array = []
var _energy_modules_taken_energy_this_round : Array = []

var last_calculated_total_energy_consumption : int

var stage_round_manager : StageRoundManager

var display_output : String setget ,get_display_output

# setting

func _set_max_energy_capacity(value : int):
	max_energy_capacity = value
	
	if current_energy_amount > max_energy_capacity:
		current_energy_amount = max_energy_capacity
	
	call_deferred("emit_signal", "display_output_changed")

func _set_current_energy(value : int):
	current_energy_amount = value
	
	if current_energy_amount > max_energy_capacity:
		current_energy_amount = max_energy_capacity
		call_deferred("emit_signal", "energy_overflow")
	
	call_deferred("emit_signal", "display_output_changed")

# init and connection related

func _init(arg_stage_round_manager : StageRoundManager):
	stage_round_manager = arg_stage_round_manager
	
	stage_round_manager.connect("round_started", self, "_on_round_started")
	stage_round_manager.connect("round_ended", self, "_on_round_ended")


func create_connected_energy_module() -> EnergyModule:
	var module = EnergyModule.new()
	
	_connect_energy_module(module)
	return module


# Energy module related

func _connect_energy_module(module : EnergyModule):
	_connected_energy_modules.append(module)
	
	module.connect("disconnect_from_battery", self, "remove_energy_module")
	module.connect("attempt_turn_module_on" , self, "_module_attempted_turn_on")
	module.connect("attempt_turn_module_off" , self, "_module_attempted_turn_off")


func remove_energy_module(module : EnergyModule):
	_connected_energy_modules.erase(module)
	_energy_modules_taken_energy_this_round.erase(module)
	
	calculate_total_energy_consumption_from_active_modules()

func get_copy_of_energy_modules() -> Array:
	return _connected_energy_modules.duplicate(false)


# Stats

func calculate_total_energy_consumption_from_active_modules():
	var total : int = 0
	for module in _connected_energy_modules:
		if module.is_turned_on:
			total += module.energy_consumption_per_round
	
	last_calculated_total_energy_consumption = total
	call_deferred("emit_signal", "display_output_changed")
	return total

func recharge_battery():
	_set_current_energy(current_energy_amount + recharge_rate_per_round_from_main + recharge_rate_per_round_from_comple)

# Round related

func _on_round_started(curr_stageround):
	pass


func _on_round_ended(curr_stageround):
	recharge_battery()
	_energy_modules_taken_energy_this_round.clear()
	
	for module in _connected_energy_modules:
		if module.is_turned_on:
			#_attempt_give_energy_to_module(module)
			_module_attempted_turn_on(module)


# Giving energy to module

func _module_attempted_turn_on(module):
	var success = _attempt_give_energy_to_module(module)
	if !success:
		module.module_turn_off()
		calculate_total_energy_consumption_from_active_modules()

func _module_attempted_turn_off(module):
	if stage_round_manager.round_started:
		pass
	else:
		if _energy_modules_taken_energy_this_round.has(module):
			_energy_modules_taken_energy_this_round.erase(module)
			_set_current_energy(current_energy_amount + module.energy_consumption_per_round)
			module.module_turn_off()
			calculate_total_energy_consumption_from_active_modules()


func _attempt_give_energy_to_module(energy_module : EnergyModule) -> bool:
	if energy_module.energy_consumption_per_round <= current_energy_amount:
		if !_energy_modules_taken_energy_this_round.has(energy_module):
			_set_current_energy(current_energy_amount - energy_module.energy_consumption_per_round)
			_energy_modules_taken_energy_this_round.append(energy_module)
			
			energy_module.module_turn_on(true)
			
			calculate_total_energy_consumption_from_active_modules()
		else:
			energy_module.module_turn_on(false)
		
		return true
	
	return false


# Display

func get_display_output() -> String:
	return str(current_energy_amount) + " / " + str(max_energy_capacity)
