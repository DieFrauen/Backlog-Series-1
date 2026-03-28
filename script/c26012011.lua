--Quark Charge
function c26012011.initial_effect(c)
	--summon and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26012011,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26012011.target)
	e1:SetOperation(c26012011.activate)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012011,3))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c26012011.cost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c26012011.mattg)
	e2:SetOperation(c26012011.matop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetDescription(aux.Stringid(26012011,4))
	e2b:SetType(EFFECT_TYPE_QUICK_O)
	e2b:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2b)
end
function c26012011.spfilter(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c26012011.revfilter(c,e,tp)
	return c:IsLevel(1) and not c:IsPublic()
end
function c26012011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c26012011.revfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(Card.IsLevel,tp,LOCATION_DECK,0,nil,1)
	local g=g1+g2
	if chk==0 then return #(g1+g2)>0 and aux.SelectUnselectGroup(g,e,tp,3,3,c26012011.rescon,0)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,0)
end
function c26012011.rescon(sg,e,tp,mg)
	local g=sg:Filter(Card.IsSetCard,nil,0x612)
	local hg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local dg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	local og=sg:Clone()-g
	return #g>0 and #og<2 and sg:GetClassCount(Card.GetAttribute)==#sg and (#hg:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)>0 or #dg:Filter(Card.IsAbleToHand,nil)>0)
end
function c26012011.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26012011.revfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(Card.IsLevel,tp,LOCATION_DECK,0,nil,1)
	local g=g1+g2
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,c26012011.rescon,1,tp,HINTMSG_CONFIRM,c26012011.rescon)
	local sg1,sg2=sg:Split(Card.IsLocation,nil,LOCATION_DECK)
	Duel.ConfirmCards(1-tp,sg1)
	local b1=#sg1:Filter(Card.IsAbleToHand,nil)>0
	Duel.ConfirmCards(1-tp,sg2)
	local b2=#sg2:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)>0
	local b3=(b1 and b2)
	local op=Duel.SelectEffect(tp,
	{b1,aux.Stringid(26012011,1)},
	{b2,aux.Stringid(26012011,2)},
	{b3,aux.Stringid(26012011,3)})
	if op~=2 then
		sc=sg1:GetFirst()
		if sc then
			if #sg1>1 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
				sc=sg1:FilterSelect(1-tp,Card.IsAbleToHand,1,1,nil)
			end
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		end
		Duel.ShuffleHand(tp)
	end
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local fg=sg2:FilterSelect(1-tp,Card.IsCanBeSpecialSummoned,1,3,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummon(fg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26012011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,tp)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and aux.SelectUnselectGroup(g,e,tp,1,2,c26012011.rescon2,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1) 
	local sg=aux.SelectUnselectGroup(g,e,tp,1,2,c26012011.rescon2,1,tp,HINTMSG_RELEASE,c26012011.rescon2)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.SendtoGrave(sg,REASON_COST+HINTMSG_RELEASE)
end
function c26012011.rescon2(sg,e,tp,mg)
	return (sg:IsExists(Card.IsCode,1,nil,26012003)
	or e:GetType()&EFFECT_TYPE_QUICK_O ==0) 
end
function c26012011.ovfilter(c,e)
	return c:IsSetCard(0x1612) and c:IsMonster() and not c:IsForbidden()
end
function c26012011.xfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(1)
	and Duel.IsExistingMatchingCard(c26012011.ovfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c26012011.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26012011.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	if e:GetLabelObject():IsExists(Card.IsCode,1,nil,26012002) then
		Duel.SetChainLimit(c26012002.chlimit)
	end
end
function c26012011.matop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26012011.xfilter,tp,LOCATION_MZONE,0,nil,tp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc and #g>0 then
		local mg=Duel.GetMatchingGroup(c26012011.ovfilter,tp,LOCATION_GRAVE,0,nil)
		local sg=aux.SelectUnselectGroup(mg,e,tp,1,6,aux.dpcheck(Card.GetAttribute),1,tp,HINTMSG_XMATERIAL)
		Duel.Overlay(tc,sg)
	end
end