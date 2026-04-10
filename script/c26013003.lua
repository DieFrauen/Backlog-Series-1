--Echolon Beat-Mapper
function c26013003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26013003)
	e1:SetTarget(c26013003.sptg)
	e1:SetOperation(c26013003.spop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_GRAVE)
	e1a:SetCost(Cost.PayLP(600))
	e1a:SetCondition(function (e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,26013013) end)
	c:RegisterEffect(e1a)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013004,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(26013013)
	e2:SetCountLimit(1,{26013003,1})
	e2:SetTarget(c26013003.target)
	e2:SetOperation(c26013003.operation)
	c:RegisterEffect(e2)
	--Echolon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013003,2))
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,{26013003,2})
	e3:SetTarget(c26013003.retg)
	e3:SetOperation(c26013003.reop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetRange(LOCATION_GRAVE)
	e1a:SetCost(Cost.PayLP(600))
	e3a:SetCondition(c26013003.gycon)
	c:RegisterEffect(e3a)
end
c26013003.listed_series={0x613}
function c26013003.lvfilter(c)
	local lv=c:GetLevel()
	local rlv=c:GetOriginalLevel()
	return c:IsFaceup() and c:IsLevelAbove(rlv*2)
end
function c26013003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c26013003:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26013003.lvfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c26013003.lvfilter,tp,LOCATION_MZONE,0,1,nil,ct) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,26013003)<2 end
	Duel.RegisterFlagEffect(tp,26013003,RESET_PHASE+PHASE_END,0,1)
	local tc=Duel.SelectTarget(tp,c26013003.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
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
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
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
		ft=math.min(ft,math.floor(lv/ov)-1)
		if ft>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,ft,nil)
			if #sg>0 then
				lvd=lvd*#sg
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
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
function c26013003.tgfilter(c,e)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsCanBeEffectTarget(e)
end
function c26013003.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return false end
	local g=c26013003.GROUP(ev):Filter(Card.IsOnField,nil)
	if chk==0 then return g:GetBinClassCount(Card.GetRace)>1 end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,#g,c26013003.rescon,1,tp,HINTMSG_TARGET,c26013003.rescon)
	Duel.SetTargetCard(tg)
	local tc=tg:GetFirst()
	local rc=0
	for tc in aux.Next(tg) do
		rc=(rc|tc:GetRace())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local arc=Duel.AnnounceRace(tp,1,rc)
	Duel.SetTargetParam(arc)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c26013003.rescon(sg,e,tp,mg)
	return sg:GetBinClassCount(Card.GetRace)>1
end
function c26013003.reop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg==0 then return end
	local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(rc)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c26013003.GROUP(ev)
	local sg=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg then
			sg:Merge(tg)
		end
	end
	return sg
end
function c26013003.gycon(e,tp,eg,ep,ev,re,r,rp)
	local g=c26013003.GROUP(ev)
	return #g>0 and Duel.IsPlayerAffectedByEffect(tp,26013013)
	and g:IsContains(e:GetHandler())
end