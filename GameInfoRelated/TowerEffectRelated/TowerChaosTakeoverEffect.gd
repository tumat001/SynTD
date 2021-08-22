extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")

const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")
const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const AbstractAttackModule = preload("res://TowerRelated/Modules/AbstractAttackModule.gd")

const ChaosOrb_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_Orb.png")
const ChaosDiamond_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_Diamond.png")

const ChaosBolt01_pic = preload("res://TowerRelated/Color_Violet/Chaos/ChaosBolt_01.png")
const ChaosBolt02_pic = preload("res://TowerRelated/Color_Violet/Chaos/ChaosBolt_02.png")
const ChaosBolt03_pic = preload("res://TowerRelated/Color_Violet/Chaos/ChaosBolt_03.png")

const ChaosSword = preload("res://TowerRelated/Color_Violet/Chaos/ChaosSwordParticle.tscn")

const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const ChaosBase01_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_01.png")
const ChaosBase02_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_02.png")
const ChaosBase03_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_03.png")
const ChaosBase04_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_04.png")
const ChaosBase05_pic = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_05.png")


var chaos_attack_modules : Array = []
var replaced_attack_modules : Array
var replaced_range_module
var replaced_main_attack_module

var replaced_self_ingredient

var sword_attack_module : InstantDamageAttackModule
const damage_accumulated_trigger : float = 80.0
var damage_accumulated : float = 0

var tower_taken_over

var chaos_shadow_anim_sprite


const CHAOS_TOWER_ID = 703


func _init().(EffectType.CHAOS_TAKEOVER, StoreOfTowerEffectsUUID.ING_CHAOS):
	description = "Takeover: CHAOS replaces the tower's attacks, stats, range, and targeting with its own. CHAOS retains the tower's colors and ingredient effects. The tower's self ingredient is replaced by this."
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Chaos.png")


