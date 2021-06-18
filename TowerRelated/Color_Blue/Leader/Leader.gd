extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")
const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")

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

var marked_enemy
var _atomic_marked_enemy
var mark_indicator : AttackSprite

var add_tower_as_member_ability : BaseAbility
var remove_tower_as_member_ability : BaseAbility
var coordinated_attack_ability : BaseAbility
var coordinated_attack_activation_conditional_clauses : ConditionalClauses

const ca_activation_clause_no_member : int = -10
const ca_activation_clause_no_mark : int = -11
const coordinated_attack_cooldown : float = 15.0

var tower_members : Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.LEADER)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 23
	#range_module.add_targeting_options(Targeting.get_all_targeting_options())
	#range_module.set_current_targeting(Targeting.FIRST)
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage_scale = 0.5
	attack_module.base_damage = info.base_damage / attack_module.base_damage_scale
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 5
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 23
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
	
	_construct_abilities()
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
	
	add_tower_as_member_ability.tower = self
	
	add_tower_as_member_ability.descriptions = [
		"Add tower as a member of this Leader."
	]
	add_tower_as_member_ability.display_name = "Add Member"
	
	register_ability_to_manager(add_tower_as_member_ability, false)
	
	
	# REMOVE MEMBER
	remove_tower_as_member_ability = BaseAbility.new()
	
	remove_tower_as_member_ability.is_timebound = true
	remove_tower_as_member_ability.connect("ability_activated", self, "_ability_prompt_remove_member", [], CONNECT_PERSIST)
	remove_tower_as_member_ability.icon = RemoveMember_Pic
	
	remove_tower_as_member_ability.set_properties_to_usual_tower_based()
	remove_tower_as_member_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	remove_tower_as_member_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	
	remove_tower_as_member_ability.tower = self
	
	remove_tower_as_member_ability.descriptions = [
		"Remove tower as a member of this Leader.",
		"Automatically removes the member if the member is benched.",
	]
	remove_tower_as_member_ability.display_name = "Remove Member"
	
	register_ability_to_manager(remove_tower_as_member_ability, false)
	
	
	# Coordinated Attack Ability
	
	coordinated_attack_ability = BaseAbility.new()
	
	coordinated_attack_ability.is_timebound = true
	coordinated_attack_ability.connect("ability_activated", self, "_cast_use_coordinated_attack", [], CONNECT_PERSIST)
	coordinated_attack_ability.icon = CoordinatedAttack_Pic
	
	coordinated_attack_ability.set_properties_to_usual_tower_based()
	
	coordinated_attack_ability.tower = self
	
	coordinated_attack_ability.descriptions = [
		"Orders all members to attack the marked enemy, regardless of range.",
		"Projectiles gain extra range to be able to reach the marked target.",
		"Cooldown: 15 s"
	]
	coordinated_attack_ability.display_name = "Coordinated Attack"
	
	register_ability_to_manager(coordinated_attack_ability)
	
	coordinated_attack_activation_conditional_clauses = coordinated_attack_ability.activation_conditional_clauses
	coordinated_attack_activation_conditional_clauses.attempt_insert_clause(ca_activation_clause_no_member)
	coordinated_attack_activation_conditional_clauses.attempt_insert_clause(ca_activation_clause_no_mark)


func _ability_prompt_add_member():
	if !input_prompt_manager.is_in_selection_mode():
		if !input_prompt_manager.is_connected("tower_selected", self, "_ability_add_selected_member"):
			input_prompt_manager.connect("tower_selected", self, "_ability_add_selected_member", [], CONNECT_ONESHOT)
			input_prompt_manager.connect("cancelled_tower_selection", self, "_ability_prompt_cancelled", [], CONNECT_ONESHOT)
			input_prompt_manager.prompt_select_tower(self)
		
	else:
		input_prompt_manager.cancel_selection()

func _ability_prompt_remove_member():
	if !input_prompt_manager.is_in_selection_mode():
		if !input_prompt_manager.is_connected("tower_selected", self, "_ability_remove_selected_member"):
			input_prompt_manager.connect("tower_selected", self, "_ability_remove_selected_member", [], CONNECT_ONESHOT)
			input_prompt_manager.connect("cancelled_tower_selection", self, "_ability_prompt_cancelled", [], CONNECT_ONESHOT)
			input_prompt_manager.prompt_select_tower(self)
		
	else:
		input_prompt_manager.cancel_selection()


func _ability_prompt_cancelled():
	if input_prompt_manager.is_connected("tower_selected", self, "_ability_remove_selected_member"):
		input_prompt_manager.disconnect("tower_selected", self, "_ability_remove_selected_member")
	
	if input_prompt_manager.is_connected("tower_selected", self, "_ability_add_selected_member"):
		input_prompt_manager.disconnect("tower_selected", self, "_ability_add_selected_member")


