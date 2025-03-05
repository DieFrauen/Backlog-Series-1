--Echolon Frequency
function c26013011.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26013011,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26013011,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26013011.activate)
	c:RegisterEffect(e1)
	--Frequency
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(26013011)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--re-activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26013011,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetLabelObject(e1)
	e3:SetCondition(c26013011.recon)
	e3:SetTarget(c26013011.retg)
	e3:SetOperation(c26013011.reop)
	c:RegisterEffect(e3)
end
function c26013011.filter(c)
	return c:IsSetCard(0x613) and c:IsAbleToGrave()
end
function c26013011.tuner(c,tc)
	return c:IsFaceup() and c:IsCode(tc:GetCode())
end
function c26013011.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26013011.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26013011,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoGrave(sc,REASON_EFFECT)
		local tg=Duel.GetMatchingGroup(c26013011.tuner,tp,LOCATION_MZONE,0,nil,sc)
		local tc=tg:GetFirst()
		for tc in aux.Next(tg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_TUNER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function c26013011.cfilter(c,tp)
	return c:IsFaceup(tp) and c:IsSetCard(0x613)
end
function c26013011.refilter(c)
	return c:IsSetCard(0x613) and c:IsMonster() and c:IsAbleToDeckAsCost()
end
function c26013011.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26013011.refilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.refilter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c26013011.recon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return (re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	and g and g:IsExists(c26013011.cfilter,1,nil,tp)
	and re:GetHandler():IsSetCard(0x613)) or rp~=tp
end
function c26013011.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabelObject():IsActivatable(tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c26013011.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)and e:GetLabelObject():IsActivatable(tp) then
		Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,tp,c:GetOriginalCodeRule())
		Duel.HintSelection(Group.FromCards(c))
	end
end