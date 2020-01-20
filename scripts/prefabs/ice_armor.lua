local assets=
{
	Asset("ANIM", "anim/ice_armor.zip"),
	Asset("ANIM", "anim/swap_ice_armor.zip"),
	Asset("ATLAS", "images/inventoryimages/ice_armor.xml"),
	Asset("IMAGE", "images/inventoryimages/ice_armor.tex"),
}

local prefabs = 
{
	
}

local function OnBlocked(owner) 
	owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function OnEquip(inst, owner) 
	owner.AnimState:OverrideSymbol("swap_body", "armormosquito", "swap_body")
	inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function OnUnequip(inst, owner) 
	owner.AnimState:ClearOverrideSymbol("swap_body")
	inst:RemoveEventCallback("blocked", OnBlocked, owner)
end


	


local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("torso_hawaiian")
	inst.AnimState:SetBuild("armormosquito2")
	inst.AnimState:PlayAnimation("anim")

	inst.foleysound = "dontstarve/movement/foley/logarmour"

	if not TheWorld.ismastersim then
		return inst
	end

	inst.entity:SetPristine()
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ice_armor.xml"
	inst.components.inventoryitem.imagename = "ice_armor"

	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
	inst.components.insulator:SetSummer()

	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)

	inst:AddComponent("armor")
	inst.components.armor:InitCondition(TUNING.ARMORMARBLE, 0.3)

	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)

    return inst
end



STRINGS.NAMES.ICE_ARMOR = "Ice Armor"
STRINGS.RECIPE_DESC.ICE_ARMOR = "Yuki's coat"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICE_ARMOR = "It looks cold!"

	
return Prefab( "common/inventory/ice_armor", fn, assets, prefabs) 
