--Echolon Frequency
function c26013013.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013013,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Frequency
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(26013013)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--re-activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013013,1))
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e3:SetLabelObject(e1)
	e3:SetCondition(c26013013.recon)
	e3:SetTarget(c26013013.retg)
	e3:SetOperation(c26013013.reop)
	c:RegisterEffect(e3)
	--activate cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c26013013.actarget)
	e4:SetCost(aux.TRUE)
	e4:SetOperation(c26013013.costop)
	c:RegisterEffect(e4)
end
function c26013013.spfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x613)
end
function c26013013.recon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26013013.spfilter,3,nil)
end
function c26013013.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabelObject():IsActivatable(tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c26013013.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)and e:GetLabelObject():IsActivatable(tp) then
		Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,tp,c:GetOriginalCodeRule())
		Duel.HintSelection(Group.FromCards(c))
	end
end
function c26013013.actarget(e,te,tp)
	if te:GetLabel()==26013013 then
		e:SetLabelObject(te:GetHandler())
		return true
	end
end
function c26013013.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if Duel.CheckLPCost(tp,600) and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,26013013)
		Duel.PayLPCost(tp,600)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(aux.tgoval)
		tc:RegisterEffect(e1)
	end
end