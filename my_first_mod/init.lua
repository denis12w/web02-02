local modname = core.get_current_modname()

-- Декоративный блок
core.register_node(modname .. ":ruby_block", {
	description = "Ruby Block",
	tiles = {"my_first_mod_ruby_block.png"},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

-- Руда в камне
core.register_node(modname .. ":stone_with_ruby", {
	description = "Ruby Ore",
	tiles = {"default_stone.png^my_first_mod_ruby_ore.png"},
	groups = {cracky = 2},
	drop = modname .. ":ruby",
	sounds = default.node_sound_stone_defaults(),
})

-- Предмет
core.register_craftitem(modname .. ":ruby", {
	description = "Ruby",
	inventory_image = "my_first_mod_ruby.png",
})

-- Генерация руды
core.register_ore({
	ore_type = "scatter",
	ore = modname .. ":stone_with_ruby",
	wherein = "default:stone",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 3,
	clust_size = 3,
	y_max = -64,
	y_min = -31000,
})

-- Крафт блока из 9 рубинов и обратно
core.register_craft({
	output = modname .. ":ruby_block",
	recipe = {
		{modname .. ":ruby", modname .. ":ruby", modname .. ":ruby"},
		{modname .. ":ruby", modname .. ":ruby", modname .. ":ruby"},
		{modname .. ":ruby", modname .. ":ruby", modname .. ":ruby"},
	},
})
core.register_craft({
	type = "shapeless",
	output = modname .. ":ruby 9",
	recipe = {modname .. ":ruby_block"},
})

-- Кирка
core.register_tool(modname .. ":ruby_pick", {
	description = "Ruby Pickaxe",
	inventory_image = "my_first_mod_ruby_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 3,
		groupcaps = {
			cracky = {times = {[1] = 1.5, [2] = 0.8, [3] = 0.4}, uses = 40, maxlevel = 3},
		},
		damage_groups = {fleshy = 5},
	},
})
core.register_craft({
	output = modname .. ":ruby_pick",
	recipe = {
		{modname .. ":ruby", modname .. ":ruby", modname .. ":ruby"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	},
})
