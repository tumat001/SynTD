extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")
const ArcingBaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.tscn")

const SePropager_BulletProjPic = preload("res://TowerRelated/Color_Green/SePropager/Assets/SePropager_Proj.png")
const SePropager_SeedPic = preload("res://TowerRelated/Color_Green/SePropager/Assets/SePropager_SeedTravelPic.png")

const AutoSellGolden_Activated_Pic = preload("res://TowerRelated/Color_Green/SePropager/Assets/GUI/Gui_AutoSellValued.png")
const AutoSellGolden_Deactivated_Pic = preload("res://TowerRelated/Color_Green/SePropager/Assets/GUI/Gui_DisabledAutoSellValued.png")
const SellAllWithValue_Pic = preload("res://TowerRelated/Color_Green/SePropager/Assets/GUI/Gui_SellAllWithValue.png")

const MapManager = preload("res://GameElementsRelated/MapManager.gd")

const LesSemis = preload("res://TowerRelated/Color_Green/SePropager_LesSemis/LesSemis.gd")


signal on_auto_sell_value_changed(new_val)

#

var proliferate_ability : BaseAbility
var _is_proliferate_ability_ready : bool
const proliferate_base_cooldown : float = 25.0
const proliferate_initial_cooldown : float = 12.5

var proliferate_seed_attack_module : ArcingBulletAttackModule
var all_owned_les_semis : Array = []

#

const cannot_be_autocasted_clause : int = 10
const no_owned_les_semis : int = 15

var toggle_auto_sell_golden_ability : BaseAbility

var sell_all_golden_abiltiy : BaseAbility
var sell_all_golden_ability_clauses : ConditionalClauses

#

