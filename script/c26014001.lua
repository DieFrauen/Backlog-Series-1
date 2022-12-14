--Arc-Chemic Helion
function c26014001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26014001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,26014001)
	e1:SetTarget(c26014001.target)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	--Extra Material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetTarget(c26014001.mtg)
	e2:SetOperation(Fusion.BanishMaterial)
	e2:SetValue(c26014001.mtval)
	c:RegisterEffect(e2)
end
c26014001.listed_names={CARD_POLYMERIZATION }

function c26014001.filter1(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsSSetable()
end
function c26014001.filter2(c,e,tp)
	return c:IsSetCard(0x614) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26014001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c26014001.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26014001.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return (b1 or b2) end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26014001,1)},
		{b2,aux.Stringid(26014001,2)})
	if op==1 then
		e:SetOperation(c26014001.tfop)
	elseif op==2 then
		e:SetOperation(c26014001.spop)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c26014001.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c26014001.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26014001.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c26014001.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26014001.mtval(e,c)
	if not c then return false end
	return c:IsSetCard(0x2614) and c:IsControler(e:GetHandlerPlayer())
end
function c26014001.mtg(e,c)
	return c==e:GetHandler()
end
