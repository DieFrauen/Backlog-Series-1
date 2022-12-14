--Arc-Chemic Regulus
function c26014016.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,26014001,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION))
	
end
