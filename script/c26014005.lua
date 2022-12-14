--Arc-Chemera Griffus
function c26014005.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WIND),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH))
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
	e2:SetValue(c26014005.splimit)
	c:RegisterEffect(e2)
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014005,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(c26014005.thtg)
	e1:SetOperation(c26014005.thop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014005,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26014005.rettg2)
	e3:SetOperation(c26014005.retop)
	c:RegisterEffect(e3)
	--If fusion summoned with an Arc-Chemic
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c26014005.valcheck)
	c:RegisterEffect(e4)
	local e3a=e3:Clone()
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetLabelObject(e4)
	e3a:SetCondition(c26014005.valcond)
	e3a:SetLabel(1)
	c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetDescription(aux.Stringid(26014005,2))
	e3b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetLabelObject(e4)
	e3b:SetCondition(c26014005.valcond)
	e3b:SetTarget(c26014005.rettg)
	e3b:SetLabel(0)
	c:RegisterEffect(e3b)
end
function c26014005.valcheck(e,c)
	if c:GetMaterial():IsExists(Card.IsSetCard,1,nil,0x1614) then
		e:SetLabel(1)
	end
end
function c26014005.valcond(e,c)
	return e:GetLabel()==e:GetLabelObject():GetLabel()
end
function c26014005.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(CARD_POLYMERIZATION)
end
function c26014005.thfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToHand()
end
function c26014005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26014005.thfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c26014005.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c26014005.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c26014005.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c26014005.retfilter(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsAbleToHand()
end
function c26014005.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c26014005.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c26014005.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local og=Duel.GetMatchingGroup(c26014005.retfilter,tp,LOCATION_GRAVE,0,nil)
		local sg=Group.CreateGroup()
		sg:AddCard(c)
		if #og>0 and Duel.SelectYesNo(tp,aux.Stringid(26014005,3)) then
			sg:AddCard(og:Select(tp,1,1,nil):GetFirst())
		end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
