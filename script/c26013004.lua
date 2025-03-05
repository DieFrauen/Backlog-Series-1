--Echolon Wave Catcher
function c26013004.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(1)
	e1:SetCountLimit(1,26013004)
	e1:SetTarget(c26013004.sptg)
	e1:SetOperation(c26013004.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c26013004.qcon)
	e2:SetCost(c26013004.qcost)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_GRAVE)
	e3:SetLabel(2)
	e3:SetCountLimit(1,{26013004,1})
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetLabel(2)
	e4:SetCondition(c26013004.qcon)
	e4:SetCost(c26013004.qcost)
	e4:SetCountLimit(1,{26013004,1})
	c:RegisterEffect(e4)
	--lv change
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26013004,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c26013004.target)
	e5:SetOperation(c26013004.operation)
	c:RegisterEffect(e5)
end
function c26013004.qcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsPlayerAffectedByEffect(tp,26013011)
	and ((re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	and g and g:IsContains(e:GetHandler())
	and re:GetHandler():IsSetCard(0x613)) or rp~=tp)
end
function c26013004.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26013011)==0 end
	Duel.RegisterFlagEffect(tp,26013011,RESET_CHAIN,0,1)
end
function c26013004.tuner(c,b)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and (b==1 or (c:GetOriginalType()&TYPE_TUNER)==0)
end
function c26013004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetLabel()
	if chkc then return c26013004:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26013004.tuner(chkc,ct) end
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c26013004.tuner,tp,LOCATION_MZONE,0,1,nil,ct) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local tc=Duel.SelectTarget(tp,c26013004.tuner,tp,LOCATION_MZONE,0,1,1,nil,ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26013004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
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