extends MarginContainer

const EmblemButton = preload("res://TowerRelated/Color_Orange/704/704_InfoPanel/704_EmblemButton/EmblemButton.gd")
const _704 = preload("res://TowerRelated/Color_Orange/704/704.gd")

const BaseTowerSpecificTooltip = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.gd")
const BaseTowerSpecificTooltip_Scene = preload("res://MiscRelated/GUI_Category_Related/BaseTowerSpecificTooltip/BaseTowerSpecificTooltip.tscn")

onready var emblem_fire_button : EmblemButton = $VBoxContainer/BodyMarginer/BodyContainer/EmblemButtonFire
onready var emblem_explosive_button : EmblemButton = $VBoxContainer/BodyMarginer/BodyContainer/EmblemButtonExplosive
onready var emblem_toughness_pierce_button : EmblemButton = $VBoxContainer/BodyMarginer/BodyContainer/EmblemButtonToughnessPierce
onready var available_points_label : Label = $VBoxContainer/BodyMarginer/BodyContainer/MarginContainer2/PointsLabel
onready var about_button : TextureButton = $VBoxContainer/TopMarginer/AboutButton

var tower_704 : _704 setget set_tower
var tower_tooltip : BaseTowerSpecificTooltip

#

static func should_display_self_for(tower) -> bool:
	return tower is _704


# setters and connects (and updates)

func set_tower(tower : _704):
	if is_instance_valid(tower_704) and tower_704.is_connected("available_points_changed", self, "_update_available_points"):
		tower_704.disconnect("available_points_changed", self, "_update_available_points")
		tower_704.disconnect("fire_level_changed", self, "_update_fire_level")
		tower_704.disconnect("explosive_level_changed", self, "_update_explosive_level")
		tower_704.disconnect("toughness_pierce_level_changed", self, "_update_toughness_pierce_level")
	
	tower_704 = tower
	
	if is_instance_valid(tower_704) and !tower_704.is_connected("available_points_changed", self, "_update_available_points"):
		tower_704.connect("available_points_changed", self, "_update_available_points")
		tower_704.connect("fire_level_changed", self, "_update_fire_level")
		tower_704.connect("explosive_level_changed", self, "_update_explosive_level")
		tower_704.connect("toughness_pierce_level_changed", self, "_update_toughness_pierce_level")


func _update_available_points():
	available_points_label.text = str(tower_704.available_points)

func _update_fire_level():
	emblem_fire_button.emblem_level = tower_704.emblem_fire_points
	emblem_fire_button.update_level()

func _update_explosive_level():
	emblem_explosive_button.emblem_level = tower_704.emblem_explosive_points
	emblem_explosive_button.update_level()

func _update_toughness_pierce_level():
	emblem_toughness_pierce_button.emblem_level = tower_704.emblem_toughness_pierce_points
	emblem_toughness_pierce_button.update_level()


func update_display():
	if is_instance_valid(tower_704):
		_update_available_points()
		_update_fire_level()
		_update_explosive_level()
		_update_toughness_pierce_level()

# ready

func _ready():
	emblem_fire_button.emblem_type = EmblemButton.FIRE
	emblem_explosive_button.emblem_type = EmblemButton.EXPLOSIVE
	emblem_toughness_pierce_button.emblem_type = EmblemButton.TOUGHNESS_PIERCE
	
	emblem_fire_button.update_type()
	emblem_explosive_button.update_type()
	emblem_toughness_pierce_button.update_type()
	

# fire emblem pressed

func _on_EmblemButtonFire_emblem_button_left_pressed():
	if is_instance_valid(tower_704):
		tower_704.attempt_allocate_points_to_fire()
		
		_update_tooltip_of_fire_level()


func _on_EmblemButtonFire_emblem_button_right_pressed():
	if !is_instance_valid(tower_tooltip):
		_construct_tower_tooltip(emblem_fire_button)
		tower_tooltip.descriptions = [
			"704's attacks causes enemies to burn on hit. Burned enemies take elemental damage every 0.5 seconds for 5 seconds.",
			"",
			"Lvl 0: No burn.",
			"Lvl 1: Burn damage = 0.4",
			"Lvl 2: Burn damage = 0.7",
			"Lvl 3: Burn damage = 1.0",
			"Lvl 4: Burn damage = 1.3"
		]
		
		get_tree().get_root().add_child(tower_tooltip)
		
		tower_tooltip.update_display()
		_update_tooltip_of_fire_level()
		
	else:
		tower_tooltip.queue_free()
		tower_tooltip = null

