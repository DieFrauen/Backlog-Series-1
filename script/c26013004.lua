--Echolon Wave Catcher
function c26013004.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013004,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(c26013004.spcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabel(1)
	e2:SetCountLimit(1,26013004,EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013004,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c26013004.target)
	e3:SetOperation(c26013004.operation)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c26013004.splimit)
	c:RegisterEffect(e4)
	--clock lizard
	aux.addContinuousLizardCheck(c,LOCATION_MZONE,c26013004.lizfilter)
	
end
function c26013004.tuner(c,b)
	return c:IsType(TYPE_TUNER) and c:GetOriginalType()&TYPE_TUNER 
end
function c26013004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local b=e:GetLabel()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_TUNER),tp,LOCATION_MZONE,0,1,nil,b)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c26013004.spcon2(e,c)
	if c==nil then return true end
	local eff={c:GetCardEffect(EFFECT_NECRO_VALLEY)}
	for _,te in ipairs(eff) do
		local op=te:GetOperation()
		if not op or op(e,c) then return false end
	end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(c26013004.tuner),c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c26013004.filter(c,lv)
	return c:IsLevelAbove(lv+1)
end
function c26013004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26013004.filter(chkc,lv) end
	if chk==0 then return Duel.IsExistingTarget(c26013004.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26013004.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,lv)
	local tc=g:GetFirst()
end
function c26013004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local lv=c:GetLevel()
	local atk=c:GetAttack()
	Duel.HintSelection(Group.FromCards(c))
	local op=Duel.SelectOption(tp,aux.Stringid(26013004,2),aux.Stringid(26013004,3))
	e:SetLabel(op)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		if e:GetLabel()==0 then
			e1:SetValue(lv*2)
		else e1:SetValue(lv*3) end
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		if tc:GetLevel()==c:GetLevel() then
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			if e:GetLabel()==0 then
				e2:SetValue(atk*2)
			else e2:SetValue(atk*3) end
			c:RegisterEffect(e2)
		else
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_ATTACK_FINAL)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			e4:SetValue(0)
			c:RegisterEffect(e4)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_ATTACK_FINAL)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			e5:SetValue(0)
			tc:RegisterEffect(e5)
		end
	end
end
function c26013004.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO+TYPE_TUNER) and c:IsLocation(LOCATION_EXTRA)
end
function c26013004.lizfilter(e,c)
	return not c:IsOriginalType(TYPE_SYNCHRO+TYPE_TUNER)
end