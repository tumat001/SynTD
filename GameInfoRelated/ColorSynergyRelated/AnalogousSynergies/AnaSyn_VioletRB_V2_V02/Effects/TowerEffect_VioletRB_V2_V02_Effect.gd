extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const VioletRB_V02_ConeExplosion_0001 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0000.png")
const VioletRB_V02_ConeExplosion_0002 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0001.png")
const VioletRB_V02_ConeExplosion_0003 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0002.png")
const VioletRB_V02_ConeExplosion_0004 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0003.png")
const VioletRB_V02_ConeExplosion_0005 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0004.png")
const VioletRB_V02_ConeExplosion_0006 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0005.png")
const VioletRB_V02_ConeExplosion_0007 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0006.png")
const VioletRB_V02_ConeExplosion_0008 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0007.png")
const VioletRB_V02_ConeExplosion_0009 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0008.png")
const VioletRB_V02_ConeExplosion_0010 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0009.png")
const VioletRB_V02_ConeExplosion_0011 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0010.png")
const VioletRB_V02_ConeExplosion_0012 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0011.png")
const VioletRB_V02_ConeExplosion_0013 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0012.png")
const VioletRB_V02_ConeExplosion_0014 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0013.png")
const VioletRB_V02_ConeExplosion_0015 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0014.png")
const VioletRB_V02_ConeExplosion_0016 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0015.png")
const VioletRB_V02_ConeExplosion_0017 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0016.png")
const VioletRB_V02_ConeExplosion_0018 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0017.png")
const VioletRB_V02_ConeExplosion_0019 = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosion/VioletRBV02_ConeExplosion0018.png")

const VioletRB_V2_V02_ConeExplosionAMI = preload("res://GameInfoRelated/ColorSynergyRelated/AnalogousSynergies/AnaSyn_VioletRB_V2_V02/Assets/ConeExplosionAMA/VioletRB_V2_V02_ConeExplosionAMI.png")

const BulletAttackModule = preload("res://TowerRelated/Modules/BulletAttackModule.gd")

const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")
const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")


const beam_modulate__violet := Color(109/255.0, 2/255.0, 217/255.0, 0.7)
const beam_modulate__red := Color(217/255.0, 2/255.0, 6/255.0, 0.7)
const beam_modulate__blue := Color(27/255.0, 2/255.0, 218/255.0, 0.7)
var _current_beam_modulate : Color

var beam_multiple_trail_component : MultipleTrailsForNodeComponent
var id_for_beam_component : int

var base_trail_length__min : int = 4
var base_trail_length__max : int = 10

var base_trail_width__min : int = 2
var base_trail_width__max : int = 8


const cone_modulate__violet := Color(109/255.0, 2/255.0, 217/255.0, 0.7)
const cone_modulate__red := Color(217/255.0, 2/255.0, 6/255.0, 0.7)
const cone_modulate__blue := Color(27/255.0, 2/255.0, 218/255.0, 0.7)
var _current_cone_explosion_modulate : Color

var cone_explosion_dmg_percent_ratio : float
var cone_explosion_attack_module : AOEAttackModule
var cone_explosion_pierce : int
var cone_aoe_size : Vector2 = VioletRB_V02_ConeExplosion_0001.get_size()


var stacking_attk_speed_percent_amount : float
var stacking_attk_speed_percent_type : int
var _current_attk_speed_percent_amount : float

var stacking_base_dmg_percent_amount : float
var stacking_base_dmg_percent_type : int
var _current_base_dmg_percent_amount : float

var enhanced_main_attack_count : int
var _current_enhanced_main_attack_count : float  # intended to be float


var _use_pre_determined_angle_rad : bool
var _pre_determined_angle_rad_to_use_for_cone_explosion : float


var _total_attk_speed_effect : TowerAttributesEffect
var _total_base_damage_effect : TowerAttributesEffect


#

var time_of_buff : float
var _timer_for_buff : TimerForTower

var status_bar_icon_to_use : Texture

#

var _tower
var _effects_applied

#

func _init().(StoreOfTowerEffectsUUID.VIOLET_RB_V2_V02_EFFECT__GENERAL):
	pass
	

#####

