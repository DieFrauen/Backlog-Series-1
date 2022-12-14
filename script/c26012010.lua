--Clustar Rousing
function c26012010.initial_effect(c)
	--summon and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26012010.target)
	e1:SetOperation(c26012010.activate)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012010,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c26012010.cost)
	e2:SetTarget(c26012010.mattg)
	e2:SetOperation(c26012010.matop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetDescription(aux.Stringid(26012010,2))
	e2a:SetCost(aux.bfgcost)
	e2a:SetCondition(aux.exccon)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetDescription(aux.Stringid(26012010,3))
	e2b:SetType(EFFECT_TYPE_QUICK_O)
	e2b:SetCode(EVENT_FREE_CHAIN)
	e2b:SetCost(c26012010.qcost)
	c:RegisterEffect(e2b)
end
function c26012010.filter(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c26012010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26012010.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26012010.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26012010.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c26012010.Gfilter(c)
	return c:IsCode(26012003) and c:IsDiscardable()
end
function c26012010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c26012010.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26012010.Gfilter,tp,LOCATION_HAND,0,1,nil) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c26012010.Gfilter,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c26012010.ovfilter(c,att)
	return c:GetLevel()==1 and c:GetAttribute()==att
end
function c26012010.xfilter(c,tp)
	local att=c:GetAttribute()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetRank()==1 and Duel.IsExistingMatchingCard(c26012010.ovfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,att)
end
function c26012010.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26012010.xfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c26012010.xfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	if e:GetLabelObject() and e:GetLabelObject():IsCode(26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
	e:SetLabelObject(nil)
end
function c26012010.matop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26012010.xfilter,tp,LOCATION_MZONE,0,nil,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,1,nil):GetFirst()
		local att=sg:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local xg=Duel.SelectMatchingCard(tp,c26012010.ovfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,att)
		if #xg>0 then
			Duel.Overlay(sg,xg)
		end
	end
end
