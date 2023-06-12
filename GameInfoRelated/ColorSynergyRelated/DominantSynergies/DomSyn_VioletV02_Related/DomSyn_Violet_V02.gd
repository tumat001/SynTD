extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const VioletV02_SynInteractable = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/GUIRelated/SynInteractable/VioletV02_SynInteractable.gd")
const VioletV02_SynInteractable_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/GUIRelated/SynInteractable/VioletV02_SynInteractable.tscn")

const VioletV02_SynergyEffects = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/Effects/VioletV02_SynergyEffects.gd")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const DomSynVioV02_UnstableParticle_01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/Assets/UnstableParticles/DomSynVioV02_UnstableParticle_01.png")
const DomSynVioV02_UnstableParticle_02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/Assets/UnstableParticles/DomSynVioV02_UnstableParticle_02.png")
const DomSynVioV02_UnstableParticle_03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/Assets/UnstableParticles/DomSynVioV02_UnstableParticle_03.png")
const DomSynVioV02_UnstableParticle_04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/Assets/UnstableParticles/DomSynVioV02_UnstableParticle_04.png")

const DomSynVioV02_GoldSalvageParticle_01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/Assets/GoldSalvageParticles/DomSynVioV02_GoldSalvageParticle_01.png")
const DomSynVioV02_GoldSalvageParticle_02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/Assets/GoldSalvageParticles/DomSynVioV02_GoldSalvageParticle_02.png")
const DomSynVioV02_GoldSalvageParticle_03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_VioletV02_Related/Assets/GoldSalvageParticles/DomSynVioV02_GoldSalvageParticle_03.png")

const With2ndCenterBasedAttackSprite = preload("res://MiscRelated/AttackSpriteRelated/With2ndCenterBasedAttackSprite.gd")
const With2ndCenterBasedAttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/With2ndCenterBasedAttackSprite.tscn")

#

signal current_salvaged_gold_changed(arg_val)
signal current_bonus_ingredient_slot_count_changed(arg_val)
signal is_applying_omni_color_changed(arg_val)

#

const unstable_particle_variation_list = [
	DomSynVioV02_UnstableParticle_01,
	DomSynVioV02_UnstableParticle_02,
	DomSynVioV02_UnstableParticle_03,
	DomSynVioV02_UnstableParticle_04
]

const gold_salvage_particle_variation_list = [
	DomSynVioV02_GoldSalvageParticle_01,
	DomSynVioV02_GoldSalvageParticle_02,
	DomSynVioV02_GoldSalvageParticle_03,
	
]

#


const initial_unstable_round_count__tier_2 = 2
const initial_unstable_round_count__tier_1 = 1

# NOTE: var names are used by syninteractable
const salvage_gold_per_bonus_ing_slot : int = 8
const salvage_gold_breakpoint_for_omni_color : int = 40

var current_salvaged_gold : int = 0
var current_bonus_ingredient_slot_count : int = 0
var is_applying_omni_color : bool = false



const extra_temporary_ing_count : int = 1

#

var unstable_particle_pool_component : AttackSpritePoolComponent

var gold_salvage_particle_pool_component : AttackSpritePoolComponent
var _pos_to_gold_count_map : Dictionary = {}
var _is_gold_particles_playing : bool
var gold_salvage_particle_timer : Timer

const gold_particle_delta : float = 0.28

#

var syn_interactable : VioletV02_SynInteractable

#

var game_elements : GameElements
var current_tier : int

var non_essential_rng : RandomNumberGenerator

#

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	current_tier = tier
	
	if non_essential_rng == null:
		non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	if syn_interactable == null:
		syn_interactable = VioletV02_SynInteractable_Scene.instance()
		syn_interactable.dom_syn_vio_v02 = self
		
		game_elements.synergy_interactable_panel.add_synergy_interactable(syn_interactable)
	
	if unstable_particle_pool_component == null:
		_initialize_particle_pool_components()
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_benefit_from_synergy(tower)
	

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	current_tier = 0
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	for tower in all_towers:
		_tower_to_remove_from_synergy(tower)
	


##

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if tower.is_benefit_from_syn_having_or_as_if_having_color(TowerColors.VIOLET):
		if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.VIOLET_V02__SYNERGY_EFFECTS):
			var vio_syn_effect = VioletV02_SynergyEffects.new()
			
			vio_syn_effect.unstable_particle_pool_component = unstable_particle_pool_component
			vio_syn_effect.non_essential_rng = non_essential_rng
			vio_syn_effect.extra_temporary_ing_count = extra_temporary_ing_count
			
			if current_tier == 2:
				vio_syn_effect.initial_unstable_round_count = initial_unstable_round_count__tier_2
			elif current_tier == 1:
				vio_syn_effect.initial_unstable_round_count = initial_unstable_round_count__tier_1
			
			vio_syn_effect.connect("gold_salvaged", self, "_on_vio_syn_effect_gold_salvaged", [], CONNECT_PERSIST)
			vio_syn_effect.connect("request_configure_self_to_dom_syn", self, "_on_vio_syn_effect_request_configure_self_to_dom_syn", [vio_syn_effect], CONNECT_ONESHOT)
			
			tower.add_tower_effect(vio_syn_effect)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.VIOLET_V02__SYNERGY_EFFECTS)
	if effect != null:
		tower.remove_tower_effect(effect)

#

func _on_vio_syn_effect_request_configure_self_to_dom_syn(arg_effect : VioletV02_SynergyEffects):
	arg_effect.make_modification_to_tower__with_dom_syn(self)
	
	
	


##########

