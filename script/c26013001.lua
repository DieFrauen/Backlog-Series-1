--Echolon Buster
function c26013001.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013001,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26013011)
	e1:SetTarget(c26013001.lvtg)
	e1:SetOperation(c26013001.lvop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_GRAVE)
	e1a:SetCondition(function (e,tp)
	e1a:SetCost(Cost.PayLP(600))
	return Duel.IsPlayerAffectedByEffect(tp,26013013) end)
	c:RegisterEffect(e1a)
	--summon from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetLabel(26013013)
	e2:SetCountLimit(1,{26013001,1})
	e2:SetTarget(c26013001.sptg)
	e2:SetOperation(c26013001.spop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	--Echolon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013001,2))
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,{26013001,2})
	e3:SetTarget(c26013001.retg)
	e3:SetOperation(c26013001.reop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetRange(LOCATION_GRAVE)
	e3a:SetCondition(c26013001.gycon)
	e3a:SetCost(Cost.PayLP(600))
	c:RegisterEffect(e3a)
end
c26013001.listed_series={0x613}
function c26013001.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x613) and c:IsLevelAbove(1)
end
function c26013001.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26013001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26013001.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,26013001)<1 end
	Duel.RegisterFlagEffect(tp,26013001,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26013001.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26013001.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetLevel()*2)
		tc:RegisterEffect(e1)
	end
end
function c26013001.spfilter(c,e,tp)
	return (c:IsSetCard(0x613) or c:IsType(TYPE_TUNER)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26013001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c26013001.spfilter(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26013001.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,26013001)<1 end
	Duel.RegisterFlagEffect(tp,26013001,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,c26013001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c26013001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26013001.tgfilter(c,e)
	return c:IsFaceup() and c:IsMonster() and not c:IsType(TYPE_TUNER) and c:IsCanBeEffectTarget(e)
end
function c26013001.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return false end
	local g=c26013001.GROUP(ev):Filter(Card.IsOnField,nil)
	if chk==0 then return #g:Filter(c26013001.tgfilter,nil,e)>0 end
	local tg=g:FilterSelect(tp,c26013001.tgfilter,1,1,nil,e)
	Duel.SetTargetCard(tg)
end
function c26013001.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)>1
end
function c26013001.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetTargetCards(e):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c26013001.GROUP(ev)
	local sg=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg then
			sg:Merge(tg)
		end
	end
	return sg
end
function c26013001.gycon(e,tp,eg,ep,ev,re,r,rp)
	local g=c26013001.GROUP(ev)
	return #g>0 and Duel.IsPlayerAffectedByEffect(tp,26013013)
	and g:IsContains(e:GetHandler())
end