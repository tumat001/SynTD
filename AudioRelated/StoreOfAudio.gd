extends Node


enum AudioIds {
	BOSS_FIGHT = 0,
	GAMEPLAY_THEME_01 = 10,
	
	HOMEPAGE_LOBBY_THEME_01 = 100,
	
	QUESTION_INFO_THEME_01 = 150,
	TIMER_SOUND = 160,
	
	
	CORRECT_ANSWER = 1000,
	GAME_OVER_LOSE = 1001,
	GAME_STAGE_START= 1002,
	GAME_STAGE_WIN = 1003,
	MALFUNCTION = 1004,
	
	EXPLOSION_01 = 1500,
	TOWER_PURCHASE_01 = 1501,
	
	SELL_TOWER = 1502,
	DRAG_TOWER = 1503,
	DROP_TOWER = 1504,
	
	####
	
#	CYDE_SPEAK_01 = 1600,
#	PLAYER_SPEAK_01 = 1601,
#	DR_ASI_SPEAK_01 = 1602,
	
	BLOCKER_DROP = 1603,
	
	ALTER_TRIGGERED = 1604,
	REDUCTION_TRIGGERED = 1605,
	
	PLAYER_SHIELD_DAMAGED = 1606,
	
	ENEMY_DEATH = 1607,
	
}

const _audio_id_to_sound_file_path = {
	AudioIds.BOSS_FIGHT : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/BossFight.ogg",
	
	AudioIds.CORRECT_ANSWER : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/CorrectAnswer.wav",
	AudioIds.EXPLOSION_01 : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/Explosion.wav",
	AudioIds.GAME_OVER_LOSE : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/GameoverLose.wav",
	AudioIds.GAMEPLAY_THEME_01 : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/GameplayTheme.ogg",
	AudioIds.GAME_STAGE_START : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/GameStageStart.wav",
	AudioIds.GAME_STAGE_WIN : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/GameStageWin.wav",
	AudioIds.HOMEPAGE_LOBBY_THEME_01 : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/HomepageLobbyTheme_02.ogg",
	AudioIds.MALFUNCTION : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/Malfunction.wav",
	AudioIds.QUESTION_INFO_THEME_01 : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/Question_InfoTheme.ogg",
	AudioIds.TIMER_SOUND : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/TimerSound.ogg",
	AudioIds.TOWER_PURCHASE_01 : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/TowerPurchase(1).wav",
	
	AudioIds.SELL_TOWER : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/SellTower.wav",
	AudioIds.DRAG_TOWER : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/DragTower.wav",
	AudioIds.DROP_TOWER : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/DropTower.wav",
	
	AudioIds.BLOCKER_DROP : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/WoodblockDrop.wav",
	
	AudioIds.ALTER_TRIGGERED : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/ChangeQuestion.wav",
	AudioIds.REDUCTION_TRIGGERED : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/MinusChoices.wav",
	
	AudioIds.PLAYER_SHIELD_DAMAGED : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/HealthDeplete.wav",
	
	AudioIds.ENEMY_DEATH : "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/EnemyDefeat.wav",
	
}

##

func get_audio_path_of_id(arg_id):
	if _audio_id_to_sound_file_path.has(arg_id):
		return _audio_id_to_sound_file_path[arg_id]
	else:
		# why default to this? i dunno... hahahhahahhahah
		return "res://CYDE_SPECIFIC_ONLY/Audio/Sound_FX/CorrectAnswer.wav"

