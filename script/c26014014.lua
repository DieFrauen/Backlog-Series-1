--Arc-Chemic Cycle
function c26014014.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c26014014.condition)
	c:RegisterEffect(e0)
	--send matching targets to GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER|TIMING_STANDBY_PHASE)
	c:RegisterEffect(e1)
	--return 1 banished Attribute to Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26014014,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+26014014)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(function() return not Duel.IsPhase(PHASE_DAMAGE) end)
	e2:SetTarget(c26014014.target)
	e2:SetOperation(c26014014.operation)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--Mass removal register
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(e2)
	e3:SetOperation(c26014014.regop)
	c:RegisterEffect(e3)
	aux.GlobalCheck(c26014014,function()
		c26014014.attr={}
		c26014014.attr[0]=0
		c26014014.attr[1]=0
		aux.AddValuesReset(function()
				c26014014.attr[0]=0
				c26014014.attr[1]=0
			end)
		end)
end
c26014014.listed_series={0x1614}
function c26014014.condition(e)
	local loc=LOCATION_MZONE|LOCATION_GRAVE|LOCATION_REMOVED 
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_WIND),0,loc,loc,1,nil)
	and  Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_WATER),0,loc,loc,1,nil)
	and  Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_FIRE),0,loc,loc,1,nil)
	and  Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_EARTH),0,loc,loc,1,nil)
end
function c26014014.tgfilter(c,tp,att)
	return c:IsMonster() and c:IsAbleToGrave()
	and (c:IsAttribute(att) or c:IsSetCard(0x1614))
	and c26014014.attr[tp]&c:GetAttribute()==0
end
function c26014014.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPhase(PHASE_DAMAGE) then return end
	local tg=eg:Filter(c26014014.regfilter,nil,e,tp)
	if #tg>0 then
		for tc in tg:Iter() do
			tc:RegisterFlagEffect(26014014,RESET_CHAIN,0,1)
		end
		local g=e:GetLabelObject():GetLabelObject()
		if Duel.GetCurrentChain()==0 then g:Clear() end
		g:Merge(tg)
		g:Remove(function(c) return c:GetFlagEffect(26014014)==0 end,nil)
		e:GetLabelObject():SetLabelObject(g)
		if Duel.GetFlagEffect(tp,26014014)==0 then
			Duel.RegisterFlagEffect(tp,26014014,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+26014014,e,0,tp,tp,0)
		end
	end
end
function c26014014.regfilter(c,e,tp)
	return c:IsFaceup() and c:IsMonster() and c:IsCanBeEffectTarget(e)
	and c26014014.attr[tp]&c:GetAttribute()==0
end
function c26014014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject():Filter(c26014014.regfilter,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c26014014.regfilter,tp,LOCATION_REMOVED,0,nil,e,tp):Filter(Card.IsSetCard,nil,0x1614)
	g:Merge(g2)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
	local att=tg:GetFirst():GetAttribute()
	local mg=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #mg>0 and c26014014.attr[tp]&ATTRIBUTE_EARTH &att ==0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_POSITION,mg,1,0,0)
	end
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,LOCATION_SZONE,c)
	if #sg>0 and c26014014.attr[tp]&ATTRIBUTE_WIND &att ==0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_POSITION,sg,1,0,0)
	end
	local gg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #gg>0 and c26014014.attr[tp]&ATTRIBUTE_WATER &att ==0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,gg,1,0,0)
	end
	if c26014014.attr[tp]&ATTRIBUTE_FIRE &att ==0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	end
end
function c26014014.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local att=tc:GetAttribute()
	if not (tc:IsRelateToEffect(e) and c:IsRelateToEffect(e)) then return end
	if Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 then
		for _,str in aux.GetAttributeStrings(att) do
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,str)
			c26014014.attr[tp]=c26014014.attr[tp]|str 
		end
		local p1,p2,p3,p4=0,0,0,0
		local mg=Duel.GetMatchingGroup(Card.IsCanTurnSet,0,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #mg>0 and att&ATTRIBUTE_EARTH ~=0 then p1=1 end

		local sg=Duel.GetMatchingGroup(nil,0,LOCATION_SZONE,LOCATION_SZONE,c)
		if #sg>0 and att&ATTRIBUTE_WIND ~=0 then p2=1 end

		local gg=Duel.GetMatchingGroup(Card.IsAbleToDeck,0,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #gg>0 and att&ATTRIBUTE_WATER ~=0 then p3=1 end

		if att&ATTRIBUTE_FIRE ~=0 then p4=1 end
		local sp,op=0,(p1+p2+p3+p4)
		if op==0 then return end
		if op>1 then 
			if Duel.SelectYesNo(tp,aux.Stringid(26014014,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26014014,1))
				sp=Duel.SelectEffect(tp,
					{p1,aux.Stringid(26014014,2)},
					{p2,aux.Stringid(26014014,3)},
					{p3,aux.Stringid(26014014,4)},
					{p3,aux.Stringid(26014014,5)})
			else return end
		end
		local tc=nil
		if sp==1 or (p1==1 and Duel.SelectYesNo(tp,aux.Stringid(26014014,2))) then
			tc=mg:Select(tp,1,1,nil)
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			return
		end
		if sp==2 or (p2==1 and Duel.SelectYesNo(tp,aux.Stringid(26014014,3))) then
			tc=sg:Select(tp,1,1,nil)
			Duel.Destroy(tc,REASON_EFFECT)
			return
		end
		if sp==3 or (p3==1 and Duel.SelectYesNo(tp,aux.Stringid(26014014,4))) then
			tc=gg:Select(tp,1,1,nil)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			return
		end
		if sp==4 or (p4==1 and Duel.SelectYesNo(tp,aux.Stringid(26014014,5))) then
			Duel.Damage(1-tp,800,REASON_EFFECT)
			return
		end
	end
end