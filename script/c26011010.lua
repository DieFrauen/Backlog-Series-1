--Halcyon Territory
function c26011010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot ss in attack pos
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_FORCE_SPSUMMON_POSITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(POS_DEFENSE)
	e2:SetTarget(c26011010.sumlimit)
	c:RegisterEffect(e2)
	--cannot target monster for attack except this one
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c26011010.atlimit)
	c:RegisterEffect(e3)
	--Effect Draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DRAW_COUNT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE) 
	e4:SetTargetRange(1,0)
	e4:SetValue(2)
	e4:SetCondition(c26011010.drcon)
	c:RegisterEffect(e4)
	if not c26011010.global_check then
		c26011010.global_check=true
		c26011010[0]=0
		c26011010[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c26011010.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c26011010.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	--atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c26011010.deffilter)
	e5:SetValue(c26011010.defval)
	c:RegisterEffect(e5)
	--fulmiknight siege (enable quick effects)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(26011010)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
end
function c26011010.checkop(e,tp,eg,ep,ev,re,r,rp)
	c26011010[Duel.GetTurnPlayer()]=1
end
function c26011010.clearop(e,tp,eg,ep,ev,re,r,rp)
	c26011010[Duel.GetTurnPlayer()]=0
end
function c26011010.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetAttribute()~=ATTRIBUTE_LIGHT 
end
function c26011010.atfilter(c,tc)
	return c:IsFaceup() and c:IsDefensePos()
	and (tc:IsAttackPos() or c:GetDefense()>tc:GetDefense())
end
function c26011010.atlimit(e,c)
	local def=c:GetDefense() or 0
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c26011010.atfilter,c:GetControler(),LOCATION_MZONE,0,1,c,c)
end
function c26011010.deffilter(e,c)
	return c:IsRace(RACE_FAIRY) and c:IsLinked()
end
function c26011010.defval(e,c)
	local at,df=c:GetBaseAttack(),c:GetBaseDefense()
	if not df and at then return 0 end
	return math.max(df-at,0)
end
function c26011010.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c26011010[1-e:GetHandlerPlayer()]==0
end

function c26011010.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x1615) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp,zone)
end
function c26011010.rescon(sg,e,tp,mg)
	return sg:IsContains(e:GetHandler())
end
function c26011010.tgfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLinkMonster()
		and (Duel.IsExistingMatchingCard(c26011010.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c,c:GetLinkedZone(tp),tp)
		or Duel.IsExistingMatchingCard(c26011010.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c,c:GetLinkedZone(1-tp),1-tp))
end
function c26011010.spfilter(c,e,summonPlayer,targetCard,targetCardZones,toFieldPlayer)
	local zone=(targetCardZones|(c:IsLinkMonster() and targetCard:GetToBeLinkedZone(c,toFieldPlayer) or 0))&ZONES_MMZ
	return zone>0 and c:IsCanBeSpecialSummoned(e,0,summonPlayer,false,false,POS_FACEUP,toFieldPlayer,zone)
end
function c26011010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c26011010.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)
		and Duel.IsExistingTarget(c26011010.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26011010.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26011010.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(c26011010.spfilter,tp,LOCATION_HAND,0,nil,e,tp,tc,tc:GetLinkedZone(tp),tp)
	local g2=Duel.GetMatchingGroup(c26011010.spfilter,tp,LOCATION_HAND,0,nil,e,tp,tc,tc:GetLinkedZone(1-tp),1-tp)
	while #(g1+g2)>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=(g1+g2):Select(tp,1,1,nil):GetFirst()
		local b1=g1:IsContains(sc)
		local b2=g2:IsContains(sc)
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26011010,2)},
			{b2,aux.Stringid(26011010,3)})
		local toFieldPlayer=op==1 and tp or 1-tp
		local zone=(tc:GetLinkedZone(toFieldPlayer)|(sc:IsLinkMonster() and tc:GetToBeLinkedZone(sc,toFieldPlayer) or 0))&ZONES_MMZ
		Duel.SpecialSummonStep(sc,0,tp,toFieldPlayer,false,false,POS_FACEUP,zone)
		g1=Duel.GetMatchingGroup(c26011010.spfilter,tp,LOCATION_HAND,0,nil,e,tp,tc,tc:GetLinkedZone(tp),tp)
		g2=Duel.GetMatchingGroup(c26011010.spfilter,tp,LOCATION_HAND,0,nil,e,tp,tc,tc:GetLinkedZone(1-tp),1-tp)
		if #(g1+g2)==0 or not Duel.SelectYesNo(tp,aux.Stringid(26011010,4)) then break end
	end
	Duel.SpecialSummonComplete()
end