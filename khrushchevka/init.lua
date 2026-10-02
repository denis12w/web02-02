local modname = core.get_current_modname()
local S = function(s) return s end

local function reg(name, def)
	def.groups = def.groups or {cracky = 2}
	def.sounds = def.sounds or default.node_sound_stone_defaults()
	core.register_node(modname .. ":" .. name, def)
end

-- Панели
reg("panel", {description = "Panel Wall", tiles = {"khrushchevka_panel.png"}})
reg("panel_seam", {description = "Panel Wall (corner seam)", tiles = {"khrushchevka_panel_seam.png"}})
reg("panel_seam_h", {description = "Panel Wall (horizontal seam)", tiles = {"khrushchevka_panel_seam_h.png"}})
reg("panel_seam_v", {description = "Panel Wall (vertical seam)", tiles = {"khrushchevka_panel_seam_v.png"}})
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
	drawtype = "glasslike",
	tiles = {"khrushchevka_window.png"},
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
	tiles = {"khrushchevka_concrete.png", "khrushchevka_concrete_under.png", "khrushchevka_concrete.png"},
	paramtype = "light",
	node_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5}},
})

-- Балконное ограждение
reg("balcony_rail", {
	description = "Balcony Railing",
	drawtype = "nodebox",
	tiles = {"khrushchevka_rail_top.png", "khrushchevka_rail_top.png", "khrushchevka_rail.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {type = "fixed", fixed = {
		{-0.5, -0.5, -0.5, 0.5, 0.5, -0.4},
	}},
	groups = {cracky = 3},
	sounds = default.node_sound_metal_defaults(),
})

-- Балконное ограждение из прутьев (сквозное)
reg("balcony_rail_bars", {
	description = "Balcony Railing (bars)",
	drawtype = "nodebox",
	tiles = {"khrushchevka_rail_top.png", "khrushchevka_rail_top.png", "khrushchevka_rail_bars.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {type = "fixed", fixed = {
		{-0.5, -0.5, -0.5, 0.5, 0.5, -0.45},
	}},
	groups = {cracky = 3},
	sounds = default.node_sound_metal_defaults(),
})

