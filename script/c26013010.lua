--Echolon Reverb Buster
function c26013010.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--count mats
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c26013010.valcheck)
	c:RegisterEffect(e1)
	--target cards (Reverb Buster)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013010,0))
	e2:SetCategory(CATEGORY_DISABLE|CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,26013010)
	e2:SetCondition(aux.NOT(c26013010.qcon))
	e2:SetTarget(c26013010.tgtg)
	e2:SetOperation(c26013010.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26013010,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c26013010.qcon)
	c:RegisterEffect(e3)
end
function c26013010.mat(c)
	return c:GetOriginalType()&TYPE_TUNER ==0
end
function c26013010.valcheck(e,c)
	local g=c:GetMaterial()
	local sg=g:Filter(Card.IsType,nil,TYPE_SYNCHRO)
	local RESETS = (RESET_EVENT|RESETS_STANDARD_DISABLE -RESET_TOFIELD)
	if #sg>0 then
		for i=1,#sg do
			c:RegisterFlagEffect(26013010,RESETS,0,1,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26013010,0))
		end
	end
	if g:FilterCount(c26013010.mat,nil)==#g then
		c:RegisterFlagEffect(26013110,RESETS,0,1,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26013010,1))
	end
end
function c26013010.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c26013010.qcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():HasFlagEffect(26013110)
end
function c26013010.filter(c,e,p)
	if not c:IsCanBeEffectTarget(e) and c:IsFaceup() then return false end
	return c:IsControler(p) or (
	(c:IsAbleToDeck() and c:IsLocation(LOCATION_GRAVE)) or 
	(c:IsOnField() and c:IsNegatable()))
end
function c26013010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local LOC = LOCATION_MZONE|LOCATION_GRAVE 
	local mt=e:GetHandler():GetFlagEffect(26013010)
	local g=Duel.GetMatchingGroup(c26013010.filter,tp,LOC,LOC,nil,e,tp)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,1,c26013010.tgcheck,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,mt+1,c26013010.tgcheck,1,tp,HINTMSG_TARGET,c26013010.tgcheck)
	Duel.SetTargetCard(sg)
	local og=sg:Filter(Card.IsControler,nil,1-tp)
	local fg,gg=og:Split(Card.IsLocation,nil,LOCATION_ONFIELD)
	if #fg>0 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,fg,#fg,0,0)
	end
	if #gg>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,gg,#gg,0,0)
	end
end
function c26013010.tgcheck(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x613)
end
function c26013010.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		local pg,og=g:Split(Card.IsControler,nil,tp)
		local pc=og:GetFirst()
		for pc in aux.Next(pg) do
			local EFF = 0
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			if pc:IsOnField() then
				EFFECT = EFFECT_INDESTRUCTABLE_EFFECT 
			else
				EFFECT = EFFECT_CANNOT_REMOVE 
			end
			e1:SetCode(EFF)
			e1:SetRange(pc:GetLocation())
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			pc:RegisterEffect(e1)
		end
		local oc=og:GetFirst()
		local dg=Group.CreateGroup()
		for oc in aux.Next(og) do
			if oc:IsOnField() then
				oc:NegateEffects(c,RESETS_STANDARD_PHASE_END)
			else
				dg:AddCard(oc)
			end
		end
		if #dg>0 then
			Duel.HintSelection(dg)
			Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
		end
	end
end