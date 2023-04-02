extends "res://EnemyRelated/EnemyFactionPassives/Type_Morphers/_Morphs/AbstractMorph.gd"



const bare_new_max_health_ratio : float = 0.60
const delay_before_next_spawn : float = 0.9
const delay_for_timer_delta : float = 0.05

#

class HordeSpawnDetails:
	
	var time_left : float
	
	var unit_offset : float
	
	var enemy_id_to_spawn : int
	

var horde_spawn_details_list : Array
var horde_spawn_timer : Timer

#

func _init().(StoreOfEnemyMorphs.MorphIds.BARE__HORDE):
	
	#todo
	icon #=
	
	var plain_fragment__bares = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Bares")
	var plain_fragment__health = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY_STAT__HEALTH, "%s%% max health" % [bare_new_max_health_ratio])
	
	var plain_fragment__bare = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Bare")
	
	descriptions = [
		["|0| only have |1|.", [plain_fragment__bares, plain_fragment__health]],
		["Whenever a |0| is spawned, spawn another one shortly after.", [plain_fragment__bare]]
	]
	
	
	var plain_fragment__wildcards = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Wildcards")
	var plain_fragment__wildcard = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Wildcard")
	
	descriptions_for_wildcard = [
		["|0| only have |1|.", [plain_fragment__wildcards, plain_fragment__health]],
		["Whenever a |0| is spawned, spawn another one shortly after.", [plain_fragment__wildcard]]
	]


func _apply_morph(arg_game_elements):
	._apply_morph(arg_game_elements)
	
	_construct_horde_spawn_timer()
	_listen_for_enemy_before_enemy_spawned(arg_game_elements, "_on_enemy_before_spawned", null)
	game_elements.enemy_manager.connect("on_enemy_spawned_and_finished_ready_prep", self, "_on_enemy_spawned_and_finished_ready_prep", [], CONNECT_PERSIST)

func _unapply_morph(arg_game_elements):
	._unapply_morph(arg_game_elements)
	
	if is_instance_valid(horde_spawn_timer) and !horde_spawn_timer.is_queued_for_deletion():
		horde_spawn_timer.queue_free()
	_unlisten_for_enemy_before_enemy_spawned(arg_game_elements, "_on_enemy_before_spawned")
	game_elements.enemy_manager.disconnect("on_enemy_spawned_and_finished_ready_prep", self, "_on_enemy_spawned_and_finished_ready_prep")
	

###

func _construct_horde_spawn_timer():
	horde_spawn_timer = Timer.new()
	horde_spawn_timer.one_shot = false
	horde_spawn_timer.connect("timeout", self, "_on_horde_spawn_timer_timeout", [], CONNECT_PERSIST)
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(horde_spawn_timer)


func _on_horde_spawn_timer_timeout():
	for details in horde_spawn_details_list:
		details.time_left -= delay_for_timer_delta
		if details.time_left <= 0:
			_remove_bare_to_summon_from_queue__and_summon_bare(details)

#

func _on_enemy_before_spawned(arg_enemy, arg_params):
	if arg_enemy.enemy_id == EnemyConstants.Enemies.BARE or arg_enemy.enemy_id == EnemyConstants.Enemies.WILDCARD:
		arg_enemy.base_health *= bare_new_max_health_ratio
		
		#if !arg_enemy.enemy_type_info_metadata.has(StoreOfEnemyMetadataIdsFromIns.MORPH_BARE_SPAWNED_FROM_HORDE_MARKER):
		#	var spawn_details = _construct_spawn_details_from_enemy(arg_enemy)
		#	_add_new_bare_to_summon_to_queue(spawn_details)


func _on_enemy_spawned_and_finished_ready_prep(arg_enemy):
	if arg_enemy.enemy_id == EnemyConstants.Enemies.BARE or arg_enemy.enemy_id == EnemyConstants.Enemies.WILDCARD:
		if !arg_enemy.enemy_type_info_metadata.has(StoreOfEnemyMetadataIdsFromIns.MORPH_BARE_SPAWNED_FROM_HORDE_MARKER):
			var spawn_details = _construct_spawn_details_from_enemy(arg_enemy)
			_add_new_bare_to_summon_to_queue(spawn_details)
	


func _add_new_bare_to_summon_to_queue(arg_details):
	horde_spawn_details_list.append(arg_details)
	if horde_spawn_timer.time_left == 0:
		horde_spawn_timer.start(delay_for_timer_delta)

func _construct_spawn_details_from_enemy(arg_enemy):
	var spawn_details = HordeSpawnDetails.new()
	spawn_details.time_left = delay_before_next_spawn
	spawn_details.unit_offset = arg_enemy.unit_offset
	spawn_details.enemy_id_to_spawn = arg_enemy.enemy_id
	
	return spawn_details


func _remove_bare_to_summon_from_queue__and_summon_bare(arg_details : HordeSpawnDetails):
	horde_spawn_details_list.erase(arg_details)
	##
	
	var enemy_id = arg_details.enemy_id_to_spawn
	var enemy_to_spawn
	
	if enemy_id == EnemyConstants.Enemies.BARE:
		enemy_to_spawn = game_elements.enemy_manager.spawn_enemy(EnemyConstants.Enemies.BARE)
		
	elif enemy_id == EnemyConstants.Enemies.WILDCARD:
		enemy_to_spawn = game_elements.enemy_manager.spawn_enemy(EnemyConstants.Enemies.WILDCARD)
		
	
	enemy_to_spawn.enemy_type_info_metadata[StoreOfEnemyMetadataIdsFromIns.MORPH_BARE_SPAWNED_FROM_HORDE_MARKER] = true
	enemy_to_spawn.shift_unit_offset(arg_details.unit_offset)


