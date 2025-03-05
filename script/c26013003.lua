--Echolon Beat-Mapper
function c26013003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(2)
	e1:SetCountLimit(1,26013003)
	e1:SetTarget(c26013003.sptg)
	e1:SetOperation(c26013003.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c26013003.qcon)
	e2:SetCost(c26013003.qcost)
	c:RegisterEffect(e2)
	--special summon 2
	local e3=e1:Clone()
	e3:SetRange(LOCATION_GRAVE)
	e3:SetLabel(3)
	e3:SetCountLimit(1,{26013003,1})
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetLabel(3)
	e4:SetCountLimit(1,{26013003,1})
	e4:SetCondition(c26013003.qcon)
	e4:SetCost(c26013003.qcost)
	c:RegisterEffect(e4)
	--lv change
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26013004,1))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,{26013003,2})
	e5:SetTarget(c26013003.target)
	e5:SetOperation(c26013003.operation)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(c26013003.qcon)
	e6:SetCost(c26013003.qcost)
	c:RegisterEffect(e6)
end
function c26013003.qcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsPlayerAffectedByEffect(tp,26013011)
	and ((re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	and g and g:IsContains(e:GetHandler())
	and re:GetHandler():IsSetCard(0x613)) or rp~=tp)
end
function c26013003.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26013011)==0 end
	Duel.RegisterFlagEffect(tp,26013011,RESET_CHAIN,0,1)
end
function c26013003.lvfilter(c,ct)
	local lv=c:GetLevel()
	local rlv=c:GetOriginalLevel()
	return c:IsFaceup() and c:IsLevelAbove(rlv*ct)
end
function c26013003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetLabel()
	if chkc then return c26013003:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26013003.lvfilter(chkc,ct) end
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c26013003.lvfilter,tp,LOCATION_MZONE,0,1,nil,ct) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,26013003)<2 end
	Duel.RegisterFlagEffect(tp,26013003,RESET_PHASE+PHASE_END,0,1)
	local tc=Duel.SelectTarget(tp,c26013003.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26013003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26013003.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x613)
	and c:IsLevelAbove(c:GetOriginalLevel()*2)
	and Duel.IsExistingMatchingCard(c26013003.selfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c26013003.selfilter(c,e,tp,tc)
	local code=tc:GetCode()
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26013003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26013003.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26013003.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,26013003)<2 end
	Duel.RegisterFlagEffect(tp,26013003,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26013003,2))
	Duel.SelectTarget(tp,c26013003.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26013003.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	local ov=tc:GetOriginalLevel()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26013003.selfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,tc)
	if lv>=ov*2 then
		local lvd=ov*-1
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		ft=math.min(ft,math.floor(lv/ov))
		if ft>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,ft,nil)
			if #sg>0 then
				lvd=lvd*#sg
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(lvd)
		tc:RegisterEffect(e1)
	end
end