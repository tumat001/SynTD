extends MarginContainer

const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")



const tower_being_dragged_mod : Color = Color(1, 1, 1, 0.0)
const mouse_inside_playable_area_mod_a : float = 0.5
const normal_vis_mod : Color = Color(1, 1, 1, 1.0)

const mod_a_transition_duration : float = 0.2


var tower_manager : TowerManager setget set_tower_manager
var synergy_manager setget set_synergy_manager
var game_elements

onready var tower_limit_label = $NotifContainer/VBoxContainer/ContentPanel/LabelMarginer/VBoxContainer/TowerLimitLabel


#

enum BlockShowSelfClauseIds {
	TUTORIAL = 0
}
var block_show_self_conditional_clauses : ConditionalClauses
var last_calculated_block_show_self : bool


var _attempted_start_show : bool
var _attempted_start_show_params

#

var _mod_tween : SceneTreeTween

var _was_inside_playable_area : bool
var _is_tower_dragging : bool

#

func _init():
	block_show_self_conditional_clauses = ConditionalClauses.new()
	block_show_self_conditional_clauses.connect("clause_inserted", self, "_on_block_show_self_conditional_clauses_updated", [], CONNECT_PERSIST)
	block_show_self_conditional_clauses.connect("clause_removed", self, "_on_block_show_self_conditional_clauses_updated", [], CONNECT_PERSIST)
	_update_last_calculated_block_show_self()

func _on_block_show_self_conditional_clauses_updated(arg_clause_id):
	_update_last_calculated_block_show_self()

func _update_last_calculated_block_show_self():
	last_calculated_block_show_self = !block_show_self_conditional_clauses.is_passed
	
	if _attempted_start_show:
		if !last_calculated_block_show_self:
			_start_show(_attempted_start_show_params[0], _attempted_start_show_params[1])
		
	elif visible and last_calculated_block_show_self:
		_end_show()

#

func _ready():
	modulate = normal_vis_mod
	
	set_process(false)

func set_tower_manager(arg_manager : TowerManager):
	tower_manager = arg_manager
	
	arg_manager.connect("tower_current_limit_taken_changed", self, "_tower_curr_slot_taken_changed", [], CONNECT_PERSIST)
	arg_manager.connect("tower_max_limit_changed", self, "_tower_max_limit_changed", [], CONNECT_PERSIST)
	
	arg_manager.connect("tower_being_dragged", self, "_tower_being_dragged", [], CONNECT_PERSIST)
	arg_manager.connect("tower_dropped_from_dragged", self, "_tower_released", [], CONNECT_PERSIST)

func set_synergy_manager(arg_manager):
	synergy_manager = arg_manager
	
	synergy_manager.connect("synergies_updated", self, "_syns_updated", [], CONNECT_PERSIST)

func all_properties_set():
	_update_display()


#

func _tower_curr_slot_taken_changed(slots_taken):
	_update_display()

func _tower_max_limit_changed(new_limit):
	_update_display()

func _syns_updated():
	_update_display()



func _update_display():
	var max_limit = tower_manager.last_calculated_tower_limit
	var curr_slots_taken = tower_manager.current_tower_limit_taken
	
	if max_limit == curr_slots_taken or synergy_manager.is_dom_color_synergy_active(TowerDominantColors.get_synergy_with_id(TowerDominantColors.SynergyID__Violet)):
		_end_show()
	else:
		_start_show(curr_slots_taken, max_limit)
		

func _get_display_string(curr_slots : int, max_limit : int) -> String:
	return "%s / %s" % [str(curr_slots), str(max_limit)]


#####

func _tower_being_dragged(tower):
	#modulate = tower_being_dragged_mod
	_is_tower_dragging = true
	
	_mod_tween = create_tween()
	_mod_tween.tween_property(self, "modulate:a", tower_being_dragged_mod.a, mod_a_transition_duration)


func _tower_released(tower):
	#modulate = normal_vis_mod
	_is_tower_dragging = false
	
	_mod_tween = create_tween()
	_mod_tween.tween_property(self, "modulate:a", normal_vis_mod.a, mod_a_transition_duration)
	
	_update_modulate_based_on_is_inside_playable_area()

##############

func _start_show(curr_slots_taken, max_limit):
	if !last_calculated_block_show_self:
		visible = true
		tower_limit_label.text = _get_display_string(curr_slots_taken, max_limit)
		
		set_process(true)
	else:
		_attempted_start_show = true
		_attempted_start_show_params = [curr_slots_taken, max_limit]


func _end_show():
	visible = false
	
	set_process(false)
	
	_attempted_start_show = false


func _process(delta):
	if !_is_tower_dragging:
		_update_modulate_based_on_is_inside_playable_area()
	

func _update_modulate_based_on_is_inside_playable_area():
	if game_elements.is_mouse_inside_playable_map_area():
		if !_was_inside_playable_area:
			_mod_tween = create_tween()
			_mod_tween.tween_property(self, "modulate:a", mouse_inside_playable_area_mod_a, mod_a_transition_duration)
		
		_was_inside_playable_area = true
	else:
		if _was_inside_playable_area:
			_mod_tween = create_tween()
			_mod_tween.tween_property(self, "modulate:a", normal_vis_mod.a, mod_a_transition_duration)
		
		_was_inside_playable_area = false
