--Echolon Rechorder
function c26013002.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26013002)
	e1:SetTarget(c26013002.sptg)
	e1:SetOperation(c26013002.spop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_GRAVE)
	e1a:SetCost(Cost.PayLP(600))
	e1a:SetCondition(function (e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,26013013) end)
	c:RegisterEffect(e1a)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013002,1))
	e2:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabel(26013013)
	e2:SetCountLimit(1,{26013002,1})
	e2:SetCondition(c26013002.thcon)
	e2:SetTarget(c26013002.thtg)
	e2:SetOperation(c26013002.thop)
	c:RegisterEffect(e2)
	--Echolon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013002,1))
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,{26013002,2})
	e3:SetTarget(c26013002.retg)
	e3:SetOperation(c26013002.reop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetRange(LOCATION_GRAVE)
	e3a:SetCost(Cost.PayLP(600))
	e3a:SetCondition(c26013002.gycon)
	c:RegisterEffect(e3a)
end
c26013002.listed_series={0x613}
function c26013002.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x613)
end
function c26013002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local LOC =(LOCATION_ONFIELD|LOCATION_GRAVE)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOC) and c26013002.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26013002.tfilter,tp,LOC,0,1,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,26013002)<1 end
	Duel.RegisterFlagEffect(tp,26013002,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c26013002.tfilter,tp,LOC,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26013002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26013002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x613) and e:GetHandler():IsOnField()
end
function c26013002.thfilter(c)
	return c:IsSetCard(0x613) and c:IsAbleToHand()
end
function c26013002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26013002.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,26013002)<1 end
	Duel.RegisterFlagEffect(tp,26013002,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26013002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26013002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26013002.tgfilter(c,code)
	return c:IsFaceup() and not c:IsCode(code)
end
function c26013002.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return false end
	local g=c26013002.GROUP(ev):Filter(Card.IsOnField,nil)
	if chk==0 then return #g:Filter(Card.IsCanBeEffectTarget,nil,e)>1 end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,#g,c26013002.rescon,1,tp,HINTMSG_TARGET,c26013002.rescon)
	Duel.SetTargetCard(tg)
end
function c26013002.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)>1
end
function c26013002.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	if #tg==0 then return end
	local g=c26013002.GROUP(ev)
	local ids={}
	for rc in aux.Next(g) do
		ids[rc:GetCode()]=true
	end
	c26013002.announce_filter={}
	for code,i in pairs(ids) do
		if #c26013002.announce_filter==0 then
			table.insert(c26013002.announce_filter,code)
			table.insert(c26013002.announce_filter,OPCODE_ISCODE)
		else
			table.insert(c26013002.announce_filter,code)
			table.insert(c26013002.announce_filter,OPCODE_ISCODE)
			table.insert(c26013002.announce_filter,OPCODE_OR)
		end
	end
	local code=Duel.AnnounceCard(tp,table.unpack(c26013002.announce_filter))
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c26013002.GROUP(ev)
	local sg=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg then
			sg:Merge(tg)
		end
	end
	return sg
end
function c26013002.gycon(e,tp,eg,ep,ev,re,r,rp)
	local g=c26013002.GROUP(ev)
	return #g>0 and Duel.IsPlayerAffectedByEffect(tp,26013013)
	and g:IsContains(e:GetHandler())
end