local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    
    Asset("ANIM", "anim/yuki.zip"),
    Asset("ANIM", "anim/yuki_moonnight.zip"),
    
    
    Asset("IMAGE", "images/names_yuki.tex"),
    Asset("ATLAS", "images/names_yuki.xml"),
    
    Asset("IMAGE", "images/saveslot_portraits/yuki.tex"),
    Asset("ATLAS", "images/saveslot_portraits/yuki.xml"),
    
    Asset("IMAGE", "images/selectscreen_portraits/yuki.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/yuki.xml"),
    
    Asset("IMAGE", "images/selectscreen_portraits/yuki_silho.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/yuki_silho.xml"),
    
    Asset("IMAGE", "bigportraits/yuki.tex"),
    Asset("ATLAS", "bigportraits/yuki.xml"),
    
    Asset("IMAGE", "images/map_icons/yuki.tex"),
    Asset("ATLAS", "images/map_icons/yuki.xml"),
    
    Asset("IMAGE", "images/avatars/avatar_yuki.tex"),
    Asset("ATLAS", "images/avatars/avatar_yuki.xml"),
    
    Asset("IMAGE", "images/avatars/avatar_ghost_yuki.tex"),
    Asset("ATLAS", "images/avatars/avatar_ghost_yuki.xml"),
    
    Asset("IMAGE", "images/avatars/self_inspect_yuki.tex"),
    Asset("ATLAS", "images/avatars/self_inspect_yuki.xml"),
    
    Asset("IMAGE", "images/names_yuki.tex"),
    Asset("ATLAS", "images/names_yuki.xml"),
    
    Asset("IMAGE", "bigportraits/yuki_none.tex"),
    Asset("ATLAS", "bigportraits/yuki_none.xml"),

}
local prefabs = {}

-- Custom starting inventory
local start_inv = {
    "ice",
	"ice_scythe",
}



-- Stats, static
TUNING.YUKI.HEALTH_MAX = 300
TUNING.YUKI.HUNGER_MAX = 225
TUNING.YUKI.SANITY_MAX = 250
TUNING.YUKI.SANITY_RATE_MULT = 1.4
TUNING.YUKI.SANITY_NEG_AURA_ABSORB = 0.3
TUNING.YUKI.MIN_TEMP = 10
TUNING.YUKI.MAX_TEMP = 100
TUNING.YUKI.OVERHEAT_TEMP = 40
TUNING.YUKI.START_TEMP = 15
TUNING.YUKI.COLD_RESISTANCE = 1000
TUNING.YUKI.HUNGER_HURT_RATE = 1.2
TUNING.YUKI.DIET = {FOODTYPE.VEGGIE, FOODTYPE.DRINK, FOODTYPE.SEEDS, FOODTYPE.GENERIC, FOODTYPE.GOODIES}


-- Stats for Yuki
TUNING.YUKI.HUNGER_RATE = TUNING.WILSON_HUNGER_RATE * 1.2
TUNING.YUKI.WALK_SPEED = 4
TUNING.YUKI.RUN_SPEED = 6
TUNING.YUKI.HEALTH_ABSORB = 0.25 -- 1 means 100% absorb: no harm
TUNING.YUKI.FIRE_DAMAGE_SCALE = 1.1 -- 1 means 100% damage: full damage
TUNING.YUKI.HIT_RANGE = 5
TUNING.YUKI.HEATER_TEMP = -20
TUNING.YUKI.DAMAGE_MULTIPLIER = TUNING.WENDY_DAMAGE_MULT * 2 -- Calc: 0.75 * 2 = 1.5

TUNING.YUKI.HARM_BACK_RATE = 0.6
TUNING.YUKI.HARM_BACK_CHANCE = 0.6
TUNING.YUKI.AREA_FREEZE_CHANCE = 0.2
TUNING.YUKI.AREA_FREEZE_TIME = 6
TUNING.YUKI.AREA_FREEZE_RANGE = 6

TUNING.YUKI.SANITY_WINTER = 0.15
TUNING.YUKI.SANITY_RAINING = 0.15
TUNING.YUKI.SANITY_WINTER_RAINING = 0.25
TUNING.YUKI.SANITY_SUMMER = -0.2