var auto_sell_golden_les_semis : bool = true

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SE_PROPAGER)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var attack_module_y_shift : float = 9
	
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attack_module_y_shift
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 336#280
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attack_module_y_shift
	
	attack_module.benefits_from_bonus_pierce = true
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(8, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	var sp = SpriteFrames.new()
	sp.add_frame("default", SePropager_BulletProjPic)
	attack_module.bullet_sprite_frames = sp
	
	add_attack_module(attack_module)
	
	#
	
	
	proliferate_seed_attack_module = ArcingBulletAttackModule_Scene.instance()
	proliferate_seed_attack_module.base_damage = 0
	proliferate_seed_attack_module.base_damage_type = 0
	proliferate_seed_attack_module.base_attack_speed = 0
	proliferate_seed_attack_module.base_attack_wind_up = 0
	proliferate_seed_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proliferate_seed_attack_module.is_main_attack = false
	proliferate_seed_attack_module.base_pierce = info.base_pierce
	proliferate_seed_attack_module.base_proj_speed = 1.5 # sec to reach the location
	#attack_module.base_proj_life_distance = info.base_range
	proliferate_seed_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	proliferate_seed_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	proliferate_seed_attack_module.benefits_from_bonus_base_damage = false
	proliferate_seed_attack_module.benefits_from_bonus_on_hit_damage = false
	proliferate_seed_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proliferate_seed_attack_module.position.y -= attack_module_y_shift
	#var bullet_shape = CircleShape2D.new()
	#bullet_shape.radius = 3
	
	#proliferate_seed_attack_module.bullet_shape = bullet_shape
	proliferate_seed_attack_module.bullet_scene = ArcingBaseBullet_Scene
	proliferate_seed_attack_module.set_texture_as_sprite_frame(SePropager_SeedPic)
	
	proliferate_seed_attack_module.max_height = 20
	proliferate_seed_attack_module.bullet_rotation_per_second = 0
	
	proliferate_seed_attack_module.is_displayed_in_tracker = false
	
	proliferate_seed_attack_module.can_be_commanded_by_tower = false
	proliferate_seed_attack_module.kill_bullets_at_end_of_round = false
	
	add_attack_module(proliferate_seed_attack_module)
	
	
	#
	
	_construct_proliferate_ability()
	
	_construct_toggle_auto_sell_golden_ability()
	_construct_sell_all_golden_ability()
	
	_post_inherit_ready()


#

func _construct_proliferate_ability():
	proliferate_ability = BaseAbility.new()
	
	proliferate_ability.is_timebound = true
	
	proliferate_ability.set_properties_to_usual_tower_based()
	proliferate_ability.tower = self
	
	proliferate_ability.connect("updated_is_ready_for_activation", self, "_can_cast_proliferate_changed", [], CONNECT_PERSIST)
	register_ability_to_manager(proliferate_ability, false)
	
	proliferate_ability.start_time_cooldown(_get_cd_to_use(proliferate_initial_cooldown))


func _can_cast_proliferate_changed(can_cast):
	_is_proliferate_ability_ready = can_cast
	_attempt_cast_proliferate()


func _attempt_cast_proliferate():
	if _is_proliferate_ability_ready:
		_cast_proliferate()

func _cast_proliferate():
	var candidate_placable = _find_candidate_placable()
	
	if is_instance_valid(candidate_placable):
		var cd = _get_cd_to_use(proliferate_base_cooldown)
		proliferate_ability.on_ability_before_cast_start(cd)
		
		_fire_proliferate_seed_at_placable(candidate_placable)
		
		proliferate_ability.start_time_cooldown(cd)
		proliferate_ability.on_ability_after_cast_ended(cd)
	else:
		proliferate_ability.start_time_cooldown(3) #refresh


func _find_candidate_placable() -> BaseAreaTowerPlacable:
	var all_unoccupied_placables : Array = game_elements.map_manager.get_all_placables_in_range(range_module.global_position, range_module.last_calculated_final_range, MapManager.PlacableState.UNOCCUPIED, MapManager.SortOrder.RANDOM)
	
	if all_unoccupied_placables.size() > 0:
		return all_unoccupied_placables[0]
	else:
		return null

func _fire_proliferate_seed_at_placable(arg_placable):
	var seed_proj = proliferate_seed_attack_module.construct_bullet(arg_placable.global_position)
	seed_proj.connect("on_final_location_reached", self, "_proliferate_seed_landed", [arg_placable], CONNECT_ONESHOT)
	
	proliferate_seed_attack_module.set_up_bullet__add_child_and_emit_signals(seed_proj)

#

func _proliferate_seed_landed(seed_pos, seed_proj, placable):
	if is_instance_valid(placable) and placable.tower_occupying == null:
		_create_les_semis_at_placable(placable)

func _create_les_semis_at_placable(placable):
	var les_semis_instance : LesSemis = game_elements.tower_inventory_bench.create_tower(Towers.LES_SEMIS, placable)
	
	var base_dmg_of_self : float = 0
	if is_instance_valid(main_attack_module):
		base_dmg_of_self = main_attack_module.last_calculated_final_damage
	
	les_semis_instance.ad_of_parent = base_dmg_of_self
	
	les_semis_instance.connect("on_reached_golden_state", self, "_on_golden_state_reached", [les_semis_instance], CONNECT_PERSIST)
	les_semis_instance.connect("tree_exiting", self, "_on_les_semis_tree_exiting", [les_semis_instance], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	all_owned_les_semis.append(les_semis_instance)
	
	game_elements.tower_inventory_bench.add_tower_to_scene(les_semis_instance)
	
	#
	# if the les semis does not appear in the damage recap charts, then re-enable this (if the one from the tower manager (add tower) is not there anymore
	#les_semis_instance.transfer_to_placable(les_semis_instance.hovering_over_placable, false, !tower_manager.can_place_tower_based_on_limit_and_curr_placement(self))

#

func _on_golden_state_reached(les_semis):
	if auto_sell_golden_les_semis and !les_semis.is_queued_for_deletion():
		les_semis.sell_tower()
	else:
		sell_all_golden_ability_clauses.remove_clause(no_owned_les_semis)

func _on_les_semis_tree_exiting(les_semis):
	all_owned_les_semis.erase(les_semis)
	
	if (all_owned_les_semis.size() == 0):
		sell_all_golden_ability_clauses.attempt_insert_clause(no_owned_les_semis)

#

func set_auto_sell_golden_les_semis(new_val):
	auto_sell_golden_les_semis = new_val
	
	if auto_sell_golden_les_semis:
		toggle_auto_sell_golden_ability.icon = AutoSellGolden_Activated_Pic
	else:
		toggle_auto_sell_golden_ability.icon = AutoSellGolden_Deactivated_Pic
	
	emit_signal("on_auto_sell_value_changed", new_val)

#

func sell_all_associated_golden_les_semis():
	for les_semis in all_owned_les_semis:
		if les_semis.is_golden and !les_semis.is_queued_for_deletion():
			les_semis.sell_tower()
	
	sell_all_golden_ability_clauses.attempt_insert_clause(no_owned_les_semis)

#

func _construct_toggle_auto_sell_golden_ability():
	toggle_auto_sell_golden_ability = BaseAbility.new()
	
	toggle_auto_sell_golden_ability.is_timebound = false
	
	toggle_auto_sell_golden_ability.auto_castable_clauses.attempt_insert_clause(cannot_be_autocasted_clause)
	
	toggle_auto_sell_golden_ability.descriptions = [
		"Toggle button to auto sell Les Semis that turn Golden.",
		"Does not sell Les Semis(es) that are already golden."
	]
	toggle_auto_sell_golden_ability.display_name = "Toggle Auto Sell"
	
	toggle_auto_sell_golden_ability.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	toggle_auto_sell_golden_ability.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	toggle_auto_sell_golden_ability.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	toggle_auto_sell_golden_ability.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	toggle_auto_sell_golden_ability.icon = AutoSellGolden_Activated_Pic
	
	toggle_auto_sell_golden_ability.set_properties_to_usual_tower_based()
	toggle_auto_sell_golden_ability.tower = self
	
	toggle_auto_sell_golden_ability.connect("ability_activated", self, "_on_toggle_auto_sell_activated", [], CONNECT_PERSIST)
	register_ability_to_manager(toggle_auto_sell_golden_ability, false)


func _on_toggle_auto_sell_activated():
	set_auto_sell_golden_les_semis(!auto_sell_golden_les_semis)


#

func _construct_sell_all_golden_ability():
	sell_all_golden_abiltiy = BaseAbility.new()
	
	sell_all_golden_abiltiy.is_timebound = false
	
	sell_all_golden_ability_clauses = sell_all_golden_abiltiy.activation_conditional_clauses
	sell_all_golden_abiltiy.auto_castable_clauses.attempt_insert_clause(cannot_be_autocasted_clause)
	sell_all_golden_abiltiy.activation_conditional_clauses.attempt_insert_clause(no_owned_les_semis)
	
	
	sell_all_golden_abiltiy.descriptions = [
		"Sell all Les Semis that have turned Golden.",
	]
	sell_all_golden_abiltiy.display_name = "Sell All Golden"
	
	sell_all_golden_abiltiy.activation_conditional_clauses.blacklisted_clauses.append(BaseAbility.ActivationClauses.ROUND_INTERMISSION_STATE)
	sell_all_golden_abiltiy.counter_decrease_clauses.blacklisted_clauses.append(BaseAbility.CounterDecreaseClauses.ROUND_INTERMISSION_STATE)
	sell_all_golden_abiltiy.should_be_displaying_clauses.blacklisted_clauses.append(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	sell_all_golden_abiltiy.should_be_displaying_clauses.remove_clause(BaseAbility.ShouldBeDisplayingClauses.TOWER_IN_BENCH)
	sell_all_golden_abiltiy.icon = SellAllWithValue_Pic
	
	
	sell_all_golden_abiltiy.set_properties_to_usual_tower_based()
	sell_all_golden_abiltiy.tower = self
	
	sell_all_golden_abiltiy.connect("ability_activated", self, "_on_sell_all_activated", [], CONNECT_PERSIST)
	register_ability_to_manager(sell_all_golden_abiltiy, false)

func _on_sell_all_activated():
	sell_all_associated_golden_les_semis()
