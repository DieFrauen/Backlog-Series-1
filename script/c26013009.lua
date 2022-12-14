--Echolon Supersonic Buster
function c26013009.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,99,nil,1,99)
	c:EnableReviveLimit()
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26013009.tncon)
	e1:SetOperation(c26013009.tnop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c26013009.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c26013009.mat(c)
	return c:GetOriginalType()&TYPE_TUNER ==0
end
function c26013009.valcheck(e,c)
	local g=c:GetMaterial()
	local g1=g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)
	local g2=g:FilterCount(c26013009.mat,nil)
	local g3=g:FilterCount(Card.IsType,nil,TYPE_TUNER)
	local val=0
	if g1>0 then
		val=val+(g1*1000)
	end
	if g2==#g then
		val=val+100
	end
	if g3>1 then
		val=val+(g3)
	end
	e:GetLabelObject():SetLabel(val)
end
function c26013009.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()~=0
end
function c26013009.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=e:GetLabel()
	Duel.Hint(HINT_CARD,tp,26013009)
	--negate targeting effects
	if val>=1000 then
		local tgv=0
		while val>=1000 do
			val=val-1000
			tgv=tgv+1
		end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26013009,2))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(c26013009.disop)
		e1:SetLabel(tgv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		aux.DoubleSnareValidity(c,LOCATION_MZONE)
	end
	--indestructible
	if val>=100 then
		val=val-100
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26013009,0))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetDescription(aux.Stringid(26013009,1))
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		c:RegisterEffect(e3)
	end
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26013009,3))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	e4:SetValue(val-1)
	c:RegisterEffect(e4)
end
function c26013009.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or rp==tp then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if #tg<=e:GetLabel() then
		Duel.Hint(HINT_CARD,tp,26013009)
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end