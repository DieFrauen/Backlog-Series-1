--Echolon Vice-Receiver
function c26013005.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26013005)
	e1:SetTarget(c26013005.sptg)
	e1:SetOperation(c26013005.spop)
	c:RegisterEffect(e1)
	--exc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26013005,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,{26013005,1})
	e2:SetCondition(c26013005.scon)
	e2:SetTarget(c26013005.stg)
	e2:SetOperation(c26013005.sop)
	c:RegisterEffect(e2)
	
end
function c26013005.tgfilter(c)
	return c:IsSetCard(0x613) and c:IsMonster() and c:IsFaceup() and c:IsCanBeEffectTarget()
end
function c26013005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26013005.tgfilter(chkc) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26013005.tgfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and #g>0 and g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.GetMatchingGroup(c26013005.tgfilter,tp,LOCATION_MZONE,0,nil)
	local tg=aux.SelectUnselectGroup(g,e,tp,1,#g,c26013005.rescon,1,tp,HINTMSG_TARGET,c26013005.rescon)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26013005.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg and sg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function c26013005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetValue(#sg)
		c:RegisterEffect(e1)
	end
end
function c26013005.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO 
end
function c26013005.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetPreviousLevelOnField()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,lv) end
	e:SetLabel(lv)
end
function c26013005.sop(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	if ac==0 or not Duel.IsPlayerCanDiscardDeck(tp,ac) then return end
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local sg=g:Filter(Card.IsSetCard,nil,0x613)
	if #sg>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
	end
	ac=ac-#sg
	if ac>0 then
		Duel.MoveToDeckBottom(ac,tp)
		Duel.SortDeckbottom(tp,tp,ac)
	end
end