--Echolon Sonic Glider
function c26013008.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013008,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,26013008)
	e1:SetCondition(c26013008.drcon)
	e1:SetTarget(c26013008.drtg)
	e1:SetOperation(c26013008.drop)
	c:RegisterEffect(e1)
	--detune/negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013008,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(26013013)
	e2:SetCountLimit(1,{26013008,1})
	e2:SetTarget(c26013008.target)
	e2:SetOperation(c26013008.operation)
	c:RegisterEffect(e2)
	--Echolon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013008,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,{26013008,2})
	e3:SetTarget(c26013008.retg)
	e3:SetOperation(c26013008.reop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetRange(LOCATION_GRAVE)
	e3a:SetCost(Cost.PayLP(600))
	e3a:SetCondition(c26013008.gycon)
	c:RegisterEffect(e3a)
end
function c26013008.mat(c)
	return c:GetOriginalType()&TYPE_TUNER ==0
end
function c26013008.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSynchroSummoned()
end
function c26013008.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=e:GetHandler():GetMaterial():FilterCount(c26013008.mat,nil)
	if chk==0 then return val>0 and Duel.IsPlayerCanDraw(tp,val) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,val)
end
function c26013008.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c26013008.filter(c)
	return c:IsType(TYPE_TUNER) or c:IsNegatable()
end
function c26013008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26013008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26013008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c26013008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_TUNER)  then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetValue(TYPE_TUNER)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e2)
		else
			tc:NegateEffects(e:GetHandler(),RESET_EVENT|RESETS_STANDARD,true)
		end
	end
end
function c26013008.tgfilter(c,e)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsCanBeEffectTarget(e)
end
function c26013008.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return false end
	local mg=c26013008.GROUP(ev):Filter(Card.IsOnField,nil)
	if chk==0 then return #mg>0 and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26013008.reop(e,tp,eg,ep,ev,re,r,rp)
	local mg=c26013008.GROUP(ev):Filter(Card.IsOnField,nil)
	if #mg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil,mg)
	if #g>0 then
		Duel.SynchroSummon(tp,g:GetFirst(),nil,mg)
	end
end
function c26013008.GROUP(ev)
	local sg=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg then
			sg:Merge(tg)
		end
	end
	return sg
end
function c26013008.gycon(e,tp,eg,ep,ev,re,r,rp)
	local g=c26013008.GROUP(ev)
	return #g>0 and Duel.IsPlayerAffectedByEffect(tp,26013013)
	and g:IsContains(e:GetHandler())
end