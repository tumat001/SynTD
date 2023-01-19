extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const OrbSticky_Scene = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_Sticky.tscn")
const OrbSticky = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_Sticky.gd")

const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const Orb_MainAttack_Pic = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_MainAttack01.png")
const Orb_SubAttack_Pic = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_SubAttack01.png")

const Orb_StickyPic01 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_Sticky01.png")

const Orb_StickyExplosionPic01 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_StickyExplosion01.png")
const Orb_StickyExplosionPic02 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_StickyExplosion02.png")
const Orb_StickyExplosionPic03 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_StickyExplosion03.png")
const Orb_StickyExplosionPic04 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_StickyExplosion04.png")
const Orb_StickyExplosionPic05 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_StickyExplosion05.png")
const Orb_StickyExplosionPic06 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_StickyExplosion06.png")
const Orb_StickyExplosionPic07 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Sticky/Orb_StickyExplosion07.png")

const Orb_Beam01 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Beam/Orb_Beam01.png")
const Orb_Beam02 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Beam/Orb_Beam02.png")
const Orb_Beam03 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Beam/Orb_Beam03.png")
const Orb_Beam04 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Beam/Orb_Beam04.png")
const Orb_Beam05 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Beam/Orb_Beam05.png")
const Orb_Beam06 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Attacks/Orb_Beam/Orb_Beam06.png")

const Orb_HatLevel01 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Hat/Orb_Hat01.png")
const Orb_HatLevel02 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Hat/Orb_Hat02.png")
const Orb_HatLevel03 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Hat/Orb_Hat03.png")
const Orb_HatLevel04 = preload("res://TowerRelated/Color_Blue/Orb/Orb_Hat/Orb_Hat04.png")

const OrbSticky_AttackModule_Icon = preload("res://TowerRelated/Color_Blue/Orb/AMAssets/OrbSticky_AttackModule_Icon.png")
const OrbStars_AttackModule_Icon = preload("res://TowerRelated/Color_Blue/Orb/AMAssets/OrbStars_AttackModule_Icon.png")
const OrbBeam_AttackModule_Icon = preload("res://TowerRelated/Color_Blue/Orb/AMAssets/OrbBeam_AttackModule_Icon.png")


signal current_level_changed()


const ap_amount_per_orb_absorbed : float = 0.75
var ap_from_orbs_effect : TowerAttributesEffect
var _original_gold_cost : int

const ap_level04 : float = 2.5
const ap_level03 : float = 2.0
const ap_level02 : float = 1.5

const tower_slots_taken : int = 2

var current_level : int = 0
var explosion_attack_module : AOEAttackModule
var sticky_attack_module : BulletAttackModule
var beam_attack_module : WithBeamInstantDamageAttackModule
var sub_attack_module : BulletAttackModule

var sub_attack_active : bool = false
var sticky_attack_active : bool = false
var beam_attack_active : bool = false

