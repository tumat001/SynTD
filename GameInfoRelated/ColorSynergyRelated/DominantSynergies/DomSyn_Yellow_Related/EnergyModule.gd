
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const TowerEffect_DomSyn_YellowEnergyEffectGiver = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_DomSyn_YellowEnergyEffectGiver.gd")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")

signal disconnect_from_battery(me)

signal module_turned_on(first_time_per_round)
signal module_turned_off()

signal attempt_turn_module_on(me)
signal attempt_turn_module_off(me)

var energy_consumption_per_round : int = 1

var is_turned_on : bool

var module_effect_descriptions : Array = []

var tower_connected_to : AbstractTower setget _set_tower_connected_to

var _energy_on_attack_sprite

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



# Functions called by EnergyBattery. Do not touch
func module_turn_on(first_time_per_round : bool):
	is_turned_on = true
	call_deferred("emit_signal", "module_turned_on", first_time_per_round)
	
	var effect := TowerEffect_DomSyn_YellowEnergyEffectGiver.new()
	tower_connected_to.add_tower_effect(effect)

func module_turn_off():
	is_turned_on = false
	call_deferred("emit_signal", "module_turned_off")
	
	if tower_connected_to != null:
		var effect = tower_connected_to.get_tower_effect(StoreOfTowerEffectsUUID.ENERGY_MODULE_ENERGY_EFFECT_GIVER)
		if effect != null:
			tower_connected_to.remove_tower_effect(effect)


# Call this when queue freeing the tower

func disconnect_from_battery():
	call_deferred("emit_signal", "disconnect_from_battery", self)
