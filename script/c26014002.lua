--Arc-Chemic Sylbird
function c26014002.initial_effect(c)
	c:SetSPSummonOnce(26014002)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014002,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.NOT(c26014002.spqcon))
	e1:SetCountLimit(1,26014002)
	e1:SetTarget(c26014002.sptg)
	e1:SetOperation(c26014002.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCondition(c26014002.spqcon)
	c:RegisterEffect(e2)   
	--add Arc-Chemic Monster to Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26014002,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{26014002,1})
	e2:SetTarget(c26014002.target)
	e2:SetOperation(c26014002.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--add Poly to Hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26014002,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_REMOVE)
	e5:SetCountLimit(1,{26014002,2})
	e5:SetTarget(c26014002.target2)
	e5:SetOperation(c26014002.operation2)
	c:RegisterEffect(e5)
end
c26014002.listed_names={CARD_POLYMERIZATION }
function c26014002.spfilter(c,tp)
	return (c:IsSetCard(0x614) or c:IsAttribute(ATTRIBUTE_WIND))
	and c:IsAbleToRemove(tp) and Duel.GetMZoneCount(tp,c)>0
	and c:IsMonster() and (c:IsControler(tp) and c:IsFaceup()
	or aux.SpElimFilter(c,true) and not c:IsOnField())
end
function c26014002.spqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(
	function(c)
		return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
	end,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp,1)
end
function c26014002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lb=e:GetLabel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c26014002.spfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26014002.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c26014002.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c26014002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26014002.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x614) and c:IsAbleToHand() 
end
function c26014002.filter2(c)
	return c:IsAbleToHand() and c:IsCode(CARD_POLYMERIZATION,26014012)
end
function c26014002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26014002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26014002.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26014002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26014002.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26014002.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26014002.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(c26014002.filter2,tp,LOCATION_DECK,0,nil)
	local tc=g:Select(tp,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end