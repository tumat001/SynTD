extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const StatusBar_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YelVio_VioletSide_StatusBarIcon.png")
const Border_YelVio = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/ModifierAssets/YelVio_IngIconBorder.png")

var _attached_tower

var scale_amount_to_use : float = 1.0 #TODO TEST AMOUNT

func _init().(StoreOfTowerEffectsUUID.YELVIO_VIOLET_SIDE_EFFECT):
	status_bar_icon = StatusBar_Icon
	


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	if !_attached_tower.is_connected("on_round_end", self, "_on_round_end"):
		_attached_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)

func _undo_modifications_to_tower(tower):
	
	if _attached_tower.is_connected("on_round_end", self, "_on_round_end"):
		_attached_tower.disconnect("on_round_end", self, "_on_round_end")


#

func _on_round_end():
	if _attached_tower.ingredient_of_self != null and _attached_tower.is_current_placable_in_map():
		var tower_effect = _attached_tower.ingredient_of_self.tower_base_effect
		if tower_effect._can_be_scaled_by_yel_vio:
			tower_effect.add_additive_scaling_by_amount(scale_amount_to_use)
			
			if !tower_effect.border_modi_textures.has(Border_YelVio):
				tower_effect.border_modi_textures.append(Border_YelVio)


