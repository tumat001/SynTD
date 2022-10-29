extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")

const Transpose_Beam01 = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Beam/Transpose_Beam01.png")
const Transpose_Beam02 = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Beam/Transpose_Beam02.png")
const Transpose_Beam03 = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Beam/Transpose_Beam03.png")
const Transpose_Beam04 = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Beam/Transpose_Beam04.png")
const Transpose_Beam05 = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Beam/Transpose_Beam05.png")
const Transpose_Beam06 = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Beam/Transpose_Beam06.png")
const Transpose_Beam07 = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Beam/Transpose_Beam07.png")
const Transpose_Beam08 = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Beam/Transpose_Beam08.png")
const Transpose_Beam09 = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Beam/Transpose_Beam09.png")

const Transpose_AbilityIcon = preload("res://TowerRelated/Color_Blue/Transpose/AbilityAssets/Transpose_AbilityIcon.png")
const Transpose_AttkSpeed_StatusBarIcon = preload("res://TowerRelated/Color_Blue/Transpose/AbilityAssets/Transpose_AttkSpeed_StatusBarIcon.png")

const Transpose_Sprite_Scene = preload("res://TowerRelated/Color_Blue/Transpose/AbilityAssets/AbilitySprites/Transpose_Sprite.tscn")


const transpose_base_cooldown : float = 45.0
const transpose_base_ability_delay : float = 1.5

const transpose_buff_duration : float = 6.0
const transpose_base_attk_speed_amount : float = 50.0
const transpose_base_ability_potency_amount : float = 0.25

const transpose_is_in_delay_timeline_clause : int = -10

var transpose_ability : BaseAbility
var transpose_ability_activation_clauses : ConditionalClauses

var transpose_attk_speed_modi : PercentModifier
var transpose_attk_speed_effect : TowerAttributesEffect
var transpose_ability_potency_effect : TowerAttributesEffect

var transpose_delay_timer : Timer
var tower_info

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.TRANSPORTER)
	tower_info = info
	
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
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 3
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1.0 / 0.15
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 3
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.number_of_unique_targets = 2
	attack_module.position.y += 3
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Transpose_Beam01)
	beam_sprite_frame.add_frame("default", Transpose_Beam02)
	beam_sprite_frame.add_frame("default", Transpose_Beam03)
	beam_sprite_frame.add_frame("default", Transpose_Beam04)
	beam_sprite_frame.add_frame("default", Transpose_Beam05)
	beam_sprite_frame.add_frame("default", Transpose_Beam06)
	beam_sprite_frame.add_frame("default", Transpose_Beam07)
	beam_sprite_frame.add_frame("default", Transpose_Beam08)
	beam_sprite_frame.add_frame("default", Transpose_Beam09)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 9.0 / 0.15)
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.15
	attack_module.show_beam_at_windup = true
	
	add_attack_module(attack_module)
	
	#
	
	_construct_and_connect_ability()
	_construct_effect()
	
	connect("on_round_end", self, "_on_round_end_t", [], CONNECT_PERSIST)
	
	_post_inherit_ready()
	

#

func _construct_effect():
	transpose_attk_speed_modi = PercentModifier.new(StoreOfTowerEffectsUUID.TRANSPOSE_ATTK_SPEED)
	transpose_attk_speed_modi.percent_amount = transpose_base_attk_speed_amount
	
	transpose_attk_speed_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, transpose_attk_speed_modi, StoreOfTowerEffectsUUID.TRANSPOSE_ATTK_SPEED)
	transpose_attk_speed_effect.is_timebound = true
	transpose_attk_speed_effect.time_in_seconds = transpose_buff_duration
	transpose_attk_speed_effect.status_bar_icon = Transpose_AttkSpeed_StatusBarIcon
	
	#
	var ap_modi = FlatModifier.new(StoreOfTowerEffectsUUID.TRANSPOSE_ABILITY_POTENCY_BUFF)
	ap_modi.flat_modifier = transpose_base_ability_potency_amount
	
	transpose_ability_potency_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, ap_modi, StoreOfTowerEffectsUUID.TRANSPOSE_ABILITY_POTENCY_BUFF)
	transpose_ability_potency_effect.is_timebound = true
	transpose_ability_potency_effect.time_in_seconds = transpose_buff_duration
	

