PrefabFiles = {
	"yuki",
	"yuki_none",
	"ice_scythe"
}

Assets = {

}

RemapSoundEvent( "dontstarve/characters/tecolin/death_voice", "tecolin/characters/tecolin/death_voice" )
RemapSoundEvent( "dontstarve/characters/tecolin/hurt", "tecolin/characters/tecolin/hurt" )
RemapSoundEvent( "dontstarve/characters/tecolin/talk_LP", "tecolin/characters/tecolin/talk_LP" )
RemapSoundEvent( "dontstarve/characters/tecolin/emote", "tecolin/characters/tecolin/emote" )
RemapSoundEvent( "dontstarve/characters/tecolin/ghost_LP", "tecolin/characters/tecolin/ghost_LP" )
RemapSoundEvent( "dontstarve/characters/tecolin/yawn", "tecolin/characters/tecolin/yawn" )
RemapSoundEvent( "dontstarve/characters/tecolin/pose", "tecolin/characters/tecolin/pose" )



-- Variables
local require = GLOBAL.require
local Vector3 = GLOBAL.Vector3
local STRINGS = GLOBAL.STRINGS
local FOODTYPE = GLOBAL.FOODTYPE
local FOODGROUP = GLOBAL.FOODGROUP
local TECH = GLOBAL.TECH
local ACTIONS = GLOBAL.ACTIONS
local Action = GLOBAL.Action
local STRINGS = GLOBAL.STRINGS
local ActionHandler = GLOBAL.ActionHandler

GLOBAL.TUNING.YUKI = {}
GLOBAL.TUNING.ICE_SCYTHE = {}
FOODTYPE.DRINK = "DRINK"



-- Food re-valued

AddPrefabPostInit("red_cap", function(inst)
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 10
end)
AddPrefabPostInit("green_cap", function(inst)
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 10
    inst.components.edible.healthvalue = 0
end
)
AddPrefabPostInit("blue_cap", function(inst)
    inst.components.edible.sanityvalue = 10
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 0
end
)

AddPrefabPostInit("red_cap_cooked", function(inst)
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 20
end
)
AddPrefabPostInit("green_cap_cooked", function(inst)
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 20
    inst.components.edible.healthvalue = 0
end
)
AddPrefabPostInit("blue_cap_cooked", function(inst)
    inst.components.edible.sanityvalue = 20
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 0
end
)



-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("yuki", "FEMALE")
