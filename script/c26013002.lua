--Echolon Rechorder
function c26013002.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013002,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(c26013002.spcon)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c26013002.thcon)
	e2:SetTarget(c26013002.thtg)
	e2:SetOperation(c26013002.thop)
	c:RegisterEffect(e2)
	
end
function c26013002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x613),tp,LOCATION_MZONE,0,1,nil)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end

function c26013002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_TUNER)
end
function c26013002.filter(c)
	return c:IsSetCard(0x613) and c:IsAbleToHand()
end
function c26013002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26013002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26013002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26013002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
