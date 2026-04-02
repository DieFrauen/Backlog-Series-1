--Quarkluon Anti-Green
function c26012009.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26012009.matfilter,1,1)
	--Special Summon "Green Quarky"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012009,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,26012009)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e)return e:GetHandler():IsLinkSummoned()end)
	e1:SetTarget(c26012009.sptg)
	e1:SetOperation(c26012009.spop)
	c:RegisterEffect(e1)
	--Attach "Green Quarky"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012009,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{26012009,1})
	e2:SetTarget(c26012009.atttg)
	e2:SetOperation(c26012009.attop)
	c:RegisterEffect(e2)
end
function c26012009.rfilter(c)
	return c:IsLevel(1) and c:IsReleasable()
end
function c26012009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	local g2=Duel.GetMatchingGroup(c26012009.rfilter,tp,LOCATION_MZONE,0,1,nil)
	local g3=Duel.GetOverlayGroup(tp,1,0)
	local g=g1+g2+g3
	if chk==0 then return #g>0 end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local REASON = REASON_COST 
	if g1:IsContains(tc) then REASON =REASON_COST|REASON_DISCARD 
	elseif g2:IsContains(tc) then REASON =REASON_COST|REASON_RELEASE 
	end
	Duel.SendtoGrave(tc,REASON)
end
function c26012009.matfilter(c,scard,sumtype,tp)
	return c:IsLevel(1)
	and (c:IsSetCard(0x612,scard,sumtype,tp) or c:IsAttribute(ATTRIBUTE_WIND,scard,sumtype,tp))
end
function c26012009.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local r1=c:IsReason(REASON_DISCARD)
	local r2=c:IsReason(REASON_RELEASE)
	local r3=(c:IsReason(REASON_COST) and re:GetHandler():IsSetCard(0x612)   and re:IsActivated() and c:IsPreviousLocation(LOCATION_OVERLAY))
	return r1 or r2 or r3
end
function c26012009.attfilter(c,e,tp)
	return not c:IsImmuneToEffect(e) and c:IsCode(26012003) and Duel.IsExistingMatchingCard(c26012009.xfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c26012009.xfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c26012009.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26012009.attfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c26012009.attop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26012009.attfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local sc=Duel.SelectMatchingCard(tp,c26012009.xfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.Overlay(sc,tc,true)
	end
end
function c26012009.spfilter(c,e,tp,zone)
	return c:IsCode(26012003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c26012009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local LOC=LOCATION_HAND|LOCATION_GRAVE 
	local zone=e:GetHandler():GetFreeLinkedZone()&ZONES_MMZ 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26012009.spfilter,tp,LOC,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOC)
end
function c26012009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then zone=c:GetFreeLinkedZone()&ZONES_MMZ 
	else return end
	local tc=Duel.SelectMatchingCard(tp,c26012009.spfilter,tp,LOCATION_HAND|LOCATION_GRAVE,0,1,1,nil,e,tp,zone):GetFirst()
	if tc and zone>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(function(e,c) return c:IsLocation(LOCATION_EXTRA)  and not (c:IsType(TYPE_XYZ) and c:IsRank(1)
				  or c:IsType(TYPE_LINK) and c:IsLink(1)) end)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end