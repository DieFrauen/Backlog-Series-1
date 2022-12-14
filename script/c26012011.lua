--Clustar Beckon
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
	e2:SetCountLimit(1,26012011)
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
function c26012011.filter(c,e,tp)
	return (c:GetLevel()==1 or c:GetRank()==1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26012011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26012011.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26012011.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c26012011.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26012011.ovfilter(c,att)
	return c:IsSetCard(0x612) and c:IsLocation(LOCATION_HAND) or c:IsAttribute(att)
end
function c26012011.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local att=tc:GetAttribute()
	local xg=Duel.GetMatchingGroup(c26012011.ovfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,tc,att)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsType(TYPE_XYZ) and #xg>0 and Duel.SelectYesNo(tp,aux.Stringid(26012011,1)) then
		local sg=xg:Select(tp,1,1,tc)
		Duel.HintSelection(sg)
		Duel.Overlay(tc,sg)
	end
end
function c26012011.resq(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,26012003)
end
function c26012011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,99,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function c26012011.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:IsExists(Card.IsCode,1,nil,26012003) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,99,c26012011.resq,1,tp,HINTMSG_DISCARD,c26012011.resq)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function c26012011.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetAttribute)==sg:GetCount() and sg:IsExists(Card.IsSetCard,1,1,0x612)
end
function c26012011.thfilter(c)
	return c:IsAbleToHand() 
end
function c26012011.Rfilter(c,e,eg)
	return c:IsAbleToHand()
	and c:IsCanBeEffectTarget(e)
	and not eg:IsExists(Card.IsAttribute,1,nil,c:GetAttribute())
end
function c26012011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsAbleToHand() end
	local g=Duel.GetMatchingGroup(c26012011.thfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>0 and g:IsExists(Card.IsSetCard,1,1,0x612) end
	local gc=e:GetLabelObject()
	local g1=aux.SelectUnselectGroup(g,e,tp,1,#gc,c26012011.rescon,1,tp,HINTMSG_TARGET,c26012011.rescon)
	if gc:IsExists(Card.IsCode,1,nil,26012001) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26012001,1))
		local g2=Duel.SelectTarget(tp,c26012011.Rfilter,tp,0,LOCATION_ONFIELD,0,1,nil,e,g1)
		g1:Merge(g2)
	end
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,#g1,0,0)
	Duel.SetChainLimit(c26012011.chlimit)
end
function c26012011.chlimit(e,ep,tp)
	return tp==ep
end
function c26012011.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end