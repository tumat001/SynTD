extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Wyvern_NormalProj = preload("res://TowerRelated/Color_Red/Wyvern/Assets/Wyvern_NormalProj.png")


signal on_current_fury_changed(new_fury_val)


const fury_to_damage_conversion_rate : float = 0.08
const min_fury_to_cast_fulminate : float = 10.0
var _current_fury : float

var fulminate_ability : BaseAbility
var fulminate_ability_activation_clause : ConditionalClauses
var can_cast_fulminate_ability : bool
const fulminate_base_cooldown : float = 18.0


var _below_min_fury_conditional_clause_id : int = -10

const base_fulminate_attack_count : int = 2
var _current_fulminate_attack_count : int
var _current_fulminate_bonus_damage : float
var fulminate_on_hit_dmg : OnHitDamage


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.WYVERN)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 10
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 670
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 10
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(6, 3)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Wyvern_NormalProj)
	
	add_attack_module(attack_module)
	
	#
	
	connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigated_dmg_dealt_w", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_w", [], CONNECT_PERSIST)
	connect("on_main_attack_module_damage_instance_constructed", self, "on_main_attack_module_damage_instance_constructed_w", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func construct_fulminate_ability():
	fulminate_ability = BaseAbility.new()
	
	fulminate_ability.is_timebound = true
	
	fulminate_ability.set_properties_to_usual_tower_based()
	fulminate_ability.tower = self
	
	fulminate_ability.connect("updated_is_ready_for_activation", self, "_can_cast_fulminate_updated", [], CONNECT_PERSIST)
	
	fulminate_ability_activation_clause = fulminate_ability.activation_conditional_clauses
	fulminate_ability_activation_clause.attempt_insert_clause(_below_min_fury_conditional_clause_id)
	
	register_ability_to_manager(fulminate_ability, false)

func _construct_fulminate_on_hit_dmg():
	var modi : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.WYVERN_FULMINATE_ON_HIT_DAMAGE)
	
	fulminate_on_hit_dmg = OnHitDamage.new(StoreOfTowerEffectsUUID.WYVERN_FULMINATE_ON_HIT_DAMAGE, modi, DamageType.PHYSICAL)


#

func _on_any_post_mitigated_dmg_dealt_w(damage_instance_report, killed, enemy, damage_register_id, module):
	set_current_fury_to(_current_fury + damage_instance_report.get_total_effective_damage())


func set_current_fury_to(new_val):
	_current_fury = new_val
	
	if _current_fury >= min_fury_to_cast_fulminate:
		fulminate_ability_activation_clause.remove_clause(_below_min_fury_conditional_clause_id)
	else:
		fulminate_ability_activation_clause.attempt_insert_clause(_below_min_fury_conditional_clause_id)
	
	emit_signal("on_current_fury_changed", _current_fury)

#

func _can_cast_fulminate_updated(can_cast):
	can_cast_fulminate_ability = can_cast
	_cast_fulminate()

func _cast_fulminate():
	_current_fulminate_attack_count += base_fulminate_attack_count
	_current_fulminate_bonus_damage = _current_fury * fury_to_damage_conversion_rate * last_calculated_final_ability_potency
	fulminate_on_hit_dmg.damage_as_modifier.flat_modifier = _current_fulminate_bonus_damage
	
	set_current_fury_to(0)


func on_main_attack_module_damage_instance_constructed_w(damage_instance, module):
	if _current_fulminate_attack_count > 0:
		_current_fulminate_attack_count -= 1
		damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.WYVERN_FULMINATE_ON_HIT_DAMAGE] = fulminate_on_hit_dmg



#

func _on_round_end_w():
	set_current_fury_to(0)

