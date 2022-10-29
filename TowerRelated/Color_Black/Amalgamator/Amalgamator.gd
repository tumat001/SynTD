extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const AmalgamatorBeam_Scene = preload("res://TowerRelated/Color_Black/Amalgamator/AmalBeam/Amalgamator_Beam.tscn")

const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

const Amalgamator_Beam01 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam01.png") 
const Amalgamator_Beam02 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam02.png") 
const Amalgamator_Beam03 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam03.png") 
const Amalgamator_Beam04 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam04.png") 
const Amalgamator_Beam05 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam05.png") 
const Amalgamator_Beam06 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam06.png") 
const Amalgamator_Beam07 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam07.png") 
const Amalgamator_Beam08 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam08.png") 
const Amalgamator_Beam09 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam09.png") 
const Amalgamator_Beam10 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam10.png") 

const Amalgam_AbilityIcon = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/Amalgam_AbilityIcon.png")

const Amalgam_Explosion01 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion01.png")
const Amalgam_Explosion02 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion02.png")
const Amalgam_Explosion03 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion03.png")
const Amalgam_Explosion04 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion04.png")
const Amalgam_Explosion05 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion05.png")
const Amalgam_Explosion06 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion06.png")
const Amalgam_Explosion07 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion07.png")
const Amalgam_Explosion08 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion08.png")
const Amalgam_Explosion09 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion09.png")
const Amalgam_Explosion10 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion10.png")
const Amalgam_Explosion11 = preload("res://TowerRelated/Color_Black/Amalgamator/AbilityAssets/SelfDestruct/Amalgam_Explosion11.png")


const Amalgamator_Hit_Particle = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_HitParticle.tscn")

onready var Shader_PureBlack = preload("res://MiscRelated/ShadersRelated/Shader_PureBlack.shader")



var convert_beam_sprite_frame : SpriteFrames


#const initial_round_cooldown_amalgam_ability : int = 1
const amalgam_tower_count : int = 2

var amalgam_ability : BaseAbility
var amalgam_activation_condtional_clauses : ConditionalClauses

const no_black_tower_clause_id : int = -10

var amal_explosion_sprite_frame : SpriteFrames

var to_convert_mark_effect : TowerMarkEffect

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.AMALGAMATOR)
	
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
	#range_module.set_range_shape(CircleShape2D.new())
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 7
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 6
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 7
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.attack_sprite_scene = Amalgamator_Hit_Particle
	attack_module.attack_sprite_follow_enemy = true
	
	var beam_sprite_frame = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Amalgamator_Beam01)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam02)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam03)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam04)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam05)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam06)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam07)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam08)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam09)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam10)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 10 / 0.2)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.2
	attack_module.show_beam_at_windup = true
	
	add_attack_module(attack_module)
	
	connect("on_round_end", self, "_on_round_end_a", [], CONNECT_PERSIST)
	
	convert_beam_sprite_frame = beam_sprite_frame
	
	_construct_amalgam_ability()
	_initialize_explosion_sprite_frame()
	_construct_to_convert_mark_effect()
	
	_post_inherit_ready()


func _initialize_explosion_sprite_frame():
	amal_explosion_sprite_frame = SpriteFrames.new()
	
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion01)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion02)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion03)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion04)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion05)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion06)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion07)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion08)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion09)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion10)
	amal_explosion_sprite_frame.add_frame("default", Amalgam_Explosion11)
	
	amal_explosion_sprite_frame.set_animation_loop("default", false)
	amal_explosion_sprite_frame.set_animation_speed("default", 11 / 0.3)

func _construct_to_convert_mark_effect():
	to_convert_mark_effect = TowerMarkEffect.new(StoreOfTowerEffectsUUID.AMALGAMATE_TO_CONVERT_MARK_EFFECT)
	

#

func _on_round_end_a():
	if is_current_placable_in_map():
		var tower_to_convert = _get_random_valid_in_map_tower()
		
		#mark tower
		if is_instance_valid(tower_to_convert):
			tower_to_convert.add_tower_effect(to_convert_mark_effect)
			call_deferred("_shoot_tower_converting_beam_to_tower", tower_to_convert)



func _get_random_valid_in_map_tower():
	var valid_towers : Array = tower_manager.get_all_active_towers_without_color(TowerColors.BLACK)
	var towers_to_remove : Array = []
	
	for tower in valid_towers:
		if tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.AMALGAMATE_TO_CONVERT_MARK_EFFECT) or tower.is_a_summoned_tower:
			towers_to_remove.append(tower)
	
	for tower in towers_to_remove:
		valid_towers.erase(tower)
	
	#var valid_towers : Array = tower_manager.get_all_active_towers_without_colors([TowerColors.BLACK, TowerColors.GRAY])
	
	if valid_towers.size() != 0:
		var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TARGETING)
		var decided_num : int = rng.randi_range(0, valid_towers.size() - 1)
		
		return valid_towers[decided_num]


func _shoot_tower_converting_beam_to_tower(arg_tower):
	if is_instance_valid(arg_tower):
		var beam = AmalgamatorBeam_Scene.instance()
		beam.set_sprite_frames(convert_beam_sprite_frame)
		#beam.connect("animation_finished", self, "_convert_tower_to_black", [arg_tower])
		beam.frame = 0
		
		beam.shader_to_use = Shader_PureBlack
		beam.tower_to_convert = arg_tower
		
		beam.time_visible = 0.2
		beam.is_timebound = true
		beam.queue_free_if_time_over = true
		beam.play_only_once(true)
		
		beam.position = global_position
		
		get_tree().get_root().add_child(beam)
		beam.update_destination_position(arg_tower.global_position)



