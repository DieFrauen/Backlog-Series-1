--Remnity of Arms
function c26015004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26015004)
	e1:SetCost(c26015004.thcost)
	e1:SetTarget(c26015004.thtg)
	e1:SetOperation(c26015004.thop)
	c:RegisterEffect(e1)
	--Special Summon tributes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26015004)
	e2:SetCondition(c26015004.spcond)
	e2:SetCost(c26015004.spcost)
	e2:SetTarget(c26015004.sptg)
	e2:SetOperation(c26015004.spop)
	c:RegisterEffect(e2)
end
function c26015004.thfilter(c,e,tp)
	return c:IsReleasable()
end
function c26015004.typfilter(c,tc)
	return c:IsRace(tc:GetRace())   
	and c:IsAttribute(tc:GetAttribute())
end
function c26015004.cfilter(c,g)
	return c:IsType(TYPE_RITUAL)
	and g:IsExists(c26015004.typfilter,1,nil,c)
	and c:GetLevel()==g:GetSum(Card.GetLevel)   
	and c:IsAbleToHand()
end
function c26015004.rescon(sg,e,tp,mg)
	return sg:IsContains(e:GetHandler())
	and Duel.IsExistingMatchingCard(c26015004.cfilter,tp,LOCATION_DECK,0,1,nil,sg)
end
function c26015004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26015004.thfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,3,c26015004.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,2,3,c26015004.rescon,1,tp,HINTMSG_TODECK,c26015004.rescon)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST+REASON_RELEASE)
end
function c26015004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26015004.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26015004.cfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tg)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26015004.spfilter(c,e,tp)
	return c:IsSetCard(0x1615) and
	c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c26015004.filter2(c,lv)
	return c:IsRitualMonster() and c:GetLevel()==lv
end
function c26015004.rescon2(sg,e,tp,mg)
	local lv=sg:GetSum(Card.GetLevel)
	local g=Duel.GetMatchingGroup(c26015004.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,lv)
	return sg:IsContains(e:GetHandler()) and #g>0
end
function c26015004.spcond(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c26015004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local op=rp~=tp
	if chk==0 then return op or Duel.IsPlayerAffectedByEffect(tp,26015010) end
	if not op then
		Duel.Hint(HINT_CARD,1-tp,26015010)
		Duel.RegisterFlagEffect(tp,26015010,RESET_PHASE+PHASE_END,0,1)
	end
end
function c26015004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26015004.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		ft=1
	end
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,ft,c26015004.rescon2,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_GRAVE)
end
function c26015004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		ft=1
	end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26015004.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,ft,c26015004.rescon2,1,tp,HINTMSG_SPSUMMON,c26015004.rescon2)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		local g=Duel.SelectMatchingCard(tp,c26015004.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,sg:GetSum(Card.GetLevel)):GetFirst()
		local rg=sg:Clone()
		if g:IsLocation(LOCATION_HAND) then rg:AddCard(g)
		else Duel.HintSelection(g) end
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleSetCard(sg)
	end
end