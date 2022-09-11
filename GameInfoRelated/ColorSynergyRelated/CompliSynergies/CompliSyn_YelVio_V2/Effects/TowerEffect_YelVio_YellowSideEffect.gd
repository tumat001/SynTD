extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const StatusBar_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YelVio_YellowSide_StatusBarIcon.png")
const Border_YelVio = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/ModifierAssets/YelVio_IngIconBorder.png")


var _attached_tower

func _init().(StoreOfTowerEffectsUUID.YELVIO_YELLOW_SIDE_EFFECT):
	status_bar_icon = StatusBar_Icon
	


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	

func _undo_modifications_to_tower(tower):
	pass

