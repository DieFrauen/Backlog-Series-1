--Echolon Ampligryph
function c26013015.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,2,c26013015.lcheck)
	
end

function c26013015.lcheck(g,lc,sumtype,tp)
	return g:FilterCount(Card.IsType,nil,TYPE_TUNER,lc,sumtype,tp)==1
end