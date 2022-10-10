extends "res://TowerRelated/DamageAndSpawnables/BaseBullet.gd"

const Seeder_Stage01 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_ExplodingSeed_Stage0.png")
const Seeder_Stage02 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_ExplodingSeed_Stage1.png")
const Seeder_Stage03 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_ExplodingSeed_Stage2.png")
const Seeder_Stage04 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_ExplodingSeed_Stage3.png")

signal seed_to_explode(me)


const max_stage : int = 5
var stage : int = 1
var damage_reg_to_detect : int

var enemy_stuck_to

const max_lifetime_s = 6.0
var current_lifetime_s = max_lifetime_s

const bullet_attach_shift = Vector2(0, -10)


func _ready():
	var sf := SpriteFrames.new()
	sf.add_frame("default", Seeder_Stage01)
	sf.add_frame("default", Seeder_Stage02)
	sf.add_frame("default", Seeder_Stage03)
	sf.add_frame("default", Seeder_Stage04)
	
	bullet_sprite.frames = sf


func hit_by_enemy(enemy):
	enemy_stuck_to = enemy
	enemy.connect("reached_end_of_path", self, "_enemy_escaped", [], CONNECT_ONESHOT)
	enemy.connect("on_hit", self, "_enemy_hit")
	
	decrease_life_distance = false
	current_life_distance = 500
	direction_as_relative_location = Vector2(0, 0)
	speed = 0
	
	collision_layer = 0
	collision_mask = 0
	
	call_deferred("emit_signal", "hit_an_enemy", self)

func decrease_pierce(amount):
	pass # Do nothing: prevent queue freeing from parent func


func _enemy_escaped(enemy):
	emit_signal("seed_to_explode", self)

func _process(delta):
	if is_instance_valid(enemy_stuck_to):
		global_position = (enemy_stuck_to.global_position + bullet_attach_shift)
	
	current_lifetime_s -= delta
	
	if current_lifetime_s <= 0:
		emit_signal("seed_to_explode", self)


func _enemy_hit(bullet, damage_reg_id, damage_instance):
	if damage_reg_id == damage_reg_to_detect:
		stage += 1
		if stage >= max_stage:
			emit_signal("seed_to_explode", self)
		else:
			_update_looks_based_on_stage()


func _update_looks_based_on_stage():
	bullet_sprite.frame = stage - 1
