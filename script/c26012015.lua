--Quark Chromoforce
function c26012015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26012015,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c26012015.condition)
	c:RegisterEffect(e0)
	--Destroy S/T
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012015,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26012015)
	e2:SetCost(c26012015.cost1)
	e2:SetTarget(c26012015.target1)
	e2:SetOperation(c26012015.operation1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26012015,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c26012015.cost2)
	e3:SetTarget(c26012015.target2)
	e3:SetOperation(c26012015.operation2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(26012015,3))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c26012015.cost3)
	e4:SetTarget(c26012015.target3)
	e4:SetOperation(c26012015.operation3)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetDescription(aux.Stringid(26012015,4))
	e5:SetCategory(0)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(c26012015.cost4)
	e5:SetTarget(c26012015.target4)
	e5:SetOperation(c26012015.operation4)
	c:RegisterEffect(e5)
end
function c26012015.condition(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if c26012015.quark(g) then return true end
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_XYZ) and tc:IsSetCard(0x612)
		and c26012015.quark(tc:GetOverlayGroup()) then return true end
	end
	return false
end
function c26012015.quark(g)
	return #g>0 and g:IsExists(Card.IsCode,1,nil,26012001)
	and g:IsExists(Card.IsCode,1,nil,26012003)
	and g:IsExists(Card.IsCode,1,nil,26012003)
end
function c26012015.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,tp)
	if chk==0 then return #g>0 end
	local sg=g:Select(tp,1,1,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST+HINTMSG_RELEASE)
end
function c26012015.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local LOC =LOCATION_SZONE 
	if chkc then return chkc:IsLocation(LOC) and chck:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOC,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local lb=e:GetLabelObject()
	local ct=#lb; if lb:IsExists(Card.IsCode,1,nil,26012001) then ct=ct+1 end
	local g=Duel.SelectTarget(tp,nil,tp,0,LOC,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	if lb:IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012015.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c26012015.filter2(c,p)
	return c:IsSetCard(0x1612) and Duel.IsPlayerCanRelease(p,c)
end
function c26012015.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26012012.filter2,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return #g>0 end
	local sg=g:Select(tp,1,1,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST|HINTMSG_RELEASE)
end
function c26012015.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local LOC =LOCATION_ONFIELD 
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOC) and chck:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOC,LOC,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local lb=e:GetLabelObject()
	local ct=#lb; if lb:IsExists(Card.IsCode,1,nil,26012001) then ct=ct+1 end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOC,LOC,1,ct,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if lb:IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26012015.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c26012015.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local LOC =LOCATION_ONFIELD 
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOC) and chck:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOC,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOC,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c26012015.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c26012015.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetOverlayGroup(tp,1,0)
	if chk==0 then return #g>0 end
	local sg=g:Select(tp,1,1,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST+HINTMSG_RELEASE)
end
function c26012015.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local LOC =LOCATION_GRAVE 
	if chkc then return chkc:IsLocation(LOC) and chkc:IsAbleToRemove() and chck:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	local lb=e:GetLabelObject()
	local ct=#lb; if lb:IsExists(Card.IsCode,1,nil,26012001) then ct=ct+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOC,1,ct,nil)
	Duel.SetOperationInfo(0,HINTMSG_REMOVE,g,#g,0,0)
	if lb:IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,0)
end
function c26012015.operation3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c26012015.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	Duel.SendtoGrave(c,REASON_COST)
end
function c26012015.attfilter(c,g)
	return not c:IsForbidden() and not g:IsExists(Card.IsAttribute,1,nil,c:GetAttribute())
end
function c26012015.xfilter(c,tp)
	if not c:IsType(TYPE_XYZ) and c:IsFaceup() then return false end
	local g=c:GetOverlayGroup()
	return #g>0 and Duel.IsExistingMatchingCard(c26012015.xfilter,tp,LOCATION_GRAVE,0,1,nil,g)
end
function c26012015.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26012015.xfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c26012015.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc=Duel.SelectMatchingCard(tp,c26012015.attfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if tc then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26012015.xfilter),tp,LOCATION_MZONE,0,nil)
		local tg=aux.SelectUnselectGroup(g,e,tp,1,6,aux.dpcheck(Card.GetAttribute),1,tp,HINTMSG_XMATERIAL)
		Duel.Overlay(tg,tc,true)
	end
end