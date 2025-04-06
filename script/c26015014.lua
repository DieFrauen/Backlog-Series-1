--Encroaching Vengeance
function c26015014.initial_effect(c) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26015014.cost)
	c:RegisterEffect(e1)   
	--Activate the turn is set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015014,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetValue(function(e,c) e:SetLabel(1) end)
	e2:SetCondition(c26015014.thcond)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	--cannot negate Ritual Spells
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c26015014.efilter)
	c:RegisterEffect(e3)
	--cannot banish gy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(c26015014.rmlimit)
	c:RegisterEffect(e4)
	--use deck as Tribute
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c26015014.mttg)
	e5:SetTargetRange(LOCATION_DECK,0)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Vengeance Revival lingers
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(26015011)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c26015014.revcon)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
end
c26015014.listed_names={26015011} 
c26015014.listed_series={0x1615,0x2615}
function c26015014.mttg(e,c)
	return c:IsSetCard(0x1615)
end
function c26015014.costfilter(c)
	return c:IsRitualMonster() and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c26015014.thcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26015014.costfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,c)
end
function c26015014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local oe=e:GetLabelObject()
	if chk==0 then oe:SetLabel(0) return true end
	if oe:GetLabel()>0 then
		oe:SetLabel(0)
		Duel.DiscardHand(tp,c26015014.costfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
	end
end
function c26015014.rmlimit(e,c,tp,r)
	return c:IsRace(RACE_ZOMBIE) and c:IsLocation(LOCATION_GRAVE)
		and c:IsControler(e:GetHandlerPlayer()) and not c:IsImmuneToEffect(e) and r&REASON_EFFECT>0
end
function c26015014.revcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(26015011)>0
end
function c26015014.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler():IsRitualSpell()
end