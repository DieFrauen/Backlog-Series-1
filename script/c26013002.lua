--Echolon Rechorder
function c26013002.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c26013002.sptg)
	e1:SetOperation(c26013002.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c26013002.qcon)
	e2:SetCost(c26013002.qcost)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013002,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,26013011)
	e3:SetCondition(c26013002.thcon)
	e3:SetTarget(c26013002.thtg)
	e3:SetOperation(c26013002.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c26013002.qcon)
	e4:SetCost(c26013002.qcost)
	c:RegisterEffect(e4)
end
c26013002.listed_series={0x613}
function c26013002.sumfilter(c)
	return c:IsLevelBelow(1) and c:IsSummonable(true,nil)
end
function c26013002.qcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsPlayerAffectedByEffect(tp,26013011)
	and ((re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	and g and g:IsContains(e:GetHandler())
	and re:GetHandler():IsSetCard(0x613)) or rp~=tp)
end
function c26013002.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26013011)==0 end
	Duel.RegisterFlagEffect(tp,26013011,RESET_CHAIN,0,1)
end
function c26013002.spfilter(c)
	return c:IsSetCard(0x613) and c:IsFaceup()
end
function c26013002.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x613)
end
function c26013002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c26013002.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26013002.tfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c26013002.tnfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26013002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26013002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_TUNER)
end
function c26013002.thfilter(c)
	return c:IsSetCard(0x613) and c:IsAbleToHand()
end
function c26013002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26013002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26013002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26013002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end