--Echolon Vice-Emissor
function c26013006.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013006,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,26013006)
	e1:SetTarget(c26013006.sumtg)
	e1:SetOperation(c26013006.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(0)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c26013006.qcon)
	e2:SetCost(c26013006.qcost)
	c:RegisterEffect(e2)
	--add tuner
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013006,3))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,{26013006,1})
	e3:SetCondition(c26013006.tncon)
	e3:SetTarget(c26013006.tntg)
	e3:SetOperation(c26013006.tnop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c26013006.qcon)
	e4:SetCost(c26013006.qcost)
	c:RegisterEffect(e4)
end
c26013006.listed_series={0x613}
function c26013006.sumfilter(c)
	return c:IsRace(RACE_PSYCHIC) and c:IsSummonable(true,nil)
end
function c26013006.qcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsPlayerAffectedByEffect(tp,26013011)
	and ((re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	and g and g:IsContains(e:GetHandler())
	and re:GetHandler():IsSetCard(0x613)) or rp~=tp)
end
function c26013006.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26013011)==0 end
	Duel.RegisterFlagEffect(tp,26013011,RESET_CHAIN,0,1)
end
function c26013006.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26013006.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.GetMatchingGroup(c26013006.sumfilter,tp,LOCATION_HAND,0,nil)
	local p1=#g>0
	local p2=true
	if (p1 or p2) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26013006,1))
		local op=Duel.SelectEffect(tp,
		{p1,aux.Stringid(26013006,0)},
		{p2,aux.Stringid(26013006,2)})
		if op==1 then
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,tc,true,nil)
		end
		if op==2 then
			if Duel.GetFlagEffect(tp,26013006)~=0 then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
			e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e1:SetDescription(aux.Stringid(26013006,0))
			e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PSYCHIC))
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,26013006,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c26013006.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO 
end
function c26013006.tnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x613) and not c:IsType(TYPE_TUNER)
end
function c26013006.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c26013006.tnfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26013006.tnfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26013006.tnfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c26013006.tnop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end