func _construct_modules():
	for module in chaos_attack_modules:
		if module != null:
			module.queue_free()
	chaos_attack_modules.clear()
	
	# Orb's range module
	var orb_range_module = RangeModule_Scene.instance()
	orb_range_module.base_range_radius = 135
	#orb_range_module.all_targeting_options = [Targeting.RANDOM, Targeting.FIRST, Targeting.LAST]
	orb_range_module.set_range_shape(CircleShape2D.new())
	orb_range_module.position.y += 22
	orb_range_module.add_targeting_option(Targeting.RANDOM)
	orb_range_module.set_current_targeting(Targeting.RANDOM)
	
	# Orb related
	var orb_attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	orb_attack_module.base_damage = 1.5
	orb_attack_module.base_damage_type = DamageType.PHYSICAL
	orb_attack_module.base_attack_speed = 1.5
	orb_attack_module.base_attack_wind_up = 0
	orb_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	orb_attack_module.is_main_attack = true
	orb_attack_module.base_pierce = 1
	orb_attack_module.base_proj_speed = 550
	orb_attack_module.base_proj_life_distance = 135
	orb_attack_module.module_id = StoreOfAttackModuleID.MAIN
	orb_attack_module.position.y -= 22
	orb_attack_module.on_hit_damage_scale = 0
	orb_attack_module.benefits_from_bonus_attack_speed = false
	orb_attack_module.benefits_from_bonus_base_damage = true
	orb_attack_module.benefits_from_bonus_on_hit_damage = false
	orb_attack_module.benefits_from_bonus_on_hit_effect = false
	orb_attack_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	orb_attack_module.bullet_shape = bullet_shape
	orb_attack_module.bullet_scene = BaseBullet_Scene
	orb_attack_module.set_texture_as_sprite_frame(ChaosOrb_pic)
	
	orb_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated")
	orb_attack_module.connect("on_round_end", self, "_on_round_end")
	
	orb_attack_module.range_module = orb_range_module
	
	chaos_attack_modules.append(orb_attack_module)
	
	
	# Diamond related
	var dia_range_module = RangeModule_Scene.instance()
	dia_range_module.base_range_radius = 135
	dia_range_module.set_range_shape(CircleShape2D.new())
	dia_range_module.position.y += 22
	dia_range_module.can_display_range = false
	dia_range_module.clear_all_targeting()
	dia_range_module.add_targeting_option(Targeting.RANDOM)
	dia_range_module.set_current_targeting(Targeting.RANDOM)
	
	var diamond_attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	diamond_attack_module.base_damage_scale = 0.25
	diamond_attack_module.base_damage = 2.5 / diamond_attack_module.base_damage_scale
	diamond_attack_module.base_damage_type = DamageType.PHYSICAL
	diamond_attack_module.base_attack_speed = 0.85
	diamond_attack_module.base_attack_wind_up = 2
	diamond_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	diamond_attack_module.is_main_attack = false
	diamond_attack_module.base_pierce = 3
	diamond_attack_module.base_proj_speed = 400
	diamond_attack_module.base_proj_life_distance = 135
	diamond_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	diamond_attack_module.position.y -= 22
	diamond_attack_module.on_hit_damage_scale = 1
	diamond_attack_module.on_hit_effect_scale = 2
	diamond_attack_module.benefits_from_bonus_attack_speed = false
	diamond_attack_module.benefits_from_bonus_base_damage = true
	diamond_attack_module.benefits_from_bonus_on_hit_damage = true
	diamond_attack_module.benefits_from_bonus_on_hit_effect = true
	diamond_attack_module.benefits_from_bonus_pierce = true
	
	diamond_attack_module.use_self_range_module = true
	diamond_attack_module.range_module = dia_range_module
	
	var diamond_shape = RectangleShape2D.new()
	diamond_shape.extents = Vector2(11, 7)
	
	diamond_attack_module.bullet_shape = diamond_shape
	diamond_attack_module.bullet_scene = BaseBullet_Scene
	diamond_attack_module.set_texture_as_sprite_frame(ChaosDiamond_pic)
	
	diamond_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated")
	
	chaos_attack_modules.append(diamond_attack_module)
	
	
	# Bolt related
	var bolt_range_module = RangeModule_Scene.instance()
	bolt_range_module.base_range_radius = 135
	bolt_range_module.set_range_shape(CircleShape2D.new())
	bolt_range_module.position.y += 22
	bolt_range_module.can_display_range = false
	bolt_range_module.clear_all_targeting()
	bolt_range_module.add_targeting_option(Targeting.RANDOM)
	bolt_range_module.set_current_targeting(Targeting.RANDOM)
	
	var bolt_attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	bolt_attack_module.base_damage_scale = 0.25
	bolt_attack_module.base_damage = 1.5 / bolt_attack_module.base_damage_scale
	bolt_attack_module.base_damage_type = DamageType.ELEMENTAL
	bolt_attack_module.base_attack_speed = 1.3
	bolt_attack_module.base_attack_wind_up = 0
	bolt_attack_module.is_main_attack = false
	bolt_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	bolt_attack_module.position.y -= 22
	bolt_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	bolt_attack_module.benefits_from_bonus_attack_speed = true
	bolt_attack_module.benefits_from_bonus_base_damage = true
	bolt_attack_module.benefits_from_bonus_on_hit_damage = false
	bolt_attack_module.benefits_from_bonus_on_hit_effect = false
	
	bolt_attack_module.use_self_range_module = true
	bolt_attack_module.range_module = bolt_range_module
	
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", ChaosBolt01_pic)
	beam_sprite_frame.add_frame("default", ChaosBolt02_pic)
	beam_sprite_frame.add_frame("default", ChaosBolt03_pic)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	bolt_attack_module.beam_scene = BeamAesthetic_Scene
	bolt_attack_module.beam_sprite_frames = beam_sprite_frame
	bolt_attack_module.beam_is_timebound = true
	bolt_attack_module.beam_time_visible = 0.15
	
	bolt_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated")
	
	chaos_attack_modules.append(bolt_attack_module)
	
	
	# Sword related
	
	sword_attack_module = InstantDamageAttackModule_Scene.instance()
	sword_attack_module.base_damage_scale = 15
	sword_attack_module.base_damage = 20 / sword_attack_module.base_damage_scale
	sword_attack_module.base_damage_type = DamageType.PHYSICAL
	sword_attack_module.base_attack_speed = 0
	sword_attack_module.base_attack_wind_up = 0
	sword_attack_module.is_main_attack = false
	sword_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	sword_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	sword_attack_module.on_hit_damage_scale = 1
	sword_attack_module.range_module = orb_range_module
	sword_attack_module.benefits_from_bonus_attack_speed = false
	sword_attack_module.benefits_from_bonus_base_damage = true
	sword_attack_module.benefits_from_bonus_on_hit_damage = false
	sword_attack_module.benefits_from_bonus_on_hit_effect = false
	
	sword_attack_module.connect("in_attack", self, "_show_attack_sprite_on_attack")
	
	chaos_attack_modules.append(sword_attack_module)
	sword_attack_module.can_be_commanded_by_tower = false


