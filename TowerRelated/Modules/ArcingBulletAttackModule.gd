extends "res://TowerRelated/Modules/BulletAttackModule.gd"

const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")

var max_height : float
var collide_with_any : bool

func _ready():
	benefits_from_bonus_proj_speed = false

func _adjust_bullet_physics_settings(bullet : BaseBullet, arg_enemy_pos : Vector2, arg_ref_pos : Vector2 = global_position):
	if bullet is ArcingBaseBullet:
		bullet.speed = last_calculated_final_proj_speed
		bullet.max_height = max_height
		bullet.final_location = arg_enemy_pos
		bullet.collide_with_any = collide_with_any
		bullet.rotation_per_second = bullet_rotation_per_second

func construct_damage_instance():
	if !collide_with_any:
		return null
	else:
		return .construct_damage_instance()
