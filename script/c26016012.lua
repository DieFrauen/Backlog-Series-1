--POL-Arc Vectorial Magnas
function c26016012.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26016012.matfilter,2)
	
end
c26016012.pendulum_level=2
function c26016012.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end