--Remnity of Arms
function c26015004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26015004)
	e1:SetCost(c26015004.thcost)
	e1:SetTarget(c26015004.thtg)
	e1:SetOperation(c26015004.thop)
	c:RegisterEffect(e1)
	--ATK down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(26015004,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c26015004.atcon)
	e2:SetCost(c26015004.atcost)
	e2:SetOperation(c26015004.atop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c26015004.eftg)
	e3:SetCondition(c26015004.efcon)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--tribute Register 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c26015004.regcon)
	e4:SetOperation(c26015004.regop)
	c:RegisterEffect(e4)
end
function c26015004.thfilter(c,e,tp)
	if c:IsReleasable() then
		local lab=Group.FromCards(c,e:GetHandler()):GetSum(Card.GetLevel)
		return Duel.IsExistingMatchingCard(c26015004.cfilter,tp,LOCATION_DECK,0,1,c,lab) 
	end
end
function c26015004.cfilter(c,lab)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_DARK) and 
	c:GetLevel()==lab and c:IsAbleToHand()
end
function c26015004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.IsExistingMatchingCard(c26015004.thfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	local tg=Duel.SelectMatchingCard(tp,c26015004.thfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	tg:AddCard(c)
	e:SetLabel(tg:GetSum(Card.GetLevel))
	Duel.SendtoGrave(tg,REASON_COST+REASON_RELEASE)
end
function c26015004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26015004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26015004.cfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--ATK down
function c26015004.atcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and (
	(a:GetControler()==tp and a:IsAttribute(ATTRIBUTE_DARK) and a:IsRace(RACE_ZOMBIE) and a:IsRelateToBattle())
		or
	(d:GetControler()==tp and d:IsAttribute(ATTRIBUTE_DARK) and d:IsRace(RACE_ZOMBIE) and d:IsRelateToBattle()))
end
function c26015004.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RELEASE)
end
function c26015004.atop(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(-e:GetHandler():GetAttack())
	if a:GetControler()==tp then
		d:RegisterEffect(e1)
	else
		a:RegisterEffect(e1)
	end
end
function c26015004.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE)
end
function c26015004.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(26015004,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26015004.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(26015004)~=0
end
function c26015004.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x615)
end