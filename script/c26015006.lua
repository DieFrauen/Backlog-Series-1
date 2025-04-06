--Immortal Revemnity
function c26015006.initial_effect(c)
	c:EnableReviveLimit()
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015006,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetLabel(0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26015006)
	e1:SetCondition(c26015006.discon)
	e1:SetCost(c26015006.discost)
	e1:SetTarget(c26015006.distg)
	e1:SetOperation(c26015006.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c26015006.discon2)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetLabel(1)
	e5:SetCondition(c26015006.discon2)
	c:RegisterEffect(e4)
	local e6=e1:Clone()
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCode(EVENT_FLIP_SUMMON)
	e6:SetCondition(c26015006.discon2)
	c:RegisterEffect(e6)
	--return 1 banished Attribute to Deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26015006,3))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_CUSTOM+26015006)
	--e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,{26015006,1})
	e7:SetCondition(function()return not Duel.IsPhase(PHASE_DAMAGE)end)
	e7:SetTarget(c26015006.sptg)
	e7:SetOperation(c26015006.spop)
	c:RegisterEffect(e7)
	--summon register
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetLabelObject(e7)
	e8:SetOperation(c26015006.regop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e0=e8:Clone()
	e0:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
end
c26015006.listed_names={26015011} 
function c26015006.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain(true)==0
	and (e:GetLabel()==0 or #eg==1)
end
function c26015006.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,26015011)
	and c26015006.discon(e,tp,eg,ep,ev,re,r,rp)
end
function c26015006.refilter(c,e)
	return c:IsMonster()
end
function c26015006.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c26015006.refilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c26015006.refilter,1,true,aux.ReleaseCheckTarget,nil,dg) end
	local sg=Duel.SelectReleaseGroupCost(tp,c26015006.refilter,1,99,true,aux.ReleaseCheckTarget,nil,dg)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	Duel.Release(sg,REASON_COST)
end
function c26015006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,#eg,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function c26015006.gyfilter(c,e)
	return c:IsSetCard(0x1615) and c:IsMonster()
end
function c26015006.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if g:CheckWithSumGreater(Card.GetLevel,5) and Duel.SelectYesNo(tp,aux.Stringid(26015006,1)) then
		Duel.Destroy(eg,REASON_EFFECT)
	else 
		Duel.SendtoHand(eg,nil,REASON_EFFECT)
	end
	if Duel.IsPlayerAffectedByEffect(tp,26015011) then
		c26015011.revival(e:GetHandler(),e,tp,g)
	end
end
function c26015006.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,26015006)==0 then
		Duel.RegisterFlagEffect(tp,26015006,RESET_CHAIN,0,1)
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+26015006,e,0,tp,tp,0)
	end
end
function c26015006.tgfilter(c,e,tid)
	return c:IsMonster()
	and c:IsLevelAbove(1)
	and c:IsCanBeEffectTarget(e)
	and c:GetTurnID()==tid
end
function c26015006.rescon(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(c26015006.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,sg)
end
function c26015006.spfilter(c,e,tp,sg)
	return c:IsRitualMonster()
	and sg:GetSum(Card.GetLevel)==c:GetLevel()
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP)
end
function c26015006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c26015006.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tid)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,c26015006.rescon,0)
	end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,2,c26015006.rescon,1,tp,HINTMSG_TARGET)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function c26015006.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26015006.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tg)
	if #g>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	end
end