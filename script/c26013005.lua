--Echolon Vice Emissor
function c26013005.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26013005)
	e1:SetTarget(c26013005.sptg)
	e1:SetOperation(c26013005.spop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_GRAVE)
	e1a:SetCost(Cost.PayLP(600))
	e1a:SetCondition(function (e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,26013013) end)
	c:RegisterEffect(e1a)
	--exc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013005,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetLabel(26013013)
	e2:SetCountLimit(1,{26013005,1})
	e2:SetTarget(c26013005.tgtg)
	e2:SetOperation(c26013005.tgop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	--Echolon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013005,2))
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,{26013005,2})
	e3:SetTarget(c26013005.retg)
	e3:SetOperation(c26013005.reop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetRange(LOCATION_GRAVE)
	e3a:SetCost(Cost.PayLP(600))
	e3a:SetCondition(c26013005.gycon)
	c:RegisterEffect(e3a)
end
function c26013005.qcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsPlayerAffectedByEffect(tp,26013011)
	and ((re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	and g and g:IsContains(e:GetHandler())
	and re:GetHandler():IsSetCard(0x613)) or rp~=tp)
end
function c26013005.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26013011)==0 end
	Duel.RegisterFlagEffect(tp,26013011,RESET_CHAIN,0,1)
end
function c26013005.spfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c26013005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26013005.spfilter,tp,LOCATION_ONFIELD,0,nil,e)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and aux.SelectUnselectGroup(g,e,tp,1,1,c26013005.rescon1,0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,26013005)<1 end
	Duel.RegisterFlagEffect(tp,26013005,RESET_CHAIN,0,1)
	local tg=aux.SelectUnselectGroup(g,e,tp,1,#g,c26013005.rescon1,1,tp,HINTMSG_TARGET,c26013005.rescon1)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26013005.resfilter(c)
	return (c:IsSetCard(0x613) or c:IsType(TYPE_TUNER))
	and c:IsMonster()
end
function c26013005.rescon1(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg
	and sg:IsExists(c26013005.resfilter,1,nil)
end
function c26013005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetValue(#sg)
		c:RegisterEffect(e1)
	end
end
function c26013005.tgfilter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsAbleToGrave() and not Duel.IsExistingMatchingCard(c26013005.nmfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c26013005.nmfilter(c,code)
	return c:IsCode(code)
end
function c26013005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26013005.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,26013005)<1 end
	Duel.RegisterFlagEffect(tp,26013005,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26013005.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26013005.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c26013005.refilter(c)
	return c:IsAttackAbove(0) and c:IsFaceup() and c:IsOnField()
end
function c26013005.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return false end
	local g=c26013005.GROUP(ev):Filter(c26013005.refilter,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,c26013005.rescon2,0) and Duel.GetFlagEffect(tp,26013005)<1 end
	Duel.RegisterFlagEffect(tp,26013005,RESET_CHAIN,0,1)
	local tg=aux.SelectUnselectGroup(g,e,tp,2,2,c26013005.rescon2,1,tp,HINTMSG_TARGET,c26013005.rescon2)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,g,#g,tp,0)
end
function c26013005.rescon2(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetBaseAttack)==2
end
function c26013005.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g~=2 then return end
	local tc=g:GetFirst()
	local tk=g:GetNext()
	local at1,at2=tc:GetBaseAttack(),tk:GetBaseAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(at2)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(at1)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	tk:RegisterEffect(e1)
end
function c26013005.GROUP(ev)
	local sg=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg then
			sg:Merge(tg)
		end
	end
	return sg
end
function c26013005.gycon(e,tp,eg,ep,ev,re,r,rp)
	local g=c26013005.GROUP(ev)
	return #g>0 and Duel.IsPlayerAffectedByEffect(tp,26013013)
	and g:IsContains(e:GetHandler())
end