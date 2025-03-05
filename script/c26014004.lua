--Arc-Chemic Caudata
function c26014004.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014001,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.NOT(c26014004.spqcon))
	e1:SetCountLimit(1,26014004)
	e1:SetTarget(c26014004.sptg)
	e1:SetOperation(c26014004.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCondition(c26014004.spqcon)
	c:RegisterEffect(e2)
	--Banish "Arc-chemic" card from Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014004,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,{26014004,1})
	e3:SetTarget(c26014004.target)
	e3:SetOperation(c26014004.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--add Poly
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26014004,2))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCountLimit(1,{26014004,2})
	e6:SetTarget(c26014004.target2)
	e6:SetOperation(c26014004.operation2)
	c:RegisterEffect(e6)
end
function c26014004.spfilter(c,tp)
	return (c:IsSetCard(0x614) or c:IsAttribute(ATTRIBUTE_FIRE))
	and c:IsAbleToRemove(tp) and Duel.GetMZoneCount(tp,c)>0
	and c:IsMonster() and (c:IsControler(tp) and c:IsFaceup()
	or aux.SpElimFilter(c,true) and not c:IsOnField())
end
function c26014004.spqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(
	function(c)
		return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
	end,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp,1)
end
function c26014004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c26014004.spfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26014004.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c26014004.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp,lb)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c26014004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26014004.filter(c)
	return c:IsSetCard(0x1614) and c:IsAbleToRemove() 
end
function c26014004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26014004.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c26014004.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c26014004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c26014004.filter2(c)
	return (c:IsSetCard(0x614) or c:IsSetCard(0x46)) and c:IsFaceup()
	and c:IsAbleToHand() 
end
function c26014004.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:GetLocation()==LOCATION_REMOVED and c26014004.filter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c26014004.filter2,tp,LOCATION_REMOVED,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26014004.filter2,tp,LOCATION_REMOVED,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26014004.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end