func set_current_salvaged_gold(arg_val):
	current_salvaged_gold = arg_val
	
	var ing_count = floor(current_salvaged_gold / salvage_gold_per_bonus_ing_slot)
	set_current_bonus_ingredient_slot_count(ing_count)
	
	if salvage_gold_breakpoint_for_omni_color <= current_salvaged_gold:
		set_is_applying_omni_color(true)
	else:
		set_is_applying_omni_color(false)
	
	emit_signal("current_salvaged_gold_changed", current_salvaged_gold)

func set_current_bonus_ingredient_slot_count(arg_val):
	if current_bonus_ingredient_slot_count != arg_val:
		current_bonus_ingredient_slot_count = arg_val
		
		emit_signal("current_bonus_ingredient_slot_count_changed", current_bonus_ingredient_slot_count)

func set_is_applying_omni_color(arg_val):
	var old_val = is_applying_omni_color
	is_applying_omni_color = arg_val
	
	if old_val != is_applying_omni_color:
		emit_signal("is_applying_omni_color_changed", is_applying_omni_color)


##

func _initialize_particle_pool_components():
	unstable_particle_pool_component = AttackSpritePoolComponent.new()
	unstable_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	unstable_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	unstable_particle_pool_component.source_for_funcs_for_attk_sprite = self
	unstable_particle_pool_component.func_name_for_creating_attack_sprite = "_create_unstable_particle"
	
	gold_salvage_particle_pool_component = AttackSpritePoolComponent.new()
	gold_salvage_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	gold_salvage_particle_pool_component.node_to_listen_for_queue_free = CommsForBetweenScenes.current_game_elements__other_node_hoster
	gold_salvage_particle_pool_component.source_for_funcs_for_attk_sprite = self
	gold_salvage_particle_pool_component.func_name_for_creating_attack_sprite = "_create_gold_salvage_particle"
	
	
	
	gold_salvage_particle_timer = Timer.new()
	gold_salvage_particle_timer.one_shot = false
	gold_salvage_particle_timer.connect("timeout", self, "_on_gold_salvage_particle_timer_timeout", [], CONNECT_PERSIST)
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(gold_salvage_particle_timer)

func _create_unstable_particle():
	var particle = AttackSprite_Scene.instance()
	
	particle.texture_to_use = StoreOfRNG.randomly_select_one_element(unstable_particle_variation_list, non_essential_rng)
	
	particle.lifetime = 0.5
	particle.queue_free_at_end_of_lifetime = false
	particle.frames_based_on_lifetime = false
	
	return particle





func _create_gold_salvage_particle():
	var particle = With2ndCenterBasedAttackSprite_Scene.instance()
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.z_index = ZIndexStore.SCREEN_EFFECTS_ABOVE_ALL
	particle.z_as_relative = false
	
	particle.has_lifetime = false
	
	particle.min_starting_distance_from_center = 8
	particle.max_starting_distance_from_center = 15
	
	particle.connect("reached_final_destination", self, "_on_gold_salvage_particle_reached_final_destination", [particle], CONNECT_PERSIST)
	
	return particle

func _play_gold_salvage_particle_at_pos(arg_source_pos):
	var particle : With2ndCenterBasedAttackSprite = gold_salvage_particle_pool_component.get_or_create_attack_sprite_from_pool()
	
	particle.texture_to_use = StoreOfRNG.randomly_select_one_element(gold_salvage_particle_variation_list, non_essential_rng)
	
	particle.global_position = arg_source_pos
	particle.center_pos_of_basis = arg_source_pos
	particle.secondary_center = syn_interactable.gold_texture_rect.rect_global_position
	
	particle.speed_accel_towards_center = 300
	particle.initial_speed_towards_center = non_essential_rng.randf_range(-60, -110)
	
	particle.reset_for_another_use()
	
	particle.secondary_initial_speed_towards_center = 0
	particle.secondary_speed_accel_towards_center = non_essential_rng.randf_range(440, 540)
	
	set_any_particle_random_modulate(particle)
	
	particle.visible = true


func set_any_particle_random_modulate(particle):
	var modulate_magnitude : float = non_essential_rng.randf_range(0.7, 1.3)
	particle.modulate = Color(modulate_magnitude, modulate_magnitude, modulate_magnitude, 1)
	


func _on_gold_salvage_particle_reached_final_destination(arg_particle):
	set_current_salvaged_gold(current_salvaged_gold + 1)
	


######

func _on_vio_syn_effect_gold_salvaged(arg_amount, arg_pos):
	increase_salvaged_gold_by_amount__from_pos(arg_amount, arg_pos)


func increase_salvaged_gold_by_amount__from_pos(arg_amount, arg_pos):
	if !_pos_to_gold_count_map.has(arg_pos):
		_pos_to_gold_count_map[arg_pos] = arg_amount
	else:
		_pos_to_gold_count_map[arg_pos] += arg_amount
	
	if !_is_gold_particles_playing:
		set_is_gold_particles_playing(true)

func set_is_gold_particles_playing(arg_val):
	_is_gold_particles_playing = arg_val
	
	if _pos_to_gold_count_map.size() > 0 and _is_gold_particles_playing:
		gold_salvage_particle_timer.start(gold_particle_delta)
	else:
		gold_salvage_particle_timer.stop()


func _on_gold_salvage_particle_timer_timeout():
	var poses_to_remove : Array = []
	
	for pos in _pos_to_gold_count_map.keys():
		var gold_count = _pos_to_gold_count_map[pos]
		
		_play_gold_salvage_particle_at_pos(pos)
		gold_count -= 1
		
		if gold_count > 0:
			_pos_to_gold_count_map[pos] = gold_count
		else:
			poses_to_remove.append(pos)
	
	for pos in poses_to_remove:
		_pos_to_gold_count_map.erase(pos)
	
	if _pos_to_gold_count_map.size() == 0:
		set_is_gold_particles_playing(false)

##########



