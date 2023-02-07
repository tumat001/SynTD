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

const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")



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

var trail_component_for_diamonds : MultipleTrailsForNodeComponent


const CHAOS_TOWER_ID = 703

const base_chaos_takeover_darksword_dmg_scale : float = 0.5
var _current_chaos_takeover_darksword_dmg_scale : float = base_chaos_takeover_darksword_dmg_scale

func _init().(EffectType.CHAOS_TAKEOVER, StoreOfTowerEffectsUUID.ING_CHAOS):
	_update_desc_of_takeover()
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Chaos.png")
	
	_can_be_scaled_by_yel_vio = true

func _update_desc_of_takeover():
	description = "Takeover: CHAOS replaces the tower's attacks, stats, range, and targeting with its own, however CHAOS's dark sword is only %s%% effective. CHAOS retains the tower's colors and absorbed ingredient effects. The tower's self ingredient is replaced to this.%s" % [str(_current_chaos_takeover_darksword_dmg_scale * _current_additive_scale * 100), _generate_desc_for_persisting_total_additive_scaling(true)]


func _construct_modules():
	for module in chaos_attack_modules:
		if is_instance_valid(module):
			module.queue_free()
	chaos_attack_modules.clear()
	
	# Orb's range module
	var orb_range_module = RangeModule_Scene.instance()
	orb_range_module.base_range_radius = 135
	#orb_range_module.all_targeting_options = [Targeting.RANDOM, Targeting.FIRST, Targeting.LAST]
	orb_range_module.set_terrain_scan_shape(CircleShape2D.new())
	orb_range_module.position.y += 22
	orb_range_module.add_targeting_option(Targeting.RANDOM)
	orb_range_module.set_current_targeting(Targeting.RANDOM)
	
	# Orb related
	var orb_attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	orb_attack_module.base_damage = 1.25
	orb_attack_module.base_damage_type = DamageType.PHYSICAL
	orb_attack_module.base_attack_speed = 1.25
	orb_attack_module.base_attack_wind_up = 0
	orb_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	orb_attack_module.is_main_attack = true
	orb_attack_module.base_pierce = 1
	orb_attack_module.base_proj_speed = 660 #550
	orb_attack_module.base_proj_life_distance = 135
	orb_attack_module.module_id = StoreOfAttackModuleID.MAIN
	orb_attack_module.position.y -= 22
	orb_attack_module.on_hit_damage_scale = 1
	orb_attack_module.benefits_from_bonus_attack_speed = true
	orb_attack_module.benefits_from_bonus_base_damage = true
	orb_attack_module.benefits_from_bonus_on_hit_damage = true
	orb_attack_module.benefits_from_bonus_on_hit_effect = true
	orb_attack_module.benefits_from_bonus_pierce = true
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	orb_attack_module.bullet_shape = bullet_shape
	orb_attack_module.bullet_scene = BaseBullet_Scene
	orb_attack_module.set_texture_as_sprite_frame(ChaosOrb_pic)
	
	orb_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated")
	orb_attack_module.connect("on_round_end", self, "_on_round_end")
	
	orb_attack_module.range_module = orb_range_module
	
	orb_attack_module.set_image_as_tracker_image(ChaosOrb_pic)
	
	chaos_attack_modules.append(orb_attack_module)
	
	
	# Diamond related
	var dia_range_module = RangeModule_Scene.instance()
	dia_range_module.base_range_radius = 135
	dia_range_module.set_terrain_scan_shape(CircleShape2D.new())
	dia_range_module.position.y += 22
	dia_range_module.can_display_range = false
	dia_range_module.clear_all_targeting()
	dia_range_module.add_targeting_option(Targeting.RANDOM)
	dia_range_module.set_current_targeting(Targeting.RANDOM)
	
	var diamond_attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	diamond_attack_module.base_damage_scale = 0.1
	diamond_attack_module.base_damage = 2 / diamond_attack_module.base_damage_scale
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
	diamond_attack_module.on_hit_damage_scale = 2
	diamond_attack_module.on_hit_effect_scale = 1
	diamond_attack_module.benefits_from_bonus_attack_speed = true
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
	
	diamond_attack_module.connect("on_post_mitigation_damage_dealt", self, "_add_damage_accumulated", [], CONNECT_PERSIST)
	diamond_attack_module.connect("after_bullet_is_shot", self, "_after_diamond_is_shot", [], CONNECT_PERSIST)
	
	diamond_attack_module.set_image_as_tracker_image(ChaosDiamond_pic)
	
	chaos_attack_modules.append(diamond_attack_module)
	
	
	# Bolt related
	var bolt_range_module = RangeModule_Scene.instance()
	bolt_range_module.base_range_radius = 135
	bolt_range_module.set_terrain_scan_shape(CircleShape2D.new())
	bolt_range_module.position.y += 22
	bolt_range_module.can_display_range = false
	bolt_range_module.clear_all_targeting()
	bolt_range_module.add_targeting_option(Targeting.RANDOM)
	bolt_range_module.set_current_targeting(Targeting.RANDOM)
	
	var bolt_attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	bolt_attack_module.base_damage_scale = 0.75
	bolt_attack_module.base_damage = 1 / bolt_attack_module.base_damage_scale
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
	
	bolt_attack_module.set_image_as_tracker_image(preload("res://TowerRelated/Color_Violet/Chaos/AMAssets/ChaosBolt_AttackModule_Icon.png"))
	
	chaos_attack_modules.append(bolt_attack_module)
	
	
	# Sword related
	
	sword_attack_module = InstantDamageAttackModule_Scene.instance()
	sword_attack_module.base_damage_scale = 10
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
	
	sword_attack_module.connect("on_enemy_hit", self, "_on_sword_attk_module_enemy_hit", [], CONNECT_PERSIST)
	sword_attack_module.connect("on_enemy_hit", self, "_on_sword_hit_enemy", [], CONNECT_PERSIST)
	
	chaos_attack_modules.append(sword_attack_module)
	sword_attack_module.can_be_commanded_by_tower = false
	
	sword_attack_module.set_image_as_tracker_image(preload("res://TowerRelated/Color_Violet/Chaos/AMAssets/ChaosSword_AttackModule_Icon.png"))
	
	#
	
	trail_component_for_diamonds = MultipleTrailsForNodeComponent.new()
	trail_component_for_diamonds.node_to_host_trails = tower_taken_over
	trail_component_for_diamonds.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	trail_component_for_diamonds.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_diamond", [], CONNECT_PERSIST)
	

