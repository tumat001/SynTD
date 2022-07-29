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
	
	return pact
