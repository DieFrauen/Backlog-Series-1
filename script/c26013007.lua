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
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013007,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c26013007.discon)
	e2:SetCost(c26013007.discost)
	e2:SetTarget(c26013007.distg)
	e2:SetOperation(c26013007.disop)
	c:RegisterEffect(e2)
	
end
function c26013007.mat(c)
	return c:GetOriginalType()&TYPE_TUNER ==0
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
function c26013007.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end
function c26013007.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_TUNER) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMOVE_TYPE)
	e1:SetValue(TYPE_TUNER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c26013007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c26013007.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	end
end
