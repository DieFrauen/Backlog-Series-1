--Echolon Calibrax
function c26013010.initial_effect(c)
	--Link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26013010.matfilter,1,1)
	--c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,26013010),LOCATION_ONFIELD)
	--tuner shift
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013010,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c26013010.cost)
	e2:SetTarget(c26013010.tunetg)
	e2:SetOperation(c26013010.tuneop)
	c:RegisterEffect(e2)
	
end
function c26013010.matfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_PSYCHIC,lc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_WIND,lc,sumtype,tp) and not c:IsType(TYPE_TUNER,lc,sumtype,tp)
end
function c26013010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c26013010.tunefilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER)
end
function c26013010.tunetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_TUNER) and c:GetLinkedGroup():IsExists(c26013010.tunefilter,1,nil) end
end
function c26013010.tuneop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_TUNER) then return end
	local tg=c:GetLinkedGroup()
	if #tg>0 and tg:IsExists(c26013010.tunefilter,1,nil) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		Duel.HintSelection(c)
		local tc=tg:GetFirst()
		if #tg>1 then tc=tg:Select(tp,1,1,nil) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		Duel.HintSelection(tc)
	end
end