onready var orb_hat_sprite : Sprite = $TowerBase/KnockUpLayer/HatSprite


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.ORB)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift_of_modules : float = 0
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += y_shift_of_modules
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 354#295
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y += y_shift_of_modules
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(8, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Orb_MainAttack_Pic)
	
	add_attack_module(attack_module)
	
	
	# Sticky
	
	sticky_attack_module = BulletAttackModule_Scene.instance()
	sticky_attack_module.base_damage = 0
	sticky_attack_module.base_damage_type = DamageType.ELEMENTAL
	sticky_attack_module.base_attack_speed = 0.4
	sticky_attack_module.base_attack_wind_up = 6
	sticky_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	sticky_attack_module.is_main_attack = false
	sticky_attack_module.base_pierce = 1
	sticky_attack_module.base_proj_speed = 140
	sticky_attack_module.base_proj_life_distance = info.base_range
	sticky_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	sticky_attack_module.on_hit_damage_scale = 0
	sticky_attack_module.position.y += y_shift_of_modules
	
	sticky_attack_module.base_damage_scale = 0
	sticky_attack_module.benefits_from_bonus_base_damage = false
	sticky_attack_module.benefits_from_bonus_on_hit_damage = false
	sticky_attack_module.benefits_from_bonus_on_hit_effect = false
	sticky_attack_module.benefits_from_bonus_pierce = false
	
	var sticky_bullet_shape = CircleShape2D.new()
	sticky_bullet_shape.radius = 6
	
	sticky_attack_module.bullet_shape = sticky_bullet_shape
	sticky_attack_module.bullet_scene = OrbSticky_Scene
	
	sticky_attack_module.connect("before_bullet_is_shot", self, "_sticky_bullet_shot", [], CONNECT_PERSIST)
	
	sticky_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01)
	
	sticky_attack_module.is_displayed_in_tracker = false
	
	add_attack_module(sticky_attack_module)
	
	
	# Sticky explosion
	
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = 6
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var aoe_sprite_frames = SpriteFrames.new()
	aoe_sprite_frames.add_frame("default", Orb_StickyExplosionPic01)
	aoe_sprite_frames.add_frame("default", Orb_StickyExplosionPic02)
	aoe_sprite_frames.add_frame("default", Orb_StickyExplosionPic03)
	aoe_sprite_frames.add_frame("default", Orb_StickyExplosionPic04)
	aoe_sprite_frames.add_frame("default", Orb_StickyExplosionPic05)
	aoe_sprite_frames.add_frame("default", Orb_StickyExplosionPic06)
	aoe_sprite_frames.add_frame("default", Orb_StickyExplosionPic07)
	
	explosion_attack_module.aoe_sprite_frames = aoe_sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 3
	explosion_attack_module.duration = 0.35
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(OrbSticky_AttackModule_Icon)
	
	add_attack_module(explosion_attack_module)
	
	
	# Beam
	
	beam_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	beam_attack_module.base_damage_scale = 0.4
	beam_attack_module.base_damage = 0.5 / beam_attack_module.base_damage_scale
	beam_attack_module.base_damage_type = DamageType.ELEMENTAL
	beam_attack_module.base_attack_speed = 6
	beam_attack_module.base_attack_wind_up = 0
	beam_attack_module.is_main_attack = false
	beam_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	beam_attack_module.position.y -= 1
	beam_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	#beam_attack_module.on_hit_damage_scale = 0.5
	beam_attack_module.position.y += y_shift_of_modules
	
	beam_attack_module.benefits_from_bonus_on_hit_damage = false
	beam_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Orb_Beam01)
	beam_sprite_frame.add_frame("default", Orb_Beam02)
	beam_sprite_frame.add_frame("default", Orb_Beam03)
	beam_sprite_frame.add_frame("default", Orb_Beam04)
	beam_sprite_frame.add_frame("default", Orb_Beam05)
	beam_sprite_frame.add_frame("default", Orb_Beam06)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 25)
	
	beam_attack_module.beam_scene = BeamAesthetic_Scene
	beam_attack_module.beam_sprite_frames = beam_sprite_frame
	beam_attack_module.beam_is_timebound = true
	beam_attack_module.beam_time_visible = 1.0 / 6.0
	
	beam_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01)
	
	beam_attack_module.set_image_as_tracker_image(OrbBeam_AttackModule_Icon)
	
	add_attack_module(beam_attack_module)
	
	beam_attack_module.connect("on_damage_instance_constructed", self, "_beam_dmg_instance_constructed", [], CONNECT_PERSIST)
	
	
	# Sub attack
	
	sub_attack_module = BulletAttackModule_Scene.instance()
	sub_attack_module.base_damage_scale = 0.4
	sub_attack_module.base_damage = 1 / sub_attack_module.base_damage_scale
	sub_attack_module.base_damage_type = DamageType.ELEMENTAL
	sub_attack_module.base_attack_speed = 9#0
	sub_attack_module.base_attack_wind_up = 0
	sub_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	sub_attack_module.is_main_attack = false
	sub_attack_module.base_pierce = info.base_pierce
	sub_attack_module.base_proj_speed = 500
	sub_attack_module.base_proj_life_distance = info.base_range
	sub_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	sub_attack_module.on_hit_damage_scale = 0.4
	sub_attack_module.position.y += y_shift_of_modules
	
	sub_attack_module.benefits_from_bonus_base_damage = true
	sub_attack_module.benefits_from_bonus_on_hit_damage = true
	sub_attack_module.benefits_from_bonus_on_hit_effect = false
	sub_attack_module.benefits_from_bonus_pierce = true
	sub_attack_module.benefits_from_bonus_attack_speed = false
	
	sub_attack_module.commit_to_targets_of_windup = true
	sub_attack_module.fill_empty_windup_target_slots = true
	
	sub_attack_module.burst_amount = 3
	sub_attack_module.burst_attack_speed = 9
	sub_attack_module.has_burst = true
	
	var sub_bullet_shape = CircleShape2D.new()
	sub_bullet_shape.radius = 7
	
	sub_attack_module.bullet_shape = sub_bullet_shape
	sub_attack_module.bullet_scene = BaseBullet_Scene
	sub_attack_module.set_texture_as_sprite_frame(Orb_SubAttack_Pic)
	
	sub_attack_module.can_be_commanded_by_tower = false
	
	sub_attack_module.connect("on_enemy_hit", self, "_sub_attack_hit_enemy", [], CONNECT_PERSIST)
	
	sub_attack_module.set_image_as_tracker_image(OrbStars_AttackModule_Icon)
	
	add_attack_module(sub_attack_module)
	
	# Others
	
	_original_gold_cost = _base_gold_cost
	
	connect("final_ability_potency_changed", self, "_orb_final_ap_changed", [], CONNECT_PERSIST)
	connect("on_main_attack_module_enemy_hit", self, "_main_attack_on_hit", [], CONNECT_DEFERRED | CONNECT_PERSIST)
	
	tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_placed_in_map", [], CONNECT_PERSIST)
	
	orb_hat_sprite.use_parent_material = false
	
	tower_limit_slots_taken = tower_slots_taken
	
	#
	
	_post_inherit_ready()

