--Arc-Chemera Merleus
function c26014006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local f0=Fusion.AddProcMix(c,false,false,26014001,26014003)[1]
	f0:SetDescription(aux.Stringid(26014006,0))
	local f1=Fusion.AddProcMix(c,false,false,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER))[1]
	f1:SetDescription(aux.Stringid(26014006,1))
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		f1:SetValue(c26014006.matfilter)
	end
	aux.GlobalCheck(c26014006,function()
		c26014006.polycheck=0
	end)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26014006.splimit)
	c:RegisterEffect(e1)
	--negate target effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,26014006,1)
	e2:SetCondition(c26014006.remcon)
	e2:SetOperation(c26014006.remop)
	c:RegisterEffect(e2)
	--Special summon 1 "Arc-Chem" monster during the next Standby Phase
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26014006,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,{26014006,1})
	e4:SetTarget(c26014006.sptg)
	e4:SetOperation(c26014006.spop)
	c:RegisterEffect(e4)
end
c26014006.listed_names={CARD_POLYMERIZATION }
function c26014006.splimit(e,se,sp,st)
	if se:GetHandler():IsCode(CARD_POLYMERIZATION) then c26014006.polycheck=1
	else c26014006.polycheck=0 end
	if (not e:GetHandler():IsLocation(LOCATION_EXTRA) or (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION) then
		return se
	end
end
function c26014006.matfilter(c,fc,sub,sub2,mg,sg,tp,contact,sumtype)
	if sumtype&SUMMON_TYPE_FUSION ~=0 and fc:IsLocation(LOCATION_EXTRA) and mg then
		return c26014006.polycheck==1
	end
	return c26014006.polycheck==1
end
function c26014006.remfilter(c,tp)
	return c:IsSetCard(0x614) and c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD|LOCATION_GRAVE) and c:IsControler(tp)
end
function c26014006.remcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and g and g:IsExists(c26014006.remfilter,1,nil,tp) and Duel.IsChainDisablable(ev) and rp~=tp
end
function c26014006.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if not c:IsAbleToRemove() and (aux.SpElimFilter(c,true) or not c:IsLocation(LOCATION_GRAVE))
	then return end
	if not Duel.SelectEffectYesNo(tp,c) then return end
	Duel.Hint(HINT_CARD,0,26014006)
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	Duel.NegateEffect(ev)
end
function c26014006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c26014006.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c26014006.spcon1)
	e1:SetOperation(c26014006.spop1)
	Duel.RegisterEffect(e1,tp)
end

function c26014006.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function c26014006.filter(c,e,tp)
	return c:IsSetCard(0x614) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26014006.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26014006.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
	e:Reset()
end
