extends MarginContainer

const Stageround = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")


const NO_MORE_NEXT_RELIC_DISPLAY : String = "-----"
const DISPLAY_FOR_NEXT_STAGEROUND_TEMPLATE := "%s-%s"

var stage_round_manager setget set_stage_round_manager
var _next_stageround_id_for_relic_offer : String
var _next_stage_num : String
var _next_round_num : String
var _no_more_left : bool = false

onready var stageround_for_next_relic_label = $ContentMargin/VBoxContainer/HBoxContainer/MarginContainer/StageroundForNextRelicLabel


func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	_update_next_stageround_offered_display()
	stage_round_manager.connect("round_ended", self, "_on_round_ended", [], CONNECT_PERSIST)
	stage_round_manager.connect("stage_rounds_set", self, "_on_stage_rounds_set", [], CONNECT_PERSIST)

func _on_round_ended(arg_stageround : Stageround):
	if (_next_stageround_id_for_relic_offer == "" or _next_stageround_id_for_relic_offer == arg_stageround.id) and !_no_more_left:
		_update_next_stageround_offered_display()
		

func _on_stage_rounds_set(stagerounds):
	_update_next_stageround_offered_display()


func _update_next_stageround_offered_display():
	if stage_round_manager.stagerounds != null and stage_round_manager.current_stageround != null:
		var next_relic_stageround = stage_round_manager.stagerounds.get_next_relic_giving_round_from_current(stage_round_manager.current_stageround)
		
		if next_relic_stageround != null:
			var stage_and_round : Array = Stageround.convert_stageround_id_to_stage_and_round_num(next_relic_stageround.id)
			stageround_for_next_relic_label.text = DISPLAY_FOR_NEXT_STAGEROUND_TEMPLATE % stage_and_round
			_no_more_left = false
			
		else:
			stageround_for_next_relic_label.text = NO_MORE_NEXT_RELIC_DISPLAY
			_no_more_left = true


