--Quarkluon Anti-Green
function c26012009.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26012009.matfilter,1,1)
	--Special Summon 1 Level 1 monster from the GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012009,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,26012009)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c26012009.condition)
	e1:SetCost(c26012009.cost)
	e1:SetTarget(c26012009.atttg)
	e1:SetOperation(c26012009.attop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(function(e) return e:GetHandler():IsLinkSummoned() end)
	c:RegisterEffect(e3)
	--Attach "Red Quarky"
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(26012009,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetTarget(c26012009.sptg)
	e4:SetOperation(c26012009.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(function(e) return e:GetHandler():IsLinkSummoned() end)
	c:RegisterEffect(e6)

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
	local r3=(c:IsReason(REASON_COST) and re:GetHandler():IsSetCard(0x612)		   and re:IsActivated() and c:IsPreviousLocation(LOCATION_OVERLAY))
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
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c26012009.zones(e,tp)
	local zone=0
	local left_right=0
	local lg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_LINK)
	for tc in lg:Iter() do
		left_right=tc:IsInMainMZone() and 1 or 0
		zone=(zone|(tc:GetFreeLinkedZone()&ZONES_MMZ)) 
	end
return zone&ZONES_MMZ
end
function c26012009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=c26012009.zones(e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26012009.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26012009.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=c26012009.zones(e,tp)
	local tc=Duel.SelectMatchingCard(tp,c26012009.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone):GetFirst()
	if tc and zone>0 then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end