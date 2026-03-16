--Halcyon Light Guidance
function c26011007.initial_effect(c)
	c:EnableReviveLimit()
	-- 2 Fairy Monsters
	Link.AddProcedure(c,c26011007.matfilter,2,2)
	--summon spirits
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26011007)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c26011007.spcond)
	e1:SetTarget(c26011007.sptg)
	e1:SetOperation(c26011007.spop)
	c:RegisterEffect(e1)
end
c26011007.listed_series={0x611} 
function c26011007.matfilter(c,scard,sumtype,tp)
	return c:IsRace(RACE_FAIRY,scard,sumtype,tp) and c:GetLevel()==2
end

function c26011007.spcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c26011007.spcheck(sg,e,tp,mg)
	local gy=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=#gy 
end
function c26011007.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x611) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c26011007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetFreeLinkedZone()&ZONES_MMZ 
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		local g=Duel.GetMatchingGroup(c26011007.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,zone)
		return ct>0 and aux.SelectUnselectGroup(g,e,tp,1,2,c26011007.spcheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c26011007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=c:GetFreeLinkedZone()&ZONES_MMZ 
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local sg=Duel.GetMatchingGroup(c26011007.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,zone)
	if #sg==0 or ct==0 then return end
	if ct>2 then ct=2 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=1 end
	local rg=aux.SelectUnselectGroup(sg,e,tp,1,ct,c26011007.spcheck,1,tp,HINTMSG_SPSUMMON)
	if #rg>0 then
		Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEUP,zone)
	end
end