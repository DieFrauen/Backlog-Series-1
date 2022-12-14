--Halcyion Wing of Prevention
function c26011004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26011004.spcon)
	e1:SetTarget(c26011004.sptg)
	e1:SetOperation(c26011004.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c26011004.disop)
	c:RegisterEffect(e2)
	aux.DoubleSnareValidity(c,LOCATION_MZONE)
   
end
function c26011004.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsExists(Card.IsOnField,1,nil) then return false end
	return true
end
function c26011004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26011004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
end
function c26011004.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c26011004.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or rc:IsDisabled() then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if tg:IsExists(c26011004.filter,1,nil) and c:IsDefensePos() and c:IsCanChangePosition() and Duel.SelectYesNo(tp,aux.Stringid(26011004,1)) then
		Duel.Hint(HINT_CARD,tp,26011004)
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
		Duel.NegateEffect(ev)
	end
end