-- Водосточная труба
reg("drainpipe", {
	description = "Drainpipe",
	drawtype = "nodebox",
	tiles = {"khrushchevka_drainpipe.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {type = "fixed", fixed = {
		{-0.12, -0.5, 0.26, 0.12, 0.5, 0.5},
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
core.register_craft({output = modname .. ":panel_seam_h 2",
	recipe = {{modname .. ":panel", modname .. ":panel"}}})
core.register_craft({output = modname .. ":panel_seam_v",
	type = "shapeless", recipe = {modname .. ":panel_seam_h"}})
core.register_craft({output = modname .. ":panel_seam_h",
	type = "shapeless", recipe = {modname .. ":panel_seam_v"}})
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
	recipe = {{modname .. ":panel", modname .. ":panel", modname .. ":panel"}}})
core.register_craft({output = modname .. ":balcony_rail_bars 6",
	recipe = {{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	          {"group:stick", "", "group:stick"}}})
core.register_craft({output = modname .. ":drainpipe 6",
	recipe = {{"default:steel_ingot"}, {"default:steel_ingot"}, {"dye:brown"}}})
core.register_craft({output = modname .. ":balcony_rail 6",
	recipe = {{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	          {"default:steel_ingot", "", "default:steel_ingot"}}})

----------------------------------------------------------------------
-- Подъезд и двор
----------------------------------------------------------------------

-- Подъездная дверь (двустворчатая логика как у стандартных дверей)
doors.register("door_entrance", {
	tiles = {{name = "khrushchevka_door.png", backface_culling = true}},
	description = "Entrance Door",
	inventory_image = "khrushchevka_door_item.png",
	groups = {node = 1, cracky = 2, door = 1},
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"},
	},
})

-- Плитка на полу лестничной клетки
reg("stair_tile", {description = "Stairwell Floor Tile", tiles = {"khrushchevka_stair_tile.png"}})
core.register_craft({output = modname .. ":stair_tile 4",
	recipe = {{"default:clay_lump", "default:gravel"}, {"default:gravel", "default:clay_lump"}}})

-- Лестничные перила (тонкий забор вдоль блока)
reg("stair_rail", {
	description = "Stairwell Railing",
	drawtype = "nodebox",
	tiles = {"khrushchevka_rail_dark.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {type = "fixed", fixed = {
		{-0.5, 0.35, -0.05, 0.5, 0.5, 0.05},
		{-0.5, -0.5, -0.03, -0.44, 0.5, 0.03},
		{0.44, -0.5, -0.03, 0.5, 0.5, 0.03},
	}},
	groups = {cracky = 3},
	sounds = default.node_sound_metal_defaults(),
})
core.register_craft({output = modname .. ":stair_rail 4",
	recipe = {{"default:steel_ingot", "default:steel_ingot"}, {"group:stick", "group:stick"}}})

-- Батарея отопления (крепится к стене)
reg("radiator", {
	description = "Radiator",
	drawtype = "nodebox",
	tiles = {"khrushchevka_radiator.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	node_box = {type = "wallmounted",
		wall_top = {-0.4, 0.4, -0.2, 0.4, 0.5, 0.2},
		wall_bottom = {-0.4, -0.5, -0.2, 0.4, -0.4, 0.2},
		wall_side = {-0.5, -0.3, -0.4, -0.4, 0.3, 0.4},
	},
	selection_box = {type = "wallmounted",
		wall_top = {-0.4, 0.4, -0.2, 0.4, 0.5, 0.2},
		wall_bottom = {-0.4, -0.5, -0.2, 0.4, -0.4, 0.2},
		wall_side = {-0.5, -0.3, -0.4, -0.4, 0.3, 0.4},
	},
	groups = {cracky = 3, attached_node = 1},
	sounds = default.node_sound_metal_defaults(),
})
core.register_craft({output = modname .. ":radiator 2",
	recipe = {{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	          {"default:steel_ingot", "default:copper_ingot", "default:steel_ingot"}}})

-- Ковёр на стене
reg("wall_carpet", {
	description = "Wall Carpet",
	drawtype = "signlike",
	tiles = {"khrushchevka_carpet.png"},
	inventory_image = "khrushchevka_carpet.png",
	wield_image = "khrushchevka_carpet.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {type = "wallmounted"},
	groups = {choppy = 3, oddly_breakable_by_hand = 2, attached_node = 1},
	sounds = default.node_sound_wood_defaults(),
})
core.register_craft({output = modname .. ":wall_carpet 2",
	recipe = {{"wool:red", "wool:red"}, {"wool:red", "wool:yellow"}}})

-- Лавочка во дворе
reg("bench", {
	description = "Yard Bench",
	drawtype = "nodebox",
	tiles = {"default_wood.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {type = "fixed", fixed = {
		{-0.5, -0.1, -0.2, 0.5, 0.0, 0.2},    -- сиденье
		{-0.5, 0.0, 0.15, 0.5, 0.45, 0.2},    -- спинка
		{-0.45, -0.5, -0.15, -0.35, -0.1, 0.15},
		{0.35, -0.5, -0.15, 0.45, -0.1, 0.15},
	}},
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
})
core.register_craft({output = modname .. ":bench 2",
	recipe = {{"", "", ""}, {"group:wood", "group:wood", "group:wood"},
	          {"group:stick", "", "group:stick"}}})

-- Гараж-ракушка: металлическая стена и ворота
reg("garage_wall", {description = "Garage Metal Wall", tiles = {"khrushchevka_garage.png"},
	sounds = default.node_sound_metal_defaults()})
reg("garage_gate", {description = "Garage Gate", tiles = {"khrushchevka_garage_gate.png"},
	sounds = default.node_sound_metal_defaults()})
core.register_craft({output = modname .. ":garage_wall 4",
	recipe = {{"default:steel_ingot", "default:steel_ingot"}, {"default:steel_ingot", "default:steel_ingot"}}})
core.register_craft({output = modname .. ":garage_gate 2",
	type = "shapeless", recipe = {modname .. ":garage_wall", modname .. ":garage_wall", "dye:green"}})