func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_effects_applied:
		_effects_applied = true
		
		if !is_instance_valid(cone_explosion_attack_module):
			_construct_and_add_attk_module()
		
		_current_cone_explosion_modulate = _get_calculated_modulate_based_on_tower_colors(cone_modulate__violet, cone_modulate__red, cone_modulate__blue)
		_current_beam_modulate = _get_calculated_modulate_based_on_tower_colors(beam_modulate__violet, beam_modulate__red, beam_modulate__blue)
		
		_construct_beam_multiple_trail_component()
		_configure_beam_multiple_trail_component()
		_construct_and_add_effects()
	
	
	_timer_for_buff = TimerForTower.new()
	_timer_for_buff.one_shot = true
	_timer_for_buff.connect("timeout", self, "_on_timer_for_buff_timeout", [], CONNECT_PERSIST)
	tower.add_child(_timer_for_buff)
	_timer_for_buff.set_tower_and_properties(tower)
	

func _construct_and_add_attk_module():
	cone_explosion_attack_module = AOEAttackModule_Scene.instance()
	cone_explosion_attack_module.base_damage_scale = 1 #explosion_base_and_on_hit_damage_scale
	cone_explosion_attack_module.base_damage = 0
	cone_explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	cone_explosion_attack_module.base_attack_speed = 0
	cone_explosion_attack_module.base_attack_wind_up = 0
	cone_explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	cone_explosion_attack_module.is_main_attack = false
	cone_explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	cone_explosion_attack_module.on_hit_damage_scale = 1
	
	cone_explosion_attack_module.benefits_from_bonus_explosion_scale = false
	cone_explosion_attack_module.benefits_from_bonus_base_damage = false
	cone_explosion_attack_module.benefits_from_bonus_attack_speed = false
	cone_explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	cone_explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	#cone_explosion_attack_module.benefits_from_any_effect = false   # for some reason adding this causes it to not show up in the dmg tracker
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0001)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0002)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0003)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0004)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0005)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0006)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0007)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0008)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0009)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0010)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0011)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0012)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0013)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0014)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0015)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0016)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0017)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0018)
	sprite_frames.add_frame("default", VioletRB_V02_ConeExplosion_0019)
	
	
	cone_explosion_attack_module.aoe_sprite_frames = sprite_frames
	cone_explosion_attack_module.sprite_frames_only_play_once = true
	cone_explosion_attack_module.pierce = cone_explosion_pierce
	cone_explosion_attack_module.duration = 0.4
	cone_explosion_attack_module.initial_delay = 0.15
	cone_explosion_attack_module.damage_repeat_count = 1
	
	cone_explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.TRIANGLE
	cone_explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	cone_explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	cone_explosion_attack_module.can_be_commanded_by_tower = false
	
	cone_explosion_attack_module.set_image_as_tracker_image(VioletRB_V2_V02_ConeExplosionAMI)
	
	
	_tower.add_attack_module(cone_explosion_attack_module)


#

func _get_calculated_modulate_based_on_tower_colors(arg_color_for_vio, arg_color_for_red, arg_color_for_blue):
	var colors_to_use : Array = []
	
	if _tower.has_tower_color(TowerColors.VIOLET):
		colors_to_use.append(arg_color_for_vio)
	if _tower.has_tower_color(TowerColors.RED):
		colors_to_use.append(arg_color_for_red)
	if _tower.has_tower_color(TowerColors.BLUE):
		colors_to_use.append(arg_color_for_blue)
	
	if colors_to_use.size() == 0:
		colors_to_use.append(arg_color_for_vio)
	
	var total_color = colors_to_use[0]
	for i in colors_to_use.size():
		if i == 0:
			break
		else:
			total_color += colors_to_use[i]
	
	
	return total_color / colors_to_use.size()


#

func _construct_beam_multiple_trail_component():
	beam_multiple_trail_component = MultipleTrailsForNodeComponent.new()
	beam_multiple_trail_component.node_to_host_trails = CommsForBetweenScenes.current_game_elements__other_node_hoster
	beam_multiple_trail_component.trail_type_id = StoreOfTrailType.BASIC_TRAIL
	

func _configure_beam_multiple_trail_component():
	beam_multiple_trail_component.connect("on_trail_before_attached_to_node", self, "_on_trail_before_attached_to_node", [], CONNECT_PERSIST)


