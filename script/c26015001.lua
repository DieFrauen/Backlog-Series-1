--Remnance Mind Remains
function c26015001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26015001.spcon)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,26015001)
	e2:SetCost(c26015001.thcost)
	e2:SetTarget(c26015001.thtg)
	e2:SetOperation(c26015001.thop)
	c:RegisterEffect(e2)
	
end
function c26015001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c26015001.thfilter(c,lv)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand() and c:GetLevel()==lv-4
end
function c26015001.ctfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c26015001.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c26015001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26015001.ctfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c26015001.ctfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabel(sg:GetFirst():GetLevel())
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function c26015001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26015001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26015001.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end