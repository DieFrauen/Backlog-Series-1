--Halcyon Wing of Perfection
function c26011006.initial_effect(c)
	--Link summon
	Link.AddProcedure(c,c26011006.matfilter,1,1)
	c:EnableReviveLimit()
	
end
c26011006.listed_series={0x611}
function c26011006.matfilter(c,lc,sumtype,tp)
	return c:IsLevel(2) and c:IsRace(RACE_FAIRY,lc,sumtype,tp)
end
