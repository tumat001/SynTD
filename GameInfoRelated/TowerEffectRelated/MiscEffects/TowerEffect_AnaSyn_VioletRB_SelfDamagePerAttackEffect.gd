extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


var self_damage_percent_amount_per_attack : float
var _tower

func _init(arg_self_damage_percent_amount : float).(StoreOfTowerEffectsUUID.VIOLET_RB_V2_SELF_DAMAGE_EFFECT):
	self_damage_percent_amount_per_attack = arg_self_damage_percent_amount


func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !tower.is_connected("on_main_attack", self, "_on_tower_attack"):
		tower.connect("on_main_attack", self, "_on_tower_attack", [tower], CONNECT_PERSIST)


func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack", self, "_on_tower_attack"):
		tower.disconnect("on_main_attack", self, "_on_tower_attack")


#

func _on_tower_attack(attk_speed_delay, enemies, attk_module, tower):
	tower.take_damage(tower.last_calculated_max_health * self_damage_percent_amount_per_attack)
