--Arc-Chemic Ophidine
function c26014003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014003,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.NOT(c26014003.spqcon))
	e1:SetCountLimit(1,26014003)
	e1:SetTarget(c26014003.sptg)
	e1:SetOperation(c26014003.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCondition(c26014003.spqcon)
	c:RegisterEffect(e2)
	--send card from Deck to GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014003,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,{26014003,1})
	e3:SetTarget(c26014003.target)
	e3:SetOperation(c26014003.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--add target from GY to Hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26014003,2))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCountLimit(1,{26014003,2})
	e6:SetTarget(c26014003.target2)
	e6:SetOperation(c26014003.operation2)
	c:RegisterEffect(e6)
end
c26014003.listed_names={CARD_POLYMERIZATION }
function c26014003.spfilter(c,tp)
	return (c:IsSetCard(0x614) or c:IsAttribute(ATTRIBUTE_WATER))
	and c:IsAbleToRemove(tp) and Duel.GetMZoneCount(tp,c)>0
	and c:IsMonster() and (c:IsControler(tp) and c:IsFaceup()
	or aux.SpElimFilter(c,true) and not c:IsOnField())
end
function c26014003.spqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(
	function(c)
		return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
	end,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp,1)
end
function c26014003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c26014003.spfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26014003.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c26014003.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp,lb)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c26014003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26014003.filter(c)
	return (c:IsSetCard(0x1614) or c:IsCode(CARD_POLYMERIZATION)) and c:IsAbleToGrave() 
end
function c26014003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26014003.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26014003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26014003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c26014003.filter2(c)
	return (c:IsCode(CARD_POLYMERIZATION) or c:IsSetCard(0x1614)) and c:IsAbleToHand() 
end
function c26014003.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and c26014003.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26014003.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26014003.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c26014003.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end