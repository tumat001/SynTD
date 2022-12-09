extends MarginContainer

const RelicStoreOfferOption = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Classes/RelicStoreOfferOption.gd")
const RelicStoreBuyHistory = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Classes/RelicStoreBuyHistory.gd")
const Stageround = preload("res://GameplayRelated/StagesAndRoundsRelated/StageRound.gd")


const EXTRA_DESC_TEMPLTE = "Bought at stage-round: %s-%s"

onready var relic_counter_panel = $ContentPanel/VBoxContainer/HBoxContainer/VBoxContainer/StoreHeaderPanel2/RelicCounterPanel
onready var relic_next_stageround_offered_panel = $ContentPanel/VBoxContainer/HBoxContainer/VBoxContainer/StoreHeaderPanel2/RelicNextStageroundOfferedPanel
onready var relic_store_panel = $ContentPanel/VBoxContainer/HBoxContainer/VBoxContainer/StorePanel/RelicStorePanel

onready var relic_history_panel = $ContentPanel/VBoxContainer/HBoxContainer/RelicHistoryPanel
onready var close_button = $ContentPanel/VBoxContainer/BottomExitPanel/CloseButton


var stage_round_manager
var relic_manager
var whole_screen_gui

#

func set_managers_using_game_elements(arg_game_elements):
	stage_round_manager = arg_game_elements.stage_round_manager
	relic_manager = arg_game_elements.relic_manager
	whole_screen_gui = arg_game_elements.whole_screen_gui
	
	relic_counter_panel.relic_manager = relic_manager
	relic_next_stageround_offered_panel.stage_round_manager = stage_round_manager
	relic_store_panel.relic_manager = relic_manager

#

func _ready():
	relic_store_panel.connect("after_call_obj_source_on_click_on_button", self, "_on_after_call_obj_source_on_click_on_shop_button", [], CONNECT_PERSIST)
	close_button.connect("on_button_released_with_button_left", self, "_on_button_released_with_button_left", [], CONNECT_PERSIST)

#

func add_relic_store_offer_option(arg_relic_store_offer_option : RelicStoreOfferOption) -> int:
	return relic_store_panel.add_relic_store_offer_option(arg_relic_store_offer_option)

func remove_relic_store_offer_option(arg_offer_id):
	return relic_store_panel.remove_relic_store_offer_option(arg_offer_id)


func trigger_relic_store_offer_option(arg_offer_id):
	relic_store_panel.trigger_relic_store_offer_option(arg_offer_id)

func is_shop_offer_id_exists(arg_offer_id):
	return relic_store_panel.is_shop_offer_id_exists(arg_offer_id)

#

func _on_after_call_obj_source_on_click_on_shop_button(arg_relic_store_offer_option : RelicStoreOfferOption, arg_success : bool, arg_button_id):
	if arg_success:
		var buy_history : RelicStoreBuyHistory = _create_store_buy_history_from_offer_option(arg_relic_store_offer_option)
		relic_history_panel.add_buy_history(buy_history)


func _create_store_buy_history_from_offer_option(arg_relic_store_offer_option : RelicStoreOfferOption):
	var descs = arg_relic_store_offer_option.get_descriptions_to_use__duplicate()
	var stage_and_round : Array = Stageround.convert_stageround_id_to_stage_and_round_num(stage_round_manager.current_stageround.id)
	var extra_desc = EXTRA_DESC_TEMPLTE % stage_and_round
	
	descs.append("")
	descs.append(extra_desc)
	
	var buy_history := RelicStoreBuyHistory.new(stage_round_manager.current_stageround.id, descs, arg_relic_store_offer_option.button_texture_normal)
	buy_history.header_left_text = arg_relic_store_offer_option.header_left_text
	
	return buy_history

##########

func _on_button_released_with_button_left():
	whole_screen_gui.hide_control(self)


