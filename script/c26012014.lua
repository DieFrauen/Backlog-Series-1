--Quark Collider
function c26012014.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26012014,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26012014.target)
	e1:SetOperation(c26012014.activate)
	c:RegisterEffect(e1)
	--grave eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012014,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c26012014.cost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c26012014.atttg)
	e2:SetOperation(c26012014.attop)
	c:RegisterEffect(e2)
	
end
function c26012014.sp2filter(c,e,tp)
	return c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26012014.xyzfilter(c,mg)
	return c:IsRank(1) and c:IsXyzSummonable(mg)
end
function c26012014.rescon(sg,e,tp,mg)
	local gg=#sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local dg=#sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return 
	((gg==1 and sg:IsExists(Card.IsSetCard,2,nil,0x612)) or gg==0) and
	((dg==1 and sg:GetClassCount(Card.GetAttribute)==3) or  dg==0)
end
function c26012014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=math.min(3,Duel.GetLocationCount(tp,LOCATION_MZONE,0))
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=math.min(1,ft) end
		local g=Duel.GetMatchingGroup(c26012014.sp2filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		return Duel.IsExistingMatchingCard(c26012014.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) or aux.SelectUnselectGroup(g,e,tp,1,ft,c26012014.rescon,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c26012014.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=math.min(3,Duel.GetLocationCount(tp,LOCATION_MZONE,0))
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=math.min(1,ft) end
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26012014.sp2filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c26012014.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	local b1=aux.SelectUnselectGroup(g1,e,tp,1,ft,c26012014.rescon,0)
	local b2=#g2>0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26012014,0))
	local op=Duel.SelectEffect(tp,
	{b1,aux.Stringid(26012014,1)},
	{b2,aux.Stringid(26012014,2)})
	local mg=nil
	if op~=2 then
		local rg=aux.SelectUnselectGroup(g1,e,tp,1,ft,c26012014.rescon,1,tp,HINTMSG_SPSUMMON,c26012014.rescon)
		Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		local mg=Duel.GetOperatedGroup()
		g2=Duel.GetMatchingGroup(c26012014.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
		if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(26012014,2)) then op=2; Duel.BreakEffect() end
	end
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,tc,mg)
	end
end

function c26012014.resfilter(c,p)
	return c:GetLevel()==1 and Duel.IsPlayerCanRelease(p,c)
end
function c26012014.xfilter(c,p)
	return c:IsType(TYPE_XYZ) and c:IsRank(1) and c:IsLinked()
end
function c26012014.ovfilter(c)
	return c:GetOverlayCount()>0
end
function c26012014.tgfilter(c)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c26012014.rescon1(sg,e,tp,mg)
	local g=sg:Filter(Card.IsSetCard,nil,0x612)
	local og=sg:Clone()-g
	return #g>0 and #og<2 and sg:GetClassCount(Card.GetAttribute)==#sg
end
function c26012014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26012014.xfilter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT,g) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
	local tc=g:FilterSelect(tp,c26012014.ovfilter,1,1,nil):GetFirst()
	local sg=tc:GetOverlayGroup():Select(tp,1,2,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26012014.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c26012014.tgfilter(chkc) end
	local g=Duel.GetMatchingGroup(c26012014.tgfilter,tp,0,LOCATION_MZONE,nil,TYPE_XYZ)
	if chk==0 then return Duel.IsExistingTarget(c26012014.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	local lb=e:GetLabelObject()
	local ct=1; if lb:IsExists(Card.IsCode,1,nil,26012001) then ct=2 end
	local tg=Duel.SelectTarget(tp,c26012014.tgfilter,tp,0,LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
	if lb:IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012014.attop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c26012014.chkfilter,nil,e)
	local xg=Duel.GetMatchingGroup(c26012014.xfilter,tp,LOCATION_MZONE,0,nil,tp)
	if #sg>0 and #xg>0 then
		local tc=xg:Select(tp,1,1,nil):GetFirst()
		if tc then
			Duel.Overlay(tc,sg,true)
		end
	end
end
function c26012014.chkfilter(c,e)
	return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end