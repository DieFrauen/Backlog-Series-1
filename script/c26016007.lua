--POL-Arc Secantor
function c26016007.initial_effect(c)
	c:SetSPSummonOnce(26016007)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26016007.matfilter,1,1)
	--Extra Link Material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26016007,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c26016007.plinkcon)
	e1:SetTarget(c26016007.plinktg)
	e1:SetOperation(c26016007.plinkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--Zone Switch
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26016007,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26016007.mvtg)
	e3:SetOperation(c26016007.mvop)
	c:RegisterEffect(e3)
end
function c26016007.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) 
	and (c:GetLeftScale()>=4 or c:GetRightScale()>=4)
end 
function c26016007.mvfilter(c,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsLinkMonster() and (ft>0 or e:GetHandler()==c)
end
function c26016007.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc~=c and c26016007.mvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26016007.mvfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26016007.mvfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c26016007.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local p1=(c:IsRelateToEffect(e) and tc~=c)
	local p2=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	if not (p1 or p2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26016007,1))
	local op=Duel.SelectEffect(tp,
	{p1,aux.Stringid(26016007,2)},
	{p2,aux.Stringid(26016007,3)})
	if op==1 then
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	elseif op==2 then
		Duel.SwapSequence(c,tc)
	end
	local sg=tc:GetLinkedGroup()
	if sg:IsExists(Card.GetLocation,1,nil,LOCATION_PZONE) and Duel.SelectYesNo(tp,aux.Stringid(26016007,1)) then
		local g=Group.FromCards(tc,sg:GetFirstMatchingCard(Card.GetLocation,tp,LOCATION_PZONE,0,nil))
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c26016007.matfilter2(c,lc,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
	and (c:GetLeftScale()>=4 or c:GetRightScale()>=4)
end
function c26016007.plinkcon(e,c,must,g,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c26016007.matfilter2,tp,LOCATION_EXTRA,0,nil,c,tp)
	local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,g)
	if must then mustg:Merge(must) end
	return ((#mustg==1 and c26016007.matfilter(mustg:GetFirst(),c,SUMMON_TYPE_LINK,tp)) or (#mustg==0 and #g>0))
end
function c26016007.plinktg(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
	local g=Duel.GetMatchingGroup(c26016007.matfilter2,tp,LOCATION_EXTRA,0,nil,c,tp)
	local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,g)
	if must then mustg:Merge(must) end
	if #mustg>0 then
		if #mustg>1 then
			return false
		end
		mustg:KeepAlive()
		e:SetLabelObject(mustg)
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local tc=g:SelectUnselect(Group.CreateGroup(),tp,false,true)
	if tc then
		local sg=Group.FromCards(tc)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c26016007.plinkop(e,tp,eg,ep,ev,re,r,rp,c,must,g,min,max)
	Duel.Hint(HINT_CARD,0,26016007)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL|REASON_LINK)
end