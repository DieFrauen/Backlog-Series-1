--Halcyon Canopy
function c26011013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26011013,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DELAY)
	e0:SetCondition(c26011013.actcon)
	c:RegisterEffect(e0)
	if not c26011013.global_check then
		c26011013.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c26011013.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--Change battle position of 1 monster from each side
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26011013,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c26011013.poscon)
	e2:SetTarget(c26011013.postg)
	e2:SetOperation(c26011013.posop)
	c:RegisterEffect(e2)
	--prevent further attacks this turn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26011013,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_BATTLE_START)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c26011013.batcost)
	e3:SetCondition(c26011013.batcon)
	e3:SetOperation(c26011013.batop)
	c:RegisterEffect(e3)
	--negate effect/change pos
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c26011013.posneg)
	c:RegisterEffect(e4)
end
c26011013[0]=0
function c26011013.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.HasFlagEffect(1-e:GetHandlerPlayer(),26011013)
end
function c26011013.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(Duel.GetTurnPlayer(),26011013,RESET_PHASE|PHASE_END,0,2)
end
function c26011013.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() or Duel.IsBattlePhase()
end
function c26011013.filter1(c,e,tp)
	return c:IsFaceup() and c:IsCanChangePosition()
	and Duel.IsExistingTarget(Card.IsCanChangePosition,tp,0,LOCATION_MZONE,1,nil)
end
function c26011013.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c26011013.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g1=Duel.SelectTarget(tp,c26011013.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g2=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,2,0,0)
end
function c26011013.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c26011013.batfilter(c)
	return c:IsDefensePos() and c:IsCanChangePosition()
end
function c26011013.batcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26011013.batfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>1 and
	c:IsAbleToGraveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	local tg=g:Select(tp,2,2,nil)
	Duel.ChangePosition(tg,POS_FACEUP_ATTACK)
	Duel.SendtoGrave(c,REASON_COST)
end
function c26011013.batcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp) and c26011013.poscon(e,tp,eg,ep,ev,re,r,rp)
end
function c26011013.batop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE|PHASE_END)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
end
function c26011013.negfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c26011013.lfilter(c)
	return c:IsDefensePos() and c:IsLinked()
end
function c26011013.posneg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te,chid,cp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_CHAIN_ID,CHAININFO_TRIGGERING_CONTROLER)
	if not (te:IsActivated() and chid~=c26011013[0] and te:IsSpellTrapEffect()) then return end
	c26011013[0]=chid
	if cp~=tp and Duel.IsExistingMatchingCard(c26011013.lfilter,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(c26011013.lfilter,tp,0,LOCATION_MZONE,1,nil) then
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