--Arc-Chemic Dualism
function c26014013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014013,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26014013,EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(1)
	e1:SetTarget(c26014013.target)
	e1:SetOperation(c26014013.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetLabel(2)
	e2:SetDescription(aux.Stringid(26014013,1))
	e2:SetOperation(c26014013.activate2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetLabel(3)
	e3:SetDescription(aux.Stringid(26014013,2))
	e3:SetOperation(c26014013.activate3)
	c:RegisterEffect(e3)
end
c26014013.listed_series={0x1614}
function c26014013.filter1(c,tc)
	return c:IsMonster() and c:IsAbleToHand()
	and not c:IsCode(tc:GetCode())
	and (c:IsSetCard(0x1614) or tc:IsSetCard(0x1614)
	and c:IsAttribute(tc:GetAttribute()) and c:IsLevelBelow(4))
end
function c26014013.filter2(c,tc)
	return c:IsAbleToGrave() and c:IsMonster() and c:IsSetCard(0x1614) and not c:IsCode(tc:GetCode())
end
function c26014013.filter2a(c,tc)
	return c:IsAbleToGrave() and c:IsLevelBelow(4) and c:IsMonster() and c:IsAttribute(att)
end
function c26014013.filter3(c,tp,tc)
	return c:IsSetCard(0x1614) and c:IsMonster()
	and c:IsAbleToRemove(tp) and not c:IsCode(tc:GetCode()) 
end
function c26014013.cfilter(c,e,tp,ct)
	if not c:IsMonster()
	or (c:IsLocation(LOCATION_HAND) and ct==0)
	or c:IsFaceup() and not c:IsCanBeEffectTarget(e)
	then return false end
	if ct==1 then
		return Duel.IsExistingMatchingCard(c26014013.filter1,tp,LOCATION_DECK,0,1,nil,c)   
	elseif ct==2 then
		return Duel.IsExistingMatchingCard(c26014013.filter2,tp,LOCATION_DECK,0,1,nil,c)
	elseif ct==3 then
		return Duel.IsExistingMatchingCard(c26014013.filter3,tp,LOCATION_DECK,0,1,nil,tp,c)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end
function c26014013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE+LOCATION_GRAVE 
	local lab=e:GetLabel()
	if chkc then return c26014013.cfilter(e,tp,0) and chkc:IsLocation(loc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c26014013.cfilter,tp,loc+LOCATION_HAND,loc,1,nil,e,tp,lab) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,c26014013.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,e,tp,lab):GetFirst()
	Duel.SetTargetCard(tc)
	if tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if lab==1 then
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif lab==2 then
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
	elseif lab==3 then
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	end
end
function c26014013.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local att=tc:GetAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sc=Duel.SelectMatchingCard(tp,c26014013.filter1,tp,LOCATION_DECK,0,1,1,nil,tc)
	if sc then
		if tc:IsLocation(LOCATION_HAND) then sc:AddCard(tc) end
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	end
end
function c26014013.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc2=Duel.SelectMatchingCard(tp,c26014013.filter2,tp,LOCATION_DECK,0,1,1,nil,tc)
	if Duel.SendtoGrave(tc2,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c26014013.filter2a,tp,LOCATION_DECK,0,nil,tc)
		if #g>0 and tc:IsSetCard(0x1614) and Duel.SelectYesNo(tp,aux.Stringid(26014013,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc2=g:Select(tp,1,1,nil)
			if tc2 then
				Duel.BreakEffect()
				Duel.SendtoGrave(tc2,REASON_EFFECT)
			end
		end
	end
end
function c26014013.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sc=Duel.SelectMatchingCard(tp,c26014013.filter3,tp,LOCATION_DECK,0,1,1,nil,tp,tc):GetFirst()
	if Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)~=0 then
		if sc:IsAttribute(tc:GetAttribute())
		and sc:IsAbleToRemove(tp)
		and (not c:IsLocation(LOCATION_GRAVE) or aux.SpElimFilter(sc))
		and Duel.SelectYesNo(tp,aux.Stringid(26014013,4)) then
			Duel.BreakEffect()  
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end