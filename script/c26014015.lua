--Arc-Chemeral Convergence
function c26014015.initial_effect(c)
	--send matching targets to GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014015,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26014015,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26014015.target1)
	e1:SetOperation(c26014015.activate1)
	c:RegisterEffect(e1)
	--Banish up to 3 targets
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(26014015,1))
	e2:SetCountLimit(1,{26014015,1},EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c26014015.target2)
	e2:SetOperation(c26014015.activate2)
	c:RegisterEffect(e2)
	--return all but 4 targets to Deck
	local e3=e1:Clone()
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(26014015,2))
	e3:SetCountLimit(1,{26014015,2},EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c26014015.target3)
	e3:SetOperation(c26014015.activate3)
	c:RegisterEffect(e3)
	--Return itself to the hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26014015,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	--e4:SetCountLimit(1,id)
	e4:SetCondition(aux.exccon)
	e4:SetCost(c26014015.thcost)
	e4:SetTarget(c26014015.thtg)
	e4:SetOperation(c26014015.thop)
	c:RegisterEffect(e4)
end
function c26014015.filter1(c,tp)
	return c:IsMonster() and c:IsFaceup() and c:GetAttribute()~=0 and c:IsAbleToGrave() and Duel.IsExistingTarget(c26014015.filter1a,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,c:GetAttribute())
end
function c26014015.filter1a(c,att)
	return c:IsAbleToGrave() and c:IsMonster() and c:IsFaceup() and c:IsAttribute(att)
end
function c26014015.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c26014015.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc1=Duel.SelectTarget(tp,c26014015.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc2=Duel.SelectTarget(tp,c26014015.filter1a,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,tc1:GetAttribute()):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,Group.FromCards(tc1,tc2),1,tp,0)
end
function c26014015.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then 
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c26014015.filter2(c,e)
	return c:IsFaceup() and c:IsMonster() and c:IsAbleToRemove() and aux.SpElimFilter(c,false,true) and c:IsCanBeEffectTarget(e)
end
function c26014015.rescon2(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x1614)
	and sg:IsExists(Card.IsAttribute,2,nil,0xf) and
	(sg:GetClassCount(Card.GetAttribute)==#sg
	or sg:GetClassCount(Card.GetAttribute)==1)
end
function c26014015.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE|LOCATION_GRAVE 
	local g=Duel.GetMatchingGroup(c26014015.filter2,tp,loc,loc,nil,e)
	if chkc then return nil end
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,3,3,c26014015.rescon2,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,c26014015.rescon2,1,tp,HINTMSG_REMOVE,c26014015.rescon2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,3,0,0)
end
function c26014015.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g==3 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c26014015.filter3(c,g)
	return c:IsMonster() and c:IsFaceup()
end
function c26014015.filter3a(c,e,tp)
	local g=Duel.GetMatchingGroup(c26014015.filter3,tp,LOCATION_REMOVED,0,nil)
	return c:IsFaceup() and c:IsMonster() and c:IsAbleToDeck() and
	aux.SelectUnselectGroup(g,e,tp,4,4,c26014015.rescon3,0)
end
function c26014015.rescon3(sg,e,tp,mg)
	return aux.dncheck and 
	sg:FilterCount(Card.IsSetCard,nil,0x1614)==4 and
	sg:FilterCount(Card.IsCanBeEffectTarget,nil,e)==4 and
	sg:FilterCount(Card.IsControler,nil,tp)==4 and 
	sg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)==4
end
function c26014015.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE|LOCATION_GRAVE|LOCATION_REMOVED 
	if chkc then return nil end
	if chk==0 then return Duel.IsExistingMatchingCard(c26014015.filter3a,tp,loc,loc,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c26014015.filter3,tp,loc,loc,nil,e)
	local sg=aux.SelectUnselectGroup(g,e,tp,4,4,c26014015.rescon3,1,tp,HINTMSG_TARGET,c26014015.rescon3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g-4,0,0)
end
function c26014015.activate3(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_MZONE|LOCATION_GRAVE|LOCATION_REMOVED 
	local g1=Duel.GetMatchingGroup(c26014015.filter3,tp,loc,loc,nil)
	local g2=Duel.GetTargetCards(e)
	g1:Sub(g2)
	if #g2==4 and #g1>0 then
		Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	end
end
function c26014015.thfilter(c)
	local loc=c:GetLocation()
	return c:IsCode(CARD_POLYMERIZATION) and (
	c:IsAbleToDeckAsCost() and loc==LOCATION_GRAVE or
	c:IsDiscardable()   and loc==LOCATION_HAND )
end
function c26014015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26014015.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c26014015.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then
		Duel.SendtoDeck(tc,nil,2,REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end 
end
function c26014015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,LOCATION_GRAVE)
end
function c26014015.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
	end
end