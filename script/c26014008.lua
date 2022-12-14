--Arc-Chemera Dragus
function c26014008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER))
	--lizard check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(CARD_CLOCK_LIZARD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c26014008.splimit)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014008,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c26014008.cost)
	e1:SetTarget(c26014008.target)
	e1:SetOperation(c26014008.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014008,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26014008.rettg2)
	e3:SetOperation(c26014008.retop)
	c:RegisterEffect(e3)
	--If fusion summoned with an Arc-Chemic
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c26014008.valcheck)
	c:RegisterEffect(e4)
	local e3a=e3:Clone()
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetLabelObject(e4)
	e3a:SetCondition(c26014008.valcond)
	e3a:SetLabel(1)
	c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetDescription(aux.Stringid(26014008,2))
	e3b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetLabelObject(e4)
	e3b:SetCondition(c26014008.valcond)
	e3b:SetTarget(c26014008.rettg)
	e3b:SetLabel(0)
	c:RegisterEffect(e3b)
end
function c26014008.valcheck(e,c)
	if c:GetMaterial():IsExists(Card.IsSetCard,1,nil,0x1614) then
		e:SetLabel(1)
	end
end
function c26014008.valcond(e,c)
	return e:GetLabel()==e:GetLabelObject():GetLabel()
end
function c26014008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsDirectAttacked() end
	--Cannot attack directly this turn
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(3207)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c26014008.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(CARD_POLYMERIZATION)
end
function c26014008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,1-tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,c)
	local dam=g:GetSum(Card.GetAttack)/2
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	
end
function c26014008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsReleasable,1-tp,LOCATION_MZONE,0,1,7,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_RULE+REASON_RELEASE) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,c)
		local dam=g:GetSum(Card.GetAttack)/2
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
function c26014008.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c26014008.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c26014008.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local og=Duel.GetMatchingGroup(c26014008.retfilter,tp,LOCATION_GRAVE,0,nil)
		local sg=Group.CreateGroup()
		sg:AddCard(c)
		if #og>0 and Duel.SelectYesNo(tp,aux.Stringid(26014008,3)) then
			sg:AddCard(og:Select(tp,1,1,nil):GetFirst())
		end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