func _post_inherit_ready():
	._post_inherit_ready()
	
	_construct_and_add_orb_absorb_effect()
	_orb_final_ap_changed()


func _construct_and_add_orb_absorb_effect():
	var modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ORB_ABSORB_ORB_BUFF)
	
	ap_from_orbs_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, modi, StoreOfTowerEffectsUUID.ORB_ABSORB_ORB_BUFF)
	add_tower_effect(ap_from_orbs_effect)

func _orb_final_ap_changed():
	var new_level = _calculate_new_level_from_change()
	
	if current_level != new_level:
		_remove_current_level()
		_apply_new_level(new_level)
		
		current_level = new_level
		call_deferred("emit_signal", "current_level_changed")


func _calculate_new_level_from_change() -> int:
	if last_calculated_final_ability_potency >= ap_level04:
		return 4
	if last_calculated_final_ability_potency >= ap_level03:
		return 3
	if last_calculated_final_ability_potency >= ap_level02:
		return 2
	else:
		return 1


# Apply remove
func _remove_current_level():
	_remove_level_02()
	_remove_level_03()
	_remove_level_04()

func _apply_new_level(new_level):
	if new_level == 1:
		_apply_level_01()
	elif new_level == 2:
		_apply_level_02()
	elif new_level == 3:
		_apply_level_02()
		_apply_level_03()
	elif new_level == 4:
		_apply_level_02()
		_apply_level_03()
		_apply_level_04()



func _apply_level_01():
	orb_hat_sprite.texture = Orb_HatLevel01


func _apply_level_02():
	orb_hat_sprite.texture = Orb_HatLevel02
	sticky_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01)
	sticky_attack_active = true

