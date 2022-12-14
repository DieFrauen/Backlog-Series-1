--POL-Arc Hyper Emplus
function c26016007.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26016007.matfilter,1,1)
	
end
function c26016007.matfilter(c,lc,sumtype,tp)
	--local lscale=c:GetLeftScale()
	--local rscale=c:GetRightScale()
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:GetLeftScale()>=4
end 