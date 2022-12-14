--Clustar Gather
function c26012012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26012012.target)
	e1:SetOperation(c26012012.activate)
	c:RegisterEffect(e1)
	--grave eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012012,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c26012012.cost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c26012012.thtg)
	e2:SetOperation(c26012012.thop)
	c:RegisterEffect(e2)
end

function c26012012.filter(c,e,tp)
	return c:IsSetCard(0x612) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26012012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26012012.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c26012012.exfilter(c,sfunc)
	return (c:GetRank()==1 or c:GetLink()==1) and sfunc(c)
end
function c26012012.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26012012.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local xg=Duel.GetMatchingGroup(c26012012.exfilter,tp,LOCATION_EXTRA,0,nil,Card.IsXyzSummonable)
		local lg=Duel.GetMatchingGroup(c26012012.exfilter,tp,LOCATION_EXTRA,0,nil,Card.IsLinkSummonable)
		local opt1,opt2=#xg>0,#lg>0
		if (opt1 or opt2) and Duel.SelectYesNo(tp,aux.Stringid(26012012,1)) then
			Duel.BreakEffect()
			local opt
			if opt1 and opt2 then
				opt=Duel.SelectOption(tp,aux.Stringid(26012012,2),aux.Stringid(26012012,3))
			elseif opt1 and not opt2 then
				opt=Duel.SelectOption(tp,aux.Stringid(26012012,2))
			elseif opt2 and not opt1 then
				opt=Duel.SelectOption(tp,aux.Stringid(26012012,3))+1
			end
			if opt==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local xc=xg:Select(tp,1,1,nil):GetFirst()
				Duel.XyzSummon(tp,xc)
			elseif opt==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local lc=lg:Select(tp,1,1,nil):GetFirst()
				Duel.LinkSummon(tp,lc)
			end
		end
	end
end
function c26012012.dcost(c)
	return c:IsDiscardable() and ((c:IsType(TYPE_MONSTER) and c:GetLevel()==1) or c:IsSetCard(0x612))
end
function c26012012.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetAttribute)==sg:GetCount()
end
function c26012012.tdfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c26012012.Rfilter(c,e,eg)
	return c:IsAbleToDeck()
	and c:IsCanBeEffectTarget(e)
	and not eg:IsExists(Card.IsAttribute,1,nil,c:GetAttribute())
end
function c26012012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26012012.dcost,tp,LOCATION_HAND,0,1,nil) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(tp,c26012012.dcost,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function c26012012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c26012012.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local gc=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(c26012012.tdfilter,tp,LOCATION_GRAVE,0,nil)
	local g1=aux.SelectUnselectGroup(g,e,tp,1,#g,c26012012.rescon,1,tp,HINTMSG_TARGET,c26012012.rescon)
	if gc:IsExists(Card.IsCode,1,nil,26012001) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26012001,1))
		local g2=Duel.SelectTarget(tp,c26012012.Rfilter,tp,0,LOCATION_ONFIELD,0,1,nil,e,g1)
		g1:Merge(g2)
	end
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,#g1,0,0)
	if gc:IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012012.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end