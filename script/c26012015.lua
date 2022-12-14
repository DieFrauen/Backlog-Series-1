--Deltaclustar Hyper-Gamma
function c26012015.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,1,5,c26012015.xyzfilter,aux.Stringid(26012015,0),99,nil,false,c26012015.xyzcheck)
end
function c26012015.xyzcheck(g,tp,xyz)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function c26012015.xyzfilter(c,tp,xyzc)
	if not c:IsFaceup() or not c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp) or not c:GetRank()==1 then return end
	local g=c:GetOverlayGroup()
	local att=c:GetAttribute()
	return g:IsExists(c26012015.ovfilter,1,nil,att,g)
end
function c26012015.ovfilter(c,att,g)
	return c:GetOriginalAttribute()==att and g:IsExists(Card.IsCode,3,nil,c:GetCode())
end