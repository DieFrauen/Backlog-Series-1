--Renmity of Souls
function c26015010.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsLevelBelow,8),2,nil,c26015010.matcheck)
	--use hidden link materials
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c26015010.extracon)
	e1:SetValue(c26015010.extraval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015010,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,26015010)
	e2:SetCondition(c26015010.thcon)
	e2:SetTarget(c26015010.thtg)
	e2:SetOperation(c26015010.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--enable renmity effects
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(26015010)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	e5:SetCondition(c26015010.encon)
	c:RegisterEffect(e5)
end
c26015010.listed_names={26015011} 
function c26015010.matcheck(g,lnkc,sumtype,sp)
	return g:IsExists(Card.IsSetCard,1,nil,0x1615,lnkc,sumtype,sp)
end
function c26015010.linkfilter(c)
	return c:IsSetCard(0x615) and c:IsCanBeLinkMaterial()
	and (c:IsFacedown() or c:IsLocation(LOCATION_HAND))
end
function c26015010.extracon(c,e,tp,sg,mg,lc,og,chk)
	if not c26015010.curgroup then return true end
	local g=c26015010.curgroup:Filter(Card.IsLocation,nil,LOCATION_HAND)
	return #(sg&g)<2
end
function c26015010.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			c26015010.curgroup=Duel.GetMatchingGroup(c26015010.linkfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
			c26015010.curgroup:KeepAlive()
			return c26015010.curgroup
		end
	elseif chk==2 then
		if c26015010.curgroup then
			c26015010.curgroup:DeleteGroup()
		end
		c26015010.curgroup=nil
	end
end
function c26015010.remfilter(c)
	return c:IsSetCard(0x1615) and c:GetOriginalLevel()>=0
end
function c26015010.egfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x615)
end
function c26015010.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26015010.egfilter,1,nil,tp) or eg:IsContains(e:GetHandler())
end
function c26015010.thfilter(c,lv)
	return (c:IsCode(26015011) or c:ListsCode(26015011) and c:IsRitualMonster()) and c:IsAbleToHand()
end
function c26015010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26015010.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26015010.exfilter(c,lv)
	return c:IsRitualMonster() and c:GetLevel()~=lv
end
function c26015010.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26015010.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26015010.encon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),26015010)==0
end