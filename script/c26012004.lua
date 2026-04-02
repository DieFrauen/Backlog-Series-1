--Protoquark Hadron
function c26012004.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,1,3,c26012004.ovfilter,aux.Stringid(26012004,1),3,c26012004.xyzop,false,c26012004.xyzcheck)
	--destroy target
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(26012004,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26012004)
	e1:SetCost(c26012004.cost)
	e1:SetTarget(c26012004.target)
	e1:SetOperation(c26012004.operation)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	--quick
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26012004,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCost(c26012004.qcost)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26012004,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,{26012004,1})
	e3:SetCondition(c26012004.thcon)
	e3:SetTarget(c26012004.thtg)
	e3:SetOperation(c26012004.thop)
	c:RegisterEffect(e3)
end
function c26012004.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsLevel(1) and c:IsSetCard(0x612)
end
function c26012004.cfilter(c)
	return c:IsLevel(1) and c:IsSetCard(0x612) and not c:IsForbidden() 
end
function c26012004.rescon1(sg,e,tp,mg)
	local attr=e:GetLabel()
	return sg:GetClassCount(Card.GetAttribute)==#sg 
	and not sg:IsExists(Card.IsAttribute,1,nil,attr)
	and #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
end
function c26012004.xyzop(e,tp,chk,mc)
	local c=e:GetHandler()
	local attr=mc:GetAttribute()
	e:SetLabel(attr)
	local g=Duel.GetMatchingGroup(c26012004.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.GetFlagEffect(tp,26012004)==0 and aux.SelectUnselectGroup(g,e,tp,2,2,c26012004.rescon1,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c26012004.rescon1,1,tp,HINTMSG_XMATERIAL,nil,nil,true)
	if #sg==2 then
		sg:AddCard(mc)
		--local pos=Duel.SelectPosition(tp,c,POS_FACEUP)
		Duel.Overlay(c,sg)
		Duel.ShuffleHand(tp)
		Duel.RegisterFlagEffect(tp,26012004,RESET_PHASE+PHASE_END,0,1)
		return true--, pos
	else return false end
end
function c26012004.xyzcheck(g,tp,xyz)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function c26012004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:Select(tp,1,3,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	e:SetLabel(#sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26012004.rescon2(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,26012003)
end
function c26012004.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return #g>0 and g:IsExists(Card.IsCode,1,nil,26012003) end
	sg=aux.SelectUnselectGroup(g,e,tp,1,3,c26012004.rescon2,1,tp,HINTMSG_DISCARD,c26012004.rescon2)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	e:SetLabel(#sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26012004.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c26012004.tgfilter(c,e,tp)
	return c:IsFaceup() and (c:IsCanBeEffectTarget(e) or Duel.IsPlayerAffectedByEffect(tp,26012006))
end
function c26012004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(c26012004.tgfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	local lb=e:GetLabelObject()
	local ct=1; if lb:IsExists(Card.IsCode,1,nil,26012001) then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c26012004.tgfilter,tp,0,LOCATION_MZONE,1,ct,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	local atk=g:Filter(Card.IsFaceup,nil):GetSum(Card.GetAttack)
	if atk<0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	end
	if e:GetLabelObject():IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		local atk=0
		for tc in aux.Next(dg) do
			local tatk=tc:GetTextAttack()
			if tatk>0 then atk=atk+tatk end
		end
		Duel.Damage(1-tp,atk/2,REASON_EFFECT)
	end
end
function c26012004.thfilter(c)
	return c:GetLevel()==1 and c:IsAbleToHand()
end
function c26012004.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c26012004.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c26012004.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26012004.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26012004.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end