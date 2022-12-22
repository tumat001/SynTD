extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const FrostImplants_Proj_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_FrostImplants/Pact_FrostImplants_Proj.png")
const FrostImplants_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/FrostImplants_StatusBarIcon.png")

#

var frost_icicle_count : int

var frost_icicle_base_dmg : float
var frost_icicle_dmg_type : int
var frost_icicle_pierce : int

var frost_icicle_delay_between_shoot : float
var frost_targeting : int

var slow_amount : float
var slow_duration : float

var frost_attack_cd : float


var _tower
var _frost_icicle_attack_module : BulletAttackModule
var _frost_attack_timer : TimerForTower

#var _has_enemies_in_range : bool

#

func _init().(StoreOfTowerEffectsUUID.RED_PACT_FROST_IMPLANTS_EFFECT):
	pass


func _make_modifications_to_tower(tower):
	_tower = tower
	
	_construct_and_add_attk_module()
	_construct_frost_attack_timer()
	


func _construct_and_add_attk_module():
	# effect
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_FROST_IMPLANTS_SLOW_ON_HIT_ADDER_EFFECT)
	slow_modifier.percent_amount = slow_amount
	slow_modifier.percent_based_on = PercentType.BASE
	
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.RED_PACT_FROST_IMPLANTS_SLOW_EFFECT)
	enemy_attr_eff.is_timebound = true
	enemy_attr_eff.time_in_seconds = slow_duration
	
	var tower_eff : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_attr_eff, StoreOfTowerEffectsUUID.RED_PACT_FROST_IMPLANTS_SLOW_ON_HIT_ADDER_EFFECT)
	tower_eff.force_apply = true
	
	#####
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = frost_icicle_base_dmg
	attack_module.base_damage_type = frost_icicle_dmg_type
	attack_module.base_attack_speed = 1 / frost_icicle_delay_between_shoot
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = 1
	attack_module.base_proj_speed = 450
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = 1
	attack_module.base_proj_inaccuracy = 25.0
	
	#attack_module.burst_amount = frost_icicle_count
	#attack_module.burst_attack_speed = 12
	#attack_module.has_burst = true
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = false
	
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 3)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(FrostImplants_Proj_Pic)
	
	attack_module.can_be_commanded_by_tower = false
	
	
	attack_module.use_own_targeting = true
	attack_module.own_targeting_option = frost_targeting
	
	attack_module.set_image_as_tracker_image(FrostImplants_Proj_Pic)
	attack_module.is_displayed_in_tracker = false
	
	attack_module.connect("in_attack_end", self, "_on_frost_icicle_attack_module_attacked", [], CONNECT_PERSIST)
	
	_frost_icicle_attack_module = attack_module
	
	
	_tower.add_attack_module(attack_module)
	_tower._force_add_on_hit_effect_adder_effect_to_module(tower_eff, attack_module)


func _construct_frost_attack_timer():
	_frost_attack_timer = TimerForTower.new()
	_frost_attack_timer.one_shot = true
	_frost_attack_timer.connect("timeout", self, "_on_frost_attack_timer_timeout", [], CONNECT_PERSIST)
	_frost_attack_timer.set_tower_and_properties(_tower)
	_tower.add_child(_frost_attack_timer)


#

func add_effects_to_tower():
	_tower.status_bar.add_status_icon(StoreOfTowerEffectsUUID.RED_PACT_FROST_IMPLANTS_IS_ACTIVE_MARKER_EFFECT, FrostImplants_StatusBarIcon)
	_activate_frost_attacks_timer()
	

func remove_effects_from_tower():
	_tower.status_bar.remove_status_icon(StoreOfTowerEffectsUUID.RED_PACT_FROST_IMPLANTS_IS_ACTIVE_MARKER_EFFECT)
	_deactivate_frost_attacks_and_end_timer()
	

func hide_frost_attack_module_icon_from_tower():
	_frost_icicle_attack_module.is_displayed_in_tracker = false

#

func _activate_frost_attacks_timer():
	_frost_attack_timer.start(frost_attack_cd)
	_frost_icicle_attack_module.is_displayed_in_tracker = true

func _deactivate_frost_attacks_and_end_timer():
	_frost_attack_timer.stop()
	

#

func _on_frost_attack_timer_timeout():
	_execute_frost_attacks()

#func _attempt_execute_frost_attacks():
#	if _has_enemies_in_range and _frost_attack_timer.time_left == 0:
#		_execute_frost_attacks()

func _execute_frost_attacks():
	#_frost_icicle_attack_module.on_command_attack_enemies_in_range_and_attack_when_ready(1, frost_icicle_count)
	_frost_icicle_attack_module.on_command_attack_enemies_in_range_and_attack_when_ready__wait_for_in_range(1, frost_icicle_count)
	#_frost_attack_timer.start(frost_attack_cd)

func _on_frost_icicle_attack_module_attacked():
	if _frost_attack_timer.time_left == 0:
		_frost_attack_timer.start(frost_attack_cd)


####

func _undo_modifications_to_tower(tower):
	if is_instance_valid(tower):
		tower.remove_attack_module(_frost_icicle_attack_module)
		
		if is_instance_valid(_frost_attack_timer):
			_frost_attack_timer.queue_free()
