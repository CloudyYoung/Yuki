local assets=
{
    Asset("ANIM", "anim/ice_scythe.zip"),
    Asset("ANIM", "anim/swap_ice_scythe.zip"),
    Asset("ATLAS", "images/inventoryimages/ice_scythe.xml"),
    Asset("IMAGE", "images/inventoryimages/ice_scythe.tex"),
}

local prefabs = 
{
	
}



TUNING.ICE_SCYTHE.DAMAGE = TUNING.RUINS_BAT_DAMAGE * 0.75
TUNING.ICE_SCYTHE.HIT_RANGE = TUNING.TOADSTOOL_SPOREBOMB_HIT_RANGE
TUNING.ICE_SCYTHE.WALK_SPPED_MULT = TUNING.CANE_SPEED_MULT
TUNING.ICE_SCYTHE.FREEZE_CHANCE = 0.2


local function OnAttack(inst, attacker, target)

    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.burnable ~= nil then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end

    local rand = math.random(0, 100)
	if rand <= TUNING.ICE_SCYTHE.FREEZE_CHANCE * 100  then
        if target.components.freezable ~= nil then
            target.components.freezable:AddColdness(20)
            -- target.components.freezable:Freeze(time + math.random())
        end
	end
end


local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_sanspear", "swap_sanspear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

 

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end



local function Scale(victim)
    local smallScale = 1
    local medScale = 1.3
    local largeScale = 1.6
	local superScale = 2.8

	return (victim:HasTag("smallcreature") and smallScale) or (victim:HasTag("largecreature") and largeScale) or (victim:HasTag("epic") and superScale) or medScale
end

local function SpawnIceHit(inst, x, y, z, scale)
	local fx = SpawnPrefab("mining_ice_fx")
	
    fx.Transform:SetPosition(x, y, z)
    fx.Transform:SetScale(scale, scale, scale)
end

local function SwingSpell(inst, attacker, target)
    attacker.SoundEmitter:PlaySound("dontstarve/wilson/attack_icestaff")

    local x, y, z = target.Transform:GetWorldPosition()
    local scale = Scale(target)
    inst:DoTaskInTime(0, SpawnIceHit, x, y, z, scale)
end


local function fn()

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)   
      
    inst.AnimState:SetBank("sanspear")
    inst.AnimState:SetBuild("sanspear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("extinguisher")
    inst:AddTag("rangedweapon")
    inst:AddTag("icestaff")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()
     
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.ICE_SCYTHE.DAMAGE)
    inst.components.weapon:SetRange(TUNING.ICE_SCYTHE.HIT_RANGE, TUNING.ICE_SCYTHE.HIT_RANGE)
    inst.components.weapon:SetOnAttack(OnAttack)
    inst.components.weapon:SetProjectile("ice_projectile")
    inst.components.weapon:SetOnProjectileLaunch(SwingSpell)

    inst:AddComponent("inspectable")
      
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.keepondeath = true
    inst.components.inventoryitem.imagename = "ice_scythe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ice_scythe.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT

    inst:AddTag("waterproofer")
    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(1)

    MakeHauntableLaunch(inst)
    
    inst:RemoveComponent("hauntable") -- not hauntable

    return inst
end



STRINGS.NAMES.ICE_SCYTHE = "Ice Scythm"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICE_SCYTHE = "Oh, frigidity."
STRINGS.RECIPE_DESC.ICE_SCYTHE = "An ice scythme of sharpness and frigidity"




return  Prefab("common/inventory/ice_scythe", fn, assets, prefabs) 