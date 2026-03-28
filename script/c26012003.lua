--Green Quarky
function c26012003.initial_effect(c)
	--search 2 discard 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26012003,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,26012003)
	e1:SetTarget(c26012003.thtg)
	e1:SetOperation(c26012003.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Xyz/Link Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26012001,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c26012003.sptg)
	e4:SetOperation(c26012003.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
c26012003.listed_series={0x612}
function c26012003.thfilter(c)
	return c:IsLevel(1) and c:IsMonster() and c:IsAbleToHand()
end
function c26012003.rescon(sg,e,tp,mg)
	return #sg:Filter(Card.IsSetCard,nil,0x612)>1
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_DECK)<2
end
function c26012003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local LOC=LOCATION_DECK|LOCATION_GRAVE|LOCATION_MZONE 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26012003.thfilter,tp,LOC,0,nil)
	if chk==0 then return c:GetFlagEffect(26012003)==0 and aux.SelectUnselectGroup(g,e,tp,2,3,c26012003.rescon,0) end
	e:GetHandler():RegisterFlagEffect(26012003,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOC)
end
function c26012003.disfilter(c)
	return c:IsLevel(1) and c:IsDiscardable()
end
function c26012003.thop(e,tp,eg,ep,ev,re,r,rp)
	local LOC=LOCATION_DECK|LOCATION_GRAVE|LOCATION_MZONE 
	local g=Duel.GetMatchingGroup(c26012003.thfilter,tp,LOC,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,3,c26012003.rescon,1,tp,HINTMSG_ATOHAND,nil,nil,true)
	if #sg>1 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c26012003.xfilter(c,tc)
	return c:IsRank(1) and c:IsXyzSummonable(tc)
end
function c26012003.lfilter(c,tc)
	return c:IsLink(1) and c:IsLinkSummonable(tc)
end
function c26012003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c26012003.xfilter,tp,LOCATION_EXTRA,0,1,nil,c)
	local b2=Duel.IsExistingMatchingCard(c26012003.lfilter,tp,LOCATION_EXTRA,0,1,nil,c)
	if chk==0 then return c:GetFlagEffect(26012003)==0 and (b1 or b2) end
	c:RegisterFlagEffect(26012003,RESET_CHAIN,0,1)
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26012001,3)},
		{b2,aux.Stringid(26012001,4)})
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26012003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local op=e:GetLabel()
	if op==1 then
		local g=Duel.GetMatchingGroup(c26012003.xfilter,tp,LOCATION_EXTRA,0,nil,c)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,sg:GetFirst(),c)
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(c26012003.lfilter,tp,LOCATION_EXTRA,0,nil,c)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,sg:GetFirst(),c)
		end
	end
end