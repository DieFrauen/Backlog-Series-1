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
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_GRAVE)
	e1a:SetCost(Cost.PayLP(600))
	e1a:SetCondition(function (e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,26013013) end)
	c:RegisterEffect(e1a)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013004,1))
	e2:SetCategory(CATEGORY_ATKCHANGE|CATEGORY_LVCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(26013013)
	e2:SetTarget(c26013004.target)
	e2:SetOperation(c26013004.operation)
	c:RegisterEffect(e2)
	--Echolon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013004,2))
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,{26013004,2})
	e3:SetTarget(c26013004.retg)
	e3:SetOperation(c26013004.reop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetRange(LOCATION_GRAVE)
	e3a:SetCost(Cost.PayLP(600))
	e3a:SetCondition(c26013004.gycon)
	c:RegisterEffect(e3a)
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
	local op=Duel.SelectOption(tp,aux.Stringid(26013004,3),aux.Stringid(26013004,4))
	local val=op+2
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(lv*val)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		if tc:GetLevel()==c:GetLevel() then e2:SetValue(atk*val)
		else e2:SetValue(0) end
		c:RegisterEffect(e2)
	end
end
function c26013004.tgfilter(c,e)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsCanBeEffectTarget(e)
end
function c26013004.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return false end
	local g=c26013004.GROUP(ev):Filter(Card.IsOnField,nil)
	if chk==0 then return g:GetBinClassCount(Card.GetAttribute)>1 end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,#g,c26013004.rescon,1,tp,HINTMSG_TARGET,c26013004.rescon)
	Duel.SetTargetCard(tg)
	local tc=tg:GetFirst()
	local at=0
	for tc in aux.Next(tg) do
		at=(at|tc:GetAttribute())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local attr=Duel.AnnounceAttribute(tp,1,rc)
	Duel.SetTargetParam(arc)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c26013004.rescon(sg,e,tp,mg)
	return sg:GetBinClassCount(Card.GetAttribute)>1
end
function c26013004.reop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg==0 then return end
	local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(rc)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c26013004.GROUP(ev)
	local sg=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg then
			sg:Merge(tg)
		end
	end
	return sg
end
function c26013004.gycon(e,tp,eg,ep,ev,re,r,rp)
	local g=c26013004.GROUP(ev)
	return #g>0 and Duel.IsPlayerAffectedByEffect(tp,26013013)
	and g:IsContains(e:GetHandler())
end