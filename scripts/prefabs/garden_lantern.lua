

local assets=
{
    Asset("ANIM", "anim/garden_lantern.zip"),
    Asset("ATLAS", "images/inventoryimages/garden_lantern.xml"),
    Asset("IMAGE", "images/inventoryimages/garden_lantern.tex"),
}

local prefabs = 
{
	
}


local function OnHit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hammered")
        inst.AnimState:PushAnimation("idle")
    end
end

local function OnHammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	SpawnPrefab("deer_ice_burst").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_up")
	inst:Remove()
end

local function OnBuild(inst)
    inst.AnimState:PlayAnimation("building")
    inst.AnimState:PushAnimation("idle")             
end


local function OnRemove(inst)
    if inst._light ~= nil and inst._light:IsValid() then
        inst._light:Remove()
    end
end
--------------------------------------

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:AddTag("structure")
    inst:AddTag("light")
    inst.entity:SetPristine()

    MakeSmallPropagator(inst)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("garden_lantern.tex")

    inst.AnimState:SetBank("gardenlantern")
    inst.AnimState:SetBuild("gardenlantern")
    inst.AnimState:PlayAnimation("idle")


    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(6)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    inst:ListenForEvent("OnBuild", OnBuild)

    inst:AddTag("FX")

    inst.entity:AddLight()
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
    inst.Light:SetRadius(10)
    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(0.8)


    MakeHauntableWork(inst)
    inst.OnRemoveEntity = OnRemove

    return inst
end


STRINGS.NAMES.GARDEN_LANTERN = "Garden Lanter"
STRINGS.RECIPE_DESC.GARDEN_LANTERN = "Shines like a moon" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GARDEN_LANTERN = "It shines like a moon"


return Prefab( "common/objects/garden_lantern", fn, assets, prefabs),
MakePlacer( "common/garden_lantern_placer", "gardenlantern", "gardenlantern", "idle" )