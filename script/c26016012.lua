--Carthesis 0/0 - POL-Arc Plane
function c26016012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26016012.cost)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26016012,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c26016012.cost)
	e2:SetCondition(c26016012.pccon)
	e2:SetTarget(c26016012.pctg)
	e2:SetOperation(c26016012.pcop)
	c:RegisterEffect(e2)
	--scale limit
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(c26016012.cost)
	e3:SetCondition(c26016012.pencon)
	e3:SetTarget(c26016012.pentg)
	e3:SetOperation(c26016012.penop)
	c:RegisterEffect(e3)
	
end
function c26016012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--Cannot use link materials
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c26016012.matlimit)
	e1:SetValue(c26016012.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c26016012.pccon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local atype=re:GetActiveType()
	return atype==TYPE_PENDULUM+TYPE_SPELL and (loc&LOCATION_PZONE)~=0 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c26016012.pcfilter(c,pc)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and 
	pc:ListsCode(c:GetCode()) or c:ListsCode(pc:GetCode())
end
function c26016012.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return Duel.CheckPendulumZones(tp) and rc:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c26016012.pcfilter,tp,LOCATION_DECK,0,1,nil,rc) end
	Duel.SetTargetCard(rc)
	Duel.HintSelection(Group.FromCards(rc))
end
function c26016012.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.CheckPendulumZones(tp) and tc:IsRelateToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c26016012.pcfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c26016012.matlimit(e,c)
	return not (c:IsType(TYPE_PENDULUM) or c:IsSetCard(0x616))
end
function c26016012.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function c26016012.penfilter(c,tp)
	return c:IsSetCard(0x616) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSummonPlayer()==tp
end
function c26016012.pencon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26016012.penfilter,1,nil,tp)
end
function c26016012.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true or Duel.IsPlayerCanPendulumSummon(tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function c26016012.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.PendulumSummon(tp)
end