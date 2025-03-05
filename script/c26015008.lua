--Endless Revemnity
function c26015008.initial_effect(c)
	c:EnableReviveLimit()
	--negate effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015008,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26015008)
	e1:SetCondition(c26015008.discon)
	e1:SetCost(c26015008.discost)
	e1:SetTarget(c26015008.distg)
	e1:SetOperation(c26015008.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c26015008.discon2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26015008,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{26015008,1})
	e3:SetCondition(c26015008.thcon)
	e3:SetTarget(c26015008.thtg)
	e3:SetOperation(c26015008.thop)
	c:RegisterEffect(e3)
	--cannot be target/battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9b))
	e4:SetValue(c26015008.tgval)
	c:RegisterEffect(e4)
end
function c26015008.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsDisabled() or not Duel.IsChainDisablable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) --and rp~=tp
end
function c26015008.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26015011) and c26015008.discon(e,tp,eg,ep,ev,re,r,rp)
end
function c26015008.disfilter(c,e)
	return c:IsSetCard(0x615) and c:IsMonster() and c:IsReleasable()
end
function c26015008.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c26015008.disfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c26015008.disfilter,1,true,aux.ReleaseCheckTarget,nil,dg) end
	local sg=Duel.SelectReleaseGroupCost(tp,c26015008.disfilter,1,#dg,true,aux.ReleaseCheckTarget,nil,dg)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.Release(sg,REASON_COST)
end
function c26015008.gyfilter(c,e)
	return c:IsSetCard(0x1615) and c:IsMonster()
end
function c26015008.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26015008)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	c:RegisterFlagEffect(26015008,RESET_CHAIN,0,1)
end
function c26015008.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if Duel.NegateEffect(ev) and g:CheckWithSumGreater(Card.GetLevel,6) and Duel.SelectYesNo(tp,aux.Stringid(26015008,1)) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
	if Duel.IsPlayerAffectedByEffect(tp,26015011) then
		c26015011.revival(e:GetHandler(),e,tp,g)
	end
end
function c26015008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp~=tp
end
function c26015008.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26015011) and c26015008.thcon(e,tp,eg,ep,ev,re,r,rp)
end
function c26015008.thfilter(c)
	return c:IsSetCard(0x1615) and c:IsAbleToHand()
end
function c26015008.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26015008.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26015008.thfilter,tp,LOCATION_GRAVE,0,1,nil) and c:GetFlagEffect(26015008)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26015008.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	c:RegisterFlagEffect(26015008,RESET_CHAIN,0,1)
end
function c26015008.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c26015008.tglimit(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL)
end
function c26015008.tgval(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end