--Arc-Chemera Manticus
function c26014009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH))
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
	e1:SetValue(c26014009.splimit)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c26014009.regop)
	c:RegisterEffect(e2)
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2a:SetCode(EVENT_CHAIN_SOLVED)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetCondition(c26014009.damcon)
	e2a:SetOperation(c26014009.damop)
	c:RegisterEffect(e2a)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014009,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26014009.rettg2)
	e3:SetOperation(c26014009.retop)
	c:RegisterEffect(e3)
	--If fusion summoned with an Arc-Chemic
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c26014009.valcheck)
	c:RegisterEffect(e4)
	local e3a=e3:Clone()
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetLabelObject(e4)
	e3a:SetCondition(c26014009.valcond)
	e3a:SetLabel(1)
	c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetDescription(aux.Stringid(26014009,2))
	e3b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetLabelObject(e4)
	e3b:SetCondition(c26014009.valcond)
	e3b:SetTarget(c26014009.rettg)
	e3b:SetLabel(0)
	c:RegisterEffect(e3b)
end
function c26014009.valcheck(e,c)
	if c:GetMaterial():IsExists(Card.IsSetCard,1,nil,0x1614) then
		e:SetLabel(1)
	end
end
function c26014009.valcond(e,c)
	return e:GetLabel()==e:GetLabelObject():GetLabel()
end
function c26014009.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(CARD_POLYMERIZATION)
end
function c26014009.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(26014009,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c26014009.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(26014009)~=0
end
function c26014009.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c26014009.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)*100
	Duel.Hint(HINT_CARD,0,26014009)
	Duel.Damage(1-tp,dam,REASON_EFFECT)
end
function c26014009.retfilter(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsAbleToHand()
end
function c26014009.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c26014009.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c26014009.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local og=Duel.GetMatchingGroup(c26014009.retfilter,tp,LOCATION_GRAVE,0,nil)
		local sg=Group.CreateGroup()
		sg:AddCard(c)
		if #og>0 and Duel.SelectYesNo(tp,aux.Stringid(26014009,3)) then
			sg:AddCard(og:Select(tp,1,1,nil):GetFirst())
		end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
