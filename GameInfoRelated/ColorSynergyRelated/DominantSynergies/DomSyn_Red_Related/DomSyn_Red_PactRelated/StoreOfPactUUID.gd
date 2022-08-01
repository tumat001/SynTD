extends Node


const Red_BasePact = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd")

const Pact_AChallenge = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_AChallenge.gd")
const Pact_FirstImpression = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_FirstImpression.gd")
const Pact_SecondImpression = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_SecondImpression.gd")
const Pact_PlayingWithFire = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_PlayingWithFire.gd")
const Pact_FutureSight = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_FutureSight.gd")
const Pact_DragonSoul = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_DragonSoul.gd")
const Pact_TigerSoul = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_TigerSoul.gd")
const Pact_Adrenaline = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_Adrenaline.gd")
const Pact_Prestige = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_Prestige.gd")
const Pact_JeweledBlade = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_JeweledBlade.gd")
const Pact_JeweledStaff = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_JeweledStaff.gd")
const Pact_DominanceSupplement = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_DominanceSupplement.gd")
const Pact_ComplementarySupplement = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_ComplementarySupplement.gd")
const Pact_PersonalSpace = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_PersonalSpace.gd")
const Pact_SoloVictor = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_SoloVictor.gd")
const Pact_TrioVictor = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_TrioVictor.gd")
const Pact_Retribution = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_Retribution.gd")
const Pact_AbilityProvisions = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_AbilityProvisions.gd")
const Pact_OraclesEye = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_OraclesEye.gd")
const Pact_CombinationExpertise = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_CombinationExpertise.gd")

enum PactUUIDs {
	FIRST_IMPRESSION = 100,
	SECOND_IMPRESSION = 101,
	PLAYING_WITH_FIRE = 102,
	A_CHALLENGE = 103,
	FUTURE_SIGHT = 104,
	
	DRAGON_SOUL = 105,
	TIGER_SOUL = 106,
	ADRENALINE = 107,
	PRESTIGE = 108,
	JEWELED_BLADE = 109,
	JEWELED_STAFF = 110,
	DOMINANCE_SUPPLEMENT = 111,
	COMPLEMENTARY_SUPPLEMENT = 112,
	PERSONAL_SPACE = 113,
	SOLO_VICTOR = 114,
	TRIO_VICTOR = 115,
	RETRIBUTION = 116,
	ABILITY_PROVISIONS = 117,
	ORACLES_EYE = 118,
	
	COMBINATION_EXPERTISE = 119,
	
}


func construct_pact(pact_uuid : int, tier : int) -> Red_BasePact:
	var pact
	
	if pact_uuid == PactUUIDs.FIRST_IMPRESSION:
		pact = Pact_FirstImpression.new(tier)
		
	elif pact_uuid == PactUUIDs.SECOND_IMPRESSION:
		pact = Pact_SecondImpression.new(tier)
		
	elif pact_uuid == PactUUIDs.PLAYING_WITH_FIRE:
		pact = Pact_PlayingWithFire.new(tier)
		
	elif pact_uuid == PactUUIDs.A_CHALLENGE:
		pact = Pact_AChallenge.new(tier)
		
	elif pact_uuid == PactUUIDs.FUTURE_SIGHT:
		pact = Pact_FutureSight.new(tier)
		
	elif pact_uuid == PactUUIDs.DRAGON_SOUL:
		pact = Pact_DragonSoul.new(tier)
		
	elif pact_uuid == PactUUIDs.TIGER_SOUL:
		pact = Pact_TigerSoul.new(tier)
		
	elif pact_uuid == PactUUIDs.ADRENALINE:
		pact = Pact_Adrenaline.new(tier)
		
	elif pact_uuid == PactUUIDs.PRESTIGE:
		pact = Pact_Prestige.new(tier)
		
	elif pact_uuid == PactUUIDs.JEWELED_BLADE:
		pact = Pact_JeweledBlade.new(tier)
		
	elif pact_uuid == PactUUIDs.JEWELED_STAFF:
		pact = Pact_JeweledStaff.new(tier)
		
	elif pact_uuid == PactUUIDs.DOMINANCE_SUPPLEMENT:
		pact = Pact_DominanceSupplement.new(tier)
		
	elif pact_uuid == PactUUIDs.COMPLEMENTARY_SUPPLEMENT:
		pact = Pact_ComplementarySupplement.new(tier)
		
	elif pact_uuid == PactUUIDs.PERSONAL_SPACE:
		pact = Pact_PersonalSpace.new(tier)
		
	elif pact_uuid == PactUUIDs.SOLO_VICTOR:
		pact = Pact_SoloVictor.new(tier)
		
	elif pact_uuid == PactUUIDs.TRIO_VICTOR:
		pact = Pact_TrioVictor.new(tier)
		
	elif pact_uuid == PactUUIDs.RETRIBUTION:
		pact = Pact_Retribution.new(tier)
		
	elif pact_uuid == PactUUIDs.ABILITY_PROVISIONS:
		pact = Pact_AbilityProvisions.new(tier)
		
	elif pact_uuid == PactUUIDs.ORACLES_EYE:
		pact = Pact_OraclesEye.new(tier)
		
	elif pact_uuid == PactUUIDs.COMBINATION_EXPERTISE:
		pact = Pact_CombinationExpertise.new(tier)
	
	return pact
