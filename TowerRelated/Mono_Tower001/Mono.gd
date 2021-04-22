extends "res://TowerRelated/AbstractTower.gd"

const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.MONO)
	
	var modifier : FlatModifier = FlatModifier.new("mono_base_damage")
	modifier.flat_modifier = 3

	base_on_hit_damage = OnHitDamage.new("mono_base_damage", modifier, DamageType.PHYSICAL)
	base_attack_speed = info.base_attk_speed
	base_range_radius = info.base_range
	base_pierce = info.base_pierce
	base_proj_speed = 600
	base_proj_time = 0.27
	base_on_hit_damage_internal_name = "mono_base_damage"
	#Names do NOT have to be the same
	
	
	$TowerBase.z_index = 0
	$TowerBarrel.z_index = 2
	
	_post_inherit_ready()

func _attack_at_position(position_arg):
	var angle = ._get_angle(position_arg.x, position_arg.y)
	
	#Instance a bullet for now, but soon, pull from pool instead
	var new_bullet = BulletMetadata.generic_bullet_scene.instance()
	
	new_bullet.set_bullet_type("bullet_mono")
	new_bullet.on_hit_damages = get_all_on_hit_damages()
	new_bullet.pierce = calculate_final_pierce()
	new_bullet.direction_as_relative_location = Vector2(position_arg.x - position.x, position_arg.y - position.y).normalized()
	new_bullet.speed = calculate_final_proj_speed()
	new_bullet.lifetime = calculate_final_proj_time()
	new_bullet.current_lifetime = new_bullet.lifetime
	new_bullet.z_index = $TowerBarrel.z_index - 1
	add_child(new_bullet)
	
	._attack_at_position(position_arg)

