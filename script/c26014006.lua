--Arc-Chemera Liocamus
function c26014006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),
	aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH))
	--lizard check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(CARD_CLOCK_LIZARD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26014006.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26014006,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c26014006.spcon)
	e2:SetTarget(c26014006.sptg)
	e2:SetOperation(c26014006.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26014006,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26014006.rettg2)
	e3:SetOperation(c26014006.retop)
	c:RegisterEffect(e3)
	--If fusion summoned with an Arc-Chemic
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c26014006.valcheck)
	c:RegisterEffect(e4)
	local e3a=e3:Clone()
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetLabelObject(e4)
	e3a:SetCondition(c26014006.valcond)
	e3a:SetLabel(1)
	c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetDescription(aux.Stringid(26014006,2))
	e3b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetLabelObject(e4)
	e3b:SetCondition(c26014006.valcond)
	e3b:SetTarget(c26014006.rettg)
	e3b:SetLabel(0)
	c:RegisterEffect(e3b)
end
function c26014006.valcheck(e,c)
	if c:GetMaterial():IsExists(Card.IsSetCard,1,nil,0x1614) then
		e:SetLabel(1)
	end
end
function c26014006.valcond(e,c)
	return e:GetLabel()==e:GetLabelObject():GetLabel()
end
function c26014006.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(CARD_POLYMERIZATION)
end
function c26014006.cfilter(c,tp)
	return c:IsMonster() and c:IsPreviousLocation(LOCATION_MZONE)
end
function c26014006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26014006.cfilter,1,nil,tp)
end
function c26014006.filter(c,e,tp,eg)
	return c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:IsExists(Card.GetControler,1,nil,c:GetControler())
end
function c26014006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26014006.filter(chkc,e,tp,eg) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e)
		and e:GetHandler():IsFaceup() and Duel.IsExistingTarget(c26014006.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c26014006.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26014006.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c26014006.retfilter(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsAbleToHand()
end
function c26014006.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c26014006.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c26014006.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local og=Duel.GetMatchingGroup(c26014006.retfilter,tp,LOCATION_GRAVE,0,nil)
		local sg=Group.CreateGroup()
		sg:AddCard(c)
		if #og>0 and Duel.SelectYesNo(tp,aux.Stringid(26014006,3)) then
			sg:AddCard(og:Select(tp,1,1,nil):GetFirst())
		end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
