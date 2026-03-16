--Halcyon Seraph Force
function c26011008.initial_effect(c)
	-- 2 Fairy Monsters
	Link.AddProcedure(c,c26011008.matfilter,2)
	--Move 1 "Mekk-Knight" to another MMZ
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011008,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c26011008.seqtg)
	e1:SetOperation(c26011008.seqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26011008,1))
	e2:SetTarget(c26011008.swtg)
	e2:SetOperation(c26011008.swop)
	c:RegisterEffect(e2)
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c26011008.postg)
	e3:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c26011008.discon)
	e4:SetOperation(c26011008.disop)
	c:RegisterEffect(e4)
	if not c26011008.global_check then
		c26011008.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHANGE_POS)
		ge1:SetOperation(c26011008.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
c26011008.listed_series={0x611} 
function c26011008.matfilter(c,scard,sumtype,tp)
	return c:IsRace(RACE_FAIRY,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_LIGHT,scard,sumtype,tp)
end
function c26011008.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(26011008,RESETS_STANDARD_PHASE_END,0,1,aux.Stringid(26011008,4))
	end
end
function c26011008.postg(e,c)
	return c:IsFaceup() and e:GetHandler():GetLinkedGroup():IsContains(c)
end

function c26011008.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,pos=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_POSITION)
	return re:GetHandler():HasFlagEffect(26011008) and rp~=tp
end
function c26011008.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(26011008,6)) then
		Duel.Hint(HINT_CARD,tp,26011008)
		Duel.NegateEffect(ev)
	end
end
function c26011008.seqfilter(c,tc)
	local p=c:GetControler()
	local zone=tc:GetLinkedZone(p)&ZONES_MMZ 
	return zone~=0 and Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_TOFIELD,zone)>0
end
function c26011008.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26011008.seqfilter(chkc,c) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c26011008.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26011008,2))
	Duel.SelectTarget(tp,c26011008.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,c)
end
function c26011008.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local p=tc:GetControler()
	if Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0 then
		local nseq=0
		local zone=c:GetLinkedZone(tp)
		if p==tp then
			nseq=math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~(zone)),2)
			Duel.MoveSequence(tc,nseq)
		else
			nseq=math.log(Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,~(zone))>>16,2)
		Duel.MoveSequence(tc,nseq)
		end
	end
end
function c26011008.swfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:GetSequence()<5
end
function c26011008.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsControler,2,nil,1)
	or sg:IsExists(Card.IsControler,2,nil,0)
end
function c26011008.swtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(c26011008.swfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,2,2,c26011008.rescon,0) end
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,c26011008.rescon,1,tp,aux.Stringid(26011008,3))
	Duel.SetTargetCard(g)
end
function c26011008.swop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if g:FilterCount(Card.IsRelateToEffect,nil,e)<2 then return end
	local tc1,tc2=g:GetFirst(),g:GetNext()
	Duel.SwapSequence(tc1,tc2)
end