#

func _construct_and_connect_ability():
	transpose_ability = BaseAbility.new()
	
	transpose_ability.is_timebound = true
	transpose_ability.connect("ability_activated", self, "_transpose_ability_activated", [], CONNECT_PERSIST)
	transpose_ability.icon = Transpose_AbilityIcon
	
	transpose_ability.set_properties_to_usual_tower_based()
	transpose_ability.tower = self
	
	transpose_ability.descriptions = tower_info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION]
	var extra_descs = [
		"",
		"\"To avoid nesting of spacetime, Transporter cannot Transpose a Transporter.\""
	]
	for desc in extra_descs:
		transpose_ability.descriptions.append(desc)
	
	transpose_ability.display_name = "Transpose"
	
	transpose_ability_activation_clauses = transpose_ability.activation_conditional_clauses
	
	register_ability_to_manager(transpose_ability)
	
	#
	
	transpose_delay_timer = Timer.new()
	transpose_delay_timer.one_shot = true
	
	add_child(transpose_delay_timer)


func _transpose_ability_activated():
	_ability_prompt_transpose_tower()

func _ability_prompt_transpose_tower():
	if input_prompt_manager.can_prompt():
		input_prompt_manager.prompt_select_tower(self, "_start_transpose_timer_to_tower", "_ability_prompt_cancelled", "_can_transpose_with_tower")
	else:
		input_prompt_manager.cancel_selection()

func _ability_prompt_cancelled():
	pass

#

func _start_transpose_timer_to_tower(tower):
	if _can_transpose_with_tower(tower):
		var cd = _get_cd_to_use(transpose_base_cooldown)
		transpose_ability.on_ability_before_cast_start(cd)
		
		var final_delay = transpose_base_ability_delay
		var final_ap_to_use = transpose_ability.get_potency_to_use(last_calculated_final_ability_potency)
		if final_ap_to_use != 0:
			final_delay /= final_ap_to_use
		
		transpose_delay_timer.connect("timeout", self, "_transpose_delay_timer_expired", [tower, cd], CONNECT_ONESHOT)
		
		transpose_delay_timer.start(final_delay)
		
		_show_swapping_particle_at_pos(tower.global_position, final_delay)
		_show_swapping_particle_at_pos(global_position, final_delay)
		transpose_ability_activation_clauses.attempt_insert_clause(transpose_is_in_delay_timeline_clause)

#

func _on_round_end_t():
	if transpose_delay_timer.is_connected("timeout", self, "_transpose_delay_timer_expired"):
		transpose_delay_timer.disconnect("timeout", self, "_transpose_delay_timer_expired")
		transpose_ability_activation_clauses.remove_clause(transpose_is_in_delay_timeline_clause)

#

func _transpose_delay_timer_expired(tower, cooldown):
	if is_round_started:
		_transpose_with_tower(tower, cooldown)

func _transpose_with_tower(tower, cooldown):
	if _can_transpose_with_tower(tower):
		transfer_to_placable(tower.current_placable, false, false, true, true)
		
		transpose_ability.start_time_cooldown(cooldown)
		
		_give_tower_transpose_attk_speed(tower)
		_give_tower_transpose_attk_speed(self)
		
		_give_tower_transpose_ability_potency(tower)
		_give_tower_transpose_ability_potency(self)
		
		transpose_ability.on_ability_after_cast_ended(cooldown)
	
	transpose_ability_activation_clauses.remove_clause(transpose_is_in_delay_timeline_clause)


func _can_transpose_with_tower(tower) -> bool:
	return tower != self and is_instance_valid(tower) and tower.is_current_placable_in_map()

#

func _give_tower_transpose_attk_speed(tower):
	var scaled_effect = transpose_attk_speed_effect._get_copy_scaled_by(last_calculated_final_ability_potency)
	tower.add_tower_effect(scaled_effect)

func _give_tower_transpose_ability_potency(tower):
	tower.add_tower_effect(transpose_ability_potency_effect._get_copy_scaled_by(1))

#

func _show_swapping_particle_at_pos(pos : Vector2, particle_lifetime : float):
	var particle = Transpose_Sprite_Scene.instance()
	
	particle.lifetime = particle_lifetime
	particle.position = pos
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_TOWERS
	
	get_tree().get_root().add_child(particle)


