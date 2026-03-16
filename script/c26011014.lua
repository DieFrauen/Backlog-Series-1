--Halcyon Command
function c26011014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011014,0))
	e1:SetCategory(CATEGORY_TOHAND|CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,26011014,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c26011014.cost)
	e1:SetCondition(c26011014.condition)
	e1:SetTarget(c26011014.target)
	e1:SetOperation(c26011014.activate)
	c:RegisterEffect(e1)
	--Can be activated from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26011014,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c26011014.handcon)
	e2:SetValue(function(e,c) e:SetLabel(1) end)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	if not c26011014.global_check then
		c26011014.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c26011014.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--return targets to Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26011014,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,{26011014,1})
	e3:SetLabel(1)
	e3:SetCost(Cost.SelfBanish)
	e3:SetCondition(aux.exccon)
	e3:SetTarget(c26011014.postg)
	e3:SetOperation(c26011014.posop)
	c:RegisterEffect(e3)
end
function c26011014.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:GetFlagEffect(26011009)==0 then
		a:RegisterFlagEffect(26011009,RESET_EVENT+RESETS_STANDARD,0,1,aux.Stringid(26011009,1))
	end
end
function c26011014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x611),tp,LOCATION_ONFIELD,0,1,nil)
end
function c26011014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then
		return #g1>0 and (g1:FilterCount(c26011014.filter,nil) or #g2>0)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,1,0,#g1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,g2,1,0,LOCATION_ONFIELD)
end
function c26011014.filter(c)
	return c:IsAttackPos() and c:GetFlagEffect(26011009)==0 and c:IsCanChangePosition()
end
function c26011014.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26011014.filter,tp,0,LOCATION_MZONE,nil)
	if #g1>0 then
		Duel.ChangePosition(g1,POS_FACEUP_DEFENSE)
	end
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(26011014,2)) then
		Duel.BreakEffect()
		pg=g2:Select(tp,1,#g,nil)
		Duel.SendtoHand(pg,nil,REASON_EFFECT)
	end
end
function c26011014.cfilter(c)
	return c:IsDefensePos() and c:IsCanChangePosition()
end
function c26011014.handcon(e)
	return Duel.IsExistingMatchingCard(c26011014.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c26011014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local lb=e:GetLabelObject()
		if lb:GetLabel()==1 then
			lb:SetLabel(0)
		end
		return true
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		local tg=Duel.SelectMatchingCard(tp,c26011014.cfilter,tp,LOCATION_MZONE,0,2,2,nil)
		Duel.ChangePosition(tg,POS_FACEUP_ATTACK)
	end
end
function c26011014.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x611) and c:IsLinkMonster()
end
function c26011014.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c26011014.lkfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26011014.lkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetFirst():GetLink(),0,0)
end
function c26011014.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local ct=tc:GetLink()
	local g=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(sg)
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end