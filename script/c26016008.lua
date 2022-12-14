--POL-Arc Hyper Minuster
function c26016008.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26016008.matfilter,1,1)
	
end
function c26016008.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:GetLeftScale()<=4
end 