#func _convert_tower_to_black(arg_tower):
#	if arg_tower != null:
#		arg_tower.remove_all_colors_from_tower(false)
#		arg_tower.add_color_to_tower(TowerColors.BLACK)
#
#		arg_tower.tower_base.material.shader = Shader_PureBlack


#

func _construct_amalgam_ability():
	amalgam_ability = BaseAbility.new()
	
	amalgam_ability.is_timebound = true
	amalgam_ability.connect("ability_activated", self, "_amalgam_abiltiy_casted", [], CONNECT_PERSIST)
	amalgam_ability.icon = Amalgam_AbilityIcon
	
	amalgam_ability.set_properties_to_usual_tower_based()
	amalgam_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	amalgam_ability.activation_conditional_clauses.remove_clause(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	amalgam_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.TOWER_IN_BENCH)
	amalgam_ability.activation_conditional_clauses.remove_clause(BaseAbility.ActivationClauses.TOWER_IN_BENCH)
	
	amalgam_ability.activation_conditional_clauses.blacklisted_clauses.append(disabled_from_attacking_clauses)
	
	amalgam_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	amalgam_ability.counter_decrease_clauses.remove_clause(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	amalgam_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.TOWER_IN_BENCH)
	amalgam_ability.counter_decrease_clauses.remove_clause(BaseAbility.CounterDecreaseClauses.TOWER_IN_BENCH)
	
	amalgam_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	amalgam_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	
	
	amalgam_ability.tower = self
	
	amalgam_ability.descriptions = [
		"Randomly selects %s non-black towers to apply Amalgamate to. Amalgamator explodes afterwards, destroying itself in the process." % [str(amalgam_tower_count)],
		"Amalgam prioritizes towers in the map, followed by benched towers.",
	]
	amalgam_ability.display_name = "Amalgam"
	
	amalgam_ability.is_timebound = false
	amalgam_ability.is_roundbound = false
	
	register_ability_to_manager(amalgam_ability, false)
	amalgam_activation_condtional_clauses = amalgam_ability.activation_conditional_clauses
	
	#amalgam_activation_condtional_clauses.blacklisted_clauses.append(disabled_from_attacking_clauses)
	#amalgam_activation_condtional_clauses.remove_clause(disabled_from_attacking_clauses)
	
	#amalgam_ability.start_round_cooldown(initial_round_cooldown_amalgam_ability)
	
	
	tower_manager.connect("tower_added", self, "_tower_added_in_game_a", [], CONNECT_PERSIST)
	tower_manager.connect("tower_in_queue_free", self, "_tower_in_queue_free_a", [], CONNECT_PERSIST)
	tower_manager.connect("tower_changed_colors", self, "_tower_colors_changed_a", [], CONNECT_PERSIST)
	
	_update_amalgam_activation_clause()


func _tower_added_in_game_a(tower):
	_update_amalgam_activation_clause()

func _tower_in_queue_free_a(tower):
	_update_amalgam_activation_clause()

func _tower_colors_changed_a(tower):
	_update_amalgam_activation_clause()



func _update_amalgam_activation_clause():
	var towers = tower_manager.get_all_towers_except_in_queue_free()
	var has_one_candidate : bool = false
	
	for tower in towers:
		if !tower._tower_colors.has(TowerColors.BLACK) and !tower.is_a_summoned_tower:
			has_one_candidate = true
			break
	
	if has_one_candidate:
		amalgam_activation_condtional_clauses.remove_clause(no_black_tower_clause_id)
	else:
		amalgam_activation_condtional_clauses.attempt_insert_clause(no_black_tower_clause_id)


#

func _amalgam_abiltiy_casted():
	_show_explosion()
	_convert_towers_using_amalgam_ability()
	
	queue_free()


func _show_explosion():
	var attk_sprite = AttackSprite_Scene.instance()
	
	attk_sprite.frames = amal_explosion_sprite_frame
	attk_sprite.has_lifetime = true
	attk_sprite.lifetime = 0.3
	attk_sprite.frames_based_on_lifetime = false
	#attk_sprite.lifetime_to_start_transparency = 0.1
	#attk_sprite.transparency_per_sec = 10
	
	attk_sprite.reset_frame_to_start = false
	
	attk_sprite.global_position = global_position
	
	get_tree().get_root().add_child(attk_sprite)

#

func _convert_towers_using_amalgam_ability():
	var towers = _get_candidate_towers_from_ability()
	
	for tower in towers:
		tower.add_tower_effect(to_convert_mark_effect)
		_shoot_tower_converting_beam_to_tower(tower)


func _get_candidate_towers_from_ability():
	var towers = tower_manager.get_all_towers_except_in_queue_free()
	towers = Targeting.enemies_to_target(towers, Targeting.RANDOM, towers.size(), global_position, true)
	
	var high_prio_bucket = []
	var low_prio_bucket = []
	
	var return_bucket = []
	
	for tower in towers:
		if !tower._tower_colors.has(TowerColors.BLACK) and !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.AMALGAMATE_TO_CONVERT_MARK_EFFECT) and !tower.is_a_summoned_tower:
			if tower.is_current_placable_in_map():
				
				if high_prio_bucket.size() < amalgam_tower_count:
					high_prio_bucket.append(tower)
			else:
				low_prio_bucket.append(tower)
	
	var converted_counter : int = 0
	for tower in high_prio_bucket:
		return_bucket.append(tower)
		converted_counter += 1
		
		if converted_counter >= amalgam_tower_count:
			return return_bucket
	
	for tower in low_prio_bucket:
		return_bucket.append(tower)
		converted_counter += 1
		
		if converted_counter >= amalgam_tower_count:
			return return_bucket
	
	return return_bucket



