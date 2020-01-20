local assets =
{
    Asset("ANIM", "anim/margarita.zip"),
	Asset("ATLAS", "images/inventoryimages/margarita.xml"),
    Asset("IMAGE", "images/inventoryimages/margarita.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

    inst.AnimState:SetBank("margarita")
    inst.AnimState:SetBuild("margarita")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "margarita"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/margarita.xml"
	
    inst:AddComponent("edible")
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = 0
	inst.components.edible.sanityvalue = 25
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    
    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunch(inst)

    return inst
end



STRINGS.NAMES.MARGARITA = "Margarita"
STRINGS.RECIPE_DESC.MARGARITA = "A Purple Mushroom Cocktail"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MARGARITA = "A special mushroom cocktail keeps you calm"


return Prefab("common/inventory/margarita", fn, assets, prefabs)
	
	
	
	
	

	
	

	