--Halcyon Territory
function c26011009.initial_effect(c)
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
	e2:SetTarget(c26011009.sumlimit)
	c:RegisterEffect(e2)
end

function c26011009.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetAttribute()~=ATTRIBUTE_LIGHT 
end