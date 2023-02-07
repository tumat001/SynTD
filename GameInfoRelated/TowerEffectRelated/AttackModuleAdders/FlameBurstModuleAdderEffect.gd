extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"

const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")

const Effect_Icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_FlameburtBurst.png")

const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const BurstProj_01 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj01.png")
const BurstProj_02 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj02.png")
const BurstProj_03 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj03.png")
const BurstProj_04 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj04.png")
const BurstProj_05 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj05.png")
const BurstProj_06 = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_Proj/FlameBurst_Proj06.png")

var burst_attack_module : BulletAttackModule
var directions_01 : Array = [
	Vector2(0, 1),
	#Vector2(1, -1),
	#Vector2(-1, -1),
	Vector2(sqrt(3)/2.0, -1/2.0),
	Vector2(-sqrt(3)/2.0, -1.0/2.0)
]
var directions_02 : Array = [
	Vector2(0, -1),
	#Vector2(1, 1),
	#Vector2(-1, 1),
	Vector2(sqrt(3)/2.0, 1/2.0),
	Vector2(-sqrt(3)/2.0, 1.0/2.0)
]

var _curr_direction_index : int = 0
var flamelet_base_dmg : float = 0.6


func _init().(StoreOfTowerEffectsUUID.ING_FLAMEBURST):
	effect_icon = Effect_Icon
	
	_update_description()
	
	_can_be_scaled_by_yel_vio = true

func _update_description():
	# ins
	var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
	interpreter_for_flat_on_hit.display_body = false
	
	var ins_for_flat_on_hit = []
	ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "damage", flamelet_base_dmg * _current_additive_scale))
	
	interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
	# ins
	
	description = ["This tower's main attacks on hit causes 3 flamelets to be spewed from enemies hit. Each flamelet deals |0|. Benefits from bonus pierce.%s" % [_generate_desc_for_persisting_total_additive_scaling(true)], [interpreter_for_flat_on_hit]]


func _construct_burst_module():
	burst_attack_module = BulletAttackModule_Scene.instance()
	#burst_attack_module.base_damage_scale = 1
	burst_attack_module.base_damage = flamelet_base_dmg #/ burst_attack_module.base_damage_scale
	burst_attack_module.base_damage_type = DamageType.ELEMENTAL
	burst_attack_module.base_attack_speed = 0
	burst_attack_module.base_attack_wind_up = 0
	burst_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	burst_attack_module.is_main_attack = false
	burst_attack_module.base_pierce = 1
	burst_attack_module.base_proj_speed = 200
	burst_attack_module.base_proj_life_distance = 100
	burst_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	#burst_attack_module.on_hit_damage_scale = 1
	
	burst_attack_module.benefits_from_bonus_on_hit_damage = false
	burst_attack_module.benefits_from_bonus_on_hit_effect = false
	burst_attack_module.benefits_from_bonus_base_damage = false
	burst_attack_module.benefits_from_bonus_attack_speed = false
	burst_attack_module.benefits_from_bonus_pierce = true
	
	var burst_bullet_shape = RectangleShape2D.new()
	burst_bullet_shape.extents = Vector2(5, 3)
	
	burst_attack_module.bullet_shape = burst_bullet_shape
	burst_attack_module.bullet_scene = BaseBullet_Scene
	
	var burst_sp = SpriteFrames.new()
	burst_sp.add_frame("default", BurstProj_01)
	burst_sp.add_frame("default", BurstProj_02)
	burst_sp.add_frame("default", BurstProj_03)
	burst_sp.add_frame("default", BurstProj_04)
	burst_sp.add_frame("default", BurstProj_05)
	burst_sp.add_frame("default", BurstProj_06)
	burst_attack_module.bullet_sprite_frames = burst_sp
	
	burst_attack_module.can_be_commanded_by_tower = false
	
	burst_attack_module.set_image_as_tracker_image(preload("res://TowerRelated/Color_Orange/FlameBurst/Assets/FlameBurstIng_AttackModule_TrackerImage.png"))


func _make_modifications_to_tower(tower):
	if !is_instance_valid(burst_attack_module):
		_construct_burst_module()
		tower.add_attack_module(burst_attack_module)
	
	for module in tower.all_attack_modules:
		if module.module_id == StoreOfAttackModuleID.MAIN:
			if !module.is_connected("on_enemy_hit", self, "_bullet_burst"):
				module.connect("on_enemy_hit", self, "_bullet_burst", [], CONNECT_PERSIST)
	
	if !tower.is_connected("attack_module_added", self, "_on_tower_attack_module_added"):
		tower.connect("attack_module_added", self, "_on_tower_attack_module_added")
		tower.connect("attack_module_removed", self, "_on_tower_attack_module_removed")


func _undo_modifications_to_tower(tower):
	if is_instance_valid(burst_attack_module):
		tower.remove_attack_module(burst_attack_module)
		burst_attack_module.queue_free()
	
	for module in tower.all_attack_modules:
		if module.module_id == StoreOfAttackModuleID.MAIN:
			if module.is_connected("on_enemy_hit", self, "_bullet_burst"):
				module.disconnect("on_enemy_hit", self, "_bullet_burst")
	
	if tower.is_connected("attack_module_added", self, "_on_tower_attack_module_added"):
		tower.disconnect("attack_module_added", self, "_on_tower_attack_module_added")
		tower.disconnect("attack_module_removed", self, "_on_tower_attack_module_removed")
	

# hit

func _bullet_burst(enemy, damage_reg_id, damage_instance, module):
	var spawn_pos : Vector2 = enemy.global_position
	
	for dir in _get_directions():
		var bullet : BaseBullet = burst_attack_module.construct_bullet(spawn_pos + dir)
		bullet.life_distance = 30
		bullet.enemies_ignored.append(enemy)
		bullet.direction_as_relative_location = dir
		bullet.rotation_degrees = rad2deg(spawn_pos.angle_to_point(spawn_pos - dir))
		bullet.global_position = spawn_pos
		bullet.scale *= 0.75
		
		burst_attack_module.set_up_bullet__add_child_and_emit_signals(bullet)
	
	_inc_directions_index()


func _get_directions():
	if _curr_direction_index == 0:
		return directions_01
	else:
		return directions_02

func _inc_directions_index():
	_curr_direction_index += 1
	if _curr_direction_index >= 2:
		_curr_direction_index = 0

# connect

func _on_tower_attack_module_added(module):
	if module.module_id == StoreOfAttackModuleID.MAIN:
		if !module.is_connected("on_enemy_hit", self, "_bullet_burst"):
			module.connect("on_enemy_hit", self, "_bullet_burst", [], CONNECT_PERSIST)


func _on_tower_attack_module_removed(module):
	if module.module_id == StoreOfAttackModuleID.MAIN:
		if module.is_connected("on_enemy_hit", self, "_bullet_burst"):
			module.disconnect("on_enemy_hit", self, "_bullet_burst")

#

func _shallow_duplicate():
	var copy = get_script().new()
	_configure_copy_to_match_self(copy)
	
	return copy

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	flamelet_base_dmg *= _current_additive_scale
	_current_additive_scale = 1
