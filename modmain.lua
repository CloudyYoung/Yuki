PrefabFiles = {
	"yuki",
	"yuki_none",
    "ice_scythe",
    "ice_armor",
    "frost_hat",
    "garden_lantern",
    "margarita",
    "mushroom_soup",
}

Assets = {
    Asset("IMAGE", "images/hud/snowflaketab.tex"),
    Asset("ATLAS", "images/hud/snowflaketab.xml"),
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
end)
AddPrefabPostInit("blue_cap", function(inst)
    inst.components.edible.sanityvalue = 10
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 0
end)
AddPrefabPostInit("red_cap_cooked", function(inst)
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 20
end)
AddPrefabPostInit("green_cap_cooked", function(inst)
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 20
    inst.components.edible.healthvalue = 0
end)
AddPrefabPostInit("blue_cap_cooked", function(inst)
    inst.components.edible.sanityvalue = 20
    inst.components.edible.hungervalue = 0
    inst.components.edible.healthvalue = 0
end)



-- Yuki Tech
local YUKI_TECH = AddRecipeTab("Yuki Tech", 998, "images/hud/snowflaketab.xml", "snowflaketab.tex", "yuki")

local garden_lantern_recipe = AddRecipe("garden_lantern", {Ingredient("ice", 10), Ingredient("lightbulb", 30), Ingredient("moonrocknugget", 6)}, YUKI_TECH, TECH.NONE, "garden_lantern_placer", 8, nil, nil, nil, "images/inventoryimages/garden_lantern.xml", "garden_lantern.tex")

local ice_armor_recipe = AddRecipe("ice_armor", {Ingredient("ice", 20), Ingredient("moonrocknugget", 8), Ingredient("heatrock", 1)}, YUKI_TECH, TECH.NONE, nil, nil, nil, nil, nil, "images/inventoryimages/ice_armor.xml", "ice_armor.tex") 

local ice_scythe_recipe = AddRecipe("ice_scythe", {Ingredient("ice", 20), Ingredient("cane", 1), Ingredient("moonrocknugget", 6), Ingredient("lightbulb", 30)}, YUKI_TECH, TECH.NONE,nil, nil, nil, nil, nil, "images/inventoryimages/ice_scythe.xml","ice_scythe.tex") 

local frost_hat_recipe = AddRecipe("frost_hat", {Ingredient("ice", 10), Ingredient("moonrocknugget", 4), Ingredient("lightbulb", 30)}, YUKI_TECH, TECH.NONE, nil, nil, nil, nil, nil, "images/inventoryimages/frost_hat.xml","frost_hat.tex") 


local mushroom_soup = {
    name = "mushroom_soup",
    test = function(cooker, names, tags) return names.red_cap and names.red_cap >= 1 and names.blue_cap and names.blue_cap >= 1 and names.green_cap and names.green_cap >= 1 and tags.veggie >= 2 end,
	priority = 10,
	weight = 1,
	cooktime = 2.5,
}
local margarita = {
	name = "margarita",
	test = function(cooker, names, tags) return names.blue_cap and names.blue_cap >= 2 and names.ice and names.ice >= 2 end,
	priority = 10,
	weight = 1,
	cooktime = 1.5,
}

AddCookerRecipe("cookpot", mushroom_soup)
AddCookerRecipe("cookpot", margarita)





-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("yuki", "FEMALE")
