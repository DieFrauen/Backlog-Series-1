--Halcyion Wing of Prevention
function c26011005.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c26011005.spcon1)
	e1:SetTarget(c26011005.sptg)
	e1:SetOperation(c26011005.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26011005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c26011005.spcon2)
	e2:SetTarget(c26011005.sptg)
	e2:SetOperation(c26011005.spop)
	c:RegisterEffect(e2)
	--send 1 "Halcyon" card from Deck to GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26011005,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,26011005)
	e3:SetTarget(c26011005.tgtg)
	e3:SetOperation(c26011005.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e6)
	--negate negation
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetCondition(c26011005.discon)
	e7:SetOperation(c26011005.disop)
	c:RegisterEffect(e7)
	aux.DoubleSnareValidity(c,LOCATION_MZONE)
end
function c26011005.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return c26011005.spcon(ev,re)
end
function c26011005.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,26011010) then return false end
	for i=1,ev do
		local sp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		if sp~=tp and c26011005.spcon(i,re) then
			return true
		end
	end
	return false
end
function c26011005.spcon(ev,re)
	local ex1=(Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
	or re:IsHasCategory(CATEGORY_NEGATE))
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	or re:IsHasCategory(CATEGORY_DISABLE))
	local ex3=(Duel.GetOperationInfo(ev,CATEGORY_DISABLE_SUMMON)
	or re:IsHasCategory(CATEGORY_DISABLE_SUMMON))
	if ex1 or ex2 or ex3 then return true end
	return false
end
function c26011005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26011005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26011005.tgfilter(c)
	return c:IsSetCard(0x611) and c:IsAbleToGrave()
end
function c26011005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26011005.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26011005.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26011005.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c26011005.posfilter(c,e)
	return c:IsFaceup() and c:IsDefensePos()
	and c:IsCanChangePosition() and not c:IsImmuneToEffect(e)
end
function c26011005.lffilter(c,e)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
	and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c26011005.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev)
end
function c26011005.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_DISABLE_SUMMON)
	local g1=Duel.GetMatchingGroup(c26011005.lffilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if rc:IsDisabled() or rc:IsStatus(STATUS_DISABLED) then return end
	if not (ex1 or ex2 or ex3) or #g1~=#g2 then return end
	local g=Duel.GetMatchingGroup(c26011005.posfilter,tp,LOCATION_MZONE,0,nil,e)
	if #g>0 then
		local tc=nil
		while Duel.SelectEffectYesNo(tp,e:GetHandler()) do
			tc=g:Select(tp,1,1,nil)
			if tc and Duel.ChangePosition(tc,POS_FACEUP_ATTACK) then
				Duel.Hint(HINT_CARD,tp,26011005)
				Duel.NegateEffect(ev)
				return
			end
		end
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