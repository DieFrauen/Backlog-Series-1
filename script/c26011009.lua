--Light Emperor Halcyon
function c26011009.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x611),2,nil,c26011009.lcheck)
	--Must first be Link Summoned
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.lnklimit)
	c:RegisterEffect(e0)
	--Send all face-down cards the opponent controls to the GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26011009,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c26011009.gytg)
	e1:SetOperation(c26011009.gyop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c26011009.gycon2)
	c:RegisterEffect(e2)
	--Double Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetLabel(0)
	e3:SetCondition(c26011009.dcon1)
	e3:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e3)
	--attack with DEF on attacking monsters
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DEFENSE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c26011009.deffilter)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c26011009.deffilter)
	e5:SetValue(function(e,c) return c:IsAttackPos() end)
	c:RegisterEffect(e5)
	if not c26011009.global_check then
		c26011009.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c26011009.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
c26011009.listed_names={26011001}
c26011009.listed_series={0x611}
function c26011009.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a,p=Duel.GetAttacker(),Duel.GetTurnPlayer()
	Duel.RegisterFlagEffect(p,26011009,RESET_PHASE+PHASE_END,0,2)
	if a:GetFlagEffect(26011009)==0 then
		a:RegisterFlagEffect(26011009,RESET_EVENT+RESETS_STANDARD,0,1,aux.Stringid(26011009,1))
	end
end
function c26011009.lcheck(g,lc,sumtype,tp)
	return Duel.GetFlagEffect(tp,26011009)==0 or g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,26011001)
end
function c26011009.tgfilter(c)
	return c:IsAttackPos() and not c:IsLinked() and c:IsAbleToGrave()
end
function c26011009.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26011009.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c26011009.gyop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.AND(c26011009.tgfilter),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c26011009.gycon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLinkSummoned()
end
function c26011009.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),26011009)==0
end
function c26011009.dcon1(e)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	return a and d and (a:IsDefensePos() or d:IsDefensePos())
end
function c26011009.deffilter(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsDefensePos() and c:IsLinked()
end