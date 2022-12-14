--Echolon Feedback
function c26013011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013011,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26013011.target)
	e1:SetOperation(c26013011.activate)
	c:RegisterEffect(e1)
	--gy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013011,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c26013011.gytg)
	e2:SetOperation(c26013011.gyop)
	c:RegisterEffect(e2)
	
end
function c26013011.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c26013011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26013011.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c26013011.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26013011.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c26013011.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end

function c26013011.gyfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHIC)
end
function c26013011.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c26013011.gyfilter.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26013011.gyfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c26013011.gyfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26013011.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		Duel.HintSelection(tc)
		--special summon limit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetDescription(aux.Stringid(26013011,2))
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetAbsoluteRange(tp,1,0)
		e2:SetTarget(c26013011.splimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(CARD_CLOCK_LIZARD)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetTarget(c26013011.lizfilter)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
	end
end
function c26013011.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO+TYPE_TUNER) and c:IsLocation(LOCATION_EXTRA)
end
function c26013011.lizfilter(e,c)
	return not c:IsOriginalType(TYPE_SYNCHRO+TYPE_TUNER)
end