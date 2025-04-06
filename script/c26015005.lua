--Renmity of Heart
function c26015005.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26015005)
	e1:SetCost(c26015005.spcost)
	e1:SetTarget(c26015005.sptg)
	e1:SetOperation(c26015005.spop)
	c:RegisterEffect(e1)
	--Send a level from Deck to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26015005)
	--e2:SetCondition(c26015005.spcond)
	e2:SetCost(c26015005.spcost2)
	e2:SetTarget(c26015005.sptg)
	e2:SetOperation(c26015005.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c26015005.spfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c26015005.matfilter(c,tc)
	if c:IsSetCard(0x1615) then return true
	elseif tc:IsType(TYPE_RITUAL) then
		return c:IsRace(tc:GetRace())
		and c:IsAttribute(tc:GetAttribute())
	end
end
function c26015005.rescon(sg,e,tp,mg)
	local tc=e:GetLabelObject()
	return tc and sg:IsContains(e:GetHandler())
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>=#sg
	and sg:GetSum(Card.GetLevel)==tc:GetLevel()
	and sg:FilterCount(c26015005.matfilter,nil,tc)==#sg
end
function c26015005.cfilter(c,e,tp,g)
	if c:IsReleasable() then
		e:SetLabelObject(c)
		return aux.SelectUnselectGroup(g,e,tp,2,3,c26015005.rescon,0)
	end
end
function c26015005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26015005.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsExistingMatchingCard(c26015005.cfilter,tp,LOCATION_HAND,0,1,c,e,tp,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=Duel.SelectMatchingCard(tp,c26015005.cfilter,tp,LOCATION_HAND,0,1,1,c,e,tp,g):GetFirst()
	e:SetLabelObject(tc)
	Duel.SendtoGrave(tc,REASON_COST+REASON_RELEASE)
end
function c26015005.filter2(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c26015005.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local p1= eg:IsExists(c26015005.filter2,1,nil,tp)
	local p2=(eg:IsExists(c26015005.filter2,1,nil,1-tp)
	and Duel.IsPlayerAffectedByEffect(tp,26015010))
	if chk==0 then return c26015005.spcost(e,tp,eg,ep,ev,re,r,rp,0) and (p1 or p2) 
	end
	c26015005.spcost(e,tp,eg,ep,ev,re,r,rp,1)
	if p2 then
		Duel.Hint(HINT_CARD,1-tp,26015010)
		Duel.RegisterFlagEffect(tp,26015010,RESET_PHASE+PHASE_END,0,1)
	end
end
function c26015005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c26015005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26015005.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,3,c26015005.rescon,1,tp,HINTMSG_SPSUMMON,c26015005.rescon)
	if #sg>1 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleSetCard(sg)
	end
end