#

func _after_diamond_is_shot(arg_diamond):
	trail_component_for_diamonds.create_trail_for_node(arg_diamond)

func _trail_before_attached_to_diamond(arg_trail, node):
	arg_trail.max_trail_length = 10
	arg_trail.trail_color = Color(109.0 / 255.0, 2 / 255.0, 217 / 255.0, 0.15)
	arg_trail.width = 4


# Takeover related

func takeover(tower):
	if tower.tower_id != CHAOS_TOWER_ID:
		tower_taken_over = tower
		
		_construct_modules()
		
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
			_attempt_set_module_to_uncommandable_by_tower(module)
		
		for module in chaos_attack_modules:
			tower.add_attack_module(module)
		
		if !tower.is_connected("attack_module_added", self, "_tower_added_attack_module"):
			tower.connect("attack_module_added", self, "_tower_added_attack_module", [], CONNECT_PERSIST)
			tower.connect("attack_module_removed", self, "_tower_removed_attack_module", [], CONNECT_PERSIST)
		
	else: # IF RECEIVING TOWER IS CHAOS
		tower._received_chaos_ing()
		



func _attempt_set_module_to_uncommandable_by_tower(module):
	if module.module_id == StoreOfAttackModuleID.MAIN or module.module_id == StoreOfAttackModuleID.PART_OF_SELF:
		replaced_attack_modules.append(module)
		module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.CHAOS_TAKEOVER)




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


#

func untakeover(tower):
	if tower.tower_id != CHAOS_TOWER_ID:
		if tower.is_connected("attack_module_added", self, "_tower_added_attack_module"):
			tower.disconnect("attack_module_added", self, "_tower_added_attack_module")
			tower.disconnect("attack_module_removed", self, "_tower_removed_attack_module")
		
		
		tower.range_module = replaced_range_module
		tower.main_attack_module = replaced_main_attack_module
		
		tower.ingredient_of_self = replaced_self_ingredient
		
		if is_instance_valid(chaos_shadow_anim_sprite):
			tower.remove_child(chaos_shadow_anim_sprite)
			chaos_shadow_anim_sprite.queue_free()
		
		for module in replaced_attack_modules:
			_attempt_set_attack_module_to_commandable_by_tower(module)
		
		for module in chaos_attack_modules:
			if is_instance_valid(module):
				tower.remove_attack_module(module)
				module.queue_free()
		
		
	else: # TOWER TO REMOVE FROM IS CHAOS
		tower._removed_chaos_ing()


func _attempt_set_attack_module_to_commandable_by_tower(module):
	if is_instance_valid(module):
		module.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.CHAOS_TAKEOVER)
		
		if module.range_module == sword_attack_module.range_module or !is_instance_valid(module.range_module):
			module.range_module = replaced_range_module



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

func _on_sword_attk_module_enemy_hit(enemy, damage_register_id, damage_instance, module):
	if is_instance_valid(enemy):
		var sword = _construct_attack_sprite_on_attack()
		sword.global_position = enemy.global_position
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(sword)
		sword.playing = true

#

func _on_sword_hit_enemy(enemy, damage_register_id, damage_instance, module):
	damage_instance.scale_only_damage_by(_current_chaos_takeover_darksword_dmg_scale * _current_additive_scale)

#

func _tower_added_attack_module(module):
	_attempt_set_module_to_uncommandable_by_tower(module)

func _tower_removed_attack_module(module):
	_attempt_set_attack_module_to_commandable_by_tower(module)

#

func _shallow_duplicate():
	var copy = get_script().new()
	_configure_copy_to_match_self(copy)
	
	return copy

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_desc_of_takeover()


func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	pass
	# NOTE: DO not do this since CHAOS's ing is passed around. Actually it's not implemented that way yet (self ing given is a new fresh copy), but if in case it becomes like that.
	#_current_chaos_takeover_darksword_dmg_scale *= _current_additive_scale
	#_current_additive_scale = 1