local function OnSeason(inst, season)
    if season == "winter" then
        SpawnPrefab("deer_ice_burst").Transform:SetPosition(inst:GetPosition():Get())
        inst.components.health:StartRegen(5, 10)
        inst.components.health:SetAbsorptionAmount(0.5)
        inst.components.locomotor.runspeed = 7
        inst.components.talker:Say("My season! My winter! My paradise!")
    else
        SpawnPrefab("deer_ice_burst").Transform:SetPosition(inst:GetPosition():Get())
        inst.components.health:StartRegen(1, 10)
        inst.components.health:SetAbsorptionAmount(0)
        inst.components.talker:Say("Owwww~ I'm waiting for my Winny!")
        inst.components.locomotor.runspeed = 6
    end
end


local function OnPhase(inst)
    if TheWorld.state.phase == "day" then
		return
    elseif TheWorld.state.phase == "dusk" then
		return
    elseif TheWorld.state.phase == "night" then
		return
    end
end



local function IsValidVictim(victim)
    return victim ~= nil and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or victim:HasTag("veggie") or victim:HasTag("structure") or victim:HasTag("wall") or victim:HasTag("companion")) and victim.components.health ~= nil and victim.components.combat ~= nil
end

local function SpawnSpirit(inst, x, y, z, scale)
    local fx = SpawnPrefab("wathgrithr_spirit")
    fx.Transform:SetPosition(x, y, z)
    fx.Transform:SetScale(scale, scale, scale)
end

local function SpawnIceSpike(inst, x, y, z, scale)
	local rand = math.random(1, 4)
	local fx = SpawnPrefab("icespike_fx_" .. rand)
	
    fx.Transform:SetPosition(x, y, z)
    fx.Transform:SetScale(scale, scale, scale)
end



local function Scale(victim)
    local smallScale = 1
    local medScale = 1.3
    local largeScale = 1.6
	local superScale = 2.8

	return (victim:HasTag("smallcreature") and smallScale) or (victim:HasTag("largecreature") and largeScale) or (victim:HasTag("epic") and superScale) or medScale
end


local function OnKilled(inst, data)
	
    if IsValidVictim(data.victim) then
        local time = data.victim.components.health.destroytime or 2
        local x, y, z = data.victim.Transform:GetWorldPosition()
        local scale = Scale(data.victim)
        inst:DoTaskInTime(time, SpawnSpirit, x, y, z, scale)
    elseif not IsValidVictim(data.victim) then
        inst.components.sanity:DoDelta(-20)
        inst.components.talker:Say("I'm so sorry cutie!")
	end
	
end


local function OnEat(inst, food)
	if food.prefab == "red_cap" then
        SpawnPrefab("spore_small").Transform:SetPosition(inst:GetPosition():Get())
        inst.components.talker:Say("Nice choice~")
	elseif food.prefab == "red_cap_cooked" then
        SpawnPrefab("spore_small").Transform:SetPosition(inst:GetPosition():Get())
        inst.components.talker:Say("I'm backing to life!")
    elseif food.prefab == "green_cap" then
        SpawnPrefab("spore_small").Transform:SetPosition(inst:GetPosition():Get())
        inst.components.talker:Say("Oh~ Confy~")
    elseif food.prefab == "green_cap_cooked" then
        SpawnPrefab("spore_small").Transform:SetPosition(inst:GetPosition():Get())
        inst.components.talker:Say("Oh~ Look at my little belly!")
    elseif food.prefab == "blue_cap" then
        SpawnPrefab("spore_tall").Transform:SetPosition(inst:GetPosition():Get())
        inst.components.talker:Say("It's very good for my brain~")
    elseif food.prefab == "blue_cap_cooked" then
        SpawnPrefab("spore_tall").Transform:SetPosition(inst:GetPosition():Get())
        inst.components.talker:Say("Keeping my mind more aware!")
    elseif food.prefab == "ratatouille" then
        inst.components.talker:Say("V E G G I E everywhere~")
    elseif food.prefab == "watermelonicle" then
        inst.components.talker:Say("What a sweet ice candy~")
    elseif food.prefab == "icecream" then
        inst.components.talker:Say("Yummy~")
    elseif food.prefab == "ice" then
        inst.components.talker:Say("My heaven~")
    end
