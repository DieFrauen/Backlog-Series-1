--POL-Arc Sinos
function c26016001.initial_effect(c)
	c:SetSPSummonOnce(26016001)
	--pendulum summon
	Pendulum.AddProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26016001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c26016001.target)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c26016001.dualcon)
	e2:SetTarget(c26016001.target)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetLabel(1)
	e3:SetValue(c26016001.scalev)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	e4:SetLabel(2)
	c:RegisterEffect(e4)
	--Extra Material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_EXTRA_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetOperation(c26016001.extracon)
	e5:SetValue(c26016001.extraval)
	c:RegisterEffect(e5)
end
c26016001.listed_names={26016002,26016012}
function c26016001.extrafilter(c,tp)
	return c:IsControler(tp)
end
function c26016001.extracon(c,e,tp,sg,mg,lc,og,chk)
	return (sg+mg):Filter(c26016001.extrafilter,nil,e:GetHandlerPlayer()):IsExists(Card.IsCode,1,og,26016002)
end
function c26016001.extraval(chk,summon_type,e,...)
	local c=e:GetHandler()
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or not sc:IsSetCard(0x616)
		then
			return Group.CreateGroup()
		else
			return Group.FromCards(c)
		end
	elseif chk==1 then
		local sg,sc,tp=...
		if summon_type&SUMMON_TYPE_LINK == SUMMON_TYPE_LINK and #sg>0 then
			Duel.Hint(HINT_CARD,tp,26016001)
		end
	end
end
function c26016001.scalev(e,c)
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil)
	local ps=e:GetHandler():GetLeftScale()
	if e:GetLabel()==1 then ps=e:GetHandler():GetRightScale() end
	return math.min(13-ps,ct)
end
function c26016001.dualcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c) and eg:IsExists(Card.IsCode,1,c,26016002)
end
function c26016001.filter1(c)
	return c:IsSetCard(0x616) and c:IsAbleToHand()
end
function c26016001.filter2(c,tp)
	return c:IsCode(26016012) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26016001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local p1=Duel.IsExistingMatchingCard(c26016001.filter1,tp,LOCATION_DECK,0,1,nil)
	local p2=Duel.IsExistingMatchingCard(c26016001.filter2,tp,LOCATION_GRAVE,0,1,nil,tp)
	if chk==0 then return p1 or p2 end
	local op=Duel.SelectEffect(tp,
	{p1,aux.Stringid(26016001,0)},
	{p2,aux.Stringid(26016001,1)})
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		e:SetOperation(c26016001.operation1)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
		e:SetOperation(c26016001.operation2)
	end
end
function c26016001.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26016001.filter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26016001.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c26016001.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp) end
end