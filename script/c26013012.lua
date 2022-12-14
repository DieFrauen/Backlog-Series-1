--Echolon Shockwave
function c26013012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(c26013012.cost)
	e1:SetTarget(c26013012.target)
	e1:SetOperation(c26013012.activate)
	c:RegisterEffect(e1)
	
end
function c26013012.cfilter(c)
	return c:IsSetCard(0x613) and c:IsReleasable()
end
function c26013012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.IsExistingMatchingCard(c26013012.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			e:SetLabel(1)
			return true
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26013012.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	e:SetLabelObject(g:GetFirst())
	g:GetFirst():CreateEffectRelation(e)
end
function c26013012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c26013012.filter(chkc) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	end
end
function c26013012.activate(e,tp,eg,ep,ev,re,r,rp)
	local lc=e:GetLabelObject()
	if not lc:IsRelateToEffect(e) then return end
	local lv=lc:GetLevel()
	local att=lc:GetAttribute()
	local typ=lc:GetRace()
	local code=lc:GetCode()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if not g then return end
	for tc in aux.Next(g) do
		if tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(typ)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(att)
			tc:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CHANGE_CODE)
			e4:SetValue(code)
			tc:RegisterEffect(e4)
		end
	end
	if lc:IsType(TYPE_SYNCHRO) then
		--lmao
	end
end
