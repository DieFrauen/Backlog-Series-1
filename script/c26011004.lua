--Halcyion Wing of Prevention
function c26011004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c26011004.spcon1)
	e1:SetTarget(c26011004.sptg)
	e1:SetOperation(c26011004.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(aux.TRUE)
	e2:SetProperty(0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26011004,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c26011004.spcon2)
	e3:SetTarget(c26011004.sptg)
	e3:SetOperation(c26011004.spop)
	c:RegisterEffect(e3)
	--Add 1 "Halcyon" card from Deck to GY
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26011004,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,26011004)
	e4:SetTarget(c26011004.thtg)
	e4:SetOperation(c26011004.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e7)
	--negate targeting
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_CHAIN_SOLVING)
	e8:SetOperation(c26011004.disop)
	c:RegisterEffect(e8)
	aux.DoubleSnareValidity(c,LOCATION_MZONE)
end
function c26011004.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return c26011004.spcon(ev,re)
end
function c26011004.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,26011010) then return false end
	for i=1,ev do
		local sp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		if sp~=tp and c26011004.spcon(i,re) then
			return true
		end
	end
	return false
end
function c26011004.spcon(ev,re)
	if not re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
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
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function c26011004.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x611)
end
function c26011004.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c26011004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26011004.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26011004.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26011004.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c26011004.posfilter(c,e)
	return c:IsFaceup() and c:IsDefensePos()
	and c:IsAttribute(ATTRIBUTE_LIGHT)
	and c:IsCanChangePosition() and not c:IsImmuneToEffect(e)
end
function c26011004.filter(c)
	return c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsSetCard(0x611))
end
function c26011004.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or rc:IsDisabled() then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local g=Duel.GetMatchingGroup(c26011003.posfilter,tp,LOCATION_MZONE,0,nil,e)
	g:Sub(tg)
	if rp~=tp and tg:IsExists(c26011004.filter,1,nil) and #g>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(26011004,3)) then
		local tc=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_CARD,tp,26011004)
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		Duel.NegateEffect(ev)
	end
end