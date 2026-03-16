--Halcyion Punishment
function c26011015.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetValue(1)
	e1:SetCountLimit(1,26011015,EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(c26011015.cost)
	e1:SetTarget(c26011015.target)
	e1:SetOperation(c26011015.activate)
	c:RegisterEffect(e1)
	--Can be activated from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26023012,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetValue(function(e,c) e:SetLabel(1) end)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	if not c26011015.global_check then
		c26011015.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetLabel(100)
		ge1:SetOperation(c26011015.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetLabel(200)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_CHANGE_POS)
		ge3:SetLabel(300)
		Duel.RegisterEffect(ge3,0)
	end
end
function c26011015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lb=e:GetLabelObject()
	if chk==0 then
		if lb and lb:GetLabel()==1 then
			lb:SetLabel(0)
		end
		return true
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		c:RegisterFlagEffect(26011015,RESET_CHAIN,0,1)
	end
end
function c26011015.checkop(e,tp,eg,ep,ev,re,r,rp)
	local lab=26011015+e:GetLabel()
	local tg=eg:Clone()
	if lab==26011115 then
		tg=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	end
	if lab==26011215 then tg=Group.FromCards(re:GetHandler()) end
	if not tg
	or #tg==0 then return end
	local tc=tg:GetFirst()
	local RESETS=RESETS_STANDARD_PHASE_END - RESET_TURN_SET 
	for tc in aux.Next(tg) do
		if tc and tc:IsOnField() and tc:GetFlagEffect(lab)==0 then
			tc:RegisterFlagEffect(lab,RESETS,0,1,aux.Stringid(26011015,1))
			--Duel.HintSelection(Group.FromCards(tc))
		end
	end
end
function c26011015.filter(c,e,b5)
	local bt=c26011015.conds(e,c,b5)
	return (bt>0 and c:IsAttackPos() and c:IsCanChangePosition())
	or (bt>1 and c:IsCanBeDisabledByEffect(e))
	or (bt>2 and c:IsAbleToRemove(nil,POS_FACEDOWN,REASON_EFFECT))
end
function c26011015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b5=c:IsLocation(LOCATION_HAND) and 1 or 0
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26011015.filter(chkc,e,b5) end
	if chk==0 then return Duel.IsExistingTarget(c26011015.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,b5) end
	b5=c:HasFlagEffect(26011015) and 1 or 0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectTarget(tp,c26011015.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,b5):GetFirst()
	local lb=c26011015.conds(e,tc,b5)
	if lb>0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
	end 
	if lb>1 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
	end 
	if lb>2 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	end 
	local pos=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsPreviousPosition(POS_FACEDOWN) and POS_FACEDOWN or 0
	Duel.SetTargetParam(pos)
end
function c26011015.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local code=26011015
	local b5=e:GetHandler():HasFlagEffect(code) and 1 or 0
	if tc and tc:IsRelateToEffect(e) then
		local bt=c26011015.conds(e,tc,b5)
		local b1= (bt>0 and tc:IsAttackPos() and tc:IsCanChangePosition())
		local b2= (bt>1 and not tc:IsDisabled())
		local b3= (bt>2 and tc:IsAbleToRemove(nil,POS_FACEDOWN,REASON_EFFECT))
		if b1 and (not (b2 or b3)
		or Duel.SelectYesNo(tp,aux.Stringid(code,0))) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		else b1=false
		end
		if b2 and (not (b1 or b3)
		or Duel.SelectYesNo(tp,aux.Stringid(code,1)) ) then
			Duel.BreakEffect()
			tc:NegateEffects(c,RESET_EVENT+RESETS_STANDARD)
		else b2=false
		end
		if b3 and (not (b1 or b2)
		or Duel.SelectYesNo(tp,aux.Stringid(code,2)) ) then
			Duel.BreakEffect()
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
		local pos=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		if c:IsRelateToEffect(e) and pos&POS_FACEDOWN>0
		and c:IsSSetable(true) then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function c26011015.conds(e,c,b5)
	local STATUS =STATUS_SPSUMMON_TURN|STATUS_SUMMON_TURN|STATUS_FLIP_SUMMON_TURN 
	local b1,b2,b3,b4=
	c:IsStatus(STATUS_SPSUMMON_TURN|STATUS_SUMMON_TURN|STATUS_FLIP_SUMMON_TURN ) and 1 or 0,
	c:HasFlagEffect(26011115) and 1 or 0,
	c:HasFlagEffect(26011215) and 1 or 0,
	c:HasFlagEffect(26011315) and 1 or 0
	return b1+b2+b3+b4-b5
end