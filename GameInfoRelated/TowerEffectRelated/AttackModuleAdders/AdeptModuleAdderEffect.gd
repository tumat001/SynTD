extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerAttackModuleAdderEffect.gd"

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

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


func _init().(StoreOfTowerEffectsUUID.ING_ADEPT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Adeptling.png")
	description = "Adeptling: Summons an adeptling beside your tower. Adeptling attacks a different target when its tower hits its main attack. Its shots deal 2 physical damage and applies on hit effects. Benefits from base damage and on hit damage buffs at 15% efficiency."


func _make_modifications_to_tower(tower):
	if adeptling_am == null:
		_construct_attack_module()
		tower.add_attack_module(adeptling_am)
	
	if !tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy"):
		tower.connect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy", [], CONNECT_PERSIST)



func _construct_attack_module():
	adeptling_am = WithBeamInstantDamageAttackModule_Scene.instance()
	adeptling_am.base_damage_scale = 0.15
	adeptling_am.base_damage = 2 / adeptling_am.base_damage_scale
	adeptling_am.base_damage_type = DamageType.PHYSICAL
	adeptling_am.base_attack_speed = 0
	adeptling_am.base_attack_wind_up = 1 / 0.15
	adeptling_am.is_main_attack = false
	adeptling_am.module_id = StoreOfAttackModuleID.PART_OF_SELF
	adeptling_am.position.y -= 10
	adeptling_am.position.x -= 20
	adeptling_am.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	adeptling_am.on_hit_damage_scale = 0.15
	adeptling_am.on_hit_effect_scale = 1
	
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
	
	var sprite : Sprite = Sprite.new()
	sprite.texture = Adeptling_Pic
	adeptling_am.add_child(sprite)


func _on_tower_main_attack_hit_enemy(enemy, damage_register_id, damage_instance, am):
	if am != null and am.range_module != null:
		var enemies = am.range_module.get_targets(2)
		
		if enemies.size() == 2:
			call_deferred("_attack_secondary_target", enemies[1])

func _attack_secondary_target(enemy):
	if enemy != null and adeptling_am != null:
		adeptling_am.on_command_attack_enemies_and_attack_when_ready([enemy], 1)



func _undo_modifications_to_tower(tower):
	if adeptling_am != null:
		tower.remove_attack_module(adeptling_am)
		adeptling_am.queue_free()
		adeptling_am = null
	
	if tower.is_connected("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy"):
		tower.disconnect("on_main_attack_module_enemy_hit", self, "_on_tower_main_attack_hit_enemy")
