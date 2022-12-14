--Arc-Chemic Typheus
function c26014019.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,26014004,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION))
	
end
