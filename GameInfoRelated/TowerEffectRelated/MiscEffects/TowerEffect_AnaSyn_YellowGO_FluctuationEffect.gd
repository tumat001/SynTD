extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


var on_hit_effect
var base_dmg_effect
var attk_speed_effect
var range_effect


func _init().(StoreOfTowerEffectsUUID.YELLOW_GO_EFFECT_BUNDLE):
	pass


func _make_modifications_to_tower(tower):
	if on_hit_effect != null and !tower.has_tower_effect_uuid_in_buff_map(on_hit_effect.effect_uuid):
		tower.add_tower_effect(on_hit_effect)
	
	if base_dmg_effect != null and !tower.has_tower_effect_uuid_in_buff_map(base_dmg_effect.effect_uuid):
		tower.add_tower_effect(base_dmg_effect)
	
	if attk_speed_effect != null and !tower.has_tower_effect_uuid_in_buff_map(attk_speed_effect.effect_uuid):
		tower.add_tower_effect(attk_speed_effect)
	
	if range_effect != null and !tower.has_tower_effect_uuid_in_buff_map(range_effect.effect_uuid):
		tower.add_tower_effect(range_effect)


func _undo_modifications_to_tower(tower):
	if on_hit_effect != null and tower.has_tower_effect_uuid_in_buff_map(on_hit_effect.effect_uuid):
		tower.remove_tower_effect(on_hit_effect)
	
	if base_dmg_effect != null and tower.has_tower_effect_uuid_in_buff_map(base_dmg_effect.effect_uuid):
		tower.remove_tower_effect(base_dmg_effect)
	
	if attk_speed_effect != null and tower.has_tower_effect_uuid_in_buff_map(attk_speed_effect.effect_uuid):
		tower.remove_tower_effect(attk_speed_effect)
	
	if range_effect != null and tower.has_tower_effect_uuid_in_buff_map(range_effect.effect_uuid):
		tower.remove_tower_effect(range_effect)



