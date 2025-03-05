--Arc-Chemera Cocatlus
function c26014007.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local f0=Fusion.AddProcMix(c,false,false,26014002,26014003)[1]
	f0:SetDescription(aux.Stringid(26014007,0))
	local f1=Fusion.AddProcMix(c,false,false,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WIND),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER))[1]
	f1:SetDescription(aux.Stringid(26014007,1))
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		f1:SetValue(c26014007.matfilter)
	end
	aux.GlobalCheck(c26014007,function()
		c26014007.polycheck=0
	end)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26014007.splimit)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26014007,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e2:SetTarget(c26014007.target)
	e2:SetOperation(c26014007.operation)
	c:RegisterEffect(e2)
	--activate cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c26014007.regop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c26014007.damcon)
	e4:SetOperation(c26014007.damop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SSET)
	e5:SetCondition(c26014007.ssetcon)
	c:RegisterEffect(e5)
end
c26014007.listed_names={CARD_POLYMERIZATION }
c26014007[0]=0
function c26014007.splimit(e,se,sp,st)
	if se:GetHandler():IsCode(CARD_POLYMERIZATION) then c26014007.polycheck=1
	else c26014007.polycheck=0 end
	if (not e:GetHandler():IsLocation(LOCATION_EXTRA) or (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION) then
		return se
	end
end
function c26014007.matfilter(c,fc,sub,sub2,mg,sg,tp,contact,sumtype)
	if sumtype&SUMMON_TYPE_FUSION ~=0 and fc:IsLocation(LOCATION_EXTRA) and mg then
		return c26014007.polycheck==1
	end
	return c26014007.polycheck==1
end
function c26014007.filter(c)
	return c:IsSpellTrap() and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function c26014007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c26014007.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26014007.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26014007.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,99,nil)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#hg*300)
end
function c26014007.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local b1=sg:FilterCount(Card.IsAbleToHand,nil)>0
	local b2=sg:FilterCount(Card.IsAbleToDeck,nil)>0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26014007,3))
	local op=Duel.SelectEffect(1-tp,
		{b1,aux.Stringid(26014007,4)},
		{b2,aux.Stringid(26014007,5)})
	if op==1 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
	if op==2 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.Damage(1-tp,#hg*300,REASON_EFFECT)
end
function c26014007.damcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep~=tp and e:GetHandler():GetFlagEffect(26014007)~=0 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c26014007.damop(e,tp,eg,ep,ev,re,r,rp)
	local hc=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.Hint(HINT_CARD,0,26014007)
	Duel.Damage(1-tp,#hc*100,REASON_EFFECT)
end
function c26014007.actg(e,te,tp)
	return te:GetHandler():IsLocation(LOCATION_HAND)
end
function c26014007.actchk(e,te,tp)
	e:SetLabelObject(te:GetHandler())
	return true
end
function c26014007.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(26014007,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c26014007.ssetfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c26014007.ssetcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26014007.ssetfilter,1,nil,1-tp) and ep~=tp
end