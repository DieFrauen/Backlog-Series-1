--Quark Spin
function c26012012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TOHAND|CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26012012)
	e1:SetTarget(c26012012.target)
	e1:SetOperation(c26012012.activate)
	c:RegisterEffect(e1)
	--grave eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012012,5))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c26012012.cost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c26012012.thtg)
	e2:SetOperation(c26012012.thop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetDescription(aux.Stringid(26012012,6))
	e2b:SetType(EFFECT_TYPE_QUICK_O)
	e2b:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2b)
end
function c26012012.thfilter(c,e)
	return c:IsMonster() and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c26012012.spfilter(c,e,tp)
	return c:IsLevel(1) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c26012012.rescon1(sg,e,tp,mg)
	local g=sg:Filter(Card.IsSetCard,nil,0x612)
	local og=sg:Clone()-g
	return --#g>0 and #og<2 and 
	sg:GetClassCount(Card.GetAttribute)==#sg
end
function c26012012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c26012012.thfilter(chkc) end
	local g=Duel.GetMatchingGroup(c26012012.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,3,c26012012.rescon1,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,3,c26012012.rescon1,1,tp,HINTMSG_ATOHAND,c26012012.rescon)
	Duel.SetTargetCard(sg)
	if sg and #sg>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
	else 
		e:SetProperty(0)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c26012012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
	local p=#g:Filter(Card.IsSetCard,nil,0x612)
	local p1,p2,p3=true,true,true
	local tc=nil
	while p>0 do
		local b1=p1 and g:IsExists(Card.IsAbleToHand,1,nil)
		local b2=p2 and ft>0 and g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)
		local b3=p3 and g:IsExists(Card.IsAbleToDeck,1,nil)
		local op=Duel.SelectEffect(tp,
				{b1,aux.Stringid(26012012,1)},
				{b2,aux.Stringid(26012012,2)},
				{b3,aux.Stringid(26012012,3)})
		if op==1 then 
			tc=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			g:Sub(tc)
			p1=false
		end
		if op==2 then 
			tc=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			g:Sub(tc)
			p2=false
		end
		if op==3 then 
			tc=g:FilterSelect(tp,Card.IsAbleToDeck,1,1,nil)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			g:Sub(tc)
			p3=false
		end
		p=p-1
		if p<1 or not Duel.SelectYesNo(tp,aux.Stringid(26012012,4)) then return end
	end
end
function c26012012.resfilter(c,p)
	return c:GetLevel()==1 and Duel.IsPlayerCanRelease(p,c)
end
function c26012012.rescon1(sg,e,tp,mg)
	local g=sg:Filter(Card.IsSetCard,nil,0x612)
	local og=sg:Clone()-g
	return #g>0 and #og<2 and sg:GetClassCount(Card.GetAttribute)==#sg
end
function c26012012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26012012.resfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,nil,tp)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and aux.SelectUnselectGroup(g,e,tp,1,2,c26012012.rescon2,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1) 
	local sg=aux.SelectUnselectGroup(g,e,tp,1,2,c26012012.rescon2,1,tp,HINTMSG_RELEASE,c26012012.rescon2)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST+HINTMSG_RELEASE)
end
function c26012012.rescon2(sg,e,tp,mg)
	return (sg:IsExists(Card.IsCode,1,nil,26012003)
	or e:GetType()&EFFECT_TYPE_QUICK_O ==0) 
end
function c26012012.filterX(c,TYP)
	local TYPE=c:GetType()
	return (TYPE&TYPE_XYZ ~=0 and c:IsRank(1)) or
	(TYPE&TYPE_LINK ~=0 and c:IsLink(1))
end
function c26012012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local LOC=LOCATION_GRAVE|LOCATION_MZONE --|LOCATION_REMOVED
	if chkc then return false end
	local g=Duel.GetMatchingGroup(Card.IsAbleToExtra,tp,LOC,LOC,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,2,c26012012.rescon3,0) end
	local lb=e:GetLabelObject()
	local ct=#lb; if lb:IsExists(Card.IsCode,1,nil,26012001) then ct=ct+1 end
	local tg=aux.SelectUnselectGroup(g,e,tp,1,ct,c26012012.rescon3,1,tp,HINTMSG_TARGET,c26012012.rescon3)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,tg,#tg,0,0)
	Duel.SetChainLimit(c26012012.chlimit)
end
function c26012012.rescon3(sg,e,tp,mg)
	return (sg:IsExists(c26012012.filterX,1,nil,TYPE_XYZ) or
	sg:IsExists(c26012012.filterX,1,nil,TYPE_LINK))
end
function c26012012.chlimit(e,ep,tp)
	return tp==ep
end
function c26012012.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end