--Quarky Subspace
function c26012010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012010,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,26012010)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c26012010.cost)
	e2:SetTarget(c26012010.target)
	e2:SetOperation(c26012010.operation)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetDescription(aux.Stringid(26012012,3))
	e2b:SetType(EFFECT_TYPE_QUICK_O)
	e2b:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2b)
end
function c26012010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26012010.resfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,nil,tp)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,0,1,c26012010.rescon2,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,0,1,c26012010.rescon2,1,tp,HINTMSG_RELEASE,c26012010.rescon2)
	if #sg>0 then e:GetHandler():RegisterFlagEffect(26012010,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1) end
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST+HINTMSG_RELEASE)
end
function c26012010.rescon2(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,26012003)
	or e:GetType()&EFFECT_TYPE_QUICK_O ==0
end
function c26012010.thfilter(c)
	return c:IsSpellTrap() and not c:IsCode(26012010)
	and c:IsSetCard(0x612) and c:IsAbleToHand()
end
function c26012010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26012010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if e:GetHandler():GetFlagEffect(26012010)==0 then
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
	end
	if e:GetLabelObject():IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012010.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26012010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	if e:GetHandler():HasFlagEffect(26012010) then return end
	Duel.BreakEffect()
	Duel.DiscardHand(tp,Card.IsSetCard,1,1,REASON_EFFECT|REASON_DISCARD,nil,0x612)
end
