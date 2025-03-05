--Arc-Chemera Griffus
function c26014005.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local f0=Fusion.AddProcMix(c,false,false,26014001,26014002)[1]
	f0:SetDescription(aux.Stringid(26014005,0))
	local f1=Fusion.AddProcMix(c,false,false,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WIND))[1]
	f1:SetDescription(aux.Stringid(26014005,1))
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		f1:SetValue(c26014005.matfilter)
	end
	aux.GlobalCheck(c26014005,function()
		c26014005.polycheck=0
	end)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26014005.splimit)
	c:RegisterEffect(e1)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26014005,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(TYPE_MONSTER)
	e2:SetCountLimit(1)
	e2:SetTarget(c26014005.thtg)
	e2:SetOperation(c26014005.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26014005,3))
	e3:SetLabel(TYPE_SPELL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(26014005,4))
	e4:SetLabel(TYPE_TRAP)
	c:RegisterEffect(e4)
end
c26014005.listed_names={CARD_POLYMERIZATION }
function c26014005.splimit(e,se,sp,st)
	if se:GetHandler():IsCode(CARD_POLYMERIZATION) then c26014005.polycheck=1
	else c26014005.polycheck=0 end
	if (not e:GetHandler():IsLocation(LOCATION_EXTRA) or (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION) then
		return se
	end
end
function c26014005.matfilter(c,fc,sub,sub2,mg,sg,tp,contact,sumtype)
	if sumtype&SUMMON_TYPE_FUSION~=0 and fc:IsLocation(LOCATION_EXTRA) and mg then
		return c26014005.polycheck==1
	end
	return c26014005.polycheck==1
end
function c26014005.thfilter(c,typ)
	return c:IsFaceup() and c:IsAbleToHand()
	and c:GetType()&typ==typ
end
function c26014005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local typ=e:GetLabel()
	if chkc then
		return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup() and c26014005.thfilter(chkc,typ) and chkc:IsControler(1-tp)
	end
	if chk==0 then return c:GetFlagEffect(26014005)==0 and Duel.IsExistingTarget(c26014005.thfilter,tp,0,LOCATION_ONFIELD,1,nil,typ) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26014005.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil,typ)
	c:RegisterFlagEffect(26014005,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26014005.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end