end

local function SanityFn(inst)
	if TheWorld.state.iswinter and TheWorld.state.israining then	
		return TUNING.YUKI.SANITY_WINTER_RAINING
	elseif TheWorld.state.iswinter then
			return TUNING.YUKI.SANITY_WINTER
	elseif TheWorld.state.israining then -- Raining sanity boost
		return TUNING.YUKI.SANITY_RAINING
	elseif TheWorld.state.issummer then 
			return TUNING.YUKI.SANITY_SUMMER
	elseif inst.components.temperature.current > 25 then
		return TUNING.DAPPERNESS_SMALL * -1.5
	else
		return 0
	end
end


local function DoAreaFreeze(inst, range, time)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, range)
	for i, v in ipairs(ents) do
		if v.components.freezable ~= nil then
			if not (v:HasTag("player") or v:HasTag("playerghost")) then
				v.components.freezable:Freeze(time + math.random())
			end
		end
	end
end

local function OnAttacked(inst, data)

	local rand = math.random(0, 100)

	if rand <= (TUNING.YUKI.AREA_FREEZE_CHANCE + 0) * 100 and (inst.components.health:GetPercent() <= 0.2 or inst.components.health.maxhealth * 0.2 <= data.damageresolved) then
		
		DoAreaFreeze(inst, TUNING.YUKI.AREA_FREEZE_RANGE, TUNING.YUKI.AREA_FREEZE_TIME)

	elseif rand <= (TUNING.YUKI.HARM_BACK_CHANCE + TUNING.YUKI.AREA_FREEZE_CHANCE) * 100 then
		
		-- Harm back
		if data.attacker.components.health ~= nil then
			data.attacker.components.health:DoDelta(data.damageresolved * TUNING.YUKI.HARM_BACK_RATE * -1)
		end

		if data.attacker.components.freezable ~= nil then
			data.attacker.components.freezable:AddColdness(data.attacker.components.freezable.resistance * 0.5)
			
			if not data.attacker.components.freezable:IsFrozen() then
				local x, y, z = data.attacker.Transform:GetWorldPosition()
				local scale = Scale(data.attacker)
				inst:DoTaskInTime(0, SpawnIceSpike, x, y, z, scale)
			end
		end

	end
	

end


local function OnHitOther(inst, data)
	if not inst.components.health:IsDead() then

		-- Return sanity
		inst.components.sanity:DoDelta(3)
		
		-- Initialize loot for target
		if data.target.components.lootdropper.loot == nil then
			data.target.components.lootdropper.loot = {}
		end

		local rand = math.random(0, 15)
        if rand == 2 or rand == 4 or rand == 6 or rand == 8 then-- 1/10 chance to get lightbulb on this hit
			table.insert(data.target.components.lootdropper.loot, "lightbulb")

		elseif rand == 0 or rand == 15 and (data.target.prefab == "dragonfly") then
			table.insert(data.target.components.lootdropper.loot, "watermelonicle")

		elseif rand == 10 and (TheWorld.state.issummer and data.target.components.health.maxhealth > 800) then
			table.insert(data.target.components.lootdropper.loot, "coconut")

		elseif rand == 12 and (TheWorld.state.issummer or TheWorld.state.issnowcovered) then
			table.insert(data.target.components.lootdropper.loot, "ice")

		elseif rand == 14 and (TheWorld.state.issummer and data.target.components.health.maxhealth > 400) then
			table.insert(data.target.components.lootdropper.loot, "icecream")
		elseif rand == 14 and (TheWorld.state.issummer and data.target.components.health.maxhealth > 800) then
			table.insert(data.target.components.lootdropper.loot, "watermelon")
		elseif rand == 14 and (TheWorld.state.issummer and data.target.components.health.maxhealth > 1200) then
			table.insert(data.target.components.lootdropper.loot, "watermelonicle")
		end

		print(rand)
		
    end
end




-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst)
        -- Minimap icon
        inst.MiniMapEntity:SetIcon("yuki.tex")
        
        inst:AddTag("fridge")
        inst:AddTag("boomerangbuilder")
        inst:RemoveTag("scarytoprey")
        inst:AddTag("yuki")
        inst:AddTag("snowflake")
        inst:AddTag("mushroom")

