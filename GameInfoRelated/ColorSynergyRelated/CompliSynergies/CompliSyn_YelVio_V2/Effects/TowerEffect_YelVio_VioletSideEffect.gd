extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const StatusBar_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YelVio_VioletSide_StatusBarIcon.png")
const Border_YelVio = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/ModifierAssets/YelVio_IngIconBorder.png")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const CenterBasedAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd")
const CenterBasedAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.tscn")

const VioletSide_IngUpgrade_ParticlePic = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/YelVio_RiftAxis/OtherAssets/VioletSide_IngUpgraded_ParticlePic.png")


var _attached_tower
var violet_ing_upgrade_particle_pool : AttackSpritePoolComponent

var _violet_ing_particle_show_timer : Timer
const _violet_ing_particle_count_per_show : int = 12
const _violet_ing_particle_show_delay : float = 0.12
var _current_violet_ing_particle_show_count : int = 0

#

var scale_amount_to_use : float = 0.0

#

func _init().(StoreOfTowerEffectsUUID.YELVIO_VIOLET_SIDE_EFFECT):
	status_bar_icon = StatusBar_Icon
	


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	_construct_vio_ing_upgrade_particle_pool()
	_construct_vio_ing_particle_timer()
	
	if !_attached_tower.is_connected("on_round_end", self, "_on_round_end"):
		_attached_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)

func _construct_vio_ing_upgrade_particle_pool():
	violet_ing_upgrade_particle_pool = AttackSpritePoolComponent.new()
	violet_ing_upgrade_particle_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	violet_ing_upgrade_particle_pool.node_to_listen_for_queue_free = _attached_tower
	violet_ing_upgrade_particle_pool.source_for_funcs_for_attk_sprite = self
	violet_ing_upgrade_particle_pool.func_name_for_creating_attack_sprite = "_create_vio_ing_upgrade_particle"
	violet_ing_upgrade_particle_pool.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_vio_ing_particle_properties_when_get_from_pool_after_add_child"

func _create_vio_ing_upgrade_particle():
	var particle = CenterBasedAttackSprite_Scene.instance()
	
	particle.center_pos_of_basis = _attached_tower.global_position
	particle.initial_speed_towards_center = -50
	particle.speed_accel_towards_center = 475
	particle.min_starting_distance_from_center = 40
	particle.max_starting_distance_from_center = 60
	particle.texture_to_use = VioletSide_IngUpgrade_ParticlePic
	particle.queue_free_at_end_of_lifetime = false
	particle.turn_invisible_at_end_of_lifetime = true
	
	return particle

func _set_vio_ing_particle_properties_when_get_from_pool_after_add_child(arg_particle):
	arg_particle.center_pos_of_basis = _attached_tower.global_position
	arg_particle.reset_for_another_use()
	


func _construct_vio_ing_particle_timer():
	_violet_ing_particle_show_timer = Timer.new()
	_violet_ing_particle_show_timer.one_shot = false
	_violet_ing_particle_show_timer.connect("timeout", self, "_on_violet_ing_particle_show_timer_timeout", [], CONNECT_PERSIST)
	
	_attached_tower.add_child(_violet_ing_particle_show_timer)

func _on_violet_ing_particle_show_timer_timeout():
	_current_violet_ing_particle_show_count += 1
	
	var particle = violet_ing_upgrade_particle_pool.get_or_create_attack_sprite_from_pool()
	particle.visible = true
	particle.lifetime = 0.5
	particle.modulate.a = 0.6
	
	if _current_violet_ing_particle_show_count >= _violet_ing_particle_count_per_show:
		_violet_ing_particle_show_timer.stop()


#

func _undo_modifications_to_tower(tower):
	if is_instance_valid(_violet_ing_particle_show_timer):
		_violet_ing_particle_show_timer.queue_free()
	
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
			
			_current_violet_ing_particle_show_count = 0
			_violet_ing_particle_show_timer.start(_violet_ing_particle_show_delay)

