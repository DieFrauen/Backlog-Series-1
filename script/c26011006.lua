--Halcyon Wing of Perfection
function c26011006.initial_effect(c)
	--Link summon
	Link.AddProcedure(c,c26011006.matfilter,1,1)
	c:EnableReviveLimit()
	--disable as material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c26011006.matcon)
	e1:SetTarget(c26011006.mattg)
	e1:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	c:RegisterEffect(e1)
	--search "Halcyon Territory"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26011002,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,26011006)
	e2:SetTarget(c26011006.ftg)
	e2:SetOperation(c26011006.fop)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26011002,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{26011006,1})
	e3:SetTarget(c26011006.sptg)
	e3:SetOperation(c26011006.spop)
	c:RegisterEffect(e3)
end
c26011006.listed_names={26011010}
c26011006.listed_series={0x611}
function c26011006.matfilter(c,lc,sumtype,tp)
	return c:IsLevel(2) and c:IsRace(RACE_FAIRY,lc,sumtype,tp)
	and c:IsAttribute(ATTRIBUTE_LIGHT,lc,sumtype,tp)
end
function c26011006.matcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 
end
function c26011006.mattg(e,c)
	return c:IsAttackPos() and c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c26011006.atcon(e)
	return Duel.IsExistingMatchingCard(Card.IsDefensePos,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c26011006.atlimit(e,c)
	return c:IsAttackPos()
end
function c26011006.plfilter(c)
	return c:IsCode(26011010) and not c:IsForbidden()
end
function c26011006.thfilter(c)
	return not c:IsCode(26011010) and c:IsSetCard(0x611)
	and c:IsAbleToHand()
end
function c26011006.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local LOC=LOCATION_DECK|LOCATION_GRAVE 
	local fc=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,26011010),tp,LOCATION_FZONE,0,1,nil)
	local g=Duel.IsExistingMatchingCard(c26011006.thfilter,tp,LOC,0,1,nil)
	if chk==0 then 
		return fc and g or Duel.IsExistingMatchingCard(c26011006.plfilter,tp,LOC,0,1,nil)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOC)
end
function c26011006.fop(e,tp,eg,ep,ev,re,r,rp)
	local LOC=LOCATION_DECK|LOCATION_GRAVE 
	local fc=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,26011010),tp,LOCATION_FZONE,0,1,nil)
	local g1=Duel.GetMatchingGroup(c26011006.plfilter,tp,LOC,0,1,nil)
	local g2=Duel.GetMatchingGroup(c26011006.thfilter,tp,LOC,0,1,nil)
	local op=1
	local b1=#g1>0
	local b2=#g2>0 and fc
	if b2 then
		op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26011006,0)},
			{b2,aux.Stringid(26011006,1)})
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sc=g1:Select(tp,1,1,nil):GetFirst()
		if sc then
			Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g2:Select(tp,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c26011006.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x611) and (zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone))
end
function c26011006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone=c:GetFreeLinkedZone()&ZONES_MMZ 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c26011006.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26011006.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetFreeLinkedZone()&ZONES_MMZ
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26011006.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end