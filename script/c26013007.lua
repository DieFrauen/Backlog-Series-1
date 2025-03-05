--Echolon Sonic Glider
function c26013007.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013007,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,26013007)
	e1:SetCondition(c26013007.drcon)
	e1:SetTarget(c26013007.drtg)
	e1:SetOperation(c26013007.drop)
	c:RegisterEffect(e1)
	--target (when attacked)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetDescription(aux.Stringid(26013007,5))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c26013007.atcon)
	e2:SetTarget(c26013007.target)
	e2:SetOperation(c26013007.operation)
	c:RegisterEffect(e2)
	--target (when used as mat)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetDescription(aux.Stringid(26013007,6))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c26013007.tncon)
	e3:SetTarget(c26013007.target)
	e3:SetOperation(c26013007.operation)
	c:RegisterEffect(e3)
	--target (frequency)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c26013007.qcon)
	e4:SetCost(c26013007.qcost)
	e4:SetTarget(c26013007.target)
	e4:SetOperation(c26013007.operation)
	c:RegisterEffect(e4)
end
function c26013007.mat(c)
	return c:GetOriginalType()&TYPE_TUNER ==0
end
function c26013007.qcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsPlayerAffectedByEffect(tp,26013011)
	and ((re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	and g and g:IsContains(e:GetHandler())
	and re:GetHandler():IsSetCard(0x613)) or rp~=tp)
end
function c26013007.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26013011)==0 end
	Duel.RegisterFlagEffect(tp,26013011,RESET_CHAIN,0,1)
end
function c26013007.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c26013007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=e:GetHandler():GetMaterial():FilterCount(c26013007.mat,nil)
	if chk==0 then return val>0 and Duel.IsPlayerCanDraw(tp,val) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,val)
end
function c26013007.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c26013007.atcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and d==e:GetHandler()
end
function c26013007.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO 
end
function c26013007.filter(c,e,tp)
	return (c:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(c26013007.scfilter,tp,LOCATION_EXTRA,0,1,nil,c))
	or (c:IsType(TYPE_TUNER) and not c:IsImmuneToEffect(e))
	or (not c:IsType(TYPE_TUNER) and not c:IsDisabled())
end
function c26013007.scfilter(c,mg)
	return c:IsSynchroSummonable(tc)
end
function c26013007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26013007.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26013007.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c26013007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c26013007.scfilter,tp,LOCATION_EXTRA,0,nil,tc)
		local p1=#g>0 and tc:IsType(TYPE_TUNER)
		local p2=tc:IsType(TYPE_TUNER)
		local p3= not tc:IsType(TYPE_TUNER) and not tc:IsDisabled()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26013007,1))
		local op=Duel.SelectEffect(tp,
		{p1,aux.Stringid(26013007,2)},
		{p2,aux.Stringid(26013007,3)},
		{p3,aux.Stringid(26013007,4)})
		if op==1 then
			if tc:GetControler()~=tp then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
				e1:SetValue(1)
				e1:SetReset(RESET_CHAIN)
				tc:RegisterEffect(e1)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),tc)
		end
		if op==2 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetValue(TYPE_TUNER)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		if op==3 then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetValue(RESET_TURN_SET)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
	end
end