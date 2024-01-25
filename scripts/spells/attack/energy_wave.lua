local function formulaFunction(player, level, maglevel)
	local min = (level / 5) + (maglevel * 4.5)
	local max = (level / 5) + (maglevel * 9)
	return -min, -max
end

function onGetFormulaValues(player, level, maglevel)
	return formulaFunction(player, level, maglevel)
end

function onGetFormulaValuesWOD(player, level, maglevel)
	return formulaFunction(player, level, maglevel)
end

local function createCombat(area, areaDiagonal, combatFunc)
	local initCombat = Combat()
	initCombat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, combatFunc)
	initCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
	initCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
	initCombat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
	initCombat:setArea(createCombatArea(area, areaDiagonal))
	return initCombat
end

local AREA_SQUAREWAVE5_LOCAL = {
	{ 1, 1, 1 },
	{ 1, 1, 1 },
	{ 1, 1, 1 },
	{ 0, 1, 0 },
	{ 0, 3, 0 },
}
local AREADIAGONAL_SQUAREWAVE5_LOCAL = {
	{ 1, 1, 1, 0, 0 },
	{ 1, 1, 1, 0, 0 },
	{ 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 0 },
	{ 0, 0, 0, 0, 3 },
}
local AREA_WAVE7_LOCAL = {
	{ 1, 1, 1, 1, 1 },
	{ 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 3, 0, 0 },
}
local AREADIAGONAL_WAVE7_LOCAL = {
	{ 0, 0, 0, 0, 0, 1, 0 },
	{ 0, 0, 0, 0, 1, 1, 0 },
	{ 0, 0, 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 0, 0, 0, 0, 3 },
}
local combat = createCombat(AREA_SQUAREWAVE5_LOCAL, AREADIAGONAL_SQUAREWAVE5_LOCAL, "onGetFormulaValues")
local combatWOD = createCombat(AREA_WAVE7_LOCAL, AREADIAGONAL_WAVE7_LOCAL, "onGetFormulaValuesWOD")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local player = creature:getPlayer()
	if creature and player then
		if player:getWheelSpellAdditionalArea("Energy Wave") then
			return combatWOD:execute(creature, var)
		end
	end
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(13)
spell:name("Energy Wave")
spell:words("exevo vis hur")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_ENERGY_WAVE)
spell:level(38)
spell:mana(170)
spell:needDirection(true)
spell:cooldown(8 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
