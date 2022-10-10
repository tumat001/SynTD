extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const AttackSprite_Scene = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.tscn")

const DragonSoulAttk_Pic01 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk01.png")
const DragonSoulAttk_Pic02 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk02.png")
const DragonSoulAttk_Pic03 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk03.png")
const DragonSoulAttk_Pic04 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk04.png")
const DragonSoulAttk_Pic05 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk05.png")
const DragonSoulAttk_Pic06 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk06.png")
const DragonSoulAttk_Pic07 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk07.png")
const DragonSoulAttk_Pic08 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk08.png")
const DragonSoulAttk_Pic09 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk09.png")
const DragonSoulAttk_Pic10 = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_DragonSoul_AttkSprite/DragonSoul_Attk10.png")


var enemy_execute_ratio : float
var player_execute_ratio : float

var soul_execute_sf : SpriteFrames

var health_forgiveness_flat_meter_for_offerable : float = 10.0
const tier_to_player_exec_ratio : Dictionary = {
	0 : 0.25,
	1 : 0.2,
	2 : 0.15,
	3 : 0.1
}


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.DRAGON_SOUL, "Dragon Soul", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		enemy_execute_ratio = 0.35
		#player_execute_ratio = 0.25 
	elif tier == 1:
		enemy_execute_ratio = 0.25
		#player_execute_ratio = 0.2 
	elif tier == 2:
		enemy_execute_ratio = 0.20
		#player_execute_ratio = 0.15 
	elif tier == 3:
		enemy_execute_ratio = 0.1
		#player_execute_ratio = 0.1 
	
	player_execute_ratio = tier_to_player_exec_ratio[tier]
	
	good_descriptions = [
		"The Dragon marks enemies upon spawning. The Dragon executes marked enemies below %s health post-damage." % (str((enemy_execute_ratio * 100)) + "%")
	]
	
	bad_descriptions = [
		"The Dragon executes you if you are below %s health" % [(str(player_execute_ratio * 100) + "%")]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_DragonSoul_Icon.png")
	
	soul_execute_sf = SpriteFrames.new()
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic01)
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic02)
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic03)
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic04)
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic05)
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic06)
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic07)
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic08)
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic09)
	soul_execute_sf.add_frame("default", DragonSoulAttk_Pic10)
	soul_execute_sf.set_animation_loop("default", false)
	

#

func _first_time_initialize():
	bad_descriptions[0] += " (%s health)" % [str(player_execute_ratio * game_elements.health_manager.starting_health)]

#

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.enemy_manager.is_connected("enemy_spawned", self, "_on_enemy_spawned"):
		game_elements.enemy_manager.connect("enemy_spawned", self, "_on_enemy_spawned", [], CONNECT_PERSIST)
		game_elements.health_manager.connect("current_health_changed", self, "_on_player_health_changed", [], CONNECT_PERSIST)
	
	_on_player_health_changed(game_elements.health_manager.current_health)


func _on_enemy_spawned(enemy):
	enemy.connect("on_post_mitigated_damage_taken", self, "_on_enemy_damage_taken")

func _on_enemy_damage_taken(damage_instance_report, is_lethal, enemy):
	if !is_lethal:
		if enemy.current_health / enemy._last_calculated_max_health < enemy_execute_ratio:
			_summon_soul_execute_attk_sprite(enemy)

func _summon_soul_execute_attk_sprite(enemy):
	var attk_sprite : AttackSprite = AttackSprite_Scene.instance()
	attk_sprite.frames = soul_execute_sf
	attk_sprite.frame = 0
	attk_sprite.lifetime = 0.35
	attk_sprite.frames_based_on_lifetime = true
	attk_sprite.has_lifetime = true
	attk_sprite.global_position = enemy.global_position + Vector2(0, -10)
	attk_sprite.connect("tree_exiting", self, "_execute_enemy", [enemy], CONNECT_ONESHOT)
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(attk_sprite)

func _execute_enemy(enemy):
	if is_instance_valid(enemy):
		enemy.execute_self_by(StoreOfTowerEffectsUUID.RED_DRAGON_SOUL_EXECUTE_DAMAGE)


#
func _on_player_health_changed(curr_health):
	if curr_health / game_elements.health_manager.starting_health < player_execute_ratio:
		
		# execute player
		game_elements.health_manager.disconnect("current_health_changed", self, "_on_player_health_changed")
		game_elements.health_manager.decrease_health_by(curr_health, game_elements.HealthManager.DecreaseHealthSource.SYNERGY)


#
func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.enemy_manager.is_connected("enemy_spawned", self, "_on_enemy_spawned"):
		game_elements.enemy_manager.disconnect("enemy_spawned", self, "_on_enemy_spawned")
		game_elements.health_manager.disconnect("current_health_changed", self, "_on_player_health_changed")


######

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	var health_exec_threshold = tier_to_player_exec_ratio[arg_tier_to_be_offered] * arg_game_elements.health_manager.starting_health
	var curr_health = arg_game_elements.health_manager.current_health
	
	return (curr_health + health_forgiveness_flat_meter_for_offerable) > health_exec_threshold


