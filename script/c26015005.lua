--Remnance Heart Remains
function c26015005.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26015005)
	e1:SetCost(c26015005.spcost)
	e1:SetTarget(c26015005.sptg)
	e1:SetOperation(c26015005.spop)
	c:RegisterEffect(e1)
	--Send a level from Deck to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015005,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c26015005.tgtg)
	e2:SetOperation(c26015005.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--tribute Register 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c26015005.regcon)
	e5:SetOperation(c26015005.regop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_REMOVE)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetTargetRange(1,1)
	e6:SetCondition(c26015005.rmcon)
	e6:SetTarget(c26015005.rmlimit)
	c:RegisterEffect(e6)
end
function c26015005.spfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0x615) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26015005.rescon(sg,e,tp,mg)
	return sg:IsContains(e:GetHandler())
	and sg:GetSum(Card.GetLevel)==e:GetLabel()
	--and sg:GetClassCount(Card.GetCode)==#sg
end
function c26015005.cfilter(c,e,tp,g)
	if c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_ZOMBIE+RACE_FIEND)and c:IsReleasable() then
		e:SetLabel(c:GetLevel())
		return aux.SelectUnselectGroup(g,e,tp,2,3,c26015005.rescon,0)
	end
end
function c26015005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26015005.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsExistingMatchingCard(c26015005.cfilter,tp,LOCATION_HAND,0,1,c,e,tp,g) end
	local tc=Duel.SelectMatchingCard(tp,c26015005.cfilter,tp,LOCATION_HAND,0,1,1,c,e,tp,g):GetFirst()
	e:SetLabel(tc:GetLevel())
	Duel.SendtoGrave(tc,REASON_COST+REASON_RELEASE)
end
function c26015005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_HAND+LOCATION_DECK)
end
function c26015005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c26015005.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,3,c26015005.rescon,1,tp,HINTMSG_TODECK,c26015005.rescon)
	if #sg>1 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26015005.t2filter(c,lv)
	return c:GetLevel()==lv
end
function c26015005.tgfilter(c,tp)
	return c:IsSetCard(0x615) and c:IsMonster() and c:IsAbleToGrave() and c:IsReleasableByEffect()
		and not Duel.IsExistingMatchingCard(c26015005.t2filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetLevel())
end
function c26015005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26015005.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26015005.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26015005.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
	end
end
function c26015005.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE)
end
function c26015005.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(26015005,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26015005.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(26015005)~=0
end
function c26015005.rmlimit(e,c,tp,r)
	local loc=c:GetLocation()
	return c:IsFaceup() and c:IsMonster()
	and ((c:IsAttribute(ATTRIBUTE_DARK) and loc==LOCATION_GRAVE)
	or (loc==LOCATION_MZONE and c:IsType(TYPE_RITUAL)))
	and c:IsControler(e:GetHandlerPlayer()) and r&REASON_EFFECT >0 
	and not c:IsImmuneToEffect(e) and not c:IsCode(26015005)
end