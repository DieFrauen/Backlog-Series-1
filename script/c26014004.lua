--Arc-Chemic Astramander
function c26014004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014004,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,26014004)
	e1:SetTarget(c26014004.target)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	--Extra Material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetTarget(c26014004.mtg)
	e2:SetOperation(Fusion.BanishMaterial)
	e2:SetValue(c26014004.mtval)
	c:RegisterEffect(e2)
end
c26014004.listed_names={CARD_POLYMERIZATION }

function c26014004.filter1(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsAbleToHand()
end
function c26014004.filter2(c)
	return c:IsSetCard(0x1614) and c:IsSummonable(true,nil)
end
function c26014004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c26014004.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26014004.filter2,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return (b1 or b2) end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26014004,1)},
		{b2,aux.Stringid(26014004,2)})
	if op==1 then
		e:SetOperation(c26014004.thop)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==2 then
		e:SetOperation(c26014004.sumop)
		e:SetCategory(CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	end
end
function c26014004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26014001.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26014004.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26014004.filter2,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	if not Duel.IsPlayerCanAdditionalSummon(tp) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(26014004,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1614))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c26014004.mtval(e,c)
	if not c then return false end
	return c:IsSetCard(0x2614) and c:IsControler(e:GetHandlerPlayer())
end
function c26014004.mtg(e,c)
	return c==e:GetHandler()
end
