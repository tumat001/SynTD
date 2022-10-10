extends "res://TowerRelated/AbstractTower.gd"

const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const CommonAttackSpriteTemplater = preload("res://MiscRelated/AttackSpriteRelated/CommonTemplates/CommonAttackSpriteTemplater.gd")
const HealingParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactCustomTowers/HealingSymbols/OtherAssets/HealingParticle.tscn")
const OnCastHealParticle_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactCustomTowers/HealingSymbols/OtherAssets/OnCastHealParticle.tscn")


const heal_cooldown : float = 5.0
const enhanced_heal_percent : float = 20.0
const normal_heal_percent : float = 10.0
const player_heal_amount : float = 2.0

const anim_heal_charge_sprite_index : int = 0
const anim_heal_depleted_sprite_index : int = 1


var _has_healed_damaged_towers_in_the_round : bool
var _is_heal_ability_ready : bool

var _enhanced_heal_modi : PercentModifier
var _normal_heal_modi : PercentModifier

var heal_ability : BaseAbility
var tower_detecting_range_module : TowerDetectingRangeModule

#
#var particle_timer : Timer
#var _current_particle_showing_count : int
const total_particle_count_per_show : int = 2
#const delay_per_particle : float = 0.15

var non_essential_rng

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.HEALING_SYMBOL)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = 0
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	can_be_sold_conditonal_clauses.attempt_insert_clause(CanBeSoldClauses.IS_NOT_SELLABLE_GENERIC_TAG)
	can_absorb_ingredient_conditonal_clauses.attempt_insert_clause(CanAbsorbIngredientClauses.CAN_NOT_ABSORB_INGREDIENT_GENERIC_TAG)
	
	connect("on_round_end__before_any_round_end_reverts", self, "_on_round_end_before_any_reverts_h", [], CONNECT_PERSIST)
	#connect("on_round_start", self, "_on_round_start_h", [], CONNECT_PERSIST)
	
	_construct_heal_ability()
	
	#
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.detection_range = info.base_range
	tower_detecting_range_module.can_display_range = true
	tower_detecting_range_module.circle_range_color = TowerDetectingRangeModule.range_module_default_circle_range_color
	add_child(tower_detecting_range_module)
	
	connect("on_tower_toggle_showing_range", self, "_on_tower_toggle_showing_range_h", [], CONNECT_PERSIST)
	
	#
	
	_enhanced_heal_modi = PercentModifier.new(0) #id does not matter
	_enhanced_heal_modi.percent_amount = enhanced_heal_percent
	_enhanced_heal_modi.percent_based_on = PercentType.MAX
	
	_normal_heal_modi = PercentModifier.new(0) #id does not matter
	_normal_heal_modi.percent_amount = normal_heal_percent
	_normal_heal_modi.percent_based_on = PercentType.MAX
	
	#
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	#
	
	tower_limit_slots_taken = 0
	is_a_summoned_tower = true
	
	_post_inherit_ready()

#

func _on_tower_toggle_showing_range_h(is_showing_ranges):
	if is_showing_ranges:
		tower_detecting_range_module.show_range()
		tower_detecting_range_module.glow_all_towers_in_range()
	else:
		tower_detecting_range_module.hide_range()
		tower_detecting_range_module.unglow_all_towers_in_range()

#

func _on_round_end_before_any_reverts_h():
	if is_current_placable_in_map():
		if !is_dead_for_the_round and !_has_healed_damaged_towers_in_the_round and !last_calculated_disabled_from_attacking:
			game_elements.health_manager.increase_health_by(player_heal_amount, game_elements.health_manager.IncreaseHealthSource.TOWER)
			_show_on_cast_heal_cosmetic_effects()
		
		_has_healed_damaged_towers_in_the_round = false
		tower_base_sprites.frame = anim_heal_charge_sprite_index


#

func _construct_heal_ability():
	heal_ability = BaseAbility.new()
	
	heal_ability.is_timebound = true
	
	heal_ability.set_properties_to_usual_tower_based()
	heal_ability.tower = self
	
	heal_ability.connect("updated_is_ready_for_activation", self, "_can_cast_heal_changed", [], CONNECT_PERSIST)
	register_ability_to_manager(heal_ability, false)


func _can_cast_heal_changed(can_cast):
	_is_heal_ability_ready = can_cast
	_attempt_cast_proliferate()

func _attempt_cast_proliferate():
	if _is_heal_ability_ready:
		_cast_heal()


func _cast_heal():
	var active_towers_in_range = tower_detecting_range_module.get_all_in_map_towers_in_range()
	active_towers_in_range = Targeting.enemies_to_target(active_towers_in_range, Targeting.TOWERS_HIGHEST_IN_ROUND_DAMAGE, active_towers_in_range.size(), global_position)
	var healed_at_least_one : bool = false
	
	for i in active_towers_in_range.size():
		var tower = active_towers_in_range[i]
		
		if is_instance_valid(tower) and !tower.has_full_health():
			_has_healed_damaged_towers_in_the_round = true
			healed_at_least_one = true
			tower_base_sprites.frame = anim_heal_depleted_sprite_index
			
			var heal_modi_to_use 
			
			if i == 0: # the highest dmging tower
				heal_modi_to_use = _enhanced_heal_modi
			else:
				heal_modi_to_use = _normal_heal_modi
			
			tower.heal_by_amount(heal_modi_to_use)
			
			_show_heal_other_tower_cosmetic_effects(tower)
	
	if healed_at_least_one:
		_show_on_cast_heal_cosmetic_effects()
	
	heal_ability.start_time_cooldown(heal_cooldown)

##


func _show_heal_other_tower_cosmetic_effects(arg_tower):
	for i in total_particle_count_per_show:
		var particle = HealingParticle_Scene.instance()
		
		CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
		particle.position = arg_tower.global_position
		particle.scale *= 1.5
		
		particle.position.x += non_essential_rng.randi_range(-17, 17)
		particle.position.y += non_essential_rng.randi_range(-16, 10)
		
		CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)

func _show_on_cast_heal_cosmetic_effects():
	var particle = OnCastHealParticle_Scene.instance()
	
	CommonAttackSpriteTemplater.configure_properties_of_attk_sprite(particle, CommonAttackSpriteTemplater.TemplateIDs.COMMON_UPWARD_DECELERATING_PARTICLE)
	particle.position = global_position - Vector2(0, 14)
	particle.scale *= 1.5
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)