end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
        
        math.randomseed(tostring(os.time()):reverse():sub(1, 9))
        
        
        -- choose which sounds this character will play
        inst.soundsname = "tecolin"
		
		
        -- Stats
        inst.components.health:SetMaxHealth(TUNING.YUKI.HEALTH_MAX)
        inst.components.hunger:SetMax(TUNING.YUKI.HUNGER_MAX)
		inst.components.sanity:SetMax(TUNING.YUKI.SANITY_MAX)
		inst.components.sanity.rate_modifier = TUNING.YUKI.SANITY_RATE_MULT
		inst.components.sanity.neg_aura_absorb = TUNING.YUKI.SANITY_NEG_AURA_ABSORB
        inst.components.temperature.maxtemp = TUNING.YUKI.MAX_TEMP
        inst.components.temperature.mintemp = TUNING.YUKI.MIN_TEMP
        inst.components.temperature.overheattemp = TUNING.YUKI.OVERHEAT_TEMP
		inst.components.temperature.current = TUNING.YUKI.START_TEMP
		inst.components.freezable:SetResistance(TUNING.YUKI.COLD_RESISTANCE)
        inst.components.eater:SetDiet({FOODGROUP.OMNI}, TUNING.YUKI.DIET)
        
        inst.components.locomotor.walkspeed = TUNING.YUKI.WALK_SPEED
        inst.components.locomotor.runspeed = TUNING.YUKI.RUN_SPEED
        inst.components.hunger.hungerrate = TUNING.YUKI.HUNGER_RATE
        inst.components.health.absorb = TUNING.YUKI.HEALTH_ABSORB
        inst.components.health.fire_damage_scale = TUNING.YUKI.FIRE_DAMAGE_SCALE
        inst.components.combat.hitrange = TUNING.YUKI.HIT_RANGE
		inst.components.combat.attackrange = TUNING.YUKI.HIT_RANGE
		inst.components.combat.damagemultiplier = TUNING.YUKI.DAMAGE_MULTIPLIER
        
        
        -- Cold others
        inst:AddComponent("heater")
        inst.components.heater.heatfn = function() return TUNING.YUKI.HEATER_TEMP end
		inst.components.heater:SetThermics(false, true)
		
        
        -- Night light
        inst.entity:AddLight()
        inst.Light:Enable(true)
        inst.Light:SetRadius(3.5)
        inst.Light:SetFalloff(0.7)
        inst.Light:SetIntensity(0.55)
        inst.Light:SetColour(120 / 255, 170 / 255, 102 / 255)
        
        
        inst.components.eater:SetOnEatFn(OnEat)
        inst.components.sanity.custom_rate_fn = SanityFn
        
        
        inst:WatchWorldState("season", OnSeason)
        inst:WatchWorldState("phase", OnPhase)
        inst:ListenForEvent("killed", OnKilled)
        inst:ListenForEvent("attacked", OnAttacked)
        inst:ListenForEvent("onhitother", OnHitOther)





end



-- YUKI Info
-- The character select screen lines
STRINGS.CHARACTER_TITLES.yuki = "The Light Snowflake"
STRINGS.CHARACTER_NAMES.yuki = "Yuki"
STRINGS.CHARACTER_DESCRIPTIONS.yuki = "A snowflake\nBorn in snowland\nCan craft specials with Mushroom and Ice"
STRINGS.CHARACTER_QUOTES.yuki = "\"Snowflakes are the kisses from Heaven...\""

-- Custom speech strings
STRINGS.CHARACTERS.yuki = require "speech_yuki"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.yuki =
{
	GENERIC = "She's Yuki!",
	ATTACKER = "The snowflake must be back to Heaven!",
	MURDERER = "I feel warmer",
	REVIVER = "Too cute to be dead~",
	GHOST = "Ice Heart?!",
}


-- The character's name as appears in-game 
STRINGS.NAMES.yuki = "Yuki"
STRINGS.SKIN_NAMES.yuki = "Yuki"


return MakePlayerCharacter("yuki", prefabs, assets, common_postinit, master_postinit, start_inv)