func _remove_level_02():
	sticky_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01)
	sticky_attack_active = false


func _apply_level_03():
	orb_hat_sprite.texture = Orb_HatLevel03
	sub_attack_active = true

func _remove_level_03():
	sub_attack_active = false


func _apply_level_04():
	orb_hat_sprite.texture = Orb_HatLevel04
	beam_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01)
	beam_attack_active = true

func _remove_level_04():
	beam_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.SELF_DEFINED_CLAUSE_01)
	beam_attack_active = false


# Sticky related

func _sticky_bullet_shot(bullet : OrbSticky):
	bullet.connect("sticky_time_reached", self, "_sticky_bullet_time_expire", [bullet], CONNECT_ONESHOT)

func _sticky_bullet_time_expire(bullet):
	var bullet_position = bullet.global_position
	var explosion = explosion_attack_module.construct_aoe(bullet_position, bullet_position)
	
	explosion.damage_instance.scale_only_damage_by(last_calculated_final_ability_potency)
	
	get_tree().get_root().add_child(explosion)
	bullet.queue_free()


# Sub attack

func _main_attack_on_hit(enemy, damage_register_id, damage_instance, module):
	if sub_attack_active:
		if !sub_attack_module.is_connected("before_bullet_is_shot", self, "_sub_attack_bullet_shot"):
			sub_attack_module.connect("before_bullet_is_shot", self, "_sub_attack_bullet_shot", [enemy])
			sub_attack_module.connect("in_attack_end", self, "_sub_attack_finished_shots")
		#sub_attack_module.on_command_attack_enemies_and_attack_when_ready([enemy], 1, 1)
		
		sub_attack_module.on_command_attack_enemies_in_range_and_attack_when_ready(1, 1)

func _sub_attack_bullet_shot(bullet, enemy):
	if is_instance_valid(enemy):
		var distance = global_position.distance_to(enemy.global_position)
		
		if bullet.life_distance < distance:
			bullet.life_distance = distance + 50


func _sub_attack_finished_shots():
	if sub_attack_module.is_connected("before_bullet_is_shot", self, "_sub_attack_bullet_shot"):
		sub_attack_module.disconnect("before_bullet_is_shot", self, "_sub_attack_bullet_shot")
		sub_attack_module.disconnect("in_attack_end", self, "_sub_attack_finished_shots")

func _sub_attack_hit_enemy(enemy, damage_register_id, damage_instance, module):
	damage_instance.scale_only_damage_by(last_calculated_final_ability_potency)

#

func _beam_dmg_instance_constructed(damage_instance, module):
	damage_instance.scale_only_damage_by(last_calculated_final_ability_potency)


#

func _can_accept_ingredient(ingredient_effect : IngredientEffect, tower_selected) -> bool:
	if ingredient_effect.tower_id == Towers.ORB:
		return true
	
	return ._can_accept_ingredient(ingredient_effect, tower_selected)


func absorb_ingredient(ingredient_effect : IngredientEffect, ingredient_gold_base_cost : int):
	if ingredient_effect != null:
		if ingredient_effect.tower_id == Towers.ORB:
			_gain_bonus_from_orb_absorbed()
			_base_gold_cost += _original_gold_cost
			return
	
	.absorb_ingredient(ingredient_effect, ingredient_gold_base_cost)

func _gain_bonus_from_orb_absorbed():
	ap_from_orbs_effect.attribute_as_modifier.flat_modifier += ap_amount_per_orb_absorbed
	_calculate_final_ability_potency()
	
	#_display_absorbed_ingredient_effects(tower_type_info.tower_tier)
	tower_manager.display_absorbed_ingredient_effects(tower_type_info.tower_tier, global_position)

#

func _tower_placed_in_map(tower):
	if is_current_placable_in_map():
		if is_instance_valid(tower) and tower.tower_id == Towers.ORB and tower != self:
			tower.sell_tower()
			_gain_bonus_from_orb_absorbed()

