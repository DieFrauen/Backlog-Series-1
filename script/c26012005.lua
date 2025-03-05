--Quarkorium Meson
function c26012005.initial_effect(c)
	c:SetUniqueOnField(1,0,26012005)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x612),1,2)
	-- Can use Link 2 monsters as Level 2 materials
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(function(e,c) return c:IsLink(1) end)
	e0:SetValue(function(e,_,rc) return rc==e:GetHandler() and 1 or 0 end)
	c:RegisterEffect(e0)
	--shuffle target
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(26012005,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e1:SetLabel(0)
	e1:SetCost(c26012005.cost)
	e1:SetTarget(c26012005.target)
	e1:SetOperation(c26012005.operation)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26012005,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER)
	e2:SetCost(c26012005.qcost)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
	--search level 1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26012005,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c26012005.thcon)
	e3:SetTarget(c26012005.thtg)
	e3:SetOperation(c26012005.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(aux.TRUE)
	e4:SetCondition(c26012005.thcon2)
	c:RegisterEffect(e4)
end
function c26012005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetOverlayGroup(tp,1,0)
	if chk==0 then return #g>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,2,2,nil)
	e:SetLabelObject(sg)
	c26012005.meson(e,sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST)
end 
function c26012005.lev(c)
	return c:GetLevel()==1
end
function c26012005.lnk(c)
	return c:IsType(TYPE_LINK) and c:IsLink(1)
end
function c26012005.meson(e,g)
	if #g==2 and g:GetClassCount(Card.GetAttribute)==1
	and g:IsExists(c26012005.lev,1,nil)
	and g:IsExists(c26012005.lnk,1,nil)
	then
		e:SetLabel(26012005)
		return
	end
	e:SetLabel(0)
end
function c26012005.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,26012003)
end
function c26012005.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetOverlayGroup(tp,1,0)
	if chk==0 then return #g>1 and g:IsExists(Card.IsCode,1,nil,26012003) end
	sg=aux.SelectUnselectGroup(g,e,tp,2,2,c26012005.rescon,1,tp,HINTMSG_REMOVEXYZ,c26012005.rescon)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	c26012005.meson(e,sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26012005.filter(c)
	return c:IsFaceup()
end
function c26012005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
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
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c26012005.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c26012005.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
	and re:GetLabel()==26012005
end
function c26012005.thfilter(c)
	return c:GetLevel()==1 and c:IsMonster() and c:IsAbleToHand()
end
function c26012005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26012005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26012005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26012005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end