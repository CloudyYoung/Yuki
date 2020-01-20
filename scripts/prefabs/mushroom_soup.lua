local assets =
{
    Asset("ANIM", "anim/mushroom_soup.zip"),
	Asset("ATLAS", "images/inventoryimages/mushroom_soup.xml"),
    Asset("IMAGE", "images/inventoryimages/mushroom_soup.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

    inst.AnimState:SetBank("lollipop")
    inst.AnimState:SetBuild("lollipop")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "mushroom_soup"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mushroom_soup.xml"
	
    inst:AddComponent("edible")
	inst.components.edible.healthvalue = 20
	inst.components.edible.hungervalue = 10
	inst.components.edible.sanityvalue = 10
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    
    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunch(inst)

    return inst
end



STRINGS.NAMES.MUSHROOM_SOUP = "Mushroom Soup"
STRINGS.RECIPE_DESC.MUSHROOM_SOUP = "A Purple Mushroom soup"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUSHROOM_SOUP = "Warms your body in such cold world"


return Prefab("common/inventory/mushroom_soup", fn, assets, prefabs)
	
	
	
	
	

	
	

	