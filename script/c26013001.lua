--Echolon Buster
function c26013001.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c26013001.sptg)
	e1:SetOperation(c26013001.spop)
	c:RegisterEffect(e1)
end

function c26013001.filter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26013001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26013001.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c26013001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26013001.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=g:GetFirst()
		local loc=tc:GetPreviousLocation()
		local opt1= tc:IsLevelAbove(1)
		local opt2= tc:GetType()&TYPE_TUNER ==0
		local opt3= tc:GetPreviousLocation()==LOCATION_HAND 
		if (opt1 or opt2) and Duel.SelectYesNo(tp,aux.Stringid(26013001,1)) then
			Duel.BreakEffect()
			local opt
			if opt1 and opt2 then
				if opt3 then
					opt=Duel.SelectOption(tp,aux.Stringid(26013001,2),aux.Stringid(26013001,3),aux.Stringid(26013001,4))
				else
					opt=Duel.SelectOption(tp,aux.Stringid(26013001,2),aux.Stringid(26013001,3))
				end
			elseif opt1 and not opt2 then
				opt=Duel.SelectOption(tp,aux.Stringid(26013001,2))
			elseif opt2 and not opt1 then
				opt=Duel.SelectOption(tp,aux.Stringid(26013001,3))+1
			end
			if opt~=1 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(tc:GetLevel())
				tc:RegisterEffect(e1)
			end
			if opt~=0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_ADD_TYPE)
				e2:SetValue(TYPE_TUNER)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			end
		end
	end
end