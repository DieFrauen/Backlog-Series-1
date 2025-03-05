--Quark Charge
function c26012010.initial_effect(c)
	--summon and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26012010,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26012010.target)
	e1:SetOperation(c26012010.activate)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012010,3))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c26012010.cost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c26012010.mattg)
	e2:SetOperation(c26012010.matop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetDescription(aux.Stringid(26012010,4))
	e2b:SetType(EFFECT_TYPE_QUICK_O)
	e2b:SetCode(EVENT_FREE_CHAIN)
	e2b:SetCost(c26012010.qcost)
	c:RegisterEffect(e2b)
end
function c26012010.spfilter(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c26012010.thfilter(c)
	return c:IsSetCard(0x612) and c:IsMonster() and c:IsAbleToHand()
end
function c26012010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(c26012010.thfilter,tp,LOCATION_DECK,0,1,nil) or 
		(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c26012010.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26012010.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26012010.thfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c26012010.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local p1=#g1>0
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local p2=(ft>0 and #g2>0)
	local opt=true
	if p1 and (not p2 or Duel.SelectYesNo(tp,aux.Stringid(23012010,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		if sg1 then
			g2:AddCard(sg1)
			Duel.SendtoHand(sg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg1)
		end
		opt=false
	end
	p2=(ft>0 and #g2>0)
	local mx=math.min(ft,2)
	if p2 and (not p1 or opt or Duel.SelectYesNo(tp,aux.Stringid(23012010,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,2,nil)
		if #sg2>0 then
			Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c26012010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:Select(tp,1,#g,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	e:SetLabel(#sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26012010.resq(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,26012003)
end
function c26012010.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and g:IsExists(Card.IsCode,1,nil,26012003) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	sg=aux.SelectUnselectGroup(g,e,tp,1,#g,c26012010.resq,1,tp,HINTMSG_DISCARD,c26012010.resq)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	e:SetLabel(#sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26012010.ovfilter(c,e)
	return c:IsSetCard(0x612) and c:IsMonster() and not c:IsImmuneToEffect(e) 
end
function c26012010.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(1)
end
function c26012010.thetg(c,tp)
	return Duel.IsExistingMatchingCard(c26012010.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c26012010.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return
		Duel.IsExistingMatchingCard(c26012010.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and
		Duel.IsExistingTarget(c26012010.ovfilter,tp,LOCATION_GRAVE,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c26012010.ovfilter,tp,LOCATION_GRAVE,0,1,e:GetLabel(),nil,e)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,#g1,0,0)
	if e:GetLabelObject():IsExists(Card.IsCode,1,nil,26012001) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26012001,1))
		local g2=Duel.SelectTarget(tp,c26012010.thetg,tp,0,LOCATION_ONFIELD,0,1,g1:GetFirst())
		g1:Merge(g2)
	end
	if e:GetLabelObject():IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012010.matop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local xg=Duel.GetMatchingGroup(c26012010.xfilter,tp,LOCATION_MZONE,0,nil,tp)	
	xg:Sub(g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tg=xg:Select(tp,1,1,nil):GetFirst()
	if tg and #sg>0 then
		Duel.Overlay(tg,sg)
	end
end