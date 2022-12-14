--Echolon Vice-Emissor
function c26013006.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c26013006.sumop)
	c:RegisterEffect(e1)
	--add tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c26013006.tncon)
	e2:SetOperation(c26013006.tnop)
	c:RegisterEffect(e2)
	
end
function c26013006.sumop(e,tp,eg,ep,ev,re,r,rp)
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

function c26013006.tncon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetPreviousTypeOnField()&TYPE_TUNER ~=0
end
function c26013006.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_TUNER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
end

