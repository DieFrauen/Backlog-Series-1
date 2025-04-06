--Vengeance Revival
function c26015011.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,
								lvtype=RITPROC_EQUAL,location=LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,forcedselection=c26015011.ritcheck})
	e1:SetDescription(aux.Stringid(26015011,0))
	e1:SetCondition(aux.FALSE)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015011,1)) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetLabelObject(e1)
	e2:SetTarget(c26015011.target)
	e2:SetOperation(c26015011.activate)
	c:RegisterEffect(e2)
end
function c26015011.ritcheck(e,tp,g,sc)
	local sg=g:Filter(Card.IsSetCard,nil,0x1615)
	return (sc:IsLocation(LOCATION_HAND) or #g==#sg)
	and (sc:IsSetCard(0x2615) or not sc:IsLocation(LOCATION_DECK))
end
function c26015011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetLabelObject():GetTarget()
	local b2=(not Duel.IsPlayerAffectedByEffect(tp,26015011))
	if chk==0 then return b1(e,tp,eg,ep,ev,re,r,rp,0) or b2 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c26015011.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=e:GetLabelObject()
	local tg=b1:GetTarget()
	local op1=b1:GetOperation()
	local b2= not Duel.IsPlayerAffectedByEffect(tp,26015011)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26063005,1))
	local op=Duel.SelectEffect(tp,
		{tg(e,tp,eg,ep,ev,re,r,rp,0),aux.Stringid(26015011,0)},
		{b2,aux.Stringid(26015011,1)})
	if op==1 then
		op1(e,tp,eg,ep,ev,re,r,rp)
	end
	if op==2 then
		Duel.Hint(HINT_CARD,tp,26015011)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(26015011)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
		local g=Duel.GetMatchingGroup(c26015011.linger,tp,LOCATION_ONFIELD,0,nil)
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(26015011,RESET_EVENT|RESETS_STANDARD_DISABLE,0,1)
			Duel.HintSelection(Group.FromCards(tc))
		end
	end
end
function c26015011.linger(c,e)
	return c:GetOriginalCodeRule()==26015014 and c:IsFaceup()
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