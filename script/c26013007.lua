--Echolon Reciproto
function c26013007.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,nil,1,99,c26013007.matfilter)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013007,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,26013007)
	e1:SetCondition(c26013007.condition)
	e1:SetTarget(c26013007.tftg)
	e1:SetOperation(c26013007.tfop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013007,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,{26013007,1})
	e2:SetCondition(c26013007.condition)
	e2:SetTarget(c26013007.sumtg)
	e2:SetOperation(c26013007.sumop)
	c:RegisterEffect(e2)
end
c26013007.listed_series={0x613}
function c26013007.tffilter(c,tp)
	return c:IsSpellTrap() and c:IsSetCard(0x613)
	and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function c26013007.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c26013007.tffilter,tp,LOCATION_DECK,0,1,nil,tp) and c:GetFlagEffect(26013007)<1 end
	c:RegisterFlagEffect(26013007,RESET_CHAIN,0,1)
end
function c26013007.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c26013007.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c26013007.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x613,scard,sumtype,tp) and c:IsLinked()
end
function c26013007.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c26013007.sumfilter(c)
	return c:IsSetCard(0x613) and c:IsSummonable(true,nil)
end
function c26013007.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and c:GetFlagEffect(26013007)<1 end
	c:RegisterFlagEffect(26013007,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26013007.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.GetMatchingGroup(c26013007.sumfilter,tp,LOCATION_HAND,0,nil)
	local p1=#g>0
	local p2=true
	if (p1 or p2) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26013007,1))
		local op=Duel.SelectEffect(tp,
		{p1,aux.Stringid(26013007,2)},
		{p2,aux.Stringid(26013007,3)})
		if op==1 then
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,tc,true,nil)
		end
		if op==2 then
			if Duel.GetFlagEffect(tp,26013007)~=0 then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
			e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e1:SetDescription(aux.Stringid(26013007,0))
			e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x613))
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,26013007,RESET_PHASE+PHASE_END,0,1)
		end
	end
end