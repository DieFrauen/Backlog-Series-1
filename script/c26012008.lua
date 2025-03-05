--Quarkluon Anti-Blue
function c26012008.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26012008.matfilter,1,1)
	--Extra Link Material
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26012008,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c26012008.plinkcon)
	e0:SetTarget(c26012008.plinktg)
	e0:SetOperation(c26012008.plinkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	aux.GlobalCheck(c26012008,function()
		c26012008[0]=false
		c26012008[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c26012008.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			c26012008[0]=false
			c26012008[1]=false
		end)
	end)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c26012008.indtg)
	e1:SetValue(1)
	--c:RegisterEffect(e1)
	--attach Blue Quarky
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012008,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c26012008.attcon)
	e2:SetTarget(c26012008.atttg)
	e2:SetOperation(c26012008.attop)
		--linking
		local el2=Effect.CreateEffect(c)
		el2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		el2:SetRange(LOCATION_MZONE)
		el2:SetTargetRange(LOCATION_MZONE,0)
		el2:SetTarget(c26012008.eftg)
		el2:SetLabelObject(e2)
		c:RegisterEffect(el2,false,REGISTER_FLAG_DETACH_XMAT)
	--xyz material
	local ex2=e2:Clone()
	ex2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	c:RegisterEffect(ex2,false,REGISTER_FLAG_DETACH_XMAT)
end
function c26012008.matfilter(c,scard,sumtype,tp)
	return c:IsCode(26012002)
end
function c26012008.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		local pos=tc:GetPosition()
		if tc:IsCode(26012002) and tc:IsPreviousPosition(POS_FACEUP)
			and tc:GetControler()==tc:GetPreviousControler() then
			c26012008[tc:GetControler()]=true
		end
	end
end
function c26012008.plfilter(c,lc,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x612) and (c:IsFaceup() or not c:IsOnField())
end
function c26012008.plinkcon(e,c,must,g,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c26012008.plfilter,tp,LOCATION_HAND,0,nil,c,tp)
	local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,g)
	if must then mustg:Merge(must) end
	return Duel.GetFlagEffect(tp,26012008)==0 and ((#mustg==1 and c26012008.matfilter(mustg:GetFirst(),c,SUMMON_TYPE_LINK,tp)) or (#mustg==0 and #g>0)) and c26012008[tp]
end
function c26012008.plinktg(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
	local g=Duel.GetMatchingGroup(c26012008.plfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c,tp)
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
		if not (tc:IsCode(26012002) and tc:IsOnField()) then 
			Duel.RegisterFlagEffect(tp,26012008,RESET_PHASE+PHASE_END,0,1)
		end
		local sg=Group.FromCards(tc)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c26012008.plinkop(e,tp,eg,ep,ev,re,r,rp,c,must,g,min,max)
	Duel.Hint(HINT_CARD,0,26012008)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL|REASON_LINK)
end
function c26012008.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c26012008.eftg(e,c)
	local lg=e:GetHandler():GetLinkedGroup()
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_XYZ) and lg:IsContains(c)
end
function c26012008.attfilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsCode(26012002)
end
function c26012008.attcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsCode,nil,26012002)==0
end
function c26012008.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26012008.attfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e)
		and e:GetHandler():IsType(TYPE_XYZ) end
end
function c26012008.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26012008.attfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e):GetFirst()
	if tc then
		Duel.Overlay(c,tc,true)
	end
	local dg=c:GetOverlayGroup():Filter(Card.IsCode,nil,26012008)
	if #dg>0 then
		Duel.SendtoGrave(dg,REASON_EFFECT)
	end
end