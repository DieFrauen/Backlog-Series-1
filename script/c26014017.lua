--Arc-Chemic Aeotus
function c26014017.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,26014002,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION))
	
end
