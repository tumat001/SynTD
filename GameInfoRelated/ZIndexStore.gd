extends Node

enum {
	MAP_ENVIRONMENT = -3000,
	TERRAIN_ABOVE_MAP_ENVIRONMENT = -2999
	ABOVE_MAP_ENVIRONMENT = -2998
	ABOVE_ABOVE_MAP_ENVIRONMENT = -2997
	
	BELOW_TOWER_PLACABLES = -1001
	TOWER_PLACABLES = -1000,
	
	PARTICLE_EFFECTS_BELOW_ENEMIES = -401
	ENEMIES = -400
	
	TOWER_BENCH = -299,
	TOWER_BENCH_PLACABLES = -298,
	
	PARTICLE_EFFECTS_BELOW_TOWERS = -191
	TOWERS = -190,
	ABOVE_TOWERS = -189,
	ENEMIES_ABOVE_TOWERS = -188
	ENEMY_INFO_BAR = -187,
	
	MAP_ENVIRONMENT_BELOW_PARTICLE_EFFECTS = -103,
	PARTICLE_EFFECTS_BELOW_PARTICLE_EFFECTS = -102,
	PARTICLE_EFFECTS = -101
	SCREEN_EFFECTS = -100
	
	SCREEN_EFFECTS_ABOVE_ALL = 0#VisualServer.CANVAS_ITEM_Z_MAX - 2
	WHOLE_SCREEN_GUI = 0 #VisualServer.CANVAS_ITEM_Z_MAX - 1
	
	TOWERS_BEING_DRAGGED = 1,
	
}


enum CanvasZLayer {
	
	BUY_CARD_DRAG = 100
}
