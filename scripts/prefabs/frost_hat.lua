local assets =
{ 
    Asset("ANIM", "anim/frost_hat.zip"),
    Asset("ANIM", "anim/frost_hat_swap.zip"), 
    Asset("ATLAS", "images/inventoryimages/frost_hat.xml"),
    Asset("IMAGE", "images/inventoryimages/frost_hat.tex"),
}

local prefabs = 
{

}

local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "pupemushhat", "swap_hat")
	
	
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        if TheSim:GetGameID()=="DST" then
			owner.AnimState:Show("HEAD_HAT")
		else
			owner.AnimState:Show("HEAD_HAIR")
		end
    end
end

local function OnUnequip(inst, owner) 

    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        if TheSim:GetGameID()=="DST" then
			owner.AnimState:Hide("HEAD_HAT")
		else
			owner.AnimState:Hide("HEAD_HAIR")
		end
    end
end

local function fn()

    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hollowhat")
    inst.AnimState:SetBuild("hollowhat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")

	if TheSim:GetGameID()=="DST" then
		inst.entity:AddNetwork()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.entity:SetPristine()
		
		MakeHauntableLaunch(inst)
	end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "frost_hat"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/frost_hat.xml"
    
	inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMOR_WATHGRITHRHAT, TUNING.ARMOR_WATHGRITHRHAT_ABSORPTION * 0.2)

    -- inst:AddComponent("waterproofer")
    -- inst.components.waterproofer:SetEffectiveness(1)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

	
    return inst
end



STRINGS.NAMES.FROST_HAT = "Frost Hat"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROST_HAT = "Yuki's hat"
STRINGS.RECIPE_DESC.FROST_HAT = "It looks cold!"


return  Prefab("common/inventory/frost_hat", fn, assets, prefabs)