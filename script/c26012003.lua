--Green Quarky
function c26012003.initial_effect(c)
	--self destroy
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_SELF_DESTROY)
	e0:SetCondition(c26012003.sdcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,26012003)
	e1:SetCost(c26012003.cost)
	e1:SetTarget(c26012003.sptg)
	e1:SetOperation(c26012003.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(TIMING_SSET,TIMING_SSET+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c26012003.qcost)
	c:RegisterEffect(e2)
end
function c26012003.sdfilter(c)
	return c:IsFaceup() and (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1)
end
function c26012003.sdcon(e)
	return not Duel.IsExistingMatchingCard(c26012003.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c26012003.dsfilter(c)
	return c:IsReleasable() and c:GetLevel()==1
end
function c26012003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26012003.dsfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c26012003.dsfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,99,c)
	e:SetLabelObject(sg)
	e:SetLabel(#sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST+REASON_RELEASE)
end
function c26012003.resq(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,26012003)
end
function c26012003.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26012003.dsfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	if chk==0 then return g:IsExists(Card.IsCode,1,nil,26012003) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,99,c26012003.resq,1,tp,HINTMSG_RELEASE,c26012003.resq)
	e:SetLabelObject(sg)
	e:SetLabel(#sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST+REASON_RELEASE)
end
function c26012003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,nil) end
	local gc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local mc=1
	if gc:IsExists(Card.IsCode,1,nil,26012001) then mc=2 end
	Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,mc,nil)
	if gc:IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c26012003.spfilter(c,e,tp)
	return c:IsSetCard(0x612) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26012003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e) 
	tg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then Duel.SendtoHand(tg,nil,REASON_EFFECT) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or ft<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26012003.spfilter),tp,LOCATION_GRAVE,0,c,e,tp)
	local mx=math.min(ft-1,e:GetLabel())
	if #g>=1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.SelectYesNo(tp,aux.Stringid(26012003,2)) then
		local sg=g:Select(tp,1,mx,c)
		sg:AddCard(c)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end