extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"

const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")

const TowerPriorityTargetEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerPriorityTargetEffect.gd")


const _base_taunt_range : float = 80.0

var tower_detecting_range_module : TowerDetectingRangeModule


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.PROXIMITY))
	
	is_blue_and_benefits_from_ap = true

func _ready():
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.detection_range = _base_taunt_range * last_calculated_final_ability_potency
	
	tower_detecting_range_module.connect("on_tower_entered", self, "_on_tower_entered_range")
	tower_detecting_range_module.connect("on_tower_exited", self, "_on_tower_exited_range")
	
	add_child(tower_detecting_range_module)

	#connect("on_finished_ready_prep", self, "_on_finish_ready_prep", [], CONNECT_ONESHOT)
	
	connect("final_ability_potency_changed", self, "_on_final_ap_changed_p")
	

#func _on_finish_ready_prep():
#

func _on_tower_entered_range(arg_tower):
	if is_instance_valid(arg_tower):
		_construct_taunt_effect_and_give_to_tower(arg_tower)

func _on_tower_exited_range(arg_tower):
	if is_instance_valid(arg_tower):
		_remove_taunt_effect_from_tower(arg_tower)


func _construct_taunt_effect_and_give_to_tower(arg_tower):
	if !arg_tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.PROXIMITY_TAUNT_EFFECT):
		var tower_target_priority_effect = TowerPriorityTargetEffect.new(self, StoreOfTowerEffectsUUID.PROXIMITY_TAUNT_EFFECT)
		tower_target_priority_effect.is_from_enemy = true
		tower_target_priority_effect.time_in_seconds = 1
		tower_target_priority_effect.is_timebound = false
		tower_target_priority_effect.status_bar_icon = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/_FactionAssets/StatusBarIcons/Proximity_TauntIcon.png")
		
		arg_tower.add_tower_effect(tower_target_priority_effect)

func _remove_taunt_effect_from_tower(arg_tower):
	var effect = arg_tower.get_tower_effect(StoreOfTowerEffectsUUID.PROXIMITY_TAUNT_EFFECT)
	
	if effect != null:
		arg_tower.remove_tower_effect(effect)

##

func _on_final_ap_changed_p(arg_potency):
	tower_detecting_range_module.detection_range = _base_taunt_range * last_calculated_final_ability_potency
	

