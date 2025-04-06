--Renmity of Flesh
function c26015002.initial_effect(c)
	--Special Summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26015002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,26015002)
	e1:SetCost(c26015002.spcost)
	e1:SetTarget(c26015002.sptg1)
	e1:SetOperation(c26015002.spop1)
	c:RegisterEffect(e1)
	--special summon other
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26015002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,{26015002,1})
	e2:SetTarget(c26015002.sptg2)
	e2:SetOperation(c26015002.spop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--ATK down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetDescription(aux.Stringid(26015002,2))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_DAMAGE_STEP)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(c26015002.atcon)
	e5:SetCost(c26015002.atcost)
	e5:SetOperation(c26015002.atop)
	c:RegisterEffect(e5)
end
--ATK down
function c26015002.atcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	if a:IsControler(tp) then a,d=d,a end
	return a and d and a:IsAttackAbove(1)
	and (d:IsRace(RACE_ZOMBIE) or d:IsRitualMonster())
end
function c26015002.atfilter(c)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	return c:IsMonster() and c:IsLevelAbove(1) and c~=a and c~=d
end
function c26015002.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26015002.atfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(26015002)==0 and
		Duel.CheckReleaseGroupCost(tp,c26015002.atfilter,1,true,aux.ReleaseCheckTarget,nil,g)
	end
	c:RegisterFlagEffect(26015002,RESET_PHASE+PHASE_DAMAGE,0,1)
	local sg=Duel.SelectReleaseGroupCost(tp,c26015002.atfilter,1,99,true,aux.ReleaseCheckTarget,nil,g)
	e:SetLabel(sg:GetSum(Card.GetLevel)*-400)
	Duel.Release(sg,REASON_COST)
end
function c26015002.atop(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(e:GetLabel())
	if a:GetControler()==tp then
		d:RegisterEffect(e1)
	else
		a:RegisterEffect(e1)
	end
end
function c26015002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local op=(tp~=Duel.GetTurnPlayer())
	if chk==0 then return op or Duel.IsPlayerAffectedByEffect(tp,26015010) end
	if not op then
		Duel.Hint(HINT_CARD,1-tp,26015010)
		Duel.RegisterFlagEffect(tp,26015010,RESET_PHASE+PHASE_END,0,1)
	end
end
function c26015002.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26015002.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26015002.spfilter2(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c26015002.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26015002.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26015002.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26015002.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		if not tc:IsRace(RACE_ZOMBIE) then
			--Cannot change their battle positions
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3313)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.ConfirmCards(1-tp,tc)
	end
end