--Halcyon Mechanism
function c26011011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26011011,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26011011.activate)
	c:RegisterEffect(e1)
	--return target and self to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c26011011.thcon)
	e2:SetTarget(c26011011.thtg)
	e2:SetOperation(c26011011.thop)
	c:RegisterEffect(e2)
	--negate effect/change pos
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c26011011.posneg)
	c:RegisterEffect(e3)
end
c26011011[0]=0
function c26011011.filter(c)
	return c:IsSetCard(0x611) and c:IsMonster() and c:IsAbleToHand()
end
function c26011011.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local LOC=LOCATION_GRAVE 
	local g1=Duel.GetMatchingGroup(Card.IsAttackPos,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	if #g1<#g2 then LOC=LOC+LOCATION_DECK end
	local g=Duel.GetMatchingGroup(c26011011.filter,tp,LOC,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26011011,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT|REASON_DISCARD,nil)
	end
end
function c26011011.thfilter(c)
	return c:IsAttackPos() and c:IsAbleToHand()
end
function c26011011.dtafilter(c)
	return (c:GetPreviousPosition()&POS_DEFENSE)~=0 and c:IsFaceup()
	and c:IsAttackPos()
end
function c26011011.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26011011.dtafilter,1,nil)
end
function c26011011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26011011.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26011011.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c26011011.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26011011.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and c and c:IsRelateToEffect(e) then
		Duel.SendtoHand(Group.FromCards(c,tc),nil,REASON_EFFECT)
	end
end
function c26011011.negfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c26011011.lfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_LINK)
end
function c26011011.posneg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tloc,chid,cp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID,CHAININFO_TRIGGERING_CONTROLER)
	if not (tloc==LOCATION_MZONE and chid~=c26011011[0] and re:IsMonsterEffect()) then return end
	c26011011[0]=chid
	if cp~=tp and Duel.IsExistingMatchingCard(c26011011.lfilter,tp,LOCATION_MZONE,0,1,nil) --and Duel.SelectEffectYesNo(tp,c)
	then
		local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
		if #g>0 then
			local pg=g:Filter(Card.IsCanChangePosition,nil)
			if #pg>0 then
				Duel.BreakEffect()
				local tg=pg:Select(1-tp,1,1,nil)
				Duel.ChangePosition(tg,POS_FACEUP_DEFENSE)
			else Duel.NegateEffect(ev) end
		end
	end
end