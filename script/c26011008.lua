--Light Emperor Halcyon
function c26011008.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,4,c26011008.lcheck)
	
end
function c26011008.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,26011001)
end