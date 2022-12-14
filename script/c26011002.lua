--Halcyion Wing of Prosperity
function c26011002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26011002.spcon)
	e1:SetTarget(c26011002.sptg)
	e1:SetOperation(c26011002.spop)
	c:RegisterEffect(e1)
end

function c26011002.spcon(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsDisabled() then return false end
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_SEARCH))
	if (ex1 and (dv1&LOCATION_DECK)==LOCATION_DECK) or ex2 then return true end
	return false
end
function c26011002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c26011002.spfilter(c,e,tp)
	return c:IsSetCard(0x611) and c:IsAbleToHand() and not c:IsCode(26011002)
end
function c26011002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c26011002.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26011002,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil):GetFirst()
			if #g>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end