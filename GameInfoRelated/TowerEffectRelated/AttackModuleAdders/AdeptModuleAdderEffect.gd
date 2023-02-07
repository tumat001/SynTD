extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"


const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")


const DamageType = preload("res://GameInfoRelated/DamageType.gd")

const Adept_MiniBeam01_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam01.png")
const Adept_MiniBeam02_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam02.png")
const Adept_MiniBeam03_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam03.png")
const Adept_MiniBeam04_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam04.png")
const Adept_MiniBeam05_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam05.png")
const Adept_MiniBeam06_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam06.png")
const Adept_MiniBeam07_Pic = preload("res://TowerRelated/Color_Red/Adept/Adept_Attks/AdeptMini_Beam07.png")

const Adeptling_Pic = preload("res://TowerRelated/Color_Red/Adept/Adeptling.png")


var adeptling_am : WithBeamInstantDamageAttackModule

const _beam_cooldown : float = 0.1
var own_timer : Timer

var adepting_base_dmg : float = 2.5


func _init().(StoreOfTowerEffectsUUID.ING_ADEPT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Adeptling.png")
	
	_update_description()
	
	_can_be_scaled_by_yel_vio = true

func _update_description():
	# INS START
	
	var interpreter = TextFragmentInterpreter.new()
	interpreter.display_body = true
	interpreter.display_header = true
	
	var ins = []
	ins.append(NumericalTextFragment.new(adepting_base_dmg * _current_additive_scale, false, DamageType.PHYSICAL))

	interpreter.array_of_instructions = ins
	
	# INS END
	
	description = ["Adeptling: Summons an adeptling beside your tower. Main attacks cause Adeptling to attack a different target, with a cooldown of 0.1 seconds. Its shots deal |0| and apply on hit effects.%s" % [_generate_desc_for_persisting_total_additive_scaling()], [interpreter]]



func _make_modifications_to_tower(tower):
	if !is_instance_valid(adeptling_am):
		_construct_attack_module()
		tower.add_attack_module(adeptling_am)
	
	#if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy"):
	#	tower.connect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy", [], CONNECT_PERSIST)
	
	if !tower.is_connected("on_main_attack", self, "_on_tower_main_attack"):
		tower.connect("on_main_attack", self, "_on_tower_main_attack", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	if !is_instance_valid(own_timer):
		own_timer = Timer.new()
		own_timer.one_shot = true
		own_timer.wait_time = 0.1
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(own_timer)



func _construct_attack_module():
	adeptling_am = WithBeamInstantDamageAttackModule_Scene.instance()
	adeptling_am.base_damage_scale = 0.40
	adeptling_am.base_damage = adepting_base_dmg  / adeptling_am.base_damage_scale
	adeptling_am.base_damage_type = DamageType.PHYSICAL
	adeptling_am.base_attack_speed = 0
	adeptling_am.base_attack_wind_up = 1 / 0.15
	adeptling_am.is_main_attack = false
	adeptling_am.module_id = StoreOfAttackModuleID.PART_OF_SELF
	adeptling_am.position.y -= 14
	adeptling_am.position.x -= 24
	adeptling_am.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	adeptling_am.on_hit_damage_scale = 0.40
	adeptling_am.on_hit_effect_scale = 1
	
	adeptling_am.benefits_from_bonus_on_hit_effect = true
	adeptling_am.benefits_from_bonus_base_damage = false
	adeptling_am.benefits_from_bonus_on_hit_damage = false
	
	adeptling_am.commit_to_targets_of_windup = true
	adeptling_am.fill_empty_windup_target_slots = false
	adeptling_am.show_beam_at_windup = true
	
	var mini_beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam01_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam02_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam03_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam04_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam05_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam06_Pic)
	mini_beam_sprite_frame.add_frame("default", Adept_MiniBeam07_Pic)
	mini_beam_sprite_frame.set_animation_loop("default", false)
	mini_beam_sprite_frame.set_animation_speed("default", 7 / 0.15)
	
	adeptling_am.beam_scene = BeamAesthetic_Scene
	adeptling_am.beam_sprite_frames = mini_beam_sprite_frame
	adeptling_am.beam_is_timebound = true
	adeptling_am.beam_time_visible = 0.15
	
	adeptling_am.can_be_commanded_by_tower = false
	
	adeptling_am.set_image_as_tracker_image(Adeptling_Pic)
	
	var sprite : Sprite = Sprite.new()
	sprite.texture = Adeptling_Pic
	adeptling_am.add_child(sprite)

#

#func _on_tower_main_attack_hit_enemy(enemy, damage_register_id, damage_instance, am):
#	if am != null and am.range_module != null:
#		var enemies = am.range_module.get_targets_without_affecting_self_current_targets(2)
#
#		if enemies.size() == 2:
#			call_deferred("_attempt_command_am_to_attack", enemies[1])

func _on_tower_main_attack(attk_speed_delay, arg_enemies, am):
	if is_instance_valid(am) and is_instance_valid(am.range_module):
		var enemies = am.range_module.get_targets_without_affecting_self_current_targets(2)
		
		if enemies.size() == 2:
			call_deferred("_attempt_command_am_to_attack", enemies[1])




func _attempt_command_am_to_attack(enemy):
	if own_timer.time_left <= 0:
		_attack_secondary_target(enemy)
		own_timer.start(_beam_cooldown)

func _attack_secondary_target(enemy):
	if is_instance_valid(enemy) and is_instance_valid(adeptling_am):
		adeptling_am.on_command_attack_enemies_and_attack_when_ready([enemy], 1)



func _undo_modifications_to_tower(tower):
	if is_instance_valid(adeptling_am):
		tower.remove_attack_module(adeptling_am)
		adeptling_am.queue_free()
		adeptling_am = null
	
	#if tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy"):
	#	tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy")
	
	if tower.is_connected("on_main_attack", self, "_on_tower_main_attack"):
		tower.disconnect("on_main_attack", self, "_on_tower_main_attack")
	
	
	if is_instance_valid(own_timer):
		own_timer.queue_free()
		own_timer = null


#

func _shallow_duplicate():
	var copy = get_script().new()
	_configure_copy_to_match_self(copy)
	
	return copy

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	adepting_base_dmg *= _current_additive_scale
	_current_additive_scale = 1
