--Arc-Chemera Manticus
function c26014009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local f0=Fusion.AddProcMix(c,false,false,26014001,26014004)[1]
	f0:SetDescription(aux.Stringid(26014009,0))
	local f1=Fusion.AddProcMix(c,false,false,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE))[1]
	f1:SetDescription(aux.Stringid(26014009,1))
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		f1:SetValue(c26014009.matfilter)
	end
	aux.GlobalCheck(c26014009,function()
		c26014009.polycheck=0
	end)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26014009.splimit)
	c:RegisterEffect(e1)
	--atk reduction
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26014009,2))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c26014009.atkcon)
	e2:SetTarget(c26014009.atktg)
	e2:SetOperation(c26014009.atkop)
	c:RegisterEffect(e2)
	--Unaffected by activated effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c26014009.immval)
	c:RegisterEffect(e3)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
c26014009.listed_names={CARD_POLYMERIZATION }
function c26014009.splimit(e,se,sp,st)
	if se:GetHandler():IsCode(CARD_POLYMERIZATION) then c26014009.polycheck=1
	else c26014009.polycheck=0 end
	if (not e:GetHandler():IsLocation(LOCATION_EXTRA) or (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION) then
		return se
	end
end
function c26014009.matfilter(c,fc,sub,sub2,mg,sg,tp,contact,sumtype)
	if sumtype&SUMMON_TYPE_FUSION ~=0 and fc:IsLocation(LOCATION_EXTRA) and mg then
		return c26014009.polycheck==1
	end
	return c26014009.polycheck==1
end
function c26014009.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c26014009.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetChainLimit(function(te,rp,tp) return not te:IsMonsterEffect()or rp==tp end)
end
function c26014009.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	local val=Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)*-100
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c26014009.immval(e,te)
	return te:IsActiveType(TYPE_MONSTER)
	and te:GetOwner():GetAttack()<e:GetHandler():GetAttack()
	and te:IsActivated()
end
