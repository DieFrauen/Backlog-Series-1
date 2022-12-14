--Echolon Reverb Buster
function c26013008.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26013008.tncon)
	e1:SetOperation(c26013008.tnop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c26013008.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	
end

function c26013008.mat(c)
	return c:GetOriginalType()&TYPE_TUNER ==0
end
function c26013008.valcheck(e,c)
	local g=c:GetMaterial()
	local val=0
	if g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then
		val=val+1
	end
	if g:FilterCount(c26013008.mat,nil)==#g then
		val=val+10
	end
	e:GetLabelObject():SetLabel(val)
end
function c26013008.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()~=0
end
function c26013008.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,tp,26013008)
	--indestructible
	if e:GetLabel()~=10 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26013008,0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	--Negate destruction based effects
	if e:GetLabel()~=01 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26013008,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetOperation(c26013008.disop)
		c:RegisterEffect(e2)
		aux.DoubleSnareValidity(c,LOCATION_MZONE)
	end
end
function c26013008.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.GetOperationInfo(ev,CATEGORY_DESTROY) or re:IsHasCategory(CATEGORY_DESTROY)  then
		Duel.Hint(HINT_CARD,tp,26013008)
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end