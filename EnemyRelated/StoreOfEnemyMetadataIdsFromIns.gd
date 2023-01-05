extends Node


enum {
	
	NOT_SPAWNED_FROM_INS = 1   # use this if this field should be set as false
	
	
	SKIRMISHER_SPAWN_AT_PATH_TYPE = 1000
	
	MAP_ENCHANT__SPECIAL_ENEMY_MARKER = 1001
	
}

const metadata_path_reserving : Array = [
	MAP_ENCHANT__SPECIAL_ENEMY_MARKER,
	
]

static func is_enemy_metadata_free_from_reserved_paths_metadata(arg_metadata, arg_blacklist : Array):
	if arg_metadata == null:
		return true
	
	for metadata in metadata_path_reserving:
		if arg_metadata.has(metadata) and !arg_blacklist.has(metadata):
			return false
	
	return true



