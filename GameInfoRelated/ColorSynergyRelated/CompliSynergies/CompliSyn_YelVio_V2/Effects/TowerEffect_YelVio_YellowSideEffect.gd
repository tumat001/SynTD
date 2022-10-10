extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const StatusBar_Icon = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YelVio_YellowSide_StatusBarIcon.png")
const Border_YelVio = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/ModifierAssets/YelVio_IngIconBorder.png")

const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")
const ArcingBaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")

const YellowSide_AttackModuleIcon = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_Explosion_AttackModuleIcon.png")
const YellowSide_ArcBullet_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_ArcBullet.png")
const YellowSide_Explosion01 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_Explosion_01.png")
const YellowSide_Explosion02 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_Explosion_02.png")
const YellowSide_Explosion03 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_Explosion_03.png")
const YellowSide_Explosion04 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_Explosion_04.png")
const YellowSide_Explosion05 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_Explosion_05.png")
const YellowSide_Explosion06 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_Explosion_06.png")
const YellowSide_Explosion07 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_Explosion_07.png")
const YellowSide_Explosion08 = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/Assets/YellowSide_Attks/YellowSide_Explosion_08.png")


var _attached_tower
var explosion_base_damage : int = 0
var explosion_pierce : int = 3

var _lob_attack_module : ArcingBulletAttackModule
var _explosion_attack_module : AOEAttackModule

var _yelvio_synergy

var _current_yel_side_shell_id : int
var _is_in_firing : bool

var yel_shell_trail_component : MultipleTrailsForNodeComponent

const base_trail_length : float = 12.0
const base_trail_width : float = 5.0
const trail_color : Color = Color(233/255.0, 1, 0, 0.7)

func _init().(StoreOfTowerEffectsUUID.YELVIO_YELLOW_SIDE_EFFECT):
	status_bar_icon = StatusBar_Icon
	


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	if !is_instance_valid(_lob_attack_module):
		_construct_lob_attack_module(0)
		_construct_explosion_attk_module(0)
		
		_attached_tower.add_attack_module(_lob_attack_module)
		_attached_tower.add_attack_module(_explosion_attack_module)
	
	if yel_shell_trail_component == null:
		yel_shell_trail_component = MultipleTrailsForNodeComponent.new()
		yel_shell_trail_component.node_to_host_trails = _attached_tower
		yel_shell_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
		yel_shell_trail_component.connect("on_trail_before_attached_to_node", self, "_trail_before_attached_to_yel_shell", [], CONNECT_PERSIST)
	

func _construct_lob_attack_module(arg_y_shift : float):
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = 0
	proj_attack_module.base_damage_type = DamageType.ELEMENTAL
	proj_attack_module.base_attack_speed = 0
	proj_attack_module.base_attack_wind_up = 0
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = false
	proj_attack_module.base_pierce = 0
	proj_attack_module.base_proj_speed = 0.55
	proj_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	proj_attack_module.on_hit_damage_scale = 0
	
	proj_attack_module.benefits_from_bonus_base_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proj_attack_module.position.y -= arg_y_shift
	
	proj_attack_module.bullet_scene = ArcingBaseBullet_Scene
	proj_attack_module.set_texture_as_sprite_frame(YellowSide_ArcBullet_Pic)
	
	proj_attack_module.max_height = 750
	proj_attack_module.bullet_rotation_per_second = 0
	
	proj_attack_module.can_be_commanded_by_tower = false
	proj_attack_module.is_displayed_in_tracker = false
	
	proj_attack_module.connect("before_bullet_is_shot", self, "_before_yel_arc_bullet_is_fired", [], CONNECT_PERSIST)
	
	_lob_attack_module = proj_attack_module


func _construct_explosion_attk_module(arg_y_shift_of_attk_module):
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = explosion_base_damage
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.position.y -= arg_y_shift_of_attk_module
	explosion_attack_module.base_explosion_scale = 2
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", YellowSide_Explosion01)
	sprite_frames.add_frame("default", YellowSide_Explosion02)
	sprite_frames.add_frame("default", YellowSide_Explosion03)
	sprite_frames.add_frame("default", YellowSide_Explosion04)
	sprite_frames.add_frame("default", YellowSide_Explosion05)
	sprite_frames.add_frame("default", YellowSide_Explosion06)
	sprite_frames.add_frame("default", YellowSide_Explosion07)
	sprite_frames.add_frame("default", YellowSide_Explosion08)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = explosion_pierce
	explosion_attack_module.duration = 0.32
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(YellowSide_AttackModuleIcon)
	
	_explosion_attack_module = explosion_attack_module

#

func connect_signals_with_syn(arg_syn):
	_yelvio_synergy = arg_syn
	
	_yelvio_synergy.connect("yel_side_fire_shell", self, "_on_yel_side_fire_shell", [], CONNECT_PERSIST)
	_yelvio_synergy.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)

func _on_yel_side_fire_shell(arg_enemy, arg_current_yel_side_shell_id, arg_is_refire : bool):
	if (arg_is_refire or !_is_in_firing) and _attached_tower.is_current_placable_in_map():
		_lob_attack_module.on_command_attack_enemies_and_attack_when_ready([arg_enemy])
		_is_in_firing = true

func _before_yel_arc_bullet_is_fired(arg_bullet : ArcingBaseBullet):
	arg_bullet.connect("on_final_location_reached", self, "_on_yel_arc_bullet_reached_location", [], CONNECT_ONESHOT)
	yel_shell_trail_component.create_trail_for_node(arg_bullet)

func _on_yel_arc_bullet_reached_location(arg_final_location : Vector2, bullet : ArcingBaseBullet):
	var explosion = _explosion_attack_module.construct_aoe(arg_final_location, arg_final_location)
	explosion.connect("tree_exiting", self, "_on_yel_explosion_queue_free", [explosion], CONNECT_ONESHOT)
	explosion.modulate.a = 0.55
	
	_explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)

func _on_yel_explosion_queue_free(arg_explosion):
	var requested_refire : bool = false
	if is_instance_valid(_attached_tower) and arg_explosion.enemy_hit_count <= 1:
		if _attached_tower.game_elements.stage_round_manager.round_started:
			_yelvio_synergy.request_refire_of_shell(_current_yel_side_shell_id)
			requested_refire = true
	
	if !requested_refire:
		_is_in_firing = false


func _on_round_end():
	_is_in_firing = false

#

func _trail_before_attached_to_yel_shell(arg_trail, arg_node):
	arg_trail.max_trail_length = base_trail_length
	arg_trail.trail_color = trail_color
	arg_trail.width = base_trail_width

##

func _undo_modifications_to_tower(tower):
	if _lob_attack_module != null:
		_attached_tower.remove_attack_module(_lob_attack_module)
		_lob_attack_module.queue_free()
		
		_attached_tower.remove_attack_module(_explosion_attack_module)
		_explosion_attack_module.queue_free()
	
	_disconnect_signals_from_syn()

func _disconnect_signals_from_syn():
	if _yelvio_synergy.is_connected("yel_side_fire_shell", self, "_on_yel_side_fire_shell"):
		_yelvio_synergy.disconnect("yel_side_fire_shell", self, "_on_yel_side_fire_shell")
		_yelvio_synergy.disconnect("on_round_end", self, "_on_round_end")
