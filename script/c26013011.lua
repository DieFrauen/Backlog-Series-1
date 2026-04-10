--Echolon Supersonic Buster
function c26013011.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,99,nil,1,99)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x613)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26013011.tncon)
	e1:SetOperation(c26013011.tnop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c26013011.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c26013011.mat(c)
	return c:GetOriginalType()&TYPE_TUNER ==0
end
function c26013011.valcheck(e,c)
	local g=c:GetMaterial()
	local g1=g:Filter(c26013011.mat,nil)
	local g2=g:Filter(Card.IsType,nil,TYPE_SYNCHRO)
	local g3=g:Filter(Card.IsType,nil,TYPE_TUNER)
	local oe=e:GetLabelObject()
	local val=0
	if #g1==#g then
		oe:SetLabelObject(g1)
		g1:KeepAlive()
	end
	if #g2>0 then
		oe:SetLabel(#g2)
	end
	if #g3>0 then
		oe:SetValue(#g3)
	end
end
function c26013011.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()~=0
end
function c26013011.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local v1=e:GetLabelObject()
	local v2=e:GetLabel()
	local v3=e:GetValue()
	Duel.Hint(HINT_CARD,tp,26013011)
	--negate targeting effects
	if #v1>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(c26013011.disop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		c:AddCounter(0x613,#v1)
		aux.DoubleSnareValidity(c,LOCATION_MZONE)
	end
	--multi attack
	if v2>1 then
		local mtc=math.max(0,math.min(7,v2)-2)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26013011,mtc))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		e2:SetValue(v2-1)
		c:RegisterEffect(e2)
	end
	if v3>0 then
		--indestructible
		local idc=math.min(8,v3)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(26013011,idc+7))
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e3:SetValue(v3)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e3)
	end
end
function c26013011.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or rp==tp then return end
	local ct=Duel.GetCounter(tp,1,0,0x613)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if #tg>0 and #tg<=ct and c:IsCanRemoveCounter(tp,0x613,1,REASON_COST) and Duel.SelectEffectYesNo(tp,c) then
		Duel.RemoveCounter(tp,1,0,0x613,1,REASON_COST)
		Duel.Hint(HINT_CARD,0,26013011)
		Duel.NegateEffect(ev)
	end
end