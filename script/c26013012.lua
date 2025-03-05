--Echolon Shockwave
function c26013012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON,TIMING_SPSUMMON)
	c:RegisterEffect(e1)
	
end