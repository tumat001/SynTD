extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


var damage_scale : float

func _init().(StoreOfTowerEffectsUUID.HERO_VOL_BUFF_EFFECT):
	pass


func _make_modifications_to_tower(tower):
	if !tower.is_connected("on_damage_instance_constructed", self, "_on_any_dmg_instance_constructed"):
		tower.connect("on_damage_instance_constructed", self, "_on_any_dmg_instance_constructed", [], CONNECT_PERSIST)

func _on_any_dmg_instance_constructed(damage_instance, module):
	damage_instance.scale_only_base_damage_by(damage_scale)



func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_damage_instance_constructed", self, "_on_any_dmg_instance_constructed"):
		tower.disconnect("on_damage_instance_constructed", self, "_on_any_dmg_instance_constructed")




func _shallow_duplicate():
	var copy = get_script().new()
	copy.damage_scale = damage_scale
	
	_configure_copy_to_match_self(copy)
	
	return copy
