extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

const Solitar_MainProjPic = preload("res://TowerRelated/Color_Red/Solitar/Assets/Solitar_MainProj.png")
const Solitar_EmpProjPic = preload("res://TowerRelated/Color_Red/Solitar/Assets/Solitar_EmpProj.png")
const Solitar_OnHitPic_01 = preload("res://TowerRelated/Color_Red/Solitar/Assets/OnHitParticle/Solitar_OnHitParticle_01.png")
const Solitar_OnHitPic_02 = preload("res://TowerRelated/Color_Red/Solitar/Assets/OnHitParticle/Solitar_OnHitParticle_02.png")
const Solitar_OnHitPic_03 = preload("res://TowerRelated/Color_Red/Solitar/Assets/OnHitParticle/Solitar_OnHitParticle_03.png")
const Solitar_OnHitPic_04 = preload("res://TowerRelated/Color_Red/Solitar/Assets/OnHitParticle/Solitar_OnHitParticle_04.png")
const Solitar_OnHitPic_05 = preload("res://TowerRelated/Color_Red/Solitar/Assets/OnHitParticle/Solitar_OnHitParticle_05.png")
const Solitar_OnHitPic_06 = preload("res://TowerRelated/Color_Red/Solitar/Assets/OnHitParticle/Solitar_OnHitParticle_06.png")

const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")


const isolation_bonus_flat_dmg : float = 2.0
const isolation_dmg_type : int = DamageType.PURE
var _isolation_on_hit_dmg : OnHitDamage

const isolation_bonus_pierce : int = 1
const isolation_stun_duration : float = 1.0
var _isolation_stun_effect : EnemyStunEffect

const isolation_radius_seek : float = 30.0
const isolation_radius_seek_includes_invis_enemies : bool = true

const isolation_during_cast_clause : int = -10
const no_enemies_in_range_clause : int = -11

var isolation_ability : BaseAbility
var _can_cast_isolation_ability : bool
const isolation_cooldown : float = 8.0

const isolation_base_duration : float = 8.0
var isolation_duration_timer : TimerForTower
var _is_in_isolation : bool

var original_main_attk_module : BulletAttackModule

var isolation_hit_particle_attk_sprite_pool : AttackSpritePoolComponent
var isolation_multiple_trail_component : MultipleTrailsForNodeComponent
const trail_color : Color = Color(253/255.0, 78/255.0, 81/255.0, 0.65)
const base_trail_length : int = 4
const base_trail_width : int = 2


#
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SOLITAR)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 11
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 700 #625
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 11
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Solitar_MainProjPic)
	
	add_attack_module(attack_module)
	original_main_attk_module = attack_module
	
	#
	
	_construct_isolation_ability()
	_construct_attk_sprite_pools()
	_construct_trails_components()
	
	connect("on_round_end", self, "_on_round_end_s", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_entered", self, "_on_enemies_entered_range_module", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_on_enemies_exited_range_module", [], CONNECT_PERSIST)
	
	
	#
	
	_post_inherit_ready()



