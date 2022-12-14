--Hyperclustar Frost
function c26012005.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,1,2,nil,nil,99,nil,false,c26012005.xyzcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetDescription(aux.Stringid(26012005,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c26012005.cost)
	e1:SetTarget(c26012005.target)
	e1:SetOperation(c26012005.operation)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26012005,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c26012005.qcost)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
	--cannot be targeted
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c26012005.thtg)
	e4:SetOperation(c26012005.thop)
	c:RegisterEffect(e4)
end
function c26012005.xyzcheck(g,tp,xyz)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function c26012005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,99,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26012005.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,26012003)
end
function c26012005.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return #g>0 and g:IsExists(Card.IsCode,1,nil,26012003) end
	sg=aux.SelectUnselectGroup(g,e,tp,1,99,c26012005.rescon,1,tp,HINTMSG_REMOVEXYZ,c26012005.rescon)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26012005.filter(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function c26012005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c26012005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26012005.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c26012005.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	if e:GetLabelObject():IsExists(Card.IsCode,1,nil,26012001) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26012001,1))
		local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,0,1,g1:GetFirst())
		g1:Merge(g2)
	end
	local atk=g1:Filter(Card.IsFaceup,nil):GetSum(Card.GetAttack)
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,#g1,0,0)
	if e:GetLabelObject():IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012005.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c26012005.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function c26012005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToHand() and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and Duel.IsExistingTarget(c26012005.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26012005.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c26012005.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
