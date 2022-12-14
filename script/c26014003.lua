--Arc-Chemic Obslither
function c26014003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,26014003)
	e1:SetTarget(c26014003.target)
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
	e2:SetTarget(c26014003.mtg)
	e2:SetOperation(Fusion.BanishMaterial)
	e2:SetValue(c26014003.mtval)
	c:RegisterEffect(e2)
end
c26014003.listed_names={CARD_POLYMERIZATION }

function c26014003.filter1(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsAbleToHand()
end
function c26014003.filter2(c)
	return c:IsAbleToGrave() and (c:IsSetCard(0x1614) or c:IsCode(CARD_POLYMERIZATION))
end
function c26014003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c26014003.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c26014003.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return (b1 or b2) end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26014003,1)},
		{b2,aux.Stringid(26014003,2)})
	if op==1 then
		e:SetOperation(c26014003.thop)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==2 then
		e:SetOperation(c26014003.tgop)
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	end
end
function c26014003.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK+LOCATION_GRAVE,0,c,REASON_EFFECT):Filter(Card.IsCode,nil,CARD_POLYMERIZATION)
	sg=aux.SelectUnselectGroup(g,e,tp,1,2,c26014003.rescon1,1,tp,HINTMSG_ATOHAND,c26014003.rescon1)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c26014003.rescon1(sg,e,tp,mg)
	return not sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) or sg:GetCount()<2
end
function c26014003.rescon2(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,CARD_POLYMERIZATION) and sg:IsExists(Card.IsSetCard,1,nil,0x1614)
end
function c26014003.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,c,REASON_EFFECT)
	sg=aux.SelectUnselectGroup(g,e,tp,1,2,c26014003.rescon2,1,tp,HINTMSG_DISCARD,c26014003.rescon2)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c26014003.mtval(e,c)
	if not c then return false end
	return c:IsSetCard(0x2614) and c:IsControler(e:GetHandlerPlayer())
end
function c26014003.mtg(e,c)
	return c==e:GetHandler()
end