func _construct_isolation_ability():
	isolation_ability = BaseAbility.new()
	
	isolation_ability.is_timebound = true
	
	isolation_ability.set_properties_to_usual_tower_based()
	isolation_ability.tower = self
	
	isolation_ability.connect("updated_is_ready_for_activation", self, "_can_cast_isolation_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(isolation_ability, false)
	
	#
	
	isolation_duration_timer = TimerForTower.new()
	isolation_duration_timer.stop_on_round_end_instead_of_pause = true
	isolation_duration_timer.connect("timeout", self, "_on_isolation_duration_timer_timeout", [], CONNECT_PERSIST)
	isolation_duration_timer.set_tower_and_properties(self)
	isolation_duration_timer.one_shot = true
	add_child(isolation_duration_timer)
	
	
	var modi = FlatModifier.new(StoreOfEnemyEffectsUUID.SOLITAR_ISOLATION_ON_HIT_DMG)
	modi.flat_modifier = isolation_bonus_flat_dmg
	_isolation_on_hit_dmg = OnHitDamage.new(StoreOfEnemyEffectsUUID.SOLITAR_ISOLATION_ON_HIT_DMG, modi, isolation_dmg_type)
	
	_isolation_stun_effect = EnemyStunEffect.new(isolation_stun_duration, StoreOfEnemyEffectsUUID.SOLITAR_ISOLATION_STUN_EFFECT)


func _construct_attk_sprite_pools():
	isolation_hit_particle_attk_sprite_pool = AttackSpritePoolComponent.new()
	isolation_hit_particle_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	isolation_hit_particle_attk_sprite_pool.node_to_listen_for_queue_free = self
	isolation_hit_particle_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	isolation_hit_particle_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_isolation_hit_particle"

func _construct_trails_components():
	isolation_multiple_trail_component = MultipleTrailsForNodeComponent.new()
	isolation_multiple_trail_component.node_to_host_trails = self
	isolation_multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	isolation_multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_node", [], CONNECT_PERSIST)
	

#

func _on_isolation_duration_timer_timeout():
	_is_in_isolation = false
	
	if isolation_ability.activation_conditional_clauses.has_clause(isolation_during_cast_clause):
		var cd = _get_cd_to_use(isolation_cooldown)
		isolation_ability.on_ability_before_cast_start(cd)
		
		isolation_ability.start_time_cooldown(cd)
		
		isolation_ability.on_ability_after_cast_ended(cd)
		
		isolation_ability.activation_conditional_clauses.remove_clause(isolation_during_cast_clause)
		
	
	if is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_s"):
		disconnect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_s")
	
	if is_connected("on_main_attack_module_enemy_hit", self, "_on_non_bullet_main_attack_module_enemy_hit__during_isolation"):
		disconnect("on_main_attack_module_enemy_hit", self, "_on_non_bullet_main_attack_module_enemy_hit__during_isolation")

func _on_round_end_s():
	_on_isolation_duration_timer_timeout()

#

func _on_enemies_entered_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		isolation_ability.activation_conditional_clauses.remove_clause(no_enemies_in_range_clause)
		
		if !enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives", [], CONNECT_DEFERRED)

func _on_enemy_killed_with_no_more_revives(damage_instance_report, arg_enemy):
	if is_instance_valid(arg_enemy):
		_on_enemies_exited_range_module(arg_enemy, null, range_module)


func _on_enemies_exited_range_module(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		if range_module.get_enemy_in_range_count() == 0:
			isolation_ability.activation_conditional_clauses.attempt_insert_clause(no_enemies_in_range_clause)
		
		if enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives"):
			enemy.disconnect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_killed_with_no_more_revives")


func _can_cast_isolation_updated(arg_val):
	_can_cast_isolation_ability = arg_val
	_attempt_cast_isolation()

func _attempt_cast_isolation():
	if _can_cast_isolation_ability:
		_cast_isolation()

func _cast_isolation():
	_is_in_isolation = true
	
	isolation_ability.activation_conditional_clauses.attempt_insert_clause(isolation_during_cast_clause)
	isolation_duration_timer.start(isolation_base_duration)
	
	if is_instance_valid(main_attack_module):
		if main_attack_module is BulletAttackModule:
			if !is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_s"):
				connect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot_s")
		else:
			if !is_connected("on_main_attack_module_enemy_hit", self, "_on_non_bullet_main_attack_module_enemy_hit__during_isolation"):
				connect("on_main_attack_module_enemy_hit", self, "_on_non_bullet_main_attack_module_enemy_hit__during_isolation")

#

# during isolation
func _on_main_bullet_attack_module_before_bullet_is_shot_s(bullet : BaseBullet, attack_module):
	bullet.pierce += isolation_bonus_pierce
	isolation_multiple_trail_component.create_trail_for_node(bullet)
	
	if attack_module == original_main_attk_module:
		bullet.set_texture_as_sprite_frames(Solitar_EmpProjPic)
	
	bullet.connect("hit_an_enemy", self, "_on_main_attk_bullet_hit_enemy")

func _on_main_attk_bullet_hit_enemy(arg_bullet : BaseBullet, arg_enemy):
	if _if_enemy_is_isolated(arg_enemy):
		if !arg_enemy.is_connected("on_hit", self, "_on_main_attk_bullet_on_enemy_hit__during_isolation"):
			arg_enemy.connect("on_hit", self, "_on_main_attk_bullet_on_enemy_hit__during_isolation", [], CONNECT_ONESHOT)
	
	if arg_bullet.num_of_non_unique_enemy_hits >= 2 and !arg_bullet.damage_instance.on_hit_effects.has(_isolation_stun_effect.effect_uuid):
		arg_bullet.damage_instance.on_hit_effects[_isolation_stun_effect.effect_uuid] = _isolation_stun_effect._get_copy_scaled_by(isolation_ability.get_potency_to_use(last_calculated_final_ability_potency))

func _if_enemy_is_isolated(arg_enemy):
	var count : int = game_elements.enemy_manager.get_enemy_count_within_distance_of_enemy(arg_enemy, isolation_radius_seek, isolation_radius_seek_includes_invis_enemies)
	return count <= 1


func _on_main_attk_bullet_on_enemy_hit__during_isolation(arg_enemy, damage_reg_id, damage_instance):
	damage_instance.on_hit_damages[_isolation_on_hit_dmg.internal_id] = _isolation_on_hit_dmg
	_create_isolation_hit_particle_at_pos(arg_enemy.global_position)

func _create_isolation_hit_particle_at_pos(arg_pos):
	var particle = isolation_hit_particle_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	particle.lifetime = 0.25
	particle.frame = 0
	
	particle.global_position = arg_pos
	particle.visible = true


#

func _on_non_bullet_main_attack_module_enemy_hit__during_isolation(arg_enemy, damage_register_id, damage_instance, module):
	if _if_enemy_is_isolated(arg_enemy):
		damage_instance.on_hit_damages[_isolation_on_hit_dmg.internal_id] = _isolation_on_hit_dmg
		_create_isolation_hit_particle_at_pos(arg_enemy.global_position)

#

func _create_isolation_hit_particle():
	var particle = AttackSprite_Scene.instance()
	particle.modulate.a = 0.65
	
	particle.lifetime = 0.25
	particle.frames = _create_frames_for_isolation_hit_particle()
	particle.frames_based_on_lifetime = true
	particle.queue_free_at_end_of_lifetime = false
	
	return particle

func _create_frames_for_isolation_hit_particle():
	var frames = SpriteFrames.new()
	
	frames.add_frame("default", Solitar_OnHitPic_01)
	frames.add_frame("default", Solitar_OnHitPic_02)
	frames.add_frame("default", Solitar_OnHitPic_03)
	frames.add_frame("default", Solitar_OnHitPic_04)
	frames.add_frame("default", Solitar_OnHitPic_05)
	frames.add_frame("default", Solitar_OnHitPic_06)
	frames.set_animation_loop("default", false)
	
	return frames

func _trail_before_attached_to_node(arg_trail, node):
	arg_trail.max_trail_length = base_trail_length
	arg_trail.trail_color = trail_color
	arg_trail.width = base_trail_width



# HeatModule

func set_heat_module(module):
	module.heat_per_attack = 1
	.set_heat_module(module)

func _construct_heat_effect():
	var base_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_attr_mod.percent_amount = 50
	base_attr_mod.percent_based_on = PercentType.BASE
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED , base_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module.benefits_from_bonus_attack_speed:
			module.calculate_all_speed_related_attributes()
	
	emit_signal("final_attack_speed_changed")


