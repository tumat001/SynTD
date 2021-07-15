extends Node


const Red_BasePact = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd")

const Pact_AChallenge = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_AChallenge.gd")
const Pact_FirstImpression = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_FirstImpression.gd")
const Pact_SecondImpression = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_SecondImpression.gd")
const Pact_PlayingWithFire = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_PlayingWithFire.gd")
const Pact_FutureSight = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_FutureSight.gd")

enum {
	FIRST_IMPRESSION = 100,
	SECOND_IMPRESSION = 101,
	PLAYING_WITH_FIRE = 102,
	A_CHALLENGE = 103,
	FUTURE_SIGHT = 104,
}


func construct_pact(pact_uuid : int, tier : int) -> Red_BasePact:
	var pact
	
	if pact_uuid == FIRST_IMPRESSION:
		pact = Pact_FirstImpression.new(tier)
		
	elif pact_uuid == SECOND_IMPRESSION:
		pact = Pact_SecondImpression.new(tier)
		
	elif pact_uuid == PLAYING_WITH_FIRE:
		pact = Pact_PlayingWithFire.new(tier)
		
	elif pact_uuid == A_CHALLENGE:
		pact = Pact_AChallenge.new(tier)
		
	elif pact_uuid == FUTURE_SIGHT:
		pact = Pact_FutureSight.new(tier)
	
	return pact
