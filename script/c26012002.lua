--Clustar Blue
function c26012002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	--e1:SetCountLimit(1,26012002,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26012002.spcon)
	c:RegisterEffect(e1)
end
function c26012002.spfilter(c)
	return c:IsFacedown() or c:IsLevelAbove(2) or c:IsRankAbove(2) or c:IsLinkAbove(2) or c:IsAttribute(ATTRIBUTE_WATER)
end
function c26012002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c26012002.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c26012002.chlimit(e,ep,tp)
	return tp==ep
end