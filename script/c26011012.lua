--Halcyon Bounty
function c26011012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011012,0))
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26011012,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26011012.target)
	e1:SetOperation(c26011012.activate)
	c:RegisterEffect(e1)
	--return targets to Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26011012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,{26011012,1})
	e2:SetLabel(1)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c26011012.thtg)
	e2:SetOperation(c26011012.thop)
	c:RegisterEffect(e2)
end
c26011012.listed_series={0x611}
function c26011012.filter(c)
	return c:IsSetCard(0x611) and (
	(c:IsMonster() and c:IsOnField() and c:IsDefensePos()) or
	(c:IsLocation(LOCATION_HAND) and not c:IsPublic()))
end
function c26011012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local LOC = LOCATION_HAND|LOCATION_MZONE 
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c26011012.filter,tp,LOC,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c26011012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local LOC = LOCATION_HAND|LOCATION_MZONE 
	local g=Duel.GetMatchingGroup(c26011012.filter,tp,LOC,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,5,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
	if #sg>0 then
		local g1,g2=sg:Split(Card.IsLocation,nil,LOCATION_HAND)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ChangePosition(g2,POS_FACEUP_ATTACK)
		Duel.Draw(tp,#sg,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		local dg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,#sg-1,#sg-1,nil)
		Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function c26011012.costfilter(c)
	return c:IsCode(26011012) and c:IsAbleToRemoveAsCost()
end
function c26011012.tdfilter(c,e)
	return (c:IsOnField() or (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(2) and c:IsLocation(LOCATION_GRAVE)))
		and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c26011012.rescon(fc,hc)
	return function(sg,e,tp,mg)
		local mct=sg:FilterCount(Card.IsOnField,nil)
		local sct=#sg-mct
		if mct==sct then return true end
		local rem_mct=fc-mct
		local rem_sct=hc-sct
		return false,mct>sct and rem_sct<(mct-sct) or rem_mct<(sct-mct)
	end
end
function c26011012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c26011012.tdfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,nil,e)
	local bg=Duel.GetMatchingGroup(c26011012.costfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,c)
	local fg=g:FilterCount(Card.IsOnField,nil)
	local gg=#g-fg
	local rescon=c26011012.rescon(fg,gg)
	if chk==0 then return fg>0 and gg>0 and aux.SelectUnselectGroup(g,e,tp,2,2,rescon,0) end
	bg=bg:Select(tp,1,math.min(math.min(fg,gg)*2),nil)
	Duel.Remove(bg,POS_FACEUP,REASON_COST)
	local tg=aux.SelectUnselectGroup(g,e,tp,2,#bg*2,rescon,1,tp,HINTMSG_TODECK,rescon)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,tp,0)
end
function c26011012.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end