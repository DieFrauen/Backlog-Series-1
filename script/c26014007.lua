--Arc-Chemera Basilus
function c26014007.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WIND),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER))
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
	e1:SetValue(c26014007.splimit)
	c:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c26014007.chkcond)
	e2:SetCost(c26014007.chkcost)
	e2:SetOperation(c26014007.atop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EFFECT_ACTIVATE_COST)
	e2a:SetOperation(c26014007.acop)
	c:RegisterEffect(e2a)
	--accumulate
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_FIELD)
	e2b:SetCode(26014007)
	e2b:SetRange(LOCATION_MZONE)
	e2b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2b:SetTargetRange(0,1)
	c:RegisterEffect(e2b)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014007,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26014007.rettg2)
	e3:SetOperation(c26014007.retop)
	c:RegisterEffect(e3)
	--If fusion summoned with an Arc-Chemic
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c26014007.valcheck)
	c:RegisterEffect(e4)
	local e3a=e3:Clone()
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetLabelObject(e4)
	e3a:SetCondition(c26014007.valcond)
	e3a:SetLabel(1)
	c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetDescription(aux.Stringid(26014007,2))
	e3b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetLabelObject(e4)
	e3b:SetCondition(c26014007.valcond)
	e3b:SetTarget(c26014007.rettg)
	e3b:SetLabel(0)
	c:RegisterEffect(e3b)
end
function c26014007.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(CARD_POLYMERIZATION)
end
function c26014007.valcheck(e,c)
	if c:GetMaterial():IsExists(Card.IsSetCard,1,nil,0x1614) then
		e:SetLabel(1)
	end
end
function c26014007.valcond(e,c)
	return e:GetLabel()==e:GetLabelObject():GetLabel()
end


function c26014007.chkcond(e,tp,eg,ep,ev,re,r,rp)
	local tp=1-e:GetHandlerPlayer()
	local ct=#{Duel.GetPlayerEffect(tp,26014007)}
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=ct
end
function c26014007.chkcost(e,te_or_c,tp)
	local ct=#{Duel.GetPlayerEffect(tp,26014007)}
	return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,e:GetHandler())
end
function c26014007.atop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) and Duel.IsAttackCostPaid()~=2 then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
		Duel.AttackCostPaid()
	end
end
function c26014007.acop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():IsLocation(LOCATION_MZONE) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
	end
end
function c26014007.retfilter(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsAbleToHand()
end
function c26014007.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c26014007.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c26014007.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local og=Duel.GetMatchingGroup(c26014007.retfilter,tp,LOCATION_GRAVE,0,nil)
		local sg=Group.CreateGroup()
		sg:AddCard(c)
		if #og>0 and Duel.SelectYesNo(tp,aux.Stringid(26014007,3)) then
			sg:AddCard(og:Select(tp,1,1,nil):GetFirst())
		end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
