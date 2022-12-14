--Halcyon Light Guidance
function c26011007.initial_effect(c)
	c:EnableReviveLimit()
	-- 2 Fairy Monsters
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FAIRY),2,2)
end