func _on_trail_before_attached_to_node(arg_trail, arg_node):
	var curr_length : int = base_trail_length__min + (base_trail_length__max - base_trail_length__min) * (1 - (_current_enhanced_main_attack_count / enhanced_main_attack_count))
	var curr_width : int = base_trail_width__min + (base_trail_width__max - base_trail_width__min) * (1 - (_current_enhanced_main_attack_count / enhanced_main_attack_count))
	
	arg_trail.max_trail_length = curr_length
	arg_trail.width = curr_width
	
	arg_trail.trail_color = _current_beam_modulate
	

func _unconfigure_beam_multiple_trail_component():
	beam_multiple_trail_component.disconnect("on_trail_before_attached_to_node", self, "_on_trail_before_attached_to_node")


##########

func activate_effects_of_barrage():
	_current_enhanced_main_attack_count += enhanced_main_attack_count
	
	if !_tower.is_connected("on_main_attack", self, "_on_main_attack"):
		_tower.connect("on_main_attack", self, "_on_main_attack")
	
	if is_instance_valid(_tower.main_attack_module) and _tower.main_attack_module is BulletAttackModule:
		if !_tower.is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot__for_beam_formation"):
			_tower.connect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot__for_beam_formation")
	
	
	_tower.status_bar.add_status_icon(effect_uuid, status_bar_icon_to_use)
	_timer_for_buff.start(time_of_buff)

func _on_main_attack(attk_speed_delay, enemies, module):
	_current_enhanced_main_attack_count -= 1
	
	if _current_enhanced_main_attack_count == 0:
		if _tower.is_connected("on_main_attack", self, "_on_main_attack"):
			_tower.disconnect("on_main_attack", self, "_on_main_attack")
		
		
		if is_instance_valid(_tower.main_attack_module):
			
			if _tower.main_attack_module is ArcingBulletAttackModule:
				if !_tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt"):
					_tower.connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt")
				
			else:
				if !_tower.is_connected("on_main_post_mitigation_damage_dealt", self, "_on_main_post_mitigation_damage_dealt"):
					_tower.connect("on_main_post_mitigation_damage_dealt", self, "_on_main_post_mitigation_damage_dealt")
				
			
			#
			
			if _tower.main_attack_module is BulletAttackModule:
				if !_tower.is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot"):
					_tower.connect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot", [], CONNECT_ONESHOT)
			
		
		_set_stacking_attk_speed_effect_amount(0)
		
	else:
		
		_set_stacking_attk_speed_effect_amount(_current_attk_speed_percent_amount + stacking_attk_speed_percent_amount)
		_set_stacking_base_dmg_effect_amount(_current_base_dmg_percent_amount + stacking_base_dmg_percent_amount)
		
		if _tower.is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot"):
			_tower.disconnect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot")



func _on_any_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	_on_main_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module)
	

func _on_main_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	var angle_to_use
	
	if _use_pre_determined_angle_rad:
		angle_to_use = _pre_determined_angle_rad_to_use_for_cone_explosion
	else:
		angle_to_use = _tower.global_position.angle_to_point(enemy.global_position)
		#angle_to_use = enemy.global_position.
	
	_create_cone_aoe__with_properties(enemy.global_position, angle_to_use, damage_instance_report.get_dmg_instance().get_copy_scaled_by(1), enemy)
	end_effects_of_barrage()

func _on_main_bullet_attack_module_before_bullet_is_shot(arg_bullet, arg_module):
	_use_pre_determined_angle_rad = true
	_pre_determined_angle_rad_to_use_for_cone_explosion = arg_bullet.direction_as_relative_location.angle() + PI

func _on_main_bullet_attack_module_before_bullet_is_shot__for_beam_formation(arg_bullet, arg_module):
	beam_multiple_trail_component.create_trail_for_node(arg_bullet)



