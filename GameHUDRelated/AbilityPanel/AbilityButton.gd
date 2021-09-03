extends MarginContainer

const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const AbilityTooltip = preload("res://GameHUDRelated/AbilityPanel/AbilityTooltip/AbilityTooltip.gd")
const AbilityTooltip_Scene = preload("res://GameHUDRelated/AbilityPanel/AbilityTooltip/AbilityTooltip.tscn")

const NO_HOTKEY_NUM : int = -1


var ability : BaseAbility setget set_ability

const ready_modulate_color = Color(1, 1, 1, 1)
const not_ready_modulate_color = Color(0.6, 0.6, 0.6, 1)

onready var cooldown_bar : TextureProgress = $CooldownBar
onready var ability_button : TextureButton = $AbilityButtonPressable
onready var auto_cast_frame : TextureRect = $AutocastFrame

var ability_tooltip : AbilityTooltip
var hotkey_num : int = NO_HOTKEY_NUM

export var destroy_button_if_ability_lost : bool = true


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
	if ability_button != null and ability != null:
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


func _should_be_displaying(value : bool):
	visible = value


# button pressed

func _on_AbilityButton_pressed_mouse_event(event):
	if ability != null:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == BUTTON_LEFT and !event.shift:
				_ability_button_left_pressed()
			elif event.button_index == BUTTON_RIGHT:
				_ability_button_right_pressed()
			elif event.button_index == BUTTON_LEFT and event.shift:
				_ability_button_autocast_pressed()


func _ability_button_left_pressed():
	if ability != null and ability.is_ready_for_activation():
		ability.activate_ability()


func _ability_button_right_pressed():
	if ability != null:
		if ability_tooltip != null:
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
	
	get_tree().get_root().add_child(ability_tooltip)


func _update_tooltip():
	if ability_tooltip != null:
		ability_tooltip.descriptions = ability.descriptions
		ability_tooltip.header_left_text = ability.display_name
		ability_tooltip.header_right_text = "Hotkey: %s" % str(hotkey_num)
		ability_tooltip.update_display()