func _update_tooltip_of_fire_level():
	if is_instance_valid(tower_tooltip):
		tower_tooltip.left_label.text = "Fire Emblem: Lvl " + str(tower_704.emblem_fire_points)


func _construct_tower_tooltip(button_owner : BaseButton):
	var tooltip = BaseTowerSpecificTooltip_Scene.instance()
	tooltip.tooltip_owner = button_owner
	
	tower_tooltip = tooltip

# explosive emblem pressed

func _on_EmblemButtonExplosive_emblem_button_left_pressed():
	if is_instance_valid(tower_704):
		tower_704.attempt_allocate_points_to_explosive()
		_update_tooltip_of_explosive_level()


func _on_EmblemButtonExplosive_emblem_button_right_pressed():
	if !is_instance_valid(tower_tooltip):
		_construct_tower_tooltip(emblem_explosive_button)
		tower_tooltip.descriptions = [
			"704's main attacks explode upon reaching the target location. Explosions affect up to 5 enemies, but not including the main target.",
			"Explosions deal 1.5 elemental damage and benefit from base damage buffs.",
			"",
			"Lvl 0: No explosion.",
			"Lvl 1: Small explosion.",
			"Lvl 2: Small explosion. Applies on hit damages at 33% efficiency.",
			"Lvl 3: Medium explosion. Applies on hit damages at 66% efficiency.",
			"Lvl 4: Big explosion. Applies on hit damages at 100% efficiency, and applies on hit effects."
		]
		
		get_tree().get_root().add_child(tower_tooltip)
		
		tower_tooltip.update_display()
		_update_tooltip_of_explosive_level()
		
	else:
		tower_tooltip.queue_free()
		tower_tooltip = null


func _update_tooltip_of_explosive_level():
	if is_instance_valid(tower_tooltip):
		tower_tooltip.left_label.text = "Explosive Emblem: Lvl " + str(tower_704.emblem_explosive_points)


# toughness pierce pressed

func _on_EmblemButtonToughnessPierce_emblem_button_left_pressed():
	if is_instance_valid(tower_704):
		tower_704.attempt_allocate_points_to_toughness_pierce()
		_update_tooltip_of_toughness_pierce_level()

func _on_EmblemButtonToughnessPierce_emblem_button_right_pressed():
	if !is_instance_valid(tower_tooltip):
		_construct_tower_tooltip(emblem_toughness_pierce_button)
		tower_tooltip.descriptions = [
			"704's launched attack gains toughness pierce.",
			"",
			"Lvl 0: Toughness pierce = 0",
			"Lvl 1: Toughness pierce = 2",
			"Lvl 2: Toughness pierce = 4",
			"Lvl 3: Toughness pierce = 6. Burn damage now benefits from this.",
			"Lvl 4: Toughness pierce = 8. Burn damage and explosion now benefits from this.",
		]
		
		get_tree().get_root().add_child(tower_tooltip)
		
		tower_tooltip.update_display()
		_update_tooltip_of_toughness_pierce_level()
		
	else:
		tower_tooltip.queue_free()
		tower_tooltip = null


func _update_tooltip_of_toughness_pierce_level():
	if is_instance_valid(tower_tooltip):
		tower_tooltip.left_label.text = "Toughness Pierce Emblem: Lvl " + str(tower_704.emblem_toughness_pierce_points)


# About pressed

func _on_AboutButton_pressed():
	if !is_instance_valid(tower_tooltip):
		_construct_tower_tooltip(about_button)
		
		tower_tooltip.descriptions = [
			"Each emblem gives specific buffs based on its level. Points can be used to level them up.",
			"Left click on the emblem to level it up.",
			"Right click on the emblem to view its details."
		]
		
		get_tree().get_root().add_child(tower_tooltip)
		
		tower_tooltip.update_display()
		tower_tooltip.left_label.text = "About Emblems"
		
	else:
		tower_tooltip.queue_free()
		tower_tooltip = null
