--Arc-Chemic Asclepus
function c26014018.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,26014003,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION))
	
end
