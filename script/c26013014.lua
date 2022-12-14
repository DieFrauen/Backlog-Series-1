--Echolon Teleforce Buster
function c26013014.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,aux.FilterBoolFunctionEx(Card.IsType,TYPE_TUNER),1,99)
	c:EnableReviveLimit()
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26013014.tncon)
	e1:SetOperation(c26013014.tnop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c26013014.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013014,2))
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(c26013014.disop)
	c:RegisterEffect(e3)
	aux.DoubleSnareValidity(c,LOCATION_MZONE)
	
end
function c26013014.mat(c)
	return c:GetOriginalType()&TYPE_TUNER ==0
end
function c26013014.valcheck(e,c)
	local g=c:GetMaterial()
	local g1=g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)
	local g2=g:FilterCount(c26013009.mat,nil)
	local val=0
	if g1==#g then
		val=val+10
	end
	if g2==#g then
		val=val+1
	end
	e:GetLabelObject():SetLabel(val)
end
function c26013014.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()~=0
end
function c26013014.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,tp,26013014)
	--indestructible
	if e:GetLabel()~=10 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26013014,0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	--indestructible
	if e:GetLabel()~=01 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetDescription(aux.Stringid(26013014,1))
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e3)
	end
end
function c26013014.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ex1=(Duel.GetOperationInfo(ev,CATEGORY_NEGATE) or re:IsHasCategory(CATEGORY_NEGATE))
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_DISABLE) or re:IsHasCategory(CATEGORY_DISABLE))
	local ex3=(Duel.GetOperationInfo(ev,CATEGORY_DISABLE_SUMMON) or re:IsHasCategory(CATEGORY_DISABLE_SUMMON))
	if ex1 or ex2 or ex3 then
		Duel.Hint(HINT_CARD,tp,26013014)
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end