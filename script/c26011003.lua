--Halcyion Wing of Protection
function c26011003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26011003.spcon)
	e1:SetTarget(c26011003.sptg)
	e1:SetOperation(c26011003.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c26011003.reptg)
	e2:SetValue(c26011003.repval)
	e2:SetOperation(c26011003.repop)
	c:RegisterEffect(e2)
end
function c26011003.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_DESTROY) or re:IsHasCategory(CATEGORY_DESTROY))
	if ex1 or ex2 then return true end
	return false
end
function c26011003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26011003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
end
function c26011003.filter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsReason(REASON_REPLACE)
end
function c26011003.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c26011003.filter,1,nil,tp)
		and c:IsDefensePos() and e:GetHandler():IsCanChangePosition() end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c26011003.repval(e,c)
	return c26011003.filter(c,e:GetHandlerPlayer())
end
function c26011003.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,26011003)
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
end