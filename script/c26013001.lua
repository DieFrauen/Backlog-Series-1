--Echolon Buster
function c26013001.initial_effect(c)
	--summon from GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,26013001)
	e1:SetTarget(c26013001.sptg)
	e1:SetOperation(c26013001.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetProperty(0)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c26013001.qcon)
	e4:SetCost(c26013001.qcost)
	c:RegisterEffect(e4)
	--ss from hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetDescription(aux.Stringid(26013001,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCountLimit(1,{26013001,1})
	e5:SetCondition(c26013001.sp2con)
	e5:SetOperation(c26013001.sp2op)
	e5:SetTarget(c26013001.sp2tg)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(c26013001.qcon)
	e6:SetCost(c26013001.qcost)
	c:RegisterEffect(e6)
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26013001,2))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1,{26013001,2})
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetCondition(c26013001.thcon)
	e7:SetTarget(c26013001.thtg)
	e7:SetOperation(c26013001.thop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetCondition(c26013001.qcon)
	e8:SetCost(c26013001.qcost)
	c:RegisterEffect(e8)
end
function c26013001.sumfilter(c)
	return c:IsLevelBelow(1) and c:IsSummonable(true,nil)
end
function c26013001.qcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsPlayerAffectedByEffect(tp,26013011)
	and ((re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	and g and g:IsContains(e:GetHandler())
	and re:GetHandler():IsSetCard(0x613)) or rp~=tp)
end
function c26013001.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26013011)==0 end
	Duel.RegisterFlagEffect(tp,26013011,RESET_CHAIN,0,1)
end
function c26013001.filter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26013001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26013001.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,26013001)<2 end
	Duel.RegisterFlagEffect(tp,26013001,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,c26013001.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c26013001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local p1= tc:IsLevelAbove(1)
		local p2= tc:GetType()&TYPE_TUNER ==0
		if (p1 or p2) and Duel.SelectYesNo(tp,aux.Stringid(26013001,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26013001,5))
			local op=Duel.SelectEffect(tp,
			{p1,aux.Stringid(26013001,2)},
			{p2,aux.Stringid(26013001,3)},
			{(p1 and p2),aux.Stringid(26013001,4)})
			if op~=2 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(tc:GetLevel())
				tc:RegisterEffect(e1)
			end
			if op~=1 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_ADD_TYPE)
				e2:SetValue(TYPE_TUNER)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function c26013001.sp2con(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0x613)
end
function c26013001.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,26013001)<2 end
	Duel.RegisterFlagEffect(tp,26013001,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26013001.sp2op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26013001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:GetFirst():IsSetCard(0x613)
end
function c26013001.thfilter(c)
	return c:IsSetCard(0x613) and c:IsAbleToHand()
end
function c26013001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26013001.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,26013001)<2 end
	Duel.RegisterFlagEffect(tp,26013001,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26013001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26013001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26013001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() and Duel.GetFlagEffect(tp,26013001)<2 end
	Duel.RegisterFlagEffect(tp,26013001,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c26013001.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end