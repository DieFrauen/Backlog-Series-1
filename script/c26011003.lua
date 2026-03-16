--Halcyion Wing of Protection
function c26011003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY,EFFECT_FLAG2_CHECK_SIMULTANEOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c26011003.sptg)
	e1:SetOperation(c26011003.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26011003,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c26011003.spcon2)
	e3:SetTarget(c26011003.sptg)
	e3:SetOperation(c26011003.spop)
	c:RegisterEffect(e3)
	--Special Summon 1 Monster
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26011003,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,26011003)
	e4:SetTarget(c26011003.tftg)
	e4:SetOperation(c26011003.tfop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e7)
	--destroy replace
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_DESTROY_REPLACE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c26011003.reptg)
	e8:SetValue(c26011003.repval)
	e8:SetOperation(c26011003.repop)
	c:RegisterEffect(e8)
end

function c26011003.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT+REASON_BATTLE ==0 then return false end
end
function c26011003.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,26011010) then return false end
	for i=1,ev do
		local sp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		if sp~=tp and c26011003.spcon(i,re) then
			return true
		end
	end
	return false
end
function c26011003.spcon(ev,re)
	local ex1=(Duel.GetOperationInfo(ev,CATEGORY_DESTROY) or re and re:IsHasCategory(CATEGORY_DESTROY))
	if ex1 then return true end
	return false
end
function c26011003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26011003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function c26011003.spfilter(c,e,tp,tid)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	return (c:IsSetCard(0x611) and c:IsControler(tp)) or (c:IsLocation(LOCATION_GRAVE) and c:GetTurnID()==tid and c:GetReason()&REASON_DESTROY ~=0)
end
function c26011003.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	local LOC =LOCATION_HAND|LOCATION_GRAVE 
	if chkc then return chkc:IsLocation(LOC) and chkc:IsControler(tp) and c26011003.spfilter(chkc,e,tp,tid) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26011003.spfilter,tp,LOC,LOCATION_GRAVE,1,nil,e,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOC)
end
function c26011003.tfop(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(c26011003.spfilter,tp,LOCATION_HAND|LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,tid)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26011003.filter(c,tp)
	return c:IsFaceup() and not c:IsReason(REASON_REPLACE)
	and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsSetCard(0x611))
end
function c26011003.posfilter(c,e)
	return c:IsFaceup() and c:IsDefensePos()
	and c:IsCanChangePosition() and not c:IsImmuneToEffect(e)
end
function c26011003.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26011003.posfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return eg:IsExists(c26011003.filter,1,nil,tp)
	and #g>0 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		if #g>#eg and Duel.SelectEffectYesNo(tp,c,aux.Stringid(26011003,3)) then g=g:Select(tp,#eg,#eg,nil) end
		e:SetLabelObject(g)
		return true
	end
end
function c26011003.repval(e,c)
	return c26011003.filter(c,e:GetHandlerPlayer())
end
function c26011003.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.Hint(HINT_CARD,tp,26011003)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end