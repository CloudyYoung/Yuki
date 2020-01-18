local assets =
{
	Asset( "ANIM", "anim/yuki.zip" ),
	Asset( "ANIM", "anim/ghost_yuki_build.zip" ),

	Asset( "IMAGE", "images/avatars/avatar_ghost_yuki.tex" ),
	Asset( "ATLAS", "images/avatars/avatar_ghost_yuki.xml" ),

}

local skins =
{
	normal_skin = "yuki",
	ghost_skin = "ghost_yuki_build",
}

return CreatePrefabSkin("yuki_none",
{
	base_prefab = "yuki",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"YUKI", "CHARACTER", "BASE"},
	build_name_override = "yuki",
	rarity = "Character",
})