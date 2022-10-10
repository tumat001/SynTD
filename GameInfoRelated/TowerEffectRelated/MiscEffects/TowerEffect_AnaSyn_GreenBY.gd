extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")

const BigParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_GreenBY/Assets/BigParticle.tscn")
const TinyParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_GreenBY/Assets/TinyParticle.tscn")
const GreenBY_AuraParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_GreenBY/Assets/AuraParticle/GreenBY_AuraParticle.tscn")

var damage_per_tick : float
var max_damage : float
var seconds_per_tick : float

var _dmg_modi : FlatModifier
var _dmg_effect : TowerOnHitDamageAdderEffect
var _timer : Timer
var _attached_tower

var aura_particle

var misc_rng : RandomNumberGenerator

func _init().(StoreOfTowerEffectsUUID.GREEN_BY_SCALING_EFFECT_GIVER):
	pass

#

func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	misc_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	if _dmg_effect == null:
		_construct_effect()
		tower.add_tower_effect(_dmg_effect)
	
	if _timer == null:
		_construct_timer(tower)
	
	if !tower.is_connected("on_main_attack", self, "_on_main_attack"):
		tower.connect("on_main_attack", self, "_on_main_attack", [], CONNECT_PERSIST)
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)

#

func _construct_effect():
	_dmg_modi = FlatModifier.new(StoreOfTowerEffectsUUID.GREEN_BY_DAMAGE_EFFECT)
	
	var on_hit_dmg = OnHitDamage.new(StoreOfTowerEffectsUUID.GREEN_BY_DAMAGE_EFFECT, _dmg_modi, DamageType.ELEMENTAL)
	_dmg_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.GREEN_BY_DAMAGE_EFFECT)

func _construct_timer(tower):
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.wait_time = seconds_per_tick
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_timer)

#

func _on_main_attack(attk_speed_delay, enemies, module):
	if _timer.time_left <= 0.01: # a bit of forgiveness leyway
		_timer.start(seconds_per_tick)
		
		if _dmg_modi.flat_modifier < max_damage:
			_dmg_modi.flat_modifier += damage_per_tick
			
			if _dmg_modi.flat_modifier >= max_damage:
				_construct_and_show_max_particle_effect()
			else:
				_construct_and_show_inc_particle_effect()


func _on_round_end():
	_dmg_modi.flat_modifier = 0
	
	if is_instance_valid(aura_particle):
		aura_particle.queue_free()
	
	if is_instance_valid(_timer):
		_timer.start(0.1)


func _construct_and_show_inc_particle_effect():
	var particle = TinyParticle_Scene.instance()
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	
	particle.position = _attached_tower.global_position
	particle.position.x += misc_rng.randi_range(-4, 4)
	particle.position.y += misc_rng.randi_range(0, 8)
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)


func _construct_and_show_max_particle_effect():
	var particle = BigParticle_Scene.instance()
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	
	particle.position = _attached_tower.global_position
	particle.position.y -= 8
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)
	
	#
	
	aura_particle = GreenBY_AuraParticle_Scene.instance()
	aura_particle.size_adapting_to = _attached_tower
	aura_particle.adapt_ratio = 0.4
	aura_particle.position.y += (_attached_tower.get_current_anim_size().y / 2) - 3
	
	_attached_tower.add_child(aura_particle)

#

func _undo_modifications_to_tower(tower):
	if tower.is_connected("on_main_attack", self, "_on_main_attack"):
		tower.disconnect("on_main_attack", self, "_on_main_attack")
		tower.disconnect("on_round_end", self, "_on_round_end")
	
	_remove_effect_from_tower()
	
	if is_instance_valid(aura_particle):
		aura_particle.queue_free()
	
	if is_instance_valid(_timer): # if greenBY suddenly acts strangely, it might be because of this. Probably not tho (Oct 10 2022)
		_timer.queue_free()
	
	_attached_tower = null


func _remove_effect_from_tower():
	var effect = _attached_tower.get_tower_effect(StoreOfTowerEffectsUUID.GREEN_BY_DAMAGE_EFFECT)
	
	if effect != null:
		_attached_tower.remove_tower_effect(effect)
