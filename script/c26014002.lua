--Arc-Chemic Argela
function c26014002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014002,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,26014002)
	e1:SetTarget(c26014002.target)
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
	e2:SetTarget(c26014002.mtg)
	e2:SetOperation(Fusion.BanishMaterial)
	e2:SetValue(c26014002.mtval)
	c:RegisterEffect(e2)
end
c26014002.listed_names={CARD_POLYMERIZATION }

function c26014002.filter(c)
	return (c:IsCode(CARD_POLYMERIZATION) or (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x614))) and c:IsAbleToHand() 
end
function c26014002.filter2(c,e,tp)
	return (c:IsCode(CARD_POLYMERIZATION) or (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x614))) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c26014002.rescon(sg,e,tp,mg)
	return #sg:Filter(Card.IsSetCard,nil,0x1614)<2 and #sg:Filter(Card.IsCode,nil,CARD_POLYMERIZATION)<2
end
function c26014002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26014002.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local b1=Duel.IsExistingMatchingCard(c26014002.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=aux.SelectUnselectGroup(g,e,tp,1,2,c26014002.rescon,0)
	if chk==0 then return (b1 or b2) end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26014002,1)},
		{b2,aux.Stringid(26014002,2)})
	if op==1 then
		e:SetOperation(c26014002.operation1)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetOperation(c26014002.operation2)
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local tg=aux.SelectUnselectGroup(g,e,tp,1,2,c26014002.rescon,1,tp,HINTMSG_SPSUMMON)
		Duel.SetTargetCard(tg)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c26014002.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26014002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26014002.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c26014002.mtval(e,c)
	if not c then return false end
	return c:IsSetCard(0x2614) and c:IsControler(e:GetHandlerPlayer())
end
function c26014002.mtg(e,c)
	return c==e:GetHandler()
end
