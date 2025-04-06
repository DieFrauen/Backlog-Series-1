--Endless Revenmity
function c26015008.initial_effect(c)
	c:EnableReviveLimit()
	--negate activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015008,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
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
	--reset "Vengeance Revival"
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26015008,3))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,{26015008,1})
	e3:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end)
	e3:SetTarget(c26015008.tftg)
	e3:SetOperation(c26015008.tfop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c26015008.tfcon)
	c:RegisterEffect(e4)
end
c26015008.listed_names={26015011} 
function c26015008.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c26015008.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26015011) and c26015008.discon(e,tp,eg,ep,ev,re,r,rp)
end
function c26015008.resfilter(c,e)
	return c:IsMonster()
end
function c26015008.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(c26015008.resfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c26015008.resfilter,1,true,aux.ReleaseCheckTarget,nil,tg) end
	local sg=Duel.SelectReleaseGroupCost(tp,c26015008.resfilter,1,99,true,aux.ReleaseCheckTarget,nil,tg)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.Release(sg,REASON_COST)
end
function c26015008.gyfilter(c,e)
	return c:IsSetCard(0x1615) and c:IsMonster()
end
function c26015008.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c26015008.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0 then
		if g:CheckWithSumGreater(Card.GetLevel,7) and (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and Duel.SelectYesNo(tp,aux.Stringid(26015008,1)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc,tp)
		end
	end
	if Duel.IsPlayerAffectedByEffect(tp,26015011) then
		c26015011.revival(e:GetHandler(),e,tp,g)
	end
end
function c26015008.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsActivated()
end
function c26015008.tfcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26015011) and c26015008.tfcon(e,tp,eg,ep,ev,re,r,rp)
end
function c26015008.tffilter(c)
	return (c:IsCode(26015011) or c:ListsCode(26015011)) and c:IsSSetable()
end
function c26015008.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26015008.tffilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26015008.tffilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26015008.tffilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26015008.tfop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc,tp,false)
		Duel.ConfirmCards(1-tp,tc)
	end
end