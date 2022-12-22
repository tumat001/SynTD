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
const Pact_CombinationEfficiency = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_CombinationEfficiency.gd")
const Pact_CombinationCatalog = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_CombinationCatalog.gd")
const Pact_HolographicTowers = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_HolographicTowers.gd")
const Pact_CloseCombat = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_CloseCombat.gd")
const Pact_CloseControl = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_CloseControl.gd")
const Pact_RangeProvisions = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_RangeProvisions.gd")
const Pact_HealingSymbols = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_HealingSymbol.gd")
const Pact_DreamsReach = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_DreamsReach.gd")
const Pact_BloodToGold = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_BloodToGold.gd")
const Pact_OrangeIdentity = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_OrangeIdentity.gd")
const Pact_BlueIdentity = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_BlueIdentity.gd")
const Pact_VioletIdentity = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_VioletIdentity.gd")
const Pact_DamageImplants = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_DamageImplants.gd")
const Pact_FrostImplants = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_FrostImplants.gd")
const Pact_XrayCycle = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Pacts/Pact_XrayCycle.gd")


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
	COMBINATION_EFFICIENCY = 120,
	COMBINATION_CATALOG = 121,
	HOLOGRAPHIC_TOWERS = 122,
	CLOSE_COMBAT = 123,
	CLOSE_CONTROL = 124,
	RANGE_PROVISIONS = 125,
	HEALING_SYMBOLS = 126,
	DREAMS_REACH = 127,
	BLOOD_TO_GOLD = 128,
	
	ORANGE_IDENTITY = 129,
	BLUE_IDENTITY = 130,
	VIOLET_IDENTITY = 131,
	
	DAMAGE_IMPLANTS = 132,
	FROST_IMPLANTS = 133,
	XRAY_CYCLE = 134,
	
}

const all_identity_pacts : Array = [
	PactUUIDs.ORANGE_IDENTITY,
	PactUUIDs.BLUE_IDENTITY,
	PactUUIDs.VIOLET_IDENTITY,
]


func construct_pact(pact_uuid : int, tier : int,
		arg_tier_for_activation : int) -> Red_BasePact:
	
	var pact
	
	if pact_uuid == PactUUIDs.FIRST_IMPRESSION:
		pact = Pact_FirstImpression.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.SECOND_IMPRESSION:
		pact = Pact_SecondImpression.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.PLAYING_WITH_FIRE:
		pact = Pact_PlayingWithFire.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.A_CHALLENGE:
		pact = Pact_AChallenge.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.FUTURE_SIGHT:
		pact = Pact_FutureSight.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.DRAGON_SOUL:
		pact = Pact_DragonSoul.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.TIGER_SOUL:
		pact = Pact_TigerSoul.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.ADRENALINE:
		pact = Pact_Adrenaline.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.PRESTIGE:
		pact = Pact_Prestige.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.JEWELED_BLADE:
		pact = Pact_JeweledBlade.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.JEWELED_STAFF:
		pact = Pact_JeweledStaff.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.DOMINANCE_SUPPLEMENT:
		pact = Pact_DominanceSupplement.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.COMPLEMENTARY_SUPPLEMENT:
		pact = Pact_ComplementarySupplement.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.PERSONAL_SPACE:
		pact = Pact_PersonalSpace.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.SOLO_VICTOR:
		pact = Pact_SoloVictor.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.TRIO_VICTOR:
		pact = Pact_TrioVictor.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.RETRIBUTION:
		pact = Pact_Retribution.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.ABILITY_PROVISIONS:
		pact = Pact_AbilityProvisions.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.ORACLES_EYE:
		pact = Pact_OraclesEye.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.COMBINATION_EXPERTISE:
		pact = Pact_CombinationExpertise.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.COMBINATION_EFFICIENCY:
		pact = Pact_CombinationEfficiency.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.COMBINATION_CATALOG:
		pact = Pact_CombinationCatalog.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.HOLOGRAPHIC_TOWERS:
		pact = Pact_HolographicTowers.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.CLOSE_COMBAT:
		pact = Pact_CloseCombat.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.CLOSE_CONTROL:
		pact = Pact_CloseControl.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.RANGE_PROVISIONS:
		pact = Pact_RangeProvisions.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.HEALING_SYMBOLS:
		pact = Pact_HealingSymbols.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.DREAMS_REACH:
		pact = Pact_DreamsReach.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.BLOOD_TO_GOLD:
		pact = Pact_BloodToGold.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.ORANGE_IDENTITY:
		pact = Pact_OrangeIdentity.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.BLUE_IDENTITY:
		pact = Pact_BlueIdentity.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.VIOLET_IDENTITY:
		pact = Pact_VioletIdentity.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.DAMAGE_IMPLANTS:
		pact = Pact_DamageImplants.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.FROST_IMPLANTS:
		pact = Pact_FrostImplants.new(tier, arg_tier_for_activation)
		
	elif pact_uuid == PactUUIDs.XRAY_CYCLE:
		pact = Pact_XrayCycle.new(tier, arg_tier_for_activation)
		
	
	return pact
