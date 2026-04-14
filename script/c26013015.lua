--Echolon Interference
function c26013015.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(c26013015.untg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Change target's properties
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013015,0))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,26013015)
	e3:SetTarget(c26013015.retg)
	e3:SetOperation(c26013015.reop)
	c:RegisterEffect(e3)
end
c26013015.listed_series={0x613}
function c26013015.untg(e,c)
	local sg=c26013015.GROUP(Duel.GetCurrentChain())
	return #sg>0 and sg:IsContains(c)
end
function c26013015.GROUP(ev)
	local sg=Group.CreateGroup()
	for i=1,ev do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and #tg>0 and te:GetHandler():IsSetCard(0x613) then
			sg:Merge(tg)
		end
	end
	return sg
end
function c26013015.filter1(c,g,e,tp)
	e:SetLabelObject(c)
	return c:IsFaceup() and aux.SelectUnselectGroup(g,e,tp,1,4,c26013015.rescon1,0)
end
function c26013015.filter2(c,g)
	return (c:IsSetCard(0x613) or c:GetType()&0x1001==0x1001)
	and c:IsFaceup()
end
function c26013015.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c26013015.filter2,tp,LOCATION_MZONE|LOCATION_GRAVE,0,nil) 
	if chk==0 then return Duel.IsExistingTarget(c26013015.filter1,tp,0,LOCATION_MZONE,1,nil,g,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil,g,e,tp)
	e:SetLabelObject(tc:GetFirst())
	local tg=aux.SelectUnselectGroup(g,e,tp,1,4,c26013015.rescon1,1,tp,HINTMSG_TARGET,c26013015.rescon1)
	Duel.SetTargetCard(tg)
	Duel.SetPossibleOperationInfo(0,CATEGORY_LVCHANGE,tc,1,0,0)
end
function c26013015.rescon1(sg,e,tp,mg)
	return #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<3
	and (e:GetLabelObject():IsLevelAbove(1) or #sg>1)
end
function c26013015.codef(c,code)
	return not c:IsCode(code)
end
function c26013015.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	local tc=g:Filter(Card.IsControler,nil,1-tp):GetFirst()
	if not tc or #g<2 or tc:IsImmuneToEffect(e) then return end
	local b1=tc:HasLevel() and #g>1
	local b2=#g>2
	local b3=#g>3
	local b4=g:IsExists(c26013015.codef,1,nil,tc:GetCode()) and #g>4
	local code={}
	if (b1 or b2 or b3 or b4)then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26013015,2))
		local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26013015,3)},
		{b2,aux.Stringid(26013015,4)},
		{b3,aux.Stringid(26013015,5)},
		{b4,aux.Stringid(26013015,6)})
		if op==1 then 
			local lev=Duel.AnnounceLevel(tp,1,#g,tc:GetLevel())
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(lev)
			tc:RegisterEffect(e1)
		end
		if op==2 then 
			local rac=Duel.AnnounceRace(tp,1,RACE_ALL)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(rac)
			tc:RegisterEffect(e2)
		end
		if op==3 then 
			local atr=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(atr)
			tc:RegisterEffect(e3)
		end
		if op==4 then
			local g=c26013002.GROUP(ev):Filter(Card.IsOnField,nil)
			local ids={}
			for rc in aux.Next(g) do
				ids[rc:GetCode()]=true
			end
			c26013015.announce_filter={}
			for code,i in pairs(ids) do
				if #c26013015.announce_filter==0 then
					table.insert(c26013015.announce_filter,code)
					table.insert(c26013015.announce_filter,OPCODE_ISCODE)
				else
					table.insert(c26013015.announce_filter,code)
					table.insert(c26013015.announce_filter,OPCODE_ISCODE)
					table.insert(c26013015.announce_filter,OPCODE_OR)
				end
			end
			local code=Duel.AnnounceCard(tp,table.unpack(c26013015.announce_filter))
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_CODE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetValue(code)
			e4:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e4)
		end
	end
end