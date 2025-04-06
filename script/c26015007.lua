--Everlasting Revemnity
function c26015007.initial_effect(c)
	c:EnableReviveLimit()
	--negate effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015007,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26015007)
	e1:SetCondition(c26015007.discon)
	e1:SetCost(c26015007.discost)
	e1:SetTarget(c26015007.distg)
	e1:SetOperation(c26015007.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c26015007.discon2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26015007,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c26015007.thcost)
	e3:SetTarget(c26015007.thtg)
	e3:SetOperation(c26015007.thop)
	c:RegisterEffect(e3)
end
c26015007.listed_names={26015011} 
function c26015007.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsDisabled() or not Duel.IsChainDisablable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) and rp~=tp
end
function c26015007.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26015011) and c26015007.discon(e,tp,eg,ep,ev,re,r,rp)
end
function c26015007.disfilter(c,e)
	return c:IsMonster()
end
function c26015007.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c26015007.disfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c26015007.disfilter,1,true,aux.ReleaseCheckTarget,nil,dg) end
	local sg=Duel.SelectReleaseGroupCost(tp,c26015007.disfilter,1,99,true,aux.ReleaseCheckTarget,nil,dg)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.Release(sg,REASON_COST)
end
function c26015007.gyfilter(c,e)
	return c:IsSetCard(0x1615) and c:IsMonster()
end
function c26015007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26015007)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	c:RegisterFlagEffect(26015007,RESET_CHAIN,0,1)
end
function c26015007.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if Duel.NegateEffect(ev) and g:CheckWithSumGreater(Card.GetLevel,6) and Duel.SelectYesNo(tp,aux.Stringid(26015007,1)) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
	if Duel.IsPlayerAffectedByEffect(tp,26015011) then
		c26015011.revival(e:GetHandler(),e,tp,g)
	end
end
function c26015007.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return re:IsActiveType(TYPE_MONSTER) and rp~=tp and Duel.IsExistingMatchingCard(c26015007.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,rc:GetLevel())
	end
	e:SetLabelObject(rc)
	rc:CreateEffectRelation(e)
end
function c26015007.thfilter(c,lv)
	return c:IsSetCard(0x1615) and c:IsAbleToHand() and c:IsLevelAbove(1) and (c:IsLocation(LOCATION_GRAVE) or c:GetLevel()==lv)
end
function c26015007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26015007)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
	c:RegisterFlagEffect(26015007,RESET_CHAIN,0,1)
end
function c26015007.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not (tc:IsPublic() and tc:IsRelateToEffect(e)) then tc=nil end
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26015007.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tc and tc:GetLevel()) 
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end