extends MarginContainer

const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const AbilityTooltip = preload("res://GameHUDRelated/AbilityPanel/AbilityTooltip/AbilityTooltip.gd")
const AbilityTooltip_Scene = preload("res://GameHUDRelated/AbilityPanel/AbilityTooltip/AbilityTooltip.tscn")

const GameSettingsManager = preload("res://GameElementsRelated/GameSettingsManager.gd")

#const NO_HOTKEY_NUM : int = -1
const NO_HOTKEY : String = ""

signal button_destroying_self()


var game_settings_manager : GameSettingsManager

var ability : BaseAbility setget set_ability

const ready_modulate_color = Color(1, 1, 1, 1)
const not_ready_modulate_color = Color(0.6, 0.6, 0.6, 1)

onready var cooldown_bar : TextureProgress = $CooldownBar
onready var ability_button : TextureButton = $AbilityButtonPressable
onready var auto_cast_frame : TextureRect = $AutocastFrame

var ability_tooltip : AbilityTooltip
#var hotkey_num : int = NO_HOTKEY_NUM
var hotkey : String = NO_HOTKEY

var is_mouse_inside_button : bool = false

export(bool) var destroy_button_if_ability_lost : bool = true

#

var _ability_panel
var is_drag_and_droppable : bool = false

var _is_being_dragged : bool = false
var _is_being_left_pressed : bool = false

# setting and connections

func set_ability(arg_ability : BaseAbility):
	if ability != null:
		_disconnect_ability_signals()
	
	ability = arg_ability
	
	if ability != null:
		if !ability.is_connected("current_round_cd_changed", self, "_current_cd_changed"):
			ability.connect("current_round_cd_changed", self, "_current_cd_changed", [], CONNECT_PERSIST)
			ability.connect("current_time_cd_changed", self, "_current_cd_changed", [], CONNECT_PERSIST)
			ability.connect("destroying_self", self, "_ability_destroying_self", [], CONNECT_PERSIST)
			ability.connect("icon_changed", self, "_icon_texture_changed", [], CONNECT_PERSIST)
			ability.connect("started_round_cooldown", self, "_started_cd", [], CONNECT_PERSIST)
			ability.connect("started_time_cooldown", self, "_started_cd", [], CONNECT_PERSIST)
			ability.connect("updated_is_ready_for_activation", self, "_updated_is_ready_for_activation", [], CONNECT_PERSIST)
			ability.connect("should_be_displaying_changed", self, "_should_be_displaying", [], CONNECT_PERSIST)
			ability.connect("auto_cast_state_changed", self, "_ability_autocast_state_changed", [], CONNECT_PERSIST)
			ability.connect("display_name_changed", self, "_ability_name_changed", [], CONNECT_PERSIST)
			ability.connect("descriptions_changed", self, "_ability_descriptions_changed", [], CONNECT_PERSIST)
			
		_update_button_status()

func _disconnect_ability_signals():
	if ability.is_connected("current_round_cd_changed", self, "_current_cd_changed"):
		ability.disconnect("current_round_cd_changed", self, "_current_cd_changed")
		ability.disconnect("current_time_cd_changed", self, "_current_cd_changed")
		ability.disconnect("destroying_self", self, "_ability_destroying_self")
		ability.disconnect("icon_changed", self, "_icon_texture_changed")
		ability.disconnect("started_round_cooldown", self, "_started_cd")
		ability.disconnect("started_time_cooldown", self, "_started_cd")
		ability.disconnect("updated_is_ready_for_activation", self, "_updated_is_ready_for_activation")
		ability.disconnect("should_be_displaying_changed", self, "_should_be_displaying")
		ability.disconnect("auto_cast_state_changed", self, "_ability_autocast_state_changed")
		ability.disconnect("display_name_changed", self, "_ability_name_changed")
		ability.disconnect("descriptions_changed", self, "_ability_descriptions_changed")


func _update_button_status():
	if is_instance_valid(ability_button) and ability != null:
		ability_button.texture_normal = ability.icon
		
		if ability.is_timebound:
			if ability._time_max_cooldown != 0:
				_started_cd(ability._time_max_cooldown, 0)
			_current_cd_changed(ability._time_current_cooldown)
		elif ability.is_roundbound:
			if ability._round_max_cooldown != 0:
				_started_cd(ability._round_max_cooldown, 0)
			_current_cd_changed(ability._round_current_cooldown)
		
		_should_be_displaying(ability.should_be_displaying)
		_ability_autocast_state_changed(ability.auto_cast_on)
		_updated_is_ready_for_activation(ability.is_ready_for_activation())

# Current cd changed

func _current_cd_changed(curr_cd):
	cooldown_bar.value = curr_cd
	
	cooldown_bar.visible = curr_cd > 0


# Started cd

func _started_cd(max_cd, curr_cd):
	cooldown_bar.max_value = max_cd
	cooldown_bar.visible = true
	# _current_cd_changed will be called


# can be activated

func _updated_is_ready_for_activation(is_ready):
	if is_ready:
		_is_ready()
	else:
		_is_not_ready()


func _is_ready():
	ability_button.modulate = ready_modulate_color
	cooldown_bar.visible = false


func _is_not_ready():
	ability_button.modulate = not_ready_modulate_color


# autocast related

func _ability_autocast_state_changed(autocast):
	if ability != null:
		auto_cast_frame.visible = ability.auto_cast_on


