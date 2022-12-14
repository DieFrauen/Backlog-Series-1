--Arc-Chemera Legion
function c26014015.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,aux.TRUE,3,99)
	--Fusion.AddProcMixN(c,true,true,c26014015.ffilter,3)
	--lizard check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(CARD_CLOCK_LIZARD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26014015.splimit)
	c:RegisterEffect(e1)
	--Material check
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetCode(EFFECT_MATERIAL_CHECK)
	e02:SetLabel(0)
	e02:SetValue(c26014015.matcheck)
	c:RegisterEffect(e02)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c26014015.attcon)
	e2:SetOperation(c26014015.attop)
	e2:SetLabelObject(e02)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014015,0))
	e3:SetProperty(CATEGORY_DISABLE,CATEGORY_DESTROY,CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c26014015.target)
	e3:SetOperation(c26014015.operation)
	c:RegisterEffect(e3)
	local e3q=e3:Clone()
	e3q:SetLabel(1)
	e3q:SetDescription(aux.Stringid(26014015,1))
	e3q:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3q:SetCode(EVENT_FREE_CHAIN)
	e3q:SetCondition(c26014015.qond)
	e3q:SetCountLimit(1)
	e3q:SetLabel(1)
	c:RegisterEffect(e3q)
	
end
function c26014015.matcheck(e,c)
	local g=c:GetMaterial()
	local att=0
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0 then
		att=att+ATTRIBUTE_EARTH 
	end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>0 then
		att=att+ATTRIBUTE_WATER 
	end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)>0 then
		att=att+ATTRIBUTE_WIND 
	end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0 then
		att=att+ATTRIBUTE_FIRE 
	end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0 then
		att=att+ATTRIBUTE_LIGHT 
	end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0 then
		--att=att+ATTRIBUTE_DARK 
	end
	if g:FilterCount(Card.IsAttribute,nil,0x40)>0 then
		att=att+0x40
	end
	e:SetLabel(att)
end
function c26014015.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(CARD_POLYMERIZATION)
end
function c26014015.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c26014015.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local att=e:GetLabelObject():GetLabel()
	if att>0 then
		--add attributes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c26014015.tgfilter(c,EARTH,WATER,FIRE,WIND)
	return c:IsFaceup() and (c:IsAttackAbove(1) and FIRE ) or (c:IsDestructable() and EARTH) or (WATER and not c:IsDisabled()) or (WIND)
end
function c26014015.qond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(26014002)==0 and
	Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_WIND),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c26014015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local EARTH =c:GetFlagEffect(26014001)==0 and
	Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_EARTH),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local WATER =c:GetFlagEffect(26014003)==0 and
	Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_WATER),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local FIRE  =c:GetFlagEffect(26014004)==0 and
	Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_FIRE),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local WIND  =c:GetFlagEffect(26014002)==0 and
	Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_FIRE),0,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetLabel()==1
	if chkc then return chkc:IsOnField() end
	if chk==0 then return (EARTH or WATER or FIRE or WIND) and Duel.IsExistingTarget(c26014015.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,EARTH,WATER,FIRE,WIND) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,c26014015.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,EARTH,WATER,FIRE,WIND)
	if WATER then Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,1,0,0) end
	if EARTH then Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0) end
	if FIRE and tg:GetFirst():IsAttackAbove(1) then
		local dam=tg:GetFirst():GetAttack()/2
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	end
	if WIND then 
		c:RegisterFlagEffect(26014002,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26014015,5))
		c:RegisterFlagEffect(26014015,RESET_CHAIN,0,1)
	end
	
end
function c26014015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local USE =c:GetFlagEffect(26014015)~=0
	local EARTH =c:GetFlagEffect(26014001)==0 and
	Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_EARTH),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local WATER =c:GetFlagEffect(26014003)==0 and
	Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_WATER),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local FIRE  =c:GetFlagEffect(26014004)==0 and
	Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_FIRE),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if tc and tc:IsRelateToEffect(e) then
		if WATER and not c:IsDisabled() and ((not EARTH and not FIRE and not USE) or Duel.SelectYesNo(tp,aux.Stringid(26014015,2))) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			c:RegisterFlagEffect(26014003,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26014015,6))
			USE =true
		end
		if EARTH and tc:IsDestructable() and ((not FIRE and not USE) or Duel.SelectYesNo(tp,aux.Stringid(26014015,3))) then
			Duel.Destroy(tc,REASON_EFFECT)
			c:RegisterFlagEffect(26014001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26014015,7))
			USE =true
		end
		if FIRE and tc:IsAttackAbove(1) and (not USE or Duel.SelectYesNo(tp,aux.Stringid(26014015,4))) then
			Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT)
			c:RegisterFlagEffect(26014004,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26014015,8))
			USE =true
		end
	end
end
