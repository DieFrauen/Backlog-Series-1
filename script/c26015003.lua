--Renmity of Mind
function c26015003.initial_effect(c)
	--Send 1 Ritual Spell from your Deck to the GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015003,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26015003)
	e1:SetCost(c26015003.thcost)
	e1:SetTarget(c26015003.thtg)
	e1:SetOperation(c26015003.thop)
	c:RegisterEffect(e1)
	--Special Summon tributes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26015003)
	e2:SetCost(c26015003.spcost)
	e2:SetCondition(c26015003.spcond)
	e2:SetTarget(c26015003.sptg)
	e2:SetOperation(c26015003.spop)
	c:RegisterEffect(e2)
end
c26015003.listed_names={26015011} 
function c26015003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.SendtoGrave(c,REASON_COST|REASON_RELEASE)
end
function c26015003.revfilter(c)
	return c:IsCode(26015011) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
end
function c26015003.thfilter(c,tp)
	return c:IsAbleToHand() and (c:IsCode(26015011) or (c:ListsCode(26015011) and Duel.IsExistingMatchingCard(c26015003.revfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)))
end
function c26015003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26015003.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26015003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc1=Duel.SelectMatchingCard(tp,c26015003.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc1 then
		if not tc1:IsCode(26015011) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc2=Duel.SelectMatchingCard(tp,c26015003.revfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,0,1,nil):GetFirst()
			local loc=tc2:GetLocation()
			if loc==LOCATION_SZONE and tc2:IsFacedown()
			or loc==LOCATION_HAND then Duel.ConfirmCards(1-tp,tc2)
			else Duel.HintSelection(tc2) end
		end
		Duel.SendtoHand(tc1,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc1)
	end
end
function c26015003.spzone(e,tp)
	local zone=Duel.GetZoneWithLinkedCount(1,tp)
	local lg=Duel.GetMatchingGroup(c26015003.cfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=(zone|tc:GetColumnZone(LOCATION_MZONE,0,0,tp))
	end
	return zone&0x1f
end
function c26015003.spcond(e,tp,eg,ep,ev,re,r,rp)
	local zone=c26015003.spzone(e,tp)
	local g=Duel.GetMatchingGroup(c26015003.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,zone)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE)
	and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
	then
		return aux.SelectUnselectGroup(g,e,tp,1,2,c26015003.rescon,0)
	end
end
function c26015003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local op=rp~=tp
	if chk==0 then return op or Duel.IsPlayerAffectedByEffect(tp,26015010) end
	if not op then
		Duel.Hint(HINT_CARD,1-tp,26015010)
		Duel.RegisterFlagEffect(tp,26015010,RESET_PHASE+PHASE_END,0,1)
	end
end
function c26015003.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x1615) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp,zone)
end
function c26015003.rescon(sg,e,tp,mg)
	return sg:IsContains(e:GetHandler())
end
function c26015003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function c26015003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c26015003.spzone(e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
	then ct=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26015003.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,zone)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,ct,c26015003.rescon,1,tp,HINTMSG_TODECK,c26015003.rescon)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE,zone)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleSetCard(sg)
	end
end