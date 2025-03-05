--Arc-Chemera Dragus
function c26014008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local f0=Fusion.AddProcMix(c,false,false,26014003,26014004)[1]
	f0:SetDescription(aux.Stringid(26014008,0))
	local f1=Fusion.AddProcMix(c,false,false,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE))[1]
	f1:SetDescription(aux.Stringid(26014008,1))
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		f1:SetValue(c26014008.matfilter)
	end
	aux.GlobalCheck(c26014008,function()
		c26014008.polycheck=0
	end)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26014008.splimit)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26014008,2))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCost(c26014008.cost)
	e2:SetTarget(c26014008.target)
	e2:SetOperation(c26014008.operation)
	c:RegisterEffect(e2)
end
c26014008.listed_names={CARD_POLYMERIZATION }
function c26014008.splimit(e,se,sp,st)
	if se:GetHandler():IsCode(CARD_POLYMERIZATION) then c26014008.polycheck=1
	else c26014008.polycheck=0 end
	if (not e:GetHandler():IsLocation(LOCATION_EXTRA) or (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION) then
		return se
	end
end
function c26014008.matfilter(c,fc,sub,sub2,mg,sg,tp,contact,sumtype)
	if sumtype&SUMMON_TYPE_FUSION~=0 and fc:IsLocation(LOCATION_EXTRA) and mg then
		return c26014008.polycheck==1
	end
	return c26014008.polycheck==1
end
function c26014008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
end
function c26014008.filter(c)
	return c:HasNonZeroAttack()
	and (c:IsAttackAbove(1000) or not c:IsDisabled())
end
function c26014008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c26014008.filter,tp,0,LOCATION_MZONE,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c26014008.filter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	local atk=tc:GetAttack()
	local atg=math.max(0,1000-atk)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
	if atg>0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atg)
	elseif atk<2000 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	end
end
function c26014008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup()
	and not c:IsImmuneToEffect(e) ) then return end
	local atk=tc:GetAttack()
	local atg=1000-atk
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_TURN_SET|RESET_PHASE+PHASE_END)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		if atk<1000 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,atg,REASON_EFFECT)
		end
		if atk<2000 then
			Duel.BreakEffect()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end