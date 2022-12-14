--Remnance Armed Remains
function c26015003.initial_effect(c)
	--Increase ATK/DEF
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015003,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c26015003.atkcon)
	e1:SetCost(c26015003.atkcost)
	e1:SetOperation(c26015003.atkop)
	c:RegisterEffect(e1)
	
end
function c26015003.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if bc and bc:IsControler(tp) then tc=bc end
	e:SetLabelObject(tc)
	return tc:IsFaceup() and tc:IsRace(RACE_ZOMBIE) and Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c26015003.atkfilter(c)
	return c:GetAttack()>0 and c:IsDiscardable() and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c26015003.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26015003.atkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c26015003.atkfilter,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c26015003.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_DRAW)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE_STEP)
		e2:SetCondition(aux.bdocon)
		e2:SetOperation(c26015003.drop)
		tc:RegisterEffect(e2)
	end
end
function c26015003.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,26015003)
	Duel.Draw(tp,1,REASON_EFFECT)
end