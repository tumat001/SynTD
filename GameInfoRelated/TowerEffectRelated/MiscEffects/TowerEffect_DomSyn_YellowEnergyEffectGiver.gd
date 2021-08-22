extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const EnergyEffect_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/EnergyEffectRelated/EnergyModuleOn_StatusBarIcon.png")


func _init().(StoreOfTowerEffectsUUID.ENERGY_MODULE_ENERGY_EFFECT_GIVER):
	status_bar_icon = EnergyEffect_StatusBarIcon


func _make_modifications_to_tower(tower):
	pass

func _undo_modifications_to_tower(tower):
	pass


