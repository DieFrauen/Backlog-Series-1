--Quarky Hueshift
function c26012013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012013,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26012013,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26012013.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012013,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,{26012013,1})
	e2:SetCost(Cost.SelfToDeck)
	e2:SetTarget(c26012013.sptg)
	e2:SetOperation(c26012013.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ALL,0)
	e3:SetTarget(c26012013.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	local e3a=e3:Clone()
	e3a:SetLabelObject(e2a)
	c:RegisterEffect(e3a)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	local e3b=e3:Clone()
	e3b:SetLabelObject(e2b)
	c:RegisterEffect(e3b)
end
c26012013.listed_series={0x1612}
function c26012013.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x1612)
end
function c26012013.thfilter(c,p)
	return c:IsSetCard(0x612) and c:IsMonster() and c:IsAbleToHand()
	and Duel.IsExistingMatchingCard(c26012013.tdfilter,p,LOCATION_HAND,0,1,nil,c:GetAttribute())
end
function c26012013.tdfilter(c,attr)
	return c:IsAttributeExcept(attr) and c:IsMonster() and c:IsAbleToDeck()
end
function c26012013.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26012013.thfilter,tp,LOCATION_DECK,0,nil,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26012013,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		local g2=Duel.SelectMatchingCard(tp,c26012013.tdfilter,tp,LOCATION_HAND,0,1,1,nil,tc:GetAttribute())
		Duel.BreakEffect()
		Duel.ConfirmCards(1-tp,g2)
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
function c26012013.spfilter(c,e,tp,tc)
	return c:IsAttributeExcept(tc:GetOriginalAttribute()) and c:IsSetCard(0x612) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c26012013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetCode()
	if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c26012013.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	c:RegisterFlagEffect(code,RESET_CHAIN,0,1)
end
function c26012013.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26012013.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetHandler()):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
