--Hollow Remains
function c26015013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26015013.cost)
	e1:SetCountLimit(1,26015013)
	e1:SetTarget(c26015013.target)
	e1:SetOperation(c26015013.operation)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c26015013.desop)
	c:RegisterEffect(e2)
	--maintain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	--e3:SetCondition(c26015013.mtcon)
	e3:SetOperation(c26015013.mtop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26015013,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(aux.exccon)
	e4:SetTarget(c26015013.thtg)
	e4:SetOperation(c26015013.thop)
	c:RegisterEffect(e4)
end
function c26015013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

function c26015013.filter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRace(RACE_ZOMBIE) and 
	(c:IsCanBeSpecialSummoned(e,0,tp,false,false) or
	(c:IsSetCard(0x2615)  and c:IsRitualMonster() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)))
end
function c26015013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c26015013.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c26015013.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local f1=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26015013.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and ((tc:IsSetCard(0x2615) and tc:IsRitualMonster() and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0) or (Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0)) then
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c26015013.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
	end
end
function c26015013.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c26015013.revfilter(c)
	return c:IsSetCard(0x1615) and c:IsMonster()
end
function c26015013.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c26015011.revfilter,tp,LOCATION_GRAVE,0,nil)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) and not tg:CheckWithSumGreater(Card.GetLevel,tc:GetLevel()) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c26015013.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c26015013.disfilter(c,e)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsMonster() and c:IsReleasable()
end
function c26015013.mtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local tg=Duel.GetMatchingGroup(c26015011.revfilter,tp,LOCATION_GRAVE,0,nil)
	if tc and tg:CheckWithSumGreater(Card.GetLevel,tc:GetLevel()) then return end 
	local dg=Duel.GetMatchingGroup(c26015013.disfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil,e)
	if Duel.CheckReleaseGroupCost(tp,c26015013.disfilter,1,true,aux.ReleaseCheckTarget,nil,dg) and Duel.SelectYesNo(tp,aux.Stringid(26015013,2)) then
		local g=Duel.SelectReleaseGroupCost(tp,c26015013.disfilter,1,1,true,aux.ReleaseCheckTarget,nil,dg)
		Duel.Release(g,REASON_RULE)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c26015013.thfilter(c,th,td)
	return c:IsCode(26015011) and (
	(c:IsAbleToHand() and td) or
	(c:IsAbleToDeck() and th))
end
function c26015013.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local th,td=c:IsAbleToHand(),c:IsAbleToDeck()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26015013.thfilter(chkc,th,td) end
	if chk==0 then return Duel.IsExistingTarget(c26015013.thfilter,tp,LOCATION_GRAVE,0,1,nil,th,td) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26015013.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,th,td)
	g:AddCard(c)
	Duel.SetTargetCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c26015013.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg==2 then
		local tc=sg:Select(tp,1,1,nil)
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,tc)
			sg:Sub(tc)
			Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
		end
	end
end