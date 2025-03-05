--Quark Chromoforce
function c26012012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c26012012.condition)
	c:RegisterEffect(e0)
	aux.GlobalCheck(c26012012,function()
		c26012012[0]=false
		c26012012[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c26012012.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			c26012012[0]=false
			c26012012[1]=false
		end)
	end)
	--special summon 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c26012012.sp1tg)
	e2:SetOperation(c26012012.sp1op)
	c:RegisterEffect(e2)
	--special summon 3
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26012012,2))
	e3:SetTarget(c26012012.sp2tg)
	e3:SetOperation(c26012012.sp2op)
	c:RegisterEffect(e3)
end
function c26012012.condition(e)
	return c26012012[e:GetHandlerPlayer()]==true
end
function c26012012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		local pos=tc:GetPosition()
		if tc:IsSetCard(0x1612) and tc:IsPreviousPosition(POS_FACEUP)
			and tc:GetControler()==tc:GetPreviousControler() then
			c26012012[tc:GetControler()]=true
		end
	end
end
function c26012012.sp1filter(c,e,tp,tc,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and tc:GetLink()==c:GetLevel() and c:GetAttribute()&tc:GetAttribute()~=0
end
function c26012012.lfilter(c,e,tp,chk)
	local lz=c:GetLinkedZone(tp)
	if not c:IsType(TYPE_LINK) or not lz then return false end
	return Duel.IsExistingMatchingCard(c26012012.sp1filter,tp,LOCATION_MZONE,0,1,nil,e,tp,c,lz) and chk==0 or Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c26012012.sp1filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c,lz)
end
function c26012012.sp1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26012012.lfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c26012012.sp1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26012012.lfilter,tp,LOCATION_MZONE,0,nil,e,tp,1)
	if #g>0 then
		local lc=g:Select(tp,1,1,nil):GetFirst()
		local zone=lc:GetLinkedZone(tp)
		local tc=Duel.SelectMatchingCard(tp,c26012012.sp1filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lc,zone)
		if #tc>0 then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP,zone)   
		end
	end
end
function c26012012.sp2filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26012012.spcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg
	and sg:IsExists(Card.IsCode,1,nil,26012001)
	and sg:IsExists(Card.IsCode,1,nil,26012002)
	and sg:IsExists(Card.IsCode,1,nil,26012003)
end
function c26012012.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
		local g=Duel.GetMatchingGroup(c26012012.sp2filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		return ft>2 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and aux.SelectUnselectGroup(g,e,tp,3,3,c26012012.spcheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c26012012.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26012012.sp2filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if #sg==0 then return end
	local rg=aux.SelectUnselectGroup(sg,e,tp,3,3,c26012012.spcheck,1,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEUP_DEFENSE,zone)
end