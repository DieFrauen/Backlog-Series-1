--Arc-Chemera Homunculus
function c26014011.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,nil,c26014011.spcheck)
	--Cannot be Link Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Extra Material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e2:SetTarget(c26014011.mtg)
	e2:SetOperation(Fusion.BanishMaterial)
	e2:SetValue(c26014011.mtval)
	c:RegisterEffect(e2)
	if not c26014011.global_check then
		c26014011.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c26014011.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c26014011.aclimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e4)
end
function c26014011.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local mat,mg=nil,nil
	for tc in aux.Next(eg) do
		mat=tc:GetMaterial()
		mg=mat:Clone(); mg:AddCard(tc)
		if tc:GetSummonType()&SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK ~=0 and (
		mg:GetClassCount(Card.GetRace)==#mg or
		mg:GetClassCount(Card.GetAttribute)==#mg )
		and #mg>2 then
			--Duel.Hint(HINT_CARD,tp,26014011)
			tc:RegisterFlagEffect(26014011,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c26014011.aclimit(e,c)
	local TYPES =TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK 
	return c:GetType()&TYPES ~=0 and
	c:IsStatus(STATUS_SPSUMMON_TURN) and
	c:GetFlagEffect(26014011)==0
end
c26014011.listed_series={0xfd}
function c26014011.spcheck(g,lc,sumtype,tp)
	return g:CheckDifferentPropertyBinary(Card.GetRace,lc,sumtype,tp) and g:CheckDifferentPropertyBinary(Card.GetAttribute,lc,sumtype,tp)
end
function c26014011.mtval(e,c)
	if not c then return false end
	return --c:IsControler(e:GetHandlerPlayer()) and 
	(c:IsSetCard(0x2614) or e:GetHandler():IsCode(CARD_POLYMERIZATION) )
end
function c26014011.mtfilter(c,att)
	return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1614)) and c:IsAttribute(att)
end
function c26014011.mtg(e,c)
	local loc=LOCATION_GRAVE|LOCATION_REMOVED
	local att=c:GetAttribute()
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c26014002.mtfilter,tp,loc,loc,1,c,att)
	and c:IsAbleToRemove(tp)
end