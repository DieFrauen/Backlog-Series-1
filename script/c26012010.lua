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
	--immune to non-target effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c26012010.immtg)
	e3:SetValue(c26012010.immval)
	c:RegisterEffect(e3)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(c26012010.sumval)
	c:RegisterEffect(e4)
	--tofield
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26046008,2))
	e5:SetCategory(CATEGORY_LEAVE_GRAVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,26012010)
	e5:SetLabelObject(e1)
	e5:SetCost(c26012010.tfcost)
	e5:SetTarget(c26012010.tftg)
	e5:SetOperation(c26012010.tfop)
	c:RegisterEffect(e5)
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
function c26012010.sumval(e,c)
	return c:GetSummonType()&SUMMON_TYPE_XYZ|SUMMON_TYPE_LINK ~=0 and c:IsSetCard(0x612)
end
function c26012010.immtg(e,c)
	local ch=Duel.GetCurrentChain()
	local te=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT)
	if not te then return false end
	local tc=te:GetHandler()
	if c:IsRelateToBattle() and tc:IsRelateToBattle() then
		local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
		if a==tc and d==c then return false end
	end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(ch,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c) and c:IsFaceup() and c:IsSetCard(0x612)
end
function c26012010.immval(e,te)
	return te:IsActivated() and te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c26012010.tffilter(c)
	return c:IsSetCard(0x612) and c:IsMonster() and c:IsAbleToDeck()
end
function c26012010.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26012010.tffilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetAttribute)>2 end
	local tg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.dpcheck(Card.GetAttribute),1,tp,HINTMSG_TODECK)
	Duel.HintSelection(tg)
	Duel.SendtoDeck(tg,nil,2,REASON_COST)
end
function c26012010.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabelObject():IsActivatable(tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c26012010.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:GetLabelObject():IsActivatable(tp) then
		Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp)
	end
end