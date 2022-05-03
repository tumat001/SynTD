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

const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

var lock_on_sprites_to_enemy : Dictionary = {}
var rotational_speed : int

const EnemyClearAllEffects = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyClearAllEffects.gd")

var re_attack_module : InstantDamageAttackModule
var re_range_module : RangeModule
var original_damage_type : int

var old_attack_module_damage_type : int

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.RE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 18
	
	re_range_module = range_module
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 18
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = true
	
	attack_module.burst_amount = 3
	attack_module.burst_attack_speed = 5
	attack_module.has_burst = true
	
	attack_module.connect("in_attack_windup", self, "_show_lock_ons", [], CONNECT_PERSIST)
	attack_module.connect("in_attack", self, "_relock_lock_ons", [], CONNECT_PERSIST)
	attack_module.connect("in_attack_end", self, "_kill_and_reset_lock_ons", [], CONNECT_PERSIST)
	attack_module.connect("in_attack", self, "_show_attack_sprite_on_attack", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	original_damage_type = info.base_damage_type
	re_attack_module = attack_module
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	var enemy_effect : EnemyClearAllEffects = EnemyClearAllEffects.new(StoreOfEnemyEffectsUUID.RE_CLEAR_EFFECT)
	var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.RE_CLEAR_EFFECTS)
	
	add_tower_effect(tower_effect)



# Attack sprite related

func _construct_attack_sprite_on_attack():
	return ReHitParticle_Scene.instance()


func _show_attack_sprite_on_attack(_attk_speed_delay, enemies : Array):
	for enemy in enemies:
		if enemy != null:
			enemy.add_child(_construct_attack_sprite_on_attack())

# Lock on related

func _process(delta):
	
	if lock_on_sprites_to_enemy.size() > 0:
		
		if rotational_speed < 40 * (main_attack_module.last_calculated_final_attk_speed / 2):
			rotational_speed += 90 * delta
		
		for sprite in lock_on_sprites_to_enemy.keys():
			if sprite != null:
				sprite.scale *= 1.007
				sprite.rotation_degrees += rotational_speed
	else:
		rotational_speed = 0

func _construct_lock_on_sprites():
	var attack_sprite = AttackSprtie_Scene.instance()
	attack_sprite.frames = SpriteFrames.new()
	attack_sprite.frames.add_frame("default", Re_lockon_sprite)
	attack_sprite.has_lifetime = true
	attack_sprite.lifetime = main_attack_module._last_calculated_attack_wind_up
	attack_sprite.scale = Vector2(1, 1)
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


# energy module related

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Re gain Random targeting option.",
			"All of Re's outgoing damage is converted to Pure damage."
		]


func _module_turned_on(_first_time_per_round : bool):
	re_range_module.add_targeting_option(Targeting.RANDOM)
	
	for module in all_attack_modules:
		if !module.is_connected("on_damage_instance_constructed", self, "_convert_all_damage_type_to_pure"):
			module.connect("on_damage_instance_constructed", self, "_convert_all_damage_type_to_pure", [], CONNECT_PERSIST)
	
	if !is_connected("attack_module_added", self, "_attack_module_attached"):
		connect("attack_module_added", self, "_attack_module_attached", [], CONNECT_PERSIST)
		connect("attack_module_removed", self, "_attack_module_detached", [], CONNECT_PERSIST)


func _module_turned_off():
	re_range_module.remove_targeting_option(Targeting.RANDOM)
	
	for module in all_attack_modules:
		if module.is_connected("on_damage_instance_constructed", self, "_convert_all_damage_type_to_pure"):
			module.disconnect("on_damage_instance_constructed", self, "_convert_all_damage_type_to_pure")
	
	if is_connected("attack_module_added", self, "_attack_module_attached"):
		disconnect("attack_module_added", self, "_attack_module_attached")
		disconnect("attack_module_removed", self, "_attack_module_detached")



func _attack_module_detached(attack_module : AbstractAttackModule):
	if energy_module != null:
		if attack_module.is_connected("on_damage_instance_constructed", self, "_convert_all_damage_type_to_pure"):
			attack_module.disconnect("on_damage_instance_constructed", self, "_convert_all_damage_type_to_pure")
	


func _attack_module_attached(attack_module : AbstractAttackModule):
	if attack_module == main_attack_module:
		if energy_module != null and energy_module.is_turned_on:
			if !attack_module.is_connected("on_damage_instance_constructed", self, "_convert_all_damage_type_to_pure"):
				attack_module.connect("on_damage_instance_constructed", self, "_convert_all_damage_type_to_pure", [], CONNECT_PERSIST)



func _convert_all_damage_type_to_pure(damage_instance : DamageInstance, module):
	for on_hit_dmg in damage_instance.on_hit_damages.values():
		on_hit_dmg.damage_type = DamageType.PURE
