--Echolon Transceiver
function c26013014.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013014,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26013014,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26013014.activate)
	c:RegisterEffect(e1)
	--Cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE|LOCATION_GRAVE,0)
	e2:SetTarget(c26013014.untg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--return 1 of 2 targets to Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013014,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c26013014.thtg)
	e3:SetOperation(c26013014.thop)
	c:RegisterEffect(e3)
	--property change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26013014,2))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c26013014.retg)
	e4:SetOperation(c26013014.reop)
	c:RegisterEffect(e4)
end
function c26013014.untg(e,c)
	local sg=c26013014.GROUP(Duel.GetCurrentChain())
	return #sg>0 and sg:IsContains(c)
end
function c26013014.thfilter(c)
	return c:IsSetCard(0x613) and c:IsMonster() and c:IsAbleToHand()
end
function c26013014.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26013014.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and c:GetFlagEffect(26013014)<1 and Duel.SelectYesNo(tp,aux.Stringid(26013014,0)) then
		c:RegisterFlagEffect(26013014,RESETS_STANDARD_PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c26013014.rthfilter(c)
	return c:IsSetCard(0x613) and c:IsFaceup()
end
function c26013014.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	local LOC = LOCATION_ONFIELD|LOCATION_GRAVE 
	local g=Duel.GetMatchingGroup(c26013014.rthfilter,tp,LOC,0,c,e)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,c26013014.rescon,0) and c:GetFlagEffect(26013014)<1 end
	c:RegisterFlagEffect(26013014,RESETS_STANDARD_PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=aux.SelectUnselectGroup(g,e,tp,2,2,c26013014.rescon,1,tp,HINTMSG_TARGET,c26013014.rescon)
	Duel.SetTargetCard(tg)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
	if tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tg,1,0,0)
	end
end
function c26013014.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==2
	and sg:IsExists(Card.IsAbleToHand,1,nil)
end
function c26013014.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e):Filter(aux.NecroValleyFilter,nil)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then 
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c26013014.GROUP(ev)
	local sg=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg then
			sg:Merge(tg)
		end
	end
	return sg
end

function c26013014.tgfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER)
end
function c26013014.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc==0 then return false end
	if chk==0 then return Duel.IsExistingTarget(c26013014.tgfilter,tp,LOCATION_MZONE,0,1,nil) and c:GetFlagEffect(26013014)<1 end
	c:RegisterFlagEffect(26013014,RESETS_STANDARD_PHASE_END,0,1)
	Duel.SelectTarget(tp,c26013014.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c26013014.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)>1
end
function c26013014.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
		--Cannot Special Summon non-Synchro monsters from Extra Deck
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetAbsoluteRange(tp,1,0)
		e2:SetTarget(function(_,c) return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO|TYPE_TUNER) end)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		--Lizard check
		local e3=aux.createContinuousLizardCheck(c,LOCATION_MZONE,function(_,c) return not c:IsOriginalType(TYPE_SYNCHRO|TYPE_TUNER) end)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
	end
end