--Vengeance Revival
function c26015011.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,
								lvtype=RITPROC_GREATER,filter=aux.FilterBoolFunction(Card.IsSetCard,0x615),location=LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,forcedselection=c26015011.ritcheck})
	e1:SetDescription(aux.Stringid(26015011,0))
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015011,1)) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c26015011.cost2)
	e2:SetTarget(c26015011.target)
	e2:SetOperation(c26015011.activate)
	c:RegisterEffect(e2)
end
function c26015011.ritcheck(e,tp,g,sc)
	local sg=g:FilterCount(Card.IsSetCard,nil,0x615)
	local fg=g:FilterCount(Card.IsOnField,nil)
	local lv=sc:GetLevel()
	return #g==sg and #g==fg and g:CheckWithSumEqual(Card.GetRitualLevel,lv,#g,#g,sc) or sc:IsLocation(LOCATION_HAND)
end
function c26015011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26015011.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26015011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,26015011) end
end
function c26015011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,26015011)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(26015011)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c26015011.revfilter(c,e)
	return c:IsSetCard(0x1615) and c:IsMonster()
end
function c26015011.revival(c,e,tp,g)
	local sg=g:Filter(c26015011.revfilter,nil)
	if c:IsLocation(LOCATION_GRAVE) and sg:CheckWithSumGreater(Card.GetLevel,c:GetLevel()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and Duel.SelectYesNo(tp,aux.Stringid(26015011,2)) then
		local pos=Duel.SelectPosition(tp,c,POS_FACEUP)
		Duel.Hint(HINT_CARD,tp,26015011)
		Duel.BreakEffect()
		if Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,pos) then
			c:SetMaterial(g)
		end
	end
end