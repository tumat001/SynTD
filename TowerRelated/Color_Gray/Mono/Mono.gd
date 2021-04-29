extends "res://TowerRelated/AbstractTower.gd"

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.MONO)
	
	tower_id = Towers.MONO
	base_damage = info.base_damage
	base_damage_type = info.base_damage_type
	base_attack_speed = info.base_attk_speed
	base_range_radius = info.base_range
	base_pierce = info.base_pierce
	base_proj_speed = 600
	base_on_hit_damage_internal_name = "mono_base_damage"
	
	$TowerBase.z_index = 1
	
	tower_highlight_sprite = info.tower_image_in_buy_card
	
	_post_inherit_ready()

#LEGACY. REMOVE/REPLACE THIS SOON
func _attack_at_position(position_arg):
	var angle = ._get_angle(position_arg.x, position_arg.y)

	#Instance a bullet for now, but soon, pull from pool instead
	var new_bullet = BulletMetadata.generic_bullet_scene.instance()

	new_bullet.set_bullet_type("bullet_mono")
	new_bullet.on_hit_damages = get_all_on_hit_damages()
	new_bullet.pierce = calculate_final_pierce()
	new_bullet.direction_as_relative_location = Vector2(position_arg.x - position.x, position_arg.y - position.y).normalized()
	new_bullet.speed = calculate_final_proj_speed()
	new_bullet.life_distance = calculate_final_life_distance()
	new_bullet.current_life_distance = new_bullet.life_distance
	new_bullet.z_index = $TowerBase.z_index - 1
	add_child(new_bullet)

	._attack_at_position(position_arg)