func _ability_add_selected_member(tower):
	if !tower_members.has(tower) and tower.is_current_placable_in_map() and !tower is get_script():
		tower_members.append(tower)
		tower.connect("tower_not_in_active_map", self, "_ability_remove_selected_member", [tower], CONNECT_PERSIST)
		tower.connect("tree_exiting", self, "_ability_remove_selected_member", [tower], CONNECT_PERSIST)
		
		coordinated_attack_activation_conditional_clauses.remove_clause(ca_activation_clause_no_member)


func _ability_remove_selected_member(tower):
	if tower_members.has(tower):
		tower_members.erase(tower)
		tower.disconnect("tower_not_in_active_map", self, "_ability_remove_selected_member")
		tower.disconnect("tree_exiting", self, "_ability_remove_selected_member")
		
		if tower_members.size() == 0:
			coordinated_attack_activation_conditional_clauses.attempt_insert_clause(ca_activation_clause_no_member)


func _remove_all_tower_members():
	for tower in tower_members:
		tower.disconnect("tower_not_in_active_map", self, "_ability_remove_selected_member")
		tower.disconnect("tree_exiting", self, "_ability_remove_selected_member")
	
	tower_members.clear()


# Ability coordinated attack

func _cast_use_coordinated_attack():
	_atomic_marked_enemy = marked_enemy
	
	for tower in tower_members:
		if tower.main_attack_module != null and tower.main_attack_module.range_module != null and tower.main_attack_module.can_be_commanded_by_tower:
			
			tower.main_attack_module.range_module.priority_enemies.append(_atomic_marked_enemy)
			tower.main_attack_module.range_module.enemies_in_range.append(_atomic_marked_enemy)
			tower.connect("on_main_attack", self, "_member_excecuted_main_attack", [tower])
			
			
			if tower.main_attack_module is BulletAttackModule:
				tower.main_attack_module.connect("before_bullet_is_shot", self, "_member_bullet_is_shot", [tower], CONNECT_ONESHOT)
			
			tower.main_attack_module.on_command_attack_enemies_and_attack_when_ready([_atomic_marked_enemy], 1)


func _member_bullet_is_shot(bullet : BaseBullet, tower):
	if !bullet is ArcingBaseBullet:
		if _atomic_marked_enemy != null:
			var distance = tower.global_position.distance_to(_atomic_marked_enemy.global_position)
			
			if bullet.life_distance < distance:
				bullet.life_distance = distance + 50


func _member_excecuted_main_attack(atk_spd_delay, enemies, module, tower):
	if enemies.has(_atomic_marked_enemy):
		if tower.main_attack_module != null and tower.main_attack_module.range_module != null:
			tower.main_attack_module.range_module.priority_enemies.erase(_atomic_marked_enemy)
			tower.main_attack_module.range_module._current_enemies.erase(_atomic_marked_enemy)
			tower.main_attack_module.range_module.enemies_in_range.erase(_atomic_marked_enemy)
			
			if tower.main_attack_module is WithBeamInstantDamageAttackModule and !tower.main_attack_module.beam_is_timebound:
				tower.main_attack_module.call_deferred("force_update_beam_state")
			
			tower.disconnect("on_main_attack", self, "_member_excecuted_main_attack")



# Mark Indicator related

func _construct_mark_indicator():
	mark_indicator = AttackSprite_Scene.instance()
	mark_indicator.visible = false
	
	mark_indicator.frames = SpriteFrames.new()
	mark_indicator.frames.add_frame("default", LeaderMark_Pic)
	
	mark_indicator.has_lifetime = false
	
	get_tree().get_root().add_child(mark_indicator)


func _process(delta):
	if marked_enemy != null:
		mark_indicator.global_position = marked_enemy.global_position


func _marked_enemy_died():
	mark_indicator.visible = false
	
	for member in tower_members:
		member.main_attack_module.range_module.priority_enemies.erase(_atomic_marked_enemy)
	
	marked_enemy = null
	_atomic_marked_enemy = null
	coordinated_attack_activation_conditional_clauses.attempt_insert_clause(ca_activation_clause_no_mark)


# Mark On hit 

func _on_main_am_enemy_hit_l(enemy, damage_register_id, damage_instance, module):
	if enemy != null and marked_enemy != enemy:
		if marked_enemy != null:
			marked_enemy.disconnect("tree_exiting", self, "_marked_enemy_died")
		
		marked_enemy = enemy
		marked_enemy.connect("tree_exiting", self, "_marked_enemy_died")
		mark_indicator.global_position = marked_enemy.global_position
		mark_indicator.visible = true
		coordinated_attack_activation_conditional_clauses.remove_clause(ca_activation_clause_no_mark)


# freeing

func queue_free():
	mark_indicator.queue_free()
	
	_remove_all_tower_members()
	
	.queue_free()
