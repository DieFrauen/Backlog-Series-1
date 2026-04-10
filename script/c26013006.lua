--Echolon Vice Receiver
function c26013006.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26013006)
	e1:SetCondition(c26013006.spcon)
	e1:SetTarget(c26013006.sptg)
	e1:SetOperation(c26013006.spop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_GRAVE)
	e1a:SetCost(Cost.PayLP(600))
	e1a:SetCondition(c26013006.spcon2)
	c:RegisterEffect(e1a)
	--summon from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013006,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetLabel(26013013)
	e2:SetCountLimit(1,{26013006,1})
	e2:SetTarget(c26013006.thtg)
	e2:SetOperation(c26013006.thop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	--Echolon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013006,2))
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,{26013006,2})
	e3:SetTarget(c26013006.retg)
	e3:SetOperation(c26013006.reop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetRange(LOCATION_GRAVE)
	e3a:SetCost(Cost.PayLP(600))
	e3a:SetCondition(c26013006.gycon)
	c:RegisterEffect(e3a)
end
c26013006.listed_series={0x613}
function c26013006.spfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x613)
end
function c26013006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26013006.spfilter,2,nil)
end
function c26013006.tgfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c26013006.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return c26013006.spcon(e,tp,eg,ep,ev,re,r,rp)
	and Duel.IsPlayerAffectedByEffect(tp,26013013)
end
function c26013006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26013006.tgfilter,tp,LOCATION_ONFIELD,0,nil,e)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and aux.SelectUnselectGroup(g,e,tp,1,1,c26013006.rescon1,0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,26013006)<1 end
	Duel.RegisterFlagEffect(tp,26013006,RESET_CHAIN,0,1)
	local tg=aux.SelectUnselectGroup(g,e,tp,1,#g,c26013006.rescon1,1,tp,LOCATION_ONFIELD,c26013006.rescon1)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26013006.resfilter(c)
	return (c:IsSetCard(0x613) or c:IsType(TYPE_TUNER) and c:IsMonster())
end
function c26013006.rescon1(sg,e,tp,mg)
	return sg:IsExists(c26013006.resfilter,1,nil)
end
function c26013006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26013006.thfilter(c)
	return c:IsSetCard(0x613) and c:IsAbleToHand()
end
function c26013006.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c26013006.thfilter(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(c26013006.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,26013006)<1 end
	Duel.RegisterFlagEffect(tp,26013006,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectTarget(tp,c26013006.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c26013006.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c26013006.refilter(c)
	return c:IsDefenseAbove(0) and c:IsFaceup() and c:IsOnField()
end
function c26013006.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return false end
	local g=c26013006.GROUP(ev):Filter(c26013006.refilter,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,c26013006.rescon2,0) and Duel.GetFlagEffect(tp,26013006)<1 end
	Duel.RegisterFlagEffect(tp,26013006,RESET_CHAIN,0,1)
	local tg=aux.SelectUnselectGroup(g,e,tp,2,2,c26013006.rescon2,1,tp,HINTMSG_TARGET,c26013006.rescon2)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,g,#g,tp,0)
end
function c26013006.rescon2(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetBaseDefense)==2
end
function c26013006.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g~=2 then return end
	local tc=g:GetFirst()
	local tk=g:GetNext()
	local at1,at2=tc:GetBaseDefense(),tk:GetBaseDefense()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(at2)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(at1)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	tk:RegisterEffect(e1)
end
function c26013006.GROUP(ev)
	local sg=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg then
			sg:Merge(tg)
		end
	end
	return sg
end
function c26013006.gycon(e,tp,eg,ep,ev,re,r,rp)
	local g=c26013006.GROUP(ev)
	return #g>0 and Duel.IsPlayerAffectedByEffect(tp,26013013)
	and g:IsContains(e:GetHandler())
end