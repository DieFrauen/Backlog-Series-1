--Antiquark Neutron
function c26012006.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,c26012006.xyzfilter,nil,3,c26012006.ovfilter,aux.Stringid(26012006,0),nil,c26012006.xyzop,false,c26012006.xyzcheck)
	--non target immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c26012006.immval)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26012006,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c26012006.condition)
	e2:SetTarget(c26012006.target)
	e2:SetOperation(c26012006.operation)
	c:RegisterEffect(e2)
end
function c26012006.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetLink)==1
end
function c26012006.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_LINK,xyz,sumtype,tp)
end
function c26012006.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard(0x2612,lc,SUMMON_TYPE_XYZ,tp) and c:IsLink(1,lc,SUMMON_TYPE_XYZ,tp) 
end
function c26012006.rescon(sg,e,tp,mg)
	local lab=e:GetLabel()
	return sg:GetClassCount(Card.GetCode)==#sg and not sg:IsExists(Card.IsCode,1,nil,lab)
end
function c26012006.cfilter(c,mc)
	return c:IsSetCard(0x2612) and c:IsLink(1) and not c:IsCode(mc:GetCode())
end
function c26012006.xyzop(e,tp,chk,mc)
	local lab=mc:GetCode()
	e:SetLabel(lab)
	local g=Duel.GetMatchingGroup(c26012006.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,mc)
	if chk==0 then return Duel.GetFlagEffect(tp,26012006)==0 and aux.SelectUnselectGroup(g,e,tp,2,2,aux.rescon,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	sg=aux.SelectUnselectGroup(g,e,tp,2,2,aux.rescon,1,tp,aux.Stringid(26012006,1),nil,nil,true)
	if #sg>1 then
		Duel.Overlay(mc,sg)
		Duel.RegisterFlagEffect(tp,26012006,0,0,1)
		return true
	else return false end
end
function c26012006.immval(e,re)
	local c=e:GetHandler()
	if not re:IsActivated() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end
function c26012006.condition(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	tc:CreateEffectRelation(e)
	return tc:IsOnField() and e:GetHandler():GetOverlayCount()>0
end

function c26012006.filter(c,ct)
	return Duel.CheckChainTarget(ct,c)
end
function c26012006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=ev
	if chkc then return chkc:IsOnField() and c26012006.filter(chkc,ct) end
	if chk==0 then return Duel.IsExistingTarget(c26012006.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26012006.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,e:GetLabelObject(),ct)
end
function c26012006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local oc=e:GetLabelObject()
	if not e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
		if oc:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(26012006,2)) then
			Duel.BreakEffect()
			Duel.Remove(oc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end