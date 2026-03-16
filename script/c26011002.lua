--Halcyion Wing of Prosperity
function c26011002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c26011002.spcon1)
	e1:SetTarget(c26011002.sptg)
	e1:SetOperation(c26011002.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26011002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c26011002.spcon2)
	e2:SetTarget(c26011002.sptg)
	e2:SetOperation(c26011002.spop)
	c:RegisterEffect(e2)
	--Add 1 card from Deck to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26011002,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c26011002.postg)
	e3:SetOperation(c26011002.posop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_HAND)
	e6:SetCondition(c26011002.poscon)
	e6:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e6)
	--add Halcyion Spell/Trap
	local e7=e3:Clone()
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetDescription(aux.Stringid(26011002,3))
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_CHANGE_POS)
	e7:SetCountLimit(1,26011002)
	e7:SetTarget(c26011002.thtg)
	e7:SetOperation(c26011002.thop)
	c:RegisterEffect(e7)
end
function c26011002.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return c26011002.spcon(ev,re)
end
function c26011002.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,26011010) then return false end
	for i=1,ev do
		local sp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		if sp~=tp and c26011002.spcon(i,re) then
			return true
		end
	end
	return false
end
function c26011002.spcon(ev,re)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_SEARCH))
	local ex3=(Duel.GetOperationInfo(ev,CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_DRAW))
	if (ex1 and (dv1&LOCATION_DECK)==LOCATION_DECK) or ex2 or ex3 then return true end
	return false
end
function c26011002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26011002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26011002.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsReason,1,nil,REASON_EFFECT)
end
function c26011002.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c26011002.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c26011002.thfilter(c)
	return c:IsSetCard(0x611) and c:IsSpellTrap()
	and (c:IsAbleToHand() or (c:IsCode(26011010) and tc:GetActivateEffect():IsActivatable(tp,true,true)))
end
function c26011002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26011002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26011002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c26011002.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		if tc:IsCode(26011010) and tc:GetActivateEffect():IsActivatable(tp,true,true) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(26011002,4)) then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end