# Takeover related

func takeover(tower):
	_construct_modules()
	
	tower_taken_over = tower
	
	replaced_main_attack_module = tower.main_attack_module
	tower.main_attack_module = null
	
	replaced_range_module = tower.range_module
	tower.range_module = sword_attack_module.range_module
	
	# ing related
	replaced_self_ingredient = tower.ingredient_of_self
	
	var tower_base_effect = get_script().new()
	var ing_effect = load("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd").new(CHAOS_TOWER_ID, tower_base_effect)
	tower.ingredient_of_self = ing_effect
	
	tower.add_child(_construct_chaos_shadow())
	
	for module in tower.all_attack_modules:
		if module.module_id == StoreOfAttackModuleID.MAIN or module.module_id == StoreOfAttackModuleID.PART_OF_SELF:
			replaced_attack_modules.append(module)
			module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.CHAOS_TAKEOVER)
	
	
	for module in chaos_attack_modules:
		tower.add_attack_module(module)


func _construct_chaos_shadow():
	chaos_shadow_anim_sprite = AnimatedSprite.new()
	chaos_shadow_anim_sprite.frames = SpriteFrames.new()
	chaos_shadow_anim_sprite.frames.add_frame("default", ChaosBase01_pic)
	chaos_shadow_anim_sprite.frames.add_frame("default", ChaosBase02_pic)
	chaos_shadow_anim_sprite.frames.add_frame("default", ChaosBase03_pic)
	chaos_shadow_anim_sprite.frames.add_frame("default", ChaosBase04_pic)
	chaos_shadow_anim_sprite.frames.add_frame("default", ChaosBase05_pic)
	chaos_shadow_anim_sprite.frames.set_animation_speed("default", 20)
	chaos_shadow_anim_sprite.playing = true
	chaos_shadow_anim_sprite.self_modulate.a = 0.4
	chaos_shadow_anim_sprite.position.y -= 12
	
	return chaos_shadow_anim_sprite


func untakeover(tower):
	tower.range_module = replaced_range_module
	tower.main_attack_module = replaced_main_attack_module
	
	tower.ingredient_of_self = replaced_self_ingredient
	
	if chaos_shadow_anim_sprite != null:
		tower.remove_child(chaos_shadow_anim_sprite)
		chaos_shadow_anim_sprite.queue_free()
	
	for module in replaced_attack_modules:
		if module != null:
			module.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.CHAOS_TAKEOVER)
			
			if module.range_module == sword_attack_module.range_module or module.range_module == null:
				module.range_module = replaced_range_module
	
	for module in chaos_attack_modules:
		if module != null:
			tower.remove_attack_module(module)
			module.queue_free()
	


# Sword related

func _on_round_end():
	damage_accumulated = 0


func _add_damage_accumulated(damage_report, killed_enemy : bool, enemy, damage_register_id : int, module):
	damage_accumulated += damage_report.get_total_effective_damage()
	call_deferred("_check_damage_accumulated")

func _check_damage_accumulated():
	if damage_accumulated >= damage_accumulated_trigger:
		var success = sword_attack_module.attempt_find_then_attack_enemies(1)
		
		if success:
			damage_accumulated = 0

# Showing sword related

func _construct_attack_sprite_on_attack():
	return ChaosSword.instance()


func _show_attack_sprite_on_attack(_attk_speed_delay, enemies : Array):
	for enemy in enemies:
		if enemy != null:
			var sword = _construct_attack_sprite_on_attack()
			sword.global_position = enemies[0].global_position
			sword.playing = true
			
			tower_taken_over.get_tree().get_root().add_child(sword)
			break
