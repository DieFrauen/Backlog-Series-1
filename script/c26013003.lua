--Echolon Beatphone
function c26013003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013003,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(2)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(c26013003.spcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabel(3)
	e2:SetCountLimit(1,26013003,EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c26013003.spcon2)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013004,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26013003.target)
	e3:SetOperation(c26013003.operation)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c26013003.splimit)
	c:RegisterEffect(e4)
	--clock lizard
	aux.addContinuousLizardCheck(c,LOCATION_MZONE,c26013003.lizfilter)
end
function c26013003.multi(c)
	local lv=c:GetLevel()
	local rlv=c:GetOriginalLevel()
	return c:IsLevelAbove(1) and (lv==rlv*2 or lv==rlv*3)
end
function c26013003.multi2(c)
	local lv=c:GetLevel()
	local rlv=c:GetOriginalLevel()
	return c:IsLevelAbove(1) and lv==rlv*3
end
function c26013003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(c26013003.multi),tp,LOCATION_MZONE,0,1,nil)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c26013003.spcon2(e,c)
	if c==nil then return true end
	local eff={c:GetCardEffect(EFFECT_NECRO_VALLEY)}
	for _,te in ipairs(eff) do
		local op=te:GetOperation()
		if not op or op(e,c) then return false end
	end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(c26013003.multi2),c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c26013003.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x613) and c:IsReleasable()
end
function c26013003.filter2(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26013003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26013003.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26013003,2))
	Duel.SelectTarget(tp,c26013003.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26013003.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	e:SetLabel(tc:GetLevel())
	local code=tc:GetCode()
	if tc and tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.GetMatchingGroup(c26013003.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,code,e,tp)
		local sg=aux.SelectUnselectGroup(g,e,tp,1,ft,c26013003.rescon,1,tp,HINTMSG_SPSUMMON,c26013003.rescon)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c26013003.rescon(sg,e,tp,mg)
	return sg:GetSum(Card.GetLevel)<=e:GetLabel()
end
function c26013003.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO+TYPE_TUNER) and c:IsLocation(LOCATION_EXTRA)
end
function c26013003.lizfilter(e,c)
	return not c:IsOriginalType(TYPE_SYNCHRO+TYPE_TUNER)
end