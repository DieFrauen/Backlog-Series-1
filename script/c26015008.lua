--Remnance Soul Remains
function c26015008.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_ZOMBIE),2,2)
end
