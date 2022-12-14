--Halcyion Wing of Perseverance
function c26011005.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26011005.spcon)
	e1:SetTarget(c26011005.sptg)
	e1:SetOperation(c26011005.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c26011005.disop)
	c:RegisterEffect(e2)
	
end
function c26011005.precon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c26011005.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ex1=(Duel.GetOperationInfo(ev,CATEGORY_NEGATE) or re:IsHasCategory(CATEGORY_NEGATE))
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_DISABLE) or re:IsHasCategory(CATEGORY_DISABLE))
	if ex1 or ex2 then return true end
	return false
end
function c26011005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26011005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		return true
	end
end
function c26011005.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	if not (ex1 or ex2 or ex3) then return end
	if c:IsDefensePos() and c:IsCanChangePosition() and Duel.SelectYesNo(tp,aux.Stringid(26011005,1)) then
		Duel.Hint(HINT_CARD,tp,26011005)
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
		--cannot inactivate/disable
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_INACTIVATE)
		e2:SetValue(c26011005.efilter)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_DISEFFECT)
		e3:SetValue(c26011005.efilter)
		e3:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e3,tp)
	end
end
function c26011005.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_LIGHT)
end
function c26011005.efilter2(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
end