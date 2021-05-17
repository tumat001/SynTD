extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")

const Re_lockon_sprite = preload("res://TowerRelated/Color_Violet/Re/Re_Lockon_Particle.png")
const Re_hit_sprite = preload("res://TowerRelated/Color_Violet/Re/Re_Hit_Particle.png")

const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprtie_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")
const ReHitParticle_Scene = preload("res://TowerRelated/Color_Violet/Re/ReHitParticle.tscn")

var lock_on_sprites_to_enemy : Dictionary = {}
var rotational_speed : int


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.RE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1
	attack_module.is_main_attack = true
	attack_module.module_name = "Main"
	attack_module.position.y -= 18
	attack_module.base_on_hit_damage_internal_name = "name"
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.base_on_hit_affected_by_scale = false
	
	attack_module.burst_amount = 3
	attack_module.burst_attack_speed = 5
	attack_module.has_burst = true
	
	attack_module.connect("in_attack_windup", self, "_show_lock_ons")
	attack_module.connect("in_attack", self, "_relock_lock_ons")
	attack_module.connect("in_attack_end", self, "_kill_and_reset_lock_ons")
	attack_module.connect("in_attack", self, "_show_attack_sprite_on_attack")
	
	attack_modules_and_target_num[attack_module] = 1
	
	_post_inherit_ready()


func _construct_attack_sprite_on_attack():
	return ReHitParticle_Scene.instance()


func _show_attack_sprite_on_attack(attk_speed_delay, enemies : Array):
	for enemy in enemies:
		if enemy != null:
			enemy.add_child(_construct_attack_sprite_on_attack())



func _process(delta):
	
	if lock_on_sprites_to_enemy.size() > 0:
		
		if rotational_speed < 40 * (main_attack_module.last_calculated_final_attk_speed / 2):
			rotational_speed += 90 * delta
		
		for sprite in lock_on_sprites_to_enemy.keys():
			if sprite != null:
				sprite.scale *= 1.005
				sprite.rotation_degrees += rotational_speed
	else:
		rotational_speed = 0

func _construct_lock_on_sprites():
	var attack_sprite = AttackSprtie_Scene.instance()
	attack_sprite.frames = SpriteFrames.new()
	attack_sprite.frames.add_frame("default", Re_lockon_sprite)
	attack_sprite.has_lifetime = true
	attack_sprite.lifetime = main_attack_module._last_calculated_attack_wind_up
	attack_sprite.scale = Vector2(1.5, 1.5)
	attack_sprite.offset = Vector2(-0.5, -2)
	
	lock_on_sprites_to_enemy[attack_sprite] = null
	
	return attack_sprite


func _show_lock_ons(wind_up, enemies : Array):
	
	for enemy in enemies:
		if enemy != null:
			enemy.add_child(_construct_lock_on_sprites())
			 
			for lock_on in lock_on_sprites_to_enemy.keys():
				if lock_on != null and lock_on_sprites_to_enemy[lock_on] == null:
					lock_on_sprites_to_enemy[lock_on] = enemy
					break


func _relock_lock_ons(attk_speed_delay, enemies : Array):
	
	pass
	
#	for i in enemies.size() - lock_on_sprites_to_enemy.size():
#		_construct_lock_on_sprites()
#
#	var index = 0
#	for lock_on in lock_on_sprites_to_enemy.keys():
#		if lock_on != null and lock_on_sprites_to_enemy[lock_on] == null:
#			if enemies[index] != null:
#				lock_on_sprites_to_enemy[lock_on] = enemies[index]
#				enemies[index].add_child(lock_on)
#				index += 1


func _kill_and_reset_lock_ons():
	for sprite in lock_on_sprites_to_enemy.keys():
		if sprite != null:
			sprite.queue_free()
	
	lock_on_sprites_to_enemy.clear()


func _queue_free():
	lock_on_sprites_to_enemy.clear()
	
	._queue_free()
