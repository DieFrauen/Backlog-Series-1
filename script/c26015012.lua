--Revival of the Dark Ones
function c26015012.initial_effect(c)
	c:SetUniqueOnField(1,0,26015012)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015012,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26015012.target)
	e1:SetOperation(c26015012.activate)
	c:RegisterEffect(e1)
	--special summon token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+26015012)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(function() return not Duel.IsPhase(PHASE_DAMAGE) end)
	e2:SetTarget(c26015012.tktg)
	e2:SetOperation(c26015012.tkop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--Mass removal register
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(e2)
	e3:SetOperation(c26015012.regop)
	c:RegisterEffect(e3)
	--negate target effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c26015012.negcon)
	e5:SetOperation(c26015012.negop)
	c:RegisterEffect(e5)
end
c26015012.listed_names={26015011} 
function c26015012.tgfilter(c,e,tp)
	return (c:IsMonster() and c:IsSetCard(0x1615) or c:IsCode(26015011)) and c:IsAbleToGrave() and Duel.IsPlayerCanRelease(tp,c)
end
function c26015012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26015012.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26015012.tgfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26015012,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RELEASE)
	end
end
function c26015012.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPhase(PHASE_DAMAGE) then return end
	local tg=eg:Filter(c26015012.regfilter,nil,e,tp)
	if #tg>0 then
		for tc in tg:Iter() do
			tc:RegisterFlagEffect(26015012,RESET_CHAIN,0,1)
		end
		local g=e:GetLabelObject():GetLabelObject()
		if Duel.GetCurrentChain()==0 then g:Clear() end
		g:Merge(tg)
		g:Remove(function(c) return c:GetFlagEffect(26015012)==0 end,nil)
		e:GetLabelObject():SetLabelObject(g)
		if Duel.GetFlagEffect(tp,26015012)==0 then
			Duel.RegisterFlagEffect(tp,26015012,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+26015012,e,0,tp,tp,0)
		end
	end
end
function c26015012.regfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and lv>0
	and c:IsMonster() and c:IsCanBeEffectTarget(e)
	and c:IsReason(REASON_RELEASE)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,26015100,0x1615,TYPES_TOKEN,1200,0,c:GetLevel(),RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP)
end
function c26015012.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject():Filter(c26015012.regfilter,nil,e,tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c26015012.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local lv=tc:GetLevel()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,26015100,0,TYPES_TOKEN,1200,0,c:GetLevel(),RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP) then
			local tlv=26015100
			local token=26015100
			if tc:IsOriginalSetCard(0x615) and tc:IsType(TYPE_EFFECT) then
				tlv=tlv+lv
			end
			local token=Duel.CreateToken(tp,tlv)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetValue(c26015012.sumlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e2:SetValue(lv)
			token:RegisterEffect(e2)
	end
end
function c26015012.sumlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_ZOMBIE)
end
function c26015012.trlimit(e,c)
	return not c:IsRace(RACE_ZOMBIE) or c:IsRitualSpell()
end
function c26015012.levelr(c,p)
	return c:IsMonster() and c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c26015012.negfilter(c,g)
	local lv=c:GetLevel()
	return c:IsMonster() and c:IsFaceup()
	and c:IsRitualMonster()
	and g:GetSum(Card.GetLevel)<=lv
end
function c26015012.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Duel.IsChainDisablable(ev) and rp~=tp)
	then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	local fg=g:Filter(c26015012.levelr,nil,tp)
	return #fg>0 and ((g==1 and fg:GetFirst():IsSetCard(0x1615))
		or Duel.IsExistingMatchingCard(c26015012.negfilter,tp,LOCATION_MZONE,0,1,nil,fg))
end
function c26015012.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if Duel.IsChainDisablable(ev) and c:IsAbleToGraveAsCost()
	and Duel.SelectYesNo(tp,aux.Stringid(26015012,2)) then
		Duel.Hint(HINT_CARD,1-tp,26015012)
		Duel.SendtoGrave(c,REASON_COST)
		Duel.NegateEffect(ev)
	end
end