func _create_cone_aoe__with_properties(arg_pos, arg_angle_in_rad, arg_unscaled_dmg_instance, enemy):
	var aoe = cone_explosion_attack_module.construct_aoe(arg_pos, arg_pos)
	aoe.coll_shape_triangle_x_and_y_size = cone_aoe_size
	aoe.center_left_tipped_triangle_tip_pos__in_pos(arg_pos, arg_angle_in_rad)
	aoe.modulate = _current_cone_explosion_modulate
	
	aoe.scale *= 2.0 #1.5
	
	#aoe.enemies_to_ignore.append(enemy)
	
	var scaled_dmg_instance = arg_unscaled_dmg_instance
	scaled_dmg_instance.final_damage_multiplier = cone_explosion_dmg_percent_ratio
	aoe.damage_instance = scaled_dmg_instance
	
	cone_explosion_attack_module.set_up_aoe__add_child_and_emit_signals(aoe)


func end_effects_of_barrage():
	if _tower.is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot"):
		_tower.disconnect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot")
	
	if _tower.is_connected("on_main_post_mitigation_damage_dealt", self, "_on_main_post_mitigation_damage_dealt"):
		_tower.disconnect("on_main_post_mitigation_damage_dealt", self, "_on_main_post_mitigation_damage_dealt")
	
	if _tower.is_connected("on_main_attack", self, "_on_main_attack"):
		_tower.disconnect("on_main_attack", self, "_on_main_attack")
	
	if _tower.is_connected("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot__for_beam_formation"):
		_tower.disconnect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_on_main_bullet_attack_module_before_bullet_is_shot__for_beam_formation")
	
	if _tower.is_connected("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt"):
		_tower.disconnect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_mitigation_damage_dealt")
	
	
	_current_enhanced_main_attack_count = 0
	
	_set_stacking_attk_speed_effect_amount(0)
	_set_stacking_base_dmg_effect_amount(0)
	
	_timer_for_buff.stop()
	_tower.status_bar.remove_status_icon(effect_uuid)


#

func _set_stacking_attk_speed_effect_amount(arg_amount):
	_total_attk_speed_effect.attribute_as_modifier.percent_amount = arg_amount
	_current_attk_speed_percent_amount = arg_amount
	_tower.recalculate_final_attack_speed()

func _set_stacking_base_dmg_effect_amount(arg_amount):
	_total_base_damage_effect.attribute_as_modifier.percent_amount = arg_amount
	_current_base_dmg_percent_amount = arg_amount
	_tower.recalculate_final_base_damage()



func _construct_and_add_effects():
	var total_attk_speed_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.VIOLET_RB_V2_V02_EFFECT__ATTK_SPEED_EFFECT)
	total_attk_speed_modi.percent_amount = 0
	total_attk_speed_modi.ignore_flat_limits = true
	total_attk_speed_modi.percent_based_on = stacking_attk_speed_percent_type
	
	_total_attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, total_attk_speed_modi, StoreOfTowerEffectsUUID.VIOLET_RB_V2_V02_EFFECT__ATTK_SPEED_EFFECT)
	_total_attk_speed_effect.is_timebound = false
	
	
	var total_base_damage_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.VIOLET_RB_V2_V02_EFFECT__BASE_DMG_EFFECT)
	total_base_damage_modi.percent_amount = 0
	total_base_damage_modi.ignore_flat_limits = true
	total_base_damage_modi.percent_based_on = stacking_base_dmg_percent_type
	
	_total_base_damage_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_DAMAGE_BONUS, total_base_damage_modi, StoreOfTowerEffectsUUID.VIOLET_RB_V2_V02_EFFECT__BASE_DMG_EFFECT)
	_total_base_damage_effect.is_timebound = false
	
	
	_tower.add_tower_effect(_total_attk_speed_effect)
	_tower.add_tower_effect(_total_base_damage_effect)

func _remove_effects():
	_tower.remove_tower_effect(_total_attk_speed_effect)
	_tower.remove_tower_effect(_total_base_damage_effect)


###

func _on_timer_for_buff_timeout():
	end_effects_of_barrage()
	

#######

func _undo_modifications_to_tower(tower):
	if _effects_applied:
		
		if is_instance_valid(cone_explosion_attack_module):
			_tower.remove_attack_module(cone_explosion_attack_module)
			cone_explosion_attack_module.queue_free()
			cone_explosion_attack_module = null
		
		end_effects_of_barrage()
		_remove_effects()
		
		_unconfigure_beam_multiple_trail_component()
	
	if is_instance_valid(_timer_for_buff) and !_timer_for_buff.is_queued_for_deletion():
		_timer_for_buff.queue_free()
