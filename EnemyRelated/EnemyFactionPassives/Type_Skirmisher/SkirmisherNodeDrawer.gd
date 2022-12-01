extends Node2D

const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

var _process_conditional_clause : ConditionalClauses
var _last_calculated_do_process : bool = false

const during_showing_red_flag_aura_clause : int = -10
const during_showing_blue_flag_aura_clause : int = -11

const max_line_distance_of_shapes : float = 1300.0

#

const red_flag_aura_color := Color(217.0 / 255.0, 2.0 / 255, 0, 0.1)
const blue_flag_aura_color := Color(2 / 255.0, 58 / 255.0, 218/ 255.0, 0.1)
const aura_growth_rate_per_sec : float = max_line_distance_of_shapes / 3.0

var _current_red_aura_radius : float
var _show_red_aura : bool
var _red_aura_center : Vector2

var _current_blue_aura_radius : float
var _show_blue_aura : bool
var _blue_aura_center : Vector2

#

func _init():
	_process_conditional_clause = ConditionalClauses.new()
	_process_conditional_clause.connect("clause_inserted", self, "__process_conditional_clause_clause_updated", [], CONNECT_PERSIST)
	_process_conditional_clause.connect("clause_removed", self, "__process_conditional_clause_clause_updated", [], CONNECT_PERSIST)

func __process_conditional_clause_clause_updated(arg_id):
	_last_calculated_do_process = !_process_conditional_clause.is_passed
	_update_process_state()

func _update_process_state():
	set_process(_last_calculated_do_process)

#

func _ready():
	_update_process_state()

#

func _process(delta):
	if _show_blue_aura:
		_current_blue_aura_radius += delta * aura_growth_rate_per_sec
	
	if _show_red_aura:
		_current_red_aura_radius += delta * aura_growth_rate_per_sec
	
	update()

#

func _draw():
	if _show_blue_aura:
		draw_circle(_blue_aura_center, _current_blue_aura_radius, blue_flag_aura_color)
	
	if _show_red_aura:
		draw_circle(_red_aura_center, _current_red_aura_radius, red_flag_aura_color)

#############

func show_blue_flag_aura(arg_center : Vector2):
	_blue_aura_center = arg_center
	_show_blue_aura = true
	_process_conditional_clause.attempt_insert_clause(during_showing_blue_flag_aura_clause)
	

func hide_blue_flag_aura():
	_current_blue_aura_radius = 0
	_show_blue_aura = false
	_process_conditional_clause.remove_clause(during_showing_blue_flag_aura_clause)
	update()

#
func show_red_flag_aura(arg_center : Vector2):
	_red_aura_center = arg_center
	_show_red_aura = true
	_process_conditional_clause.attempt_insert_clause(during_showing_red_flag_aura_clause)
	

func hide_red_flag_aura():
	_current_red_aura_radius = 0
	_show_red_aura = false
	_process_conditional_clause.remove_clause(during_showing_red_flag_aura_clause)
	update()
