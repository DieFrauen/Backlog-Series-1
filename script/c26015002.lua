--Remnance Strenght Remains
function c26015002.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26015002)
	e1:SetCost(c26015002.spcost)
	e1:SetTarget(c26015002.sptg)
	e1:SetOperation(c26015002.spop)
	c:RegisterEffect(e1)
	
end

function c26015002.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x615) and
	c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:GetLevel()==lv-3
end
function c26015002.ctfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c26015002.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c26015002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26015002.ctfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c26015002.ctfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	e:SetLabel(sg:GetFirst():GetLevel())
	Duel.ConfirmCards(1-tp,sg)
end
function c26015002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c26015002.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26015002.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end