# other changes

func _icon_texture_changed(icon : Texture):
	ability_button.texture_normal = icon

func _ability_name_changed(new_name : String):
	_update_tooltip()

func _ability_descriptions_changed(desc : Array):
	_update_tooltip()


func _ability_destroying_self():
	if ability != null:
		_disconnect_ability_signals()
	
	if destroy_button_if_ability_lost:
		queue_free()
		emit_signal("button_destroying_self")


func _should_be_displaying(value : bool):
	visible = value


# button pressed

func _on_AbilityButton_pressed_mouse_event(event):
	if ability != null:
		if event.button_index == BUTTON_LEFT and !event.shift:
			#_ability_button_left_pressed()
			_is_being_left_pressed = true
			
		if event.button_index == BUTTON_RIGHT:
			_ability_button_right_pressed()
		elif event.button_index == BUTTON_LEFT and event.shift:
			_ability_button_autocast_pressed()
			


func _on_AbilityButtonPressable_released_mouse_event(event):
	if ability != null:
		if event.button_index == BUTTON_LEFT and !event.shift:
			_ability_button_left_pressed()
			
			_is_being_left_pressed = false
			_end_of_being_dragged()
		#elif event.button_index == BUTTON_RIGHT:
		#	_ability_button_right_pressed()
		#elif event.button_index == BUTTON_LEFT and event.shift:
		#	_ability_button_autocast_pressed()



func _ability_button_left_pressed():
	attempt_activate_ability()

func attempt_activate_ability():
	if ability != null and ability.is_ready_for_activation():
		ability.activate_ability()



func _ability_button_right_pressed():
	if ability != null:
		if is_instance_valid(ability_tooltip):
			ability_tooltip.queue_free()
			ability_tooltip = null
			
		else:
			_construct_tooltip()
			_update_tooltip()
			ability_tooltip.visible = true


func _ability_button_autocast_pressed():
	if ability != null:
		ability.auto_cast_on = !ability.auto_cast_on


# Tooltip related

func _construct_tooltip():
	ability_tooltip = AbilityTooltip_Scene.instance()
	ability_tooltip.tooltip_owner = ability_button
	ability_tooltip.tower_associated_with_ability = ability.tower
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(ability_tooltip)


func _update_tooltip():
	if is_instance_valid(ability_tooltip):
		if game_settings_manager == null or game_settings_manager.descriptions_mode == GameSettingsManager.DescriptionsMode.COMPLEX or !ability.has_simple_descriptions():
			if ability.descriptions_source == null:
				ability_tooltip.descriptions = ability.descriptions
			else:
				ability_tooltip.descriptions = ability.descriptions_source.call(ability.descriptions_source_func_name)
		elif game_settings_manager.descriptions_mode == GameSettingsManager.DescriptionsMode.SIMPLE:
			if ability.simple_descriptions_source == null:
				ability_tooltip.descriptions = ability.simple_descriptions
			else:
				ability_tooltip.descriptions = ability.simple_descriptions_source.call(ability.simple_descriptions_source_func_name)
		
		ability_tooltip.header_left_text = ability.display_name
		
		if hotkey != NO_HOTKEY:#-1:
			ability_tooltip.header_right_text = "Hotkey: %s" % hotkey
		
		ability_tooltip.update_display()


# drag related

func get_drag_data(position):
	if is_drag_and_droppable:
		var icon_preview = _get_drag_preview_of_self()
		set_drag_preview(icon_preview)
		
		
		return _get_drag_data_of_self()
	else:
		return null

func _get_drag_data_of_self():
	return DropData.new(hotkey)

func _get_drag_preview_of_self() -> TextureRect:
	var icon_preview = TextureRect.new()
	icon_preview.texture = ability.icon
	
	var icon_size = ability.icon.get_size()
	#icon_preview.position = Vector2(-icon_size.x / 2.0, -icon_size.y / 2.0)
	icon_preview.anchor_left = 0.5
	icon_preview.anchor_bottom = 0.5
	icon_preview.anchor_right = 0.5
	icon_preview.anchor_top = 0.5
	icon_preview.mouse_filter = MOUSE_FILTER_IGNORE
	icon_preview.connect("tree_exiting", self, "_preview_exiting", [], CONNECT_ONESHOT)
	
	return icon_preview

func _preview_exiting():
	_end_of_being_dragged()


class DropData:
	var hotkey
	
	func _init(arg_hotkey):
		hotkey = arg_hotkey


func can_drop_data(position, data):
	return is_drag_and_droppable and data is DropData 


func drop_data(position, data):
	_ability_panel.swap_buttons_with_hotkeys(int(hotkey), int(data.hotkey))



func _on_AbilityButtonPressable_gui_input(event):
	if is_drag_and_droppable:
		if event is InputEventMouseMotion:
			if !_is_being_dragged and _is_being_left_pressed:
				#force_drag(_get_drag_data_of_self(), _get_drag_preview_of_self())
				_is_being_dragged = true

func _end_of_being_dragged():
	if _is_being_dragged:
		_is_being_dragged = false
		_is_being_left_pressed = false



# hover related

func _on_AbilityButtonPressable_mouse_entered():
	is_mouse_inside_button = true


func _on_AbilityButtonPressable_mouse_exited():
	is_mouse_inside_button = false


#

