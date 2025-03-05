--Immortal Revemnity
function c26015007.initial_effect(c)
	c:EnableReviveLimit()
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015007,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26015007)
	e1:SetCondition(c26015007.discon)
	e1:SetCost(c26015007.discost)
	e1:SetTarget(c26015007.distg)
	e1:SetOperation(c26015007.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c26015007.discon2)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetCondition(c26015007.discon2)
	c:RegisterEffect(e4)
	local e6=e1:Clone()
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCode(EVENT_FLIP_SUMMON)
	e6:SetCondition(c26015007.discon2)
	c:RegisterEffect(e6)
	--return 1 banished Attribute to Deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26015007,1))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_CUSTOM+26015007)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,{26015007,1})
	e7:SetCondition(function()return not Duel.IsPhase(PHASE_DAMAGE)end)
	e7:SetTarget(c26015007.thtg)
	e7:SetOperation(c26015007.thop)
	c:RegisterEffect(e7)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e7:SetLabelObject(g)
	--summon register
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetLabelObject(e7)
	e8:SetOperation(c26015007.regop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e0=e8:Clone()
	e0:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
end
function c26015007.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)==0
end
function c26015007.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26015011) and Duel.GetCurrentChain(true)==0
end
function c26015007.disfilter(c,e)
	return c:IsSetCard(0x615) and c:IsMonster() and c:IsReleasable()
end
function c26015007.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c26015007.disfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c26015007.disfilter,1,true,aux.ReleaseCheckTarget,nil,dg) end
	local sg=Duel.SelectReleaseGroupCost(tp,c26015007.disfilter,1,#dg,true,aux.ReleaseCheckTarget,nil,dg)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.Release(sg,REASON_COST)
end
function c26015007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,#eg,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function c26015007.gyfilter(c,e)
	return c:IsSetCard(0x1615) and c:IsMonster()
end
function c26015007.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if g:CheckWithSumGreater(Card.GetLevel,5) and Duel.SelectYesNo(tp,aux.Stringid(26015007,1)) then
		Duel.Destroy(eg,REASON_EFFECT)
	else 
		Duel.SendtoHand(eg,nil,REASON_EFFECT)
	end
	if Duel.IsPlayerAffectedByEffect(tp,26015011) then
		c26015011.revival(e:GetHandler(),e,tp,gy)
	end
end
function c26015007.tgfilter(c,e,tp,chk)
	return (c==e:GetHandler() or not c:IsControler(tp)) and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c26015007.thfilter(c,g)
	return c:IsSetCard(0x615) and c:IsMonster() and c:IsAbleToHand() and g:CheckWithSumGreater(Card.GetLevel,c:GetLevel()+1)
end
function c26015007.regop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c26015007.tgfilter,nil,e,tp,false)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(26015007,RESET_CHAIN,0,1)
		end
		local g=e:GetLabelObject():GetLabelObject()
		if Duel.GetCurrentChain()==0 then g:Clear() end
		g:Merge(tg)
		g:Remove(function(c) return c:GetFlagEffect(26015007)==0 end,nil)
		e:GetLabelObject():SetLabelObject(g)
		if Duel.GetFlagEffect(tp,26015007)==0 then
			Duel.RegisterFlagEffect(tp,26015007,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+26015007,e,0,tp,tp,0)
		end
	end
end
function c26015007.rescon(sg,e,tp,mg)
	local g=Duel.GetMatchingGroup(c26015007.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,sg)
	return g:IsExists(Card.GetLevel,1,nil,sg:GetSum(Card.GetLevel))
end
function c26015007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject():Filter(c26015007.tgfilter,nil,e,tp,false)
	if chkc then return false end
	if chk==0 then 
		Duel.ResetFlagEffect(tp,26015007)
		for tc in aux.Next(g) do tc:ResetFlagEffect(26015007) end
		return #g>0 and Duel.IsExistingMatchingCard(c26015007.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,g) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=aux.SelectUnselectGroup(g,e,tp,1,#g,c26015007.rescon,1,tp,HINTMSG_TARGET,c26015007.rescon)
	Duel.SetTargetCard(tc)
end
function c26015007.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26015007.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,sg)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end