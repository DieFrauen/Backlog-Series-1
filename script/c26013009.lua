--Echolon Bitcrusher
function c26013009.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,nil,1,99)
	--Send to the GY and decrease Level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013009,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,26013009)
	e1:SetLabel(1)
	e1:SetCondition(c26013009.cond)
	e1:SetTarget(c26013009.tgtg)
	e1:SetOperation(c26013009.tgop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c26013009.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26013009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,{26013009,1})
	e2:SetTarget(c26013009.sptg)
	e2:SetOperation(c26013009.spop)
	c:RegisterEffect(e2)
end
function c26013009.mat(c)
	return c:GetOriginalType()&TYPE_TUNER ==0
end
function c26013009.valcheck(e,c)
	local g=c:GetMaterial()
	local v=#g
	if v==#g:Filter(c26013009.mat,nil) then v=v*2 end
	e:GetLabelObject():SetLabel(v)
end
function c26013009.cond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSynchroSummoned()
end
function c26013009.tgfilter(c,val)
	return c:IsAbleToGrave() and c:IsLevelBelow(val)
	and (c:IsType(TYPE_TUNER|TYPE_SYNCHRO) or c:IsSetCard(0x613))
end
function c26013009.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local LOC =LOCATION_DECK|LOCATION_EXTRA 
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26013009.tgfilter,tp,LOC,0,1,nil,e:GetLabel()) and c:GetFlagEffect(26013009)<1 end
	c:RegisterFlagEffect(26013009,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOC)
end
function c26013009.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26013009.tgfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,1,nil,e:GetLabel())
	if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT)  end
end
function c26013009.spcheck(sg,e,tp,mg)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	return sg:GetClassCount(Card.GetCode)==#sg
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<=ft
end
function c26013009.spfilter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsCanBeEffectTarget(e)
	and not c:IsCode(e:GetHandler():GetCode())
	and ((c:IsOnField() and not c:IsType(TYPE_TUNER))
	or (c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)))
end
function c26013009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26013009.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,2,c26013009.spcheck,0) and c:GetFlagEffect(26013009)<1 end
	c:RegisterFlagEffect(26013009,RESET_CHAIN,0,1)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,2,c26013009.spcheck,1,tp,HINTMSG_SPSUMMON,c26013009.spcheck)
	Duel.SetTargetCard(sg)
	local gg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #gg>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,gg,#gg,tp,0)
	end
end
function c26013009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	if #g<1 then return end
	local g1,g2=g:Split(Card.IsOnField,nil)
	local tc=g1:GetFirst()
	for tc in aux.Next(g1) do
		if tc:IsFaceup() and not tc:IsType(TYPE_TUNER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_TUNER)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
	if #g2>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		if #g2>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g2=g2:Select(tp,ft,ft,nil)
		end
		Duel.SpecialSummon(g2,0,tp,tp,true,false,POS_FACEUP)
	end
end