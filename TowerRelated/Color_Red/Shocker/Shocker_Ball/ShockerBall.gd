extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"

signal on_enemy_stucked_to_exiting(enemy)
signal on_enemy_hit(enemy)
signal on_position_changed(new_pos)

var offset_from_enemy : Vector2
var enemy_stuck_to


onready var bullet_sprite = $BulletSprite

func _ready():
	pass

# Enemy hit and pos related

func hit_by_enemy(enemy):
	if enemy_stuck_to == null:
		offset_from_enemy = global_position - enemy.global_position
		
		enemy_stuck_to = enemy
		decrease_life_distance = false
		current_life_distance = 500
		direction_as_relative_location = Vector2(0, 0)
		speed = 0
		
		collision_layer = 0
		collision_mask = 0
		
		call_deferred("emit_signal", "hit_an_enemy", self)
		enemy.connect("tree_exiting", self, "enemy_died", [enemy], CONNECT_ONESHOT)
		enemy.connect("on_hit", self, "enemy_hit", [], CONNECT_PERSIST)


func decrease_pierce(amount):
	pass # Do nothing: prevent queue freeing from parent func


func _physics_process(delta):
	if enemy_stuck_to != null:
		
		var curr_enemy_pos = enemy_stuck_to.global_position
		
		global_position = curr_enemy_pos + offset_from_enemy
		emit_signal("on_position_changed", global_position)

#

func enemy_died(enemy):
	emit_signal("on_enemy_stucked_to_exiting", enemy)


func enemy_hit(enemy, damage_reg_id, damage_instance):
	if !damage_instance.on_hit_damages.has(StoreOfTowerEffectsUUID.SHOCKER_SHOCK_BALL_MAIN_DAMAGE):
		emit_signal("on_enemy_hit", enemy)
