local modname = core.get_current_modname()
local S = function(s) return s end

local function reg(name, def)
	def.groups = def.groups or {cracky = 2}
	def.sounds = def.sounds or default.node_sound_stone_defaults()
	core.register_node(modname .. ":" .. name, def)
end

-- Панели
reg("panel", {description = "Panel Wall", tiles = {"khrushchevka_panel.png"}})
reg("panel_seam", {description = "Panel Wall (seams)", tiles = {"khrushchevka_panel_seam.png"}})
reg("panel_beige", {description = "Beige Panel Wall", tiles = {"khrushchevka_panel_beige.png"}})
reg("panel_blue", {description = "Blue Panel Wall", tiles = {"khrushchevka_panel_blue.png"}})

-- Силикатный кирпич
reg("brick_silicate", {description = "Silicate Brick", tiles = {"khrushchevka_brick.png"}})

-- Кровля, асфальт, внутренняя отделка
reg("roof_bitumen", {description = "Bitumen Roof", tiles = {"khrushchevka_roof.png"}})
reg("asphalt", {description = "Asphalt", tiles = {"khrushchevka_asphalt.png"}})
reg("linoleum", {
	description = "Linoleum", tiles = {"khrushchevka_linoleum.png"},
	groups = {crumbly = 3}, sounds = default.node_sound_dirt_defaults(),
})
reg("wallpaper", {
	description = "Wallpaper", tiles = {"khrushchevka_wallpaper.png"},
	groups = {choppy = 3, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
})

-- Окно: стекло в раме (прозрачное)
reg("window", {
	description = "Window",
	drawtype = "glasslike_framed",
	tiles = {"khrushchevka_window_frame.png", "khrushchevka_window_glass.png"},
	paramtype = "light",
	sunlight_propagates = true,
	use_texture_alpha = "blend",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})

-- Балконная плита
reg("balcony_slab", {
	description = "Balcony Slab",
	drawtype = "nodebox",
	tiles = {"khrushchevka_panel.png"},
	paramtype = "light",
	node_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5}},
})

-- Балконное ограждение
reg("balcony_rail", {
	description = "Balcony Railing",
	drawtype = "nodebox",
	tiles = {"khrushchevka_rail.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {type = "fixed", fixed = {
		{-0.5, -0.5, -0.5, 0.5, 0.5, -0.4},
	}},
	groups = {cracky = 3},
	sounds = default.node_sound_metal_defaults(),
})

-- Ступени и плиты
stairs.register_stair_and_slab("panel", modname .. ":panel",
	{cracky = 2}, {"khrushchevka_panel.png"},
	"Panel Stair", "Panel Slab", default.node_sound_stone_defaults())
stairs.register_stair_and_slab("brick_silicate", modname .. ":brick_silicate",
	{cracky = 2}, {"khrushchevka_brick.png"},
	"Silicate Brick Stair", "Silicate Brick Slab", default.node_sound_stone_defaults())

-- Крафты
local cobble, sand, stone = "default:cobble", "default:sand", "default:stone"
core.register_craft({output = modname .. ":panel 4",
	recipe = {{stone, stone}, {stone, stone}}})
core.register_craft({output = modname .. ":panel_seam 2",
	recipe = {{modname .. ":panel"}, {modname .. ":panel"}}})
core.register_craft({output = modname .. ":panel_beige",
	type = "shapeless", recipe = {modname .. ":panel", "dye:yellow"}})
core.register_craft({output = modname .. ":panel_blue",
	type = "shapeless", recipe = {modname .. ":panel", "dye:blue"}})
core.register_craft({output = modname .. ":brick_silicate 4",
	recipe = {{sand, stone}, {stone, sand}}})
core.register_craft({output = modname .. ":roof_bitumen 4",
	recipe = {{"default:coal_lump", "default:coal_lump"}, {"default:gravel", "default:gravel"}}})
core.register_craft({output = modname .. ":asphalt 4",
	recipe = {{"default:coal_lump", "default:gravel"}, {"default:gravel", "default:coal_lump"}}})
core.register_craft({output = modname .. ":linoleum 4",
	recipe = {{"default:paper", "dye:brown"}, {"default:paper", "default:paper"}}})
core.register_craft({output = modname .. ":wallpaper 4",
	recipe = {{"default:paper", "default:paper"}, {"default:paper", "dye:green"}}})
core.register_craft({output = modname .. ":window 2",
	recipe = {{"default:steel_ingot", "default:glass"}, {"default:glass", "default:steel_ingot"}}})
core.register_craft({output = modname .. ":balcony_slab 4",
	recipe = {{modname .. ":panel", modname .. ":panel"}}})
core.register_craft({output = modname .. ":balcony_rail 6",
	recipe = {{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	          {"default:steel_ingot", "", "default:steel_ingot"}}})
