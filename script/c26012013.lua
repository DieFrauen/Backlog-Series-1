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
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26046008,2))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,26012013)
	e4:SetLabelObject(e1)
	e4:SetCost(c26012013.thcost)
	e4:SetTarget(c26012013.thtg)
	e4:SetOperation(c26012013.thop)
	c:RegisterEffect(e4)
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
	local LOC = LOCATION_DECK|LOCATION_GRAVE 
	if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c26012013.spfilter,tp,LOC,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOC)
	c:RegisterFlagEffect(code,RESET_CHAIN,0,1)
end
function c26012013.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26012013.spfilter,tp,LOCATION_DECK|LOCATION_GRAVE ,0,1,1,nil,e,tp,e:GetHandler()):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c26012013.disfilter(c,tp)
	return c:IsMonster() and c:IsDiscardable() and Duel.IsExistingMatchingCard(c26012013.rthfilter,tp,LOCATION_GRAVE,0,1,nil,c)
end
function c26012013.rthfilter(c,tc)
	return c:IsMonster() and c:IsLevel(1) and c:IsAbleToHand() and tc and c:IsAttributeExcept(tc:GetAttribute())
end
function c26012013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26012013.disfilter,tp,LOCATION_HAND,0,nil,tp)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and #g>0 end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1) 
	local sg=g:Select(tp,1,1,nil):GetFirst()
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST|HINTMSG_DISCARD)
end
function c26012013.rescon2(sg,e,tp,mg)
	return (sg:IsExists(Card.IsCode,1,nil,26012003)
	or e:GetType()&EFFECT_TYPE_QUICK_O ==0) 
end
function c26012013.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lb=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26012013.rthfilter(chkc,lb) end
	local g=Duel.GetMatchingGroup
	if chk==0 then return Duel.IsExistingMatchingCard(c26012013.rthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local ct=#lb; if lb:IsCode(26012001) then ct=ct+1 end
	local tg=Duel.SelectTarget(tp,c26012013.rthfilter,tp,LOCATION_GRAVE,0,1,ct,nil,lb)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,tg,#tg,0,0)
	if lb:IsCode(26012002) then 
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012013.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end