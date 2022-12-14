--POL-Arc Dual Magnadragon
function c26016009.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x616),2,2)
	
end
function c26016012.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
