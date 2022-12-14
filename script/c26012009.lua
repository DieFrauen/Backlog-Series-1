--Celadon Gleam Clustar
function c26012009.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26012009.matfilter,1,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26012009)
	e1:SetTarget(c26012009.target)
	e1:SetOperation(c26012009.operation)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012009,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,26012009)
	e2:SetCost(c26012009.matcost)
	e2:SetTarget(c26012009.mattg)
	e2:SetOperation(c26012009.matop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetDescription(aux.Stringid(26012009,2))
	e2b:SetType(EFFECT_TYPE_QUICK_O)
	e2b:SetCode(EVENT_FREE_CHAIN)
	e2b:SetCost(c26012009.qcost)
	c:RegisterEffect(e2b)
end
function c26012009.matfilter(c,lc,sumtype,tp)
	return (c:GetLevel()==1 or c:GetRank()==1) --and c:GetAttribute(ATTRIBUTE_WIND)
end 
function c26012009.filter(c,e,tp,zone,op)
	return (op==false and c:GetLevel()==1 or c:IsCode(26012003))
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) 
end
function c26012009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and (Duel.IsExistingMatchingCard(c26012009.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone,false) or Duel.IsExistingMatchingCard(c26012009.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone,true))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26012009.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	local g1=Duel.GetMatchingGroup(c26012009.filter,tp,LOCATION_HAND,0,nil,e,tp,zone,false)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26012009.filter),tp,LOCATION_GRAVE,0,nil,e,tp,zone,true)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=g1:Select(tp,1,1,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c26012009.Gfilter(c)
	return c:IsCode(26012003) and c:IsDiscardable()
end
function c26012009.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c26012009.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26012009.Gfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c26012009.Gfilter,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c26012009.xfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetRank()==1 and not c:IsImmuneToEffect(e)
end
function c26012009.ovfilter(c,e)
	return c:GetLevel()==1 and not c:IsImmuneToEffect(e)
end
function c26012009.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26012009.ovfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(c26012009.ovfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e) and c:GetLinkedGroup():IsExists(c26012009.xfilter,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectTarget(tp,c26012009.ovfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e)
	if e:GetLabelObject():IsCode(26012001) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26012001,1))
		local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,0,1,g1:GetFirst())
		g1:Merge(g2)
	end
	if e:GetLabelObject():IsCode(26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012009.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local xg=c:GetLinkedGroup()
	if c:IsRelateToEffect(e) and #tg>0 and xg:IsExists(c26012009.xfilter,1,nil,e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=xg:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.Overlay(sg:GetFirst(),tg)
		end
	end
end
