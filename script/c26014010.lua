--Arc-Chemera Fenixus
function c26014010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local f0=Fusion.AddProcMix(c,false,false,26014002,26014004)[1]
	f0:SetDescription(aux.Stringid(26014010,0))
	local f1=Fusion.AddProcMix(c,false,false,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WIND),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE))[1]
	f1:SetDescription(aux.Stringid(26014010,1))
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		f1:SetValue(c26014010.matfilter)
	end
	aux.GlobalCheck(c26014010,function()
		c26014010.polycheck=0
	end)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26014010.splimit)
	c:RegisterEffect(e1)
	--indestructible
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c26014010.indval)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c26014010.descon)
	e3:SetTarget(c26014010.destg)
	e3:SetValue(c26014010.repval)
	c:RegisterEffect(e3)
	--Special summon 1 "Arc-Chem" monster during the next Standby Phase
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26014010,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,{26014010,1})
	e4:SetCondition(c26014010.spcon)
	e4:SetTarget(c26014010.sptg)
	e4:SetOperation(c26014010.spop)
	c:RegisterEffect(e4)
end
c26014010.listed_names={CARD_POLYMERIZATION }
function c26014010.splimit(e,se,sp,st)
	if se:GetHandler():IsCode(CARD_POLYMERIZATION) then c26014010.polycheck=1
	else c26014010.polycheck=0 end
	if (not e:GetHandler():IsLocation(LOCATION_EXTRA) or (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION) then
		return se
	end
end
function c26014010.matfilter(c,fc,sub,sub2,mg,sg,tp,contact,sumtype)
	if sumtype&SUMMON_TYPE_FUSION~=0 and fc:IsLocation(LOCATION_EXTRA) and mg then
		return c26014010.polycheck==1
	end
	return c26014010.polycheck==1
end
function c26014010.descon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT ~=0 and re and re:IsActivated()
end
function c26014010.indval(e,re,rp)
	return re:GetHandler()~=e:GetHandler()
end
function c26014010.rfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and not c:IsReason(REASON_REPLACE)
end
function c26014010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and eg:IsExists(c26014010.rfilter,1,c,tp) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Destroy(c,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c26014010.repval(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c~=e:GetHandler()
end
--summon during next SP
function c26014010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_EFFECT+REASON_BATTLE)~=0
end
function c26014010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c26014010.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c26014010.spcon1)
	e1:SetOperation(c26014010.spop1)
	if Duel.IsTurnPlayer(tp) then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end

function c26014010.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c26014010.filter(c,e,tp)
	return c:IsSetCard(0x614) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26014010.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26014010.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end