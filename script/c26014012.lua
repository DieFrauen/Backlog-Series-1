--Arc-Chemic Process
function c26014012.initial_effect(c)
	--Fusion
	local e1=Fusion.CreateSummonEff({handler=c,
	desc=aux.Stringid(26014012,0),
	extrafil=c26014012.fextra,
	stage2=c26014012.stage2,
	matcheck=c26014012.matcheck})
	c:RegisterEffect(e1)
	aux.GlobalCheck(c26014012,function()
		c26014012.attr={}
		c26014012.attr[0]=0
		c26014012.attr[1]=0
		aux.AddValuesReset(function()
				c26014012.attr[0]=0
				c26014012.attr[1]=0
			end)
		end)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE|LOCATION_HAND|LOCATION_GRAVE)
	e2:SetValue(CARD_POLYMERIZATION)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014012,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,26014012)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c26014012.thcost)
	e3:SetTarget(c26014012.thtg)
	e3:SetOperation(c26014012.thop)
	c:RegisterEffect(e3)
end
c26014012.listed_series={0x1614}
c26014012.listed_names={CARD_POLYMERIZATION }
function c26014012.attfilter(c,tc)
	return c:IsFaceup() and c:IsMonster() and c:IsAttribute(tc:GetAttribute())
end
function c26014012.fextrafilter(c,tp)
	return c:IsSetCard(0x1614) and c:IsMonster() and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c26014012.attfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,c)
end
function c26014012.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function c26014012.fextra(e,tp,mg)
	local eg=Duel.GetMatchingGroup(c26014012.fextrafilter,tp,LOCATION_DECK,0,nil,tp)
	if #eg>0 then
		return eg,c26014012.fcheck
	end
	return nil,c26014012.fcheck
end
function c26014012.fcheck(tp,sg,fc)
	return sg:FilterCount(c26014012.mtfilter,nil,tp)==0
end
function c26014012.matcheck(tp,sg,fc)
	local att=c26014012.attr[tp]
	return sg:GetClassCount(Card.IsAttribute,nil,fc,SUMMON_TYPE_FUSION,tp)==#sg
end
function c26014012.mtfilter(c,tp)
	return c26014012.attr[tp]&c:GetAttribute()~=0
end
function c26014012.stage2(e,tc,tp,sg,chk)
	if chk==1 then
		local sc=tc:GetMaterial():GetFirst()
		for sc in aux.Next(sg) do
			local att=sc:GetAttribute()
			c26014012.attr[tp]=c26014012.attr[tp]|att
		end
	end
end
function c26014012.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,1,REASON_COST)
end
function c26014012.thfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsMonster() and (c:IsAbleToDeck() or c:IsAbleToExtra()) and c:IsFaceup()
end
function c26014012.th2filter(c,tc)
	return tc:ListsCodeAsMaterial(c:GetCode()) and c:IsMonster() and c:IsFaceup() and c:IsAbleToDeck() 
end
function c26014012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26014012.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26014012.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	local bg=Duel.GetMatchingGroup(c26014012.th2filter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,nil,tc)
	if #bg>0 and Duel.SelectYesNo(tp,aux.Stringid(26014012,2)) then
		g2=bg:Select(tp,1,2,nil)
		g:Merge(g2)
		Duel.SetTargetCard(g2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,0)
end
function c26014012.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then 
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end