--Echolon Vice-Receiver
function c26013005.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26013005)
	e1:SetTarget(c26013005.sptg)
	e1:SetOperation(c26013005.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c26013005.qcon)
	e2:SetCost(c26013005.qcost)
	c:RegisterEffect(e2)
	--exc
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013005,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,{26013005,1})
	e3:SetCondition(c26013005.tgcon)
	e3:SetTarget(c26013005.tgtg)
	e3:SetOperation(c26013005.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetProperty(0)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c26013005.qcon)
	e4:SetCost(c26013005.qcost)
	c:RegisterEffect(e4)
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
function c26013005.spfilter(c)
	return c:IsSetCard(0x613) and c:IsMonster() and c:IsFaceup() and c:IsCanBeEffectTarget()
end
function c26013005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26013005.tgfilter(chkc) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26013005.spfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and #g>0 and g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.GetMatchingGroup(c26013005.spfilter,tp,LOCATION_MZONE,0,nil)
	local tg=aux.SelectUnselectGroup(g,e,tp,1,#g,c26013005.rescon,1,tp,HINTMSG_TARGET,c26013005.rescon)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26013005.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg and sg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
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
function c26013005.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO 
end
function c26013005.tgfilter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsAbleToGrave() and not Duel.IsExistingMatchingCard(c26013005.nmfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c26013005.nmfilter(c,code)
	return c:IsCode(code)
end
function c26013005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26013005.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26013005.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26013005.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end