extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const Leader_AddMember_BeamScene = preload("res://TowerRelated/Color_Blue/Leader/ConnectionBeam/Leader_AddMember_Beam.tscn")
const Leader_RemoveMember_BeamScene = preload("res://TowerRelated/Color_Blue/Leader/ConnectionBeam/Leader_RemoveMember_Beam.tscn")
const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")

const LeaderBeam01 = preload("res://TowerRelated/Color_Blue/Leader/Leader_Beam/LeaderBeam01.png")
const LeaderBeam02 = preload("res://TowerRelated/Color_Blue/Leader/Leader_Beam/LeaderBeam02.png")
const LeaderBeam03 = preload("res://TowerRelated/Color_Blue/Leader/Leader_Beam/LeaderBeam03.png")
const LeaderBeam04 = preload("res://TowerRelated/Color_Blue/Leader/Leader_Beam/LeaderBeam04.png")
const LeaderBeam05 = preload("res://TowerRelated/Color_Blue/Leader/Leader_Beam/LeaderBeam05.png")
const LeaderBeam06 = preload("res://TowerRelated/Color_Blue/Leader/Leader_Beam/LeaderBeam06.png")
const LeaderBeam07 = preload("res://TowerRelated/Color_Blue/Leader/Leader_Beam/LeaderBeam07.png")
const LeaderBeam08 = preload("res://TowerRelated/Color_Blue/Leader/Leader_Beam/LeaderBeam08.png")
const LeaderBeam09 = preload("res://TowerRelated/Color_Blue/Leader/Leader_Beam/LeaderBeam09.png")

const LeaderMark_Pic = preload("res://TowerRelated/Color_Blue/Leader/LeaderMark.png")
const AddMember_Pic = preload("res://TowerRelated/Color_Blue/Leader/Ability/TowerSelectionPanel/TowerAdd_Icon.png")
const RemoveMember_Pic = preload("res://TowerRelated/Color_Blue/Leader/Ability/TowerSelectionPanel/TowerRemove_Icon.png")
const CoordinatedAttack_Pic = preload("res://TowerRelated/Color_Blue/Leader/Ability/CoordinatedAttack_Icon.png")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

const LeaderMemberConnectionBeam_Pic = preload("res://TowerRelated/Color_Blue/Leader/Leader_MemberConnectionBeam.png")
const LeaderCommandAttack_ParticleScene = preload("res://TowerRelated/Color_Blue/Leader/Leader_CommandMark/Leader_CommandAttkParticle.tscn")

signal show_member_connection_mode_changed(is_showing)


var marked_enemy
var _atomic_marked_enemy
var mark_indicator : AttackSprite

var add_tower_as_member_ability : BaseAbility
var add_tower_activation_conditional_clauses : ConditionalClauses
const at_activation_clause_member_limit_reached : int = -10

var remove_tower_as_member_ability : BaseAbility
var remove_tower_activation_conditional_clauses : ConditionalClauses
const rt_activation_clause_no_member : int = -10

var coordinated_attack_ability : BaseAbility
var coordinated_attack_activation_conditional_clauses : ConditionalClauses
const ca_activation_clause_no_member : int = -10
const ca_activation_clause_no_mark : int = -11

const coordinated_attack_cooldown : float = 17.0 #13.0
const attacked_marked_enemy_cd_reduction : float = 1.0

const member_upper_limit : int = 5

var tower_members_beam_map : Dictionary = {}

var is_showing_member_connections : bool = false

#

const base_stun_duration : float = 2.75
var stun_effect : EnemyStunEffect

var _tower_info : TowerTypeInformation

#

var is_showing_add_member_beam : bool = false
var is_showing_remove_member_beam : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.LEADER)
	_tower_info = info
	
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
	range_module.position.y += 28
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 5
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 28
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", LeaderBeam01)
	beam_sprite_frame.add_frame("default", LeaderBeam02)
	beam_sprite_frame.add_frame("default", LeaderBeam03)
	beam_sprite_frame.add_frame("default", LeaderBeam04)
	beam_sprite_frame.add_frame("default", LeaderBeam05)
	beam_sprite_frame.add_frame("default", LeaderBeam06)
	beam_sprite_frame.add_frame("default", LeaderBeam07)
	beam_sprite_frame.add_frame("default", LeaderBeam08)
	beam_sprite_frame.add_frame("default", LeaderBeam09)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 45)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.2
	attack_module.show_beam_at_windup = true
	attack_module.show_beam_regardless_of_state = true
	
	add_attack_module(attack_module)
	
	connect("on_main_attack_module_enemy_hit", self, "_on_main_am_enemy_hit_l", [], CONNECT_PERSIST)
	connect("tower_not_in_active_map", self, "_remove_all_tower_members", [], CONNECT_PERSIST)
	connect("global_position_changed", self, "_self_global_pos_changed", [], CONNECT_PERSIST)
	
	_construct_abilities()
	_construct_effect()
	
	_construct_mark_indicator()
	_post_inherit_ready()


# Ability related

func _construct_abilities():
	
	# ADD MEMBER ABILITY
	add_tower_as_member_ability = BaseAbility.new()
	
	add_tower_as_member_ability.is_timebound = true
	add_tower_as_member_ability.connect("ability_activated", self, "_ability_prompt_add_member", [], CONNECT_PERSIST)
	add_tower_as_member_ability.icon = AddMember_Pic
	
	add_tower_as_member_ability.set_properties_to_usual_tower_based()
	add_tower_as_member_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	add_tower_as_member_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	add_tower_as_member_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	add_tower_as_member_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	
	add_tower_as_member_ability.tower = self
	
	add_tower_as_member_ability.descriptions = [
		"Add tower as a member of this Leader.",
		"If no tower is hovered by your mouse, a prompt is shown to select the member."
	]
	add_tower_as_member_ability.display_name = "Add Member"
	
	register_ability_to_manager(add_tower_as_member_ability, false)
	add_tower_activation_conditional_clauses = add_tower_as_member_ability.activation_conditional_clauses
	
	# REMOVE MEMBER
	remove_tower_as_member_ability = BaseAbility.new()
	
	remove_tower_as_member_ability.is_timebound = true
	remove_tower_as_member_ability.connect("ability_activated", self, "_ability_prompt_remove_member", [], CONNECT_PERSIST)
	remove_tower_as_member_ability.icon = RemoveMember_Pic
	
	remove_tower_as_member_ability.set_properties_to_usual_tower_based()
	remove_tower_as_member_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	remove_tower_as_member_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	remove_tower_as_member_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	remove_tower_as_member_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	
	remove_tower_as_member_ability.tower = self
	
	remove_tower_as_member_ability.descriptions = [
		"Remove tower as a member of this Leader.",
		"If no tower is hovered by your mouse, a prompt is shown to select the member.",
		"",
		"Automatically removes the member if the member is benched.",
	]
	remove_tower_as_member_ability.display_name = "Remove Member"
	
	register_ability_to_manager(remove_tower_as_member_ability, false)
	remove_tower_activation_conditional_clauses = remove_tower_as_member_ability.activation_conditional_clauses
	remove_tower_activation_conditional_clauses.attempt_insert_clause(rt_activation_clause_no_member)
	
	
	# Coordinated Attack Ability
	coordinated_attack_ability = BaseAbility.new()
	
	coordinated_attack_ability.is_timebound = true
	coordinated_attack_ability.connect("ability_activated", self, "_cast_use_coordinated_attack", [], CONNECT_PERSIST)
	coordinated_attack_ability.icon = CoordinatedAttack_Pic
	
	coordinated_attack_ability.set_properties_to_usual_tower_based()
	
	coordinated_attack_ability.tower = self
	
	coordinated_attack_ability.descriptions = _tower_info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION]
	coordinated_attack_ability.simple_descriptions = _tower_info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION]
	
	coordinated_attack_ability.display_name = "Coordinated Attack"
	
	coordinated_attack_ability.set_properties_to_auto_castable()
	coordinated_attack_ability.auto_cast_func = "_cast_use_coordinated_attack"
	coordinated_attack_ability.auto_cast_on = true
	
	register_ability_to_manager(coordinated_attack_ability)
	
	coordinated_attack_activation_conditional_clauses = coordinated_attack_ability.activation_conditional_clauses
	coordinated_attack_activation_conditional_clauses.attempt_insert_clause(ca_activation_clause_no_member)
	coordinated_attack_activation_conditional_clauses.attempt_insert_clause(ca_activation_clause_no_mark)
	


func _ability_prompt_add_member():
	var mouse_hovered_tower = tower_manager.get_tower_on_mouse_hover()
	if is_instance_valid(mouse_hovered_tower):
		_ability_add_selected_member(mouse_hovered_tower)
		
		if !input_prompt_manager.can_prompt():
			input_prompt_manager.cancel_selection()
			_ability_prompt__add_member_cancelled()
	else:
		if input_prompt_manager.can_prompt():
			is_showing_add_member_beam = true
			input_prompt_manager.prompt_select_tower(self, "_ability_add_selected_member", "_ability_prompt__add_member_cancelled", "_can_add_tower_as_member")
			
		else:
			input_prompt_manager.cancel_selection()
			_ability_prompt__add_member_cancelled()

func _ability_prompt_remove_member():
	var mouse_hovered_tower = tower_manager.get_tower_on_mouse_hover()
	if is_instance_valid(mouse_hovered_tower):
		_ability_remove_selected_member(mouse_hovered_tower)
		
		if !input_prompt_manager.can_prompt():
			input_prompt_manager.cancel_selection()
			_ability_prompt__remove_member_cancelled()
	else:
		if input_prompt_manager.can_prompt():
			is_showing_remove_member_beam = true
			input_prompt_manager.prompt_select_tower(self, "_ability_remove_selected_member", "_ability_prompt__remove_member_cancelled", "_can_remove_member_tower")
			
		else:
			input_prompt_manager.cancel_selection()
			_ability_prompt__remove_member_cancelled()


func _ability_prompt__add_member_cancelled():
	is_showing_add_member_beam = false

func _ability_prompt__remove_member_cancelled():
	is_showing_remove_member_beam = false

# member adding/removing

func _ability_add_selected_member(tower):
	if _can_add_tower_as_member(tower):
		tower_members_beam_map[tower] = null
		tower.connect("tower_not_in_active_map", self, "_ability_remove_selected_member", [tower], CONNECT_PERSIST)
		tower.connect("tree_exiting", self, "_ability_remove_selected_member", [tower], CONNECT_PERSIST)
		tower.connect("global_position_changed", self, "_member_global_pos_changed", [tower], CONNECT_PERSIST)
		
		coordinated_attack_activation_conditional_clauses.remove_clause(ca_activation_clause_no_member)
		remove_tower_activation_conditional_clauses.remove_clause(rt_activation_clause_no_member)
		
		if tower_members_beam_map.size() >= member_upper_limit:
			add_tower_activation_conditional_clauses.attempt_insert_clause(at_activation_clause_member_limit_reached)
		
		if is_showing_member_connections:
			var beam = _construct_beam()
			tower_members_beam_map[tower] = beam
			beam.visible = true
			beam.update_destination_position(tower.global_position)
		
		_toggle_show_tower_info()
		
		call_deferred("_show_add_member_beam_to_tower", tower)
		
	
	is_showing_add_member_beam = false

func _can_add_tower_as_member(tower) -> bool:
	return !tower_members_beam_map.has(tower) and tower.is_current_placable_in_map() and !tower is get_script()


func _ability_remove_selected_member(tower):
	if _can_remove_member_tower(tower):
		if is_instance_valid(tower_members_beam_map[tower]):
			tower_members_beam_map[tower].queue_free()
		
		tower_members_beam_map.erase(tower)
		tower.disconnect("tower_not_in_active_map", self, "_ability_remove_selected_member")
		tower.disconnect("tree_exiting", self, "_ability_remove_selected_member")
		tower.disconnect("global_position_changed", self, "_member_global_pos_changed")
		
		if is_instance_valid(tower.main_attack_module):
			if tower.main_attack_module.range_module.priority_enemies_regardless_of_range.has(_atomic_marked_enemy):
				tower.main_attack_module.range_module.remove_priority_target_regardless_of_range(_atomic_marked_enemy)
		
		if tower.is_connected("on_main_attack_finished", self, "_member_finished_with_main_attack"):
			tower.disconnect("on_main_attack_finished", self, "_member_finished_with_main_attack")
		
		if tower.is_connected("on_main_attack_module_damage_instance_constructed", self, "_member_mat_damage_instance_constructed"):
			tower.disconnect("on_main_attack_module_damage_instance_constructed", self, "_member_mat_damage_instance_constructed")
		
		if tower.main_attack_module is BulletAttackModule:
			if tower.main_attack_module.is_connected("before_bullet_is_shot", self, "_member_bullet_is_shot"):
				tower.main_attack_module.disconnect("before_bullet_is_shot", self, "_member_bullet_is_shot")
		
		
		add_tower_activation_conditional_clauses.remove_clause(at_activation_clause_member_limit_reached)
		if tower_members_beam_map.size() == 0:
			coordinated_attack_activation_conditional_clauses.attempt_insert_clause(ca_activation_clause_no_member)
			remove_tower_activation_conditional_clauses.attempt_insert_clause(rt_activation_clause_no_member)
		
		_toggle_show_tower_info()
		
		call_deferred("_show_remove_member_beam_to_tower", tower)
		
	
	is_showing_remove_member_beam = false

func _can_remove_member_tower(tower) -> bool:
	return is_instance_valid(tower) and tower_members_beam_map.has(tower)


func _remove_all_tower_members():
	for tower in tower_members_beam_map.keys():
		tower.disconnect("tower_not_in_active_map", self, "_ability_remove_selected_member")
		tower.disconnect("tree_exiting", self, "_ability_remove_selected_member")
		tower.disconnect("global_position_changed", self, "_member_global_pos_changed")
		
		if is_instance_valid(tower.main_attack_module):
			if tower.main_attack_module.range_module.priority_enemies_regardless_of_range.has(_atomic_marked_enemy):
				tower.main_attack_module.range_module.member.main_attack_module.range_module.remove_priority_target_regardless_of_range(_atomic_marked_enemy)
		
		if tower.is_connected("on_main_attack_finished", self, "_member_finished_with_main_attack"):
			tower.disconnect("on_main_attack_finished", self, "_member_finished_with_main_attack")
		
		if tower.is_connected("on_main_attack_module_damage_instance_constructed", self, "_member_mat_damage_instance_constructed"):
			tower.disconnect("on_main_attack_module_damage_instance_constructed", self, "_member_mat_damage_instance_constructed")
		
		if tower.main_attack_module is BulletAttackModule:
			if tower.main_attack_module.is_connected("before_bullet_is_shot", self, "_member_bullet_is_shot"):
				tower.main_attack_module.disconnect("before_bullet_is_shot", self, "_member_bullet_is_shot")
		
		if is_instance_valid(tower_members_beam_map[tower]):
			tower_members_beam_map[tower].queue_free()
	
	tower_members_beam_map.clear()
	
	add_tower_activation_conditional_clauses.remove_clause(at_activation_clause_member_limit_reached)
	if tower_members_beam_map.size() == 0:
		coordinated_attack_activation_conditional_clauses.attempt_insert_clause(ca_activation_clause_no_member)
		remove_tower_activation_conditional_clauses.attempt_insert_clause(rt_activation_clause_no_member)


# Ability: coordinated attack

func _cast_use_coordinated_attack():
	var cd = _get_cd_to_use(coordinated_attack_cooldown)
	coordinated_attack_ability.on_ability_before_cast_start(cd)
	
	_atomic_marked_enemy = marked_enemy
	
	for tower in tower_members_beam_map:
		if is_instance_valid(tower.main_attack_module) and is_instance_valid(tower.main_attack_module.range_module) and tower.main_attack_module.can_be_commanded_by_tower and !tower.last_calculated_disabled_from_attacking:
			#if !tower.main_attack_module.range_module.priority_enemies.has(_atomic_marked_enemy):
			if !tower.is_connected("on_main_attack_finished", self, "_member_finished_with_main_attack"):
				#tower.main_attack_module.range_module.priority_enemies.append(_atomic_marked_enemy)
				#tower.main_attack_module.range_module.enemies_in_range.append(_atomic_marked_enemy)
				tower.main_attack_module.range_module.add_priority_target_regardless_of_range(_atomic_marked_enemy)
				
				if !tower.is_connected("on_main_attack_module_damage_instance_constructed", self, "_member_mat_damage_instance_constructed"):
					tower.connect("on_main_attack_module_damage_instance_constructed", self, "_member_mat_damage_instance_constructed", [tower], CONNECT_ONESHOT)
				
				tower.connect("on_main_attack_finished", self, "_member_finished_with_main_attack", [tower], CONNECT_ONESHOT)
				
				if tower.main_attack_module is BulletAttackModule:
					tower.main_attack_module.connect("before_bullet_is_shot", self, "_member_bullet_is_shot", [tower])
				
				tower.main_attack_module.on_command_attack_enemies_and_attack_when_ready([_atomic_marked_enemy], 1)
	
	if is_instance_valid(_atomic_marked_enemy):
		_atomic_marked_enemy._add_effect(stun_effect)
		_construct_and_show_particle_at_pos(_atomic_marked_enemy.global_position)
	
	
	coordinated_attack_ability.start_time_cooldown(cd)
	coordinated_attack_ability.on_ability_after_cast_ended(cd)


func _construct_and_show_particle_at_pos(pos : Vector2):
	var particle = LeaderCommandAttack_ParticleScene.instance()
	particle.position = pos
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)


func _member_bullet_is_shot(bullet : BaseBullet, tower):
	if !bullet is ArcingBaseBullet:
		if is_instance_valid(_atomic_marked_enemy):
			var distance = tower.global_position.distance_to(_atomic_marked_enemy.global_position)
			
			if bullet.life_distance < distance:
				bullet.life_distance = distance + BulletAttackModule.get_life_distance_bonus_allowance()



func _member_finished_with_main_attack(module, tower):
	if is_instance_valid(tower.main_attack_module) and is_instance_valid(tower.main_attack_module.range_module):
		#tower.main_attack_module.range_module.priority_enemies.erase(_atomic_marked_enemy)
		#tower.main_attack_module.range_module.enemies_in_range.erase(_atomic_marked_enemy)
		tower.main_attack_module.range_module.remove_priority_target_regardless_of_range(_atomic_marked_enemy)
		tower.main_attack_module.range_module._current_enemies.erase(_atomic_marked_enemy)
		
		
		if tower.main_attack_module is WithBeamInstantDamageAttackModule and !tower.main_attack_module.beam_is_timebound:
			tower.main_attack_module.call_deferred("force_update_beam_state")
		
		if tower.main_attack_module is BulletAttackModule:
			if tower.main_attack_module.is_connected("before_bullet_is_shot", self, "_member_bullet_is_shot"):
				tower.main_attack_module.disconnect("before_bullet_is_shot", self, "_member_bullet_is_shot")


func _member_mat_damage_instance_constructed(damage_instance, module, tower):
	var final_potency = coordinated_attack_ability.get_potency_to_use(last_calculated_final_ability_potency)
	if final_potency != 1:
		#damage_instance.on_hit_damages = damage_instance.get_copy_scaled_by(final_potency).on_hit_damages
		damage_instance.scale_only_damage_by(final_potency)

# Mark Indicator related

func _construct_mark_indicator():
	mark_indicator = AttackSprite_Scene.instance()
	mark_indicator.visible = false
	
	mark_indicator.frames = SpriteFrames.new()
	mark_indicator.frames.add_frame("default", LeaderMark_Pic)
	
	mark_indicator.has_lifetime = false
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(mark_indicator)


func _process(delta):
	if is_instance_valid(marked_enemy):
		mark_indicator.global_position = marked_enemy.global_position
	
	update()

func _draw():
	if is_showing_add_member_beam:
		var mouse_pos = get_global_mouse_position()
		draw_line(Vector2(0, 0), mouse_pos - global_position, Color(26/255.0, 2/255.0, 171/255.0), 3)
	
	if is_showing_remove_member_beam:
		var mouse_pos = get_global_mouse_position()
		draw_line(Vector2(0, 0), mouse_pos - global_position, Color(173/255.0, 46/255.0, 48/255.0), 3)




func _marked_enemy_cancel_focus():
	mark_indicator.visible = false
	
	for member in tower_members_beam_map.keys():
		if is_instance_valid(member.main_attack_module):
			member.main_attack_module.range_module.remove_priority_target_regardless_of_range(_atomic_marked_enemy)
		
		if member.is_connected("on_main_attack_finished", self, "_member_finished_with_main_attack"):
			member.disconnect("on_main_attack_finished", self, "_member_finished_with_main_attack")
		
		if member.is_connected("on_main_attack_module_damage_instance_constructed", self, "_member_mat_damage_instance_constructed"):
			member.disconnect("on_main_attack_module_damage_instance_constructed", self, "_member_mat_damage_instance_constructed")
		
		if member.main_attack_module is BulletAttackModule:
			if member.main_attack_module.is_connected("before_bullet_is_shot", self, "_member_bullet_is_shot"):
				member.main_attack_module.disconnect("before_bullet_is_shot", self, "_member_bullet_is_shot")
	
	marked_enemy = null
	_atomic_marked_enemy = null
	coordinated_attack_activation_conditional_clauses.attempt_insert_clause(ca_activation_clause_no_mark)


# Mark On hit 

func _on_main_am_enemy_hit_l(enemy, damage_register_id, damage_instance, module):
	if is_instance_valid(enemy) and enemy == marked_enemy:
		coordinated_attack_ability.time_decreased(attacked_marked_enemy_cd_reduction)
	
	
	if is_instance_valid(enemy) and marked_enemy != enemy and !enemy.is_queued_for_deletion():
		if is_instance_valid(marked_enemy):
			marked_enemy.disconnect("cancel_all_lockons", self, "_marked_enemy_cancel_focus")
		
		marked_enemy = enemy
		marked_enemy.connect("cancel_all_lockons", self, "_marked_enemy_cancel_focus", [], CONNECT_ONESHOT)
		mark_indicator.global_position = marked_enemy.global_position
		mark_indicator.visible = true
		coordinated_attack_activation_conditional_clauses.remove_clause(ca_activation_clause_no_mark)


# Show members related

func show_member_connections():
	is_showing_member_connections = true
	emit_signal("show_member_connection_mode_changed", true)
	
	for tower in tower_members_beam_map.keys():
		if tower_members_beam_map[tower] == null:
			tower_members_beam_map[tower] = _construct_beam()
		
		var beam = tower_members_beam_map[tower]
		beam.visible = true
		beam.update_destination_position(tower.global_position)
		beam.global_position = global_position
	
	_self_global_pos_changed(old_global_position, global_position)


func _construct_beam():
	var beam = BeamAesthetic_Scene.instance()
	beam.time_visible = 0
	beam.is_timebound = false
	beam.set_texture_as_default_anim(LeaderMemberConnectionBeam_Pic)
	beam.global_position = global_position
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
	return beam


func hide_member_connections():
	is_showing_member_connections = false
	emit_signal("show_member_connection_mode_changed", false)
	
	for tower in tower_members_beam_map.keys():
		tower_members_beam_map[tower].visible = false


func _member_global_pos_changed(old_position, new_position, tower):
	if tower_members_beam_map.has(tower) and tower.is_current_placable_in_map():
		var beam = tower_members_beam_map[tower]
		
		if is_instance_valid(beam) and beam.visible:
			beam.update_destination_position(tower.global_position)


func _self_global_pos_changed(old_pos, new_pos):
	for tower in tower_members_beam_map.keys():
		if is_showing_member_connections:
			var beam = tower_members_beam_map[tower]
			beam.global_position = global_position
			beam.update_destination_position(tower.global_position)


# effect related

func _construct_effect():
	stun_effect = EnemyStunEffect.new(base_stun_duration, StoreOfEnemyEffectsUUID.LEADER_STUN)
	stun_effect.is_timebound = true
	stun_effect.is_from_enemy = false


# freeing

func queue_free():
	mark_indicator.queue_free()
	
	_remove_all_tower_members()
	
	.queue_free()

###########

func _show_add_member_beam_to_tower(arg_tower):
	if is_instance_valid(arg_tower):
		var beam = Leader_AddMember_BeamScene.instance()
		beam.frame = 0
		
		beam.position = global_position
		
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
		beam.update_destination_position(arg_tower.global_position)

func _show_remove_member_beam_to_tower(arg_tower):
	if is_instance_valid(arg_tower):
		var beam = Leader_RemoveMember_BeamScene.instance()
		beam.frame = 0
		
		beam.position = global_position
		
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
		beam.update_destination_position(arg_tower.global_position)

#########


