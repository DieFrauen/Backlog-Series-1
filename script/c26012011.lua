--Quark Spin
function c26012011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26012011)
	e1:SetTarget(c26012011.target)
	e1:SetOperation(c26012011.activate)
	c:RegisterEffect(e1)
	--grave eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012011,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c26012011.cost)
	e2:SetTarget(c26012011.thtg)
	e2:SetOperation(c26012011.thop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetDescription(aux.Stringid(26012011,3))
	e2b:SetType(EFFECT_TYPE_QUICK_O)
	e2b:SetCode(EVENT_FREE_CHAIN)
	e2b:SetCost(c26012011.qcost)
	c:RegisterEffect(e2b)
end
function c26012011.thfilter(c)
	return c:IsSetCard(0x612) and c:IsMonster() and c:IsAbleToHand()
end
function c26012011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c26012011.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26012011.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26012011.thfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c26012011.spfilter(c,e,tp)
	return c:GetLevel()==1 and c:IsLocation(LOCATION_HAND)
end
function c26012011.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg<=0 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	sg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #sg==3 then
		local spg=Duel.GetMatchingGroup(c26012011.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
		local opt=nil
		local opt1=(#spg>1 and ft>1 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
		local opt2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		if (opt1 or opt2) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26012011,0))
			if opt1 and opt2 then
				opt=Duel.SelectOption(tp,aux.Stringid(26012011,1),aux.Stringid(26012011,2))
			elseif opt1 and not opt2 then
				opt=Duel.SelectOption(tp,aux.Stringid(26012011,1))
			elseif opt2 and not opt1 then
				opt=Duel.SelectOption(tp,aux.Stringid(26012011,2))+1
			end
			Duel.BreakEffect()
			if opt==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local lc=spg:Select(tp,2,ft,nil)
				Duel.SpecialSummon(lc,0,tp,tp,false,false,POS_FACEUP)
			elseif opt==1 then
				Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end
function c26012011.resfilter(c,p)
	return c:GetLevel()==1 and Duel.IsPlayerCanRelease(p,c)
end
function c26012011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
		and Duel.IsExistingMatchingCard(c26012011.resfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c26012011.resfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST+HINTMSG_RELEASE)
end
function c26012011.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26012011.resfilter,tp,LOCATION_HAND,0,nil,tp):Filter(Card.IsCode,nil,26012003)
	if chk==0 then return #g>0 and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,1,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.SendtoGrave(sg,REASON_COST+REASON_RELEASE)
end
function c26012011.filterE(c,e,tp)
	return c:GetLevel()==1 and c:IsAbleToHand()
end
function c26012011.filterX(c,e,tp)
	return c:GetRank()==1 and c:IsType(TYPE_XYZ) and c:IsAbleToHand()
end
function c26012011.filterL(c,e,tp)
	return c:GetLink()==1 and c:IsType(TYPE_LINK) and c:IsAbleToHand()
end
function c26012011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_GRAVE+LOCATION_REMOVED 
	if chkc then return chkc:IsLocation(loc) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return
	Duel.IsExistingTarget(c26012011.filterE,tp,loc,0,1,nil) and
	Duel.IsExistingTarget(c26012011.filterX,tp,loc,0,1,nil) and
	Duel.IsExistingTarget(c26012011.filterL,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c26012011.filterE,tp,loc,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,c26012011.filterX,tp,loc,0,1,1,nil)
	local g3=Duel.SelectTarget(tp,c26012011.filterL,tp,loc,0,1,1,nil)
	g1:Merge(g2);g1:Merge(g3)
	if e:GetLabelObject():IsExists(Card.IsCode,1,nil,26012001) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26012001,1))
		local g4=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,0,1,nil)
		g1:Merge(g4)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,#g1,0,0)
	if e:GetLabelObject():IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012011.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end