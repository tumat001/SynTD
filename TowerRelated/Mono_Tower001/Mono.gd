extends "res://TowerRelated/AbstractTower.gd"

const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var modifier : FlatModifier = FlatModifier.new("mono_base_damage")
	modifier.flat_modifier = 3

	base_on_hit_damage = OnHitDamage.new("mono_base_damage", modifier, DamageType.PHYSICAL)
	base_attack_speed = 0.75
	base_range_radius = 200
	base_pierce = 1
	base_proj_speed = 600
	base_proj_time = 0.27
	base_on_hit_damage_internal_name = "mono_base_damage"
	#Names do NOT have to be the same
	
	$TowerBase.z_index = 0
	$TowerBarrel.z_index = 2
	
	_update_detection_range()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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

func _rotate_barrel_to(position_arg):
	var angle = ._get_angle(position_arg.x, position_arg.y)
	
	$TowerBarrel.rotation_degrees = angle

func _update_detection_range():
	var final_range = calculate_final_range_radius()
	
	$Range/RangeShape.shape.set_deferred("radius", final_range)
	._update_detection_range()


func _on_Range_area_shape_entered(area_id, area, area_shape, self_shape):
	_on_enemy_enter_range(area.get_parent())


func _on_Range_area_shape_exited(area_id, area, area_shape, self_shape):
	if area != null:
		_on_enemy_leave_range(area.get_parent())


func _on_Mono_input_event(viewport, event, shape_idx):
	if  event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		pass
		#TODO Continue with drawing of tower range
