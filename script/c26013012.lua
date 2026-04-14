--Phonon Echolon
function c26013012.initial_effect(c)
	--Link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26013012.matfilter,1,1)
	--tuner shift
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013012,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c26013012.cost)
	e1:SetTarget(c26013012.tunetg)
	e1:SetOperation(c26013012.tuneop)
	c:RegisterEffect(e1)
	--search "Echolon Frequency Field"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013012,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetLabel(1)
	e2:SetCost(c26013012.cost)
	e2:SetTarget(c26013012.exctg)
	e2:SetOperation(c26013012.excop)
	c:RegisterEffect(e2)
end
c26013015.listed_series={0x613}
function c26013012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,99,REASON_COST|REASON_DISCARD)
end
function c26013012.matfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_PSYCHIC,lc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_WIND,lc,sumtype,tp) and not c:IsType(TYPE_TUNER)
end
function c26013012.tunefilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER)
end
function c26013012.tunetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_TUNER) and c:GetLinkedGroup():IsExists(c26013012.tunefilter,1,nil) end
	local g=c:GetLinkedGroup():Filter(c26013012.tunefilter,nil,c)
	local tc=g:GetFirst()
	if #g>1 then tc=g:Select(tp,1,1,nil) end
	Duel.SetTargetCard(tc)
end
function c26013012.tuneop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsType(TYPE_TUNER)
	and tc:IsRelateToEffect(e) and c26013012.tunefilter(tc) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		Duel.HintSelection(tc)
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(26013012,5))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EFFECT_REMOVE_TYPE)
		c:RegisterEffect(e2)
		Duel.HintSelection(tc)
	end
end
function c26013012.plfilter(c,tp)
	return c:IsCode(26013013) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26013012.tfilter(c)
	return (c:IsSetCard(0x613) or c:GetType()&0x1001==0x1001)
	and c:IsFaceup()
end
function c26013012.exctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local LOC = LOCATION_ONFIELD|LOCATION_GRAVE 
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOC) and c26013012.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26013012.tfilter,tp,LOC,0,1,c) and #dg>0 and Duel.GetFlagEffect(tp,26013012)<1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c26013012.tfilter,tp,LOC,0,1,5,c)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26013012.thfilter(c)
	return c:IsSetCard(0x613) and c:IsAbleToHand()
end
function c26013012.excop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<#g then return end
	Duel.ConfirmDecktop(tp,#g)
	local dg=Duel.GetDecktopGroup(tp,#g)
	local mg=dg:Filter(c26013012.thfilter,nil)
	if #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.RegisterFlagEffect(tp,26013012,RESET_PHASE|PHASE_END,0,1)
	else Duel.ShuffleDeck(tp) end
end