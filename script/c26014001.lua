--Arc-Chemic Liogno
function c26014001.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014001,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.NOT(c26014001.spqcon))
	e1:SetCountLimit(1,26014001)
	e1:SetTarget(c26014001.sptg)
	e1:SetOperation(c26014001.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCondition(c26014001.spqcon)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,{26014001,1})
	e3:SetTarget(c26014001.target)
	e3:SetOperation(c26014001.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--set Poly to field
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26014001,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCountLimit(1,{26014001,2})
	e6:SetTarget(c26014001.settg)
	e6:SetOperation(c26014001.setop)
	c:RegisterEffect(e6)
end
c26014001.listed_names={CARD_POLYMERIZATION }
function c26014001.spfilter(c,tp)
	return (c:IsSetCard(0x614) or c:IsAttribute(ATTRIBUTE_EARTH))
	and c:IsAbleToRemove(tp) and Duel.GetMZoneCount(tp,c)>0
	and c:IsMonster() and (c:IsControler(tp) and c:IsFaceup()
	or aux.SpElimFilter(c,true) and not c:IsOnField())
end
function c26014001.spqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(
	function(c)
		return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
	end,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp,1)
end
function c26014001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lb=e:GetLabel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c26014001.spfilter(chkc,tp,lb) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26014001.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp,lb)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c26014001.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp,lb)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c26014001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26014001.sumfilter(c,e,tp)
	return c:IsSetCard(0x614) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26014001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsExistingMatchingCard(c26014001.sumfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c26014001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26014001.sumfilter),tp,LOCATION_HAND+LOCATION_GRAVE ,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26014001.setfilter(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsSSetable()
end
function c26014001.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26014001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c26014001.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26014001.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then Duel.SSet(tp,tc) end
end