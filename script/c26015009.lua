--Unstoppable Revemnity
function c26015009.initial_effect(c)
	c:EnableReviveLimit()
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015009,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	--e1:SetCondition(c26015009.discon)
	--e1:SetCountLimit(1,26015009)
	e1:SetCost(c26015009.discost)
	e1:SetTarget(c26015009.distg)
	e1:SetOperation(c26015009.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c26015009.discon2)
	c:RegisterEffect(e2)
	--Chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26015009,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c26015009.thcon)
	e3:SetTarget(c26015009.thtg)
	e3:SetOperation(c26015009.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c26015009.dircon)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
c26015009.listed_names={26015011} 
function c26015009.resfilter(c,e)
	return c:IsMonster()
end
function c26015009.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(c26015009.resfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c26015009.resfilter,1,true,aux.ReleaseCheckTarget,nil,tg) end
	local sg=Duel.SelectReleaseGroupCost(tp,c26015009.resfilter,1,99,true,aux.ReleaseCheckTarget,nil,tg)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.Release(sg,REASON_COST)
end
function c26015009.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c26015009.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26015011) --and Duel.GetAttacker():IsControler(1-tp)
end
function c26015009.gyfilter(c,e)
	return c:IsSetCard(0x1615) and c:IsMonster()
end
function c26015009.rescon(sg,e,tp,mg)
	return sg:IsContains(e:GetLabelObject())
	and aux.dncheck
end
function c26015009.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c26015009.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:CheckWithSumGreater(Card.GetLevel,8) and #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(26015009,1)) then
		Duel.Destroy(dg,REASON_EFFECT)
	end
	if Duel.IsPlayerAffectedByEffect(tp,26015011) then
		c26015011.revival(c,e,tp,g)
	end
end
function c26015009.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsMonster()
end
function c26015009.dircon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c26015009.thfilter(c)
	return c:IsSetCard(0x1615) and c:IsAbleToHand()
end
function c26015009.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26015009.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26015009.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26015009.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26015009.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local c=e:GetHandler()
		if c:IsRelateToBattle() then
			Duel.ChainAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
			c:RegisterEffect(e1)
		end
	end
end