--Call of Vengeance
function c26015015.initial_effect(c)
	--Ritual
	local e1=Ritual.CreateProc({handler=c,
	lvtype=RITPROC_EQUAL,
	filter=c26015015.cfilter,
	location=LOCATION_HAND+LOCATION_GRAVE,
	extrafil=c26015015.extrafil,
	forcedselection=c26015015.ritcheck,
	customoperation=c26015015.customoperation})
	e1:SetDescription(aux.Stringid(26015015,0))
	c:RegisterEffect(e1)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015015,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c26015015.target2)
	e2:SetOperation(c26015015.activate2)
	c:RegisterEffect(e2)
	--return to hand
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26015015,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e3:SetTarget(c26015015.target3)
	e3:SetOperation(c26015015.activate3)
	c:RegisterEffect(e3)
end
c26015015.listed_names={26015011} 
function c26015015.disable(e,tp,g)
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c26015015.discon)
	e1:SetOperation(c26015015.disop)
	e1:SetLabelObject(g)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c26015015.mgfilter(c,lv)
	return c:GetLevel()==lv
end
function c26015015.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local lv=re:GetHandler():GetLevel()
	return re:IsActiveType(TYPE_MONSTER)
	and g:IsExists(c26015015.mgfilter,1,nil,lv) and rp~=tp
end
function c26015015.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26015015)
	Duel.NegateEffect(ev)
end
function c26015015.cfilter(c,e)
	return c:IsSetCard(0x2615) or c:IsLocation(LOCATION_HAND)
end
function c26015015.extrafil(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c26015015.exfilter,tp,0,LOCATION_MZONE,nil,e)
end
function c26015015.exfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0
	and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c26015015.ritcheck(e,tp,g,sc)
	return g:IsExists(Card.IsSetCard,1,nil,0x1615)
end
function c26015015.customoperation(mg,e,tp,eg,ep,ev,re,r,rp,tc)
	if #mg==0 then return end
	Duel.HintSelection(mg)
	tc:SetMaterial(mg)
	Duel.Release(mg,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
	Duel.BreakEffect()
	if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
		c26015015.disable(e,tp,mg)
	end
end

function c26015015.filter2(c,tp)
	return c:IsSetCard(0x615) and c:IsMonster() and c:IsAbleToGrave() and Duel.IsPlayerCanRelease(tp,c)
end
function c26015015.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26015015.filter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c26015015.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c26015015.filter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)~=0 then
		c26015015.disable(e,tp,g)
	end
end
function c26015015.filter3(c)
	return (c:IsSetCard(0x615) and c:IsMonster() or c:IsCode(26015011)) and c:IsAbleToHand()
end
function c26015015.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26015015.filter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c26015015.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26015015.filter3),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		c26015015.disable(e,tp,g)
	end
end