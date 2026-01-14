local core = require("web-search.core")

vim.api.nvim_create_user_command("WebSearch", function()
	core.generic_search()
end, {})

vim.api.nvim_create_user_command("WebSearchSelection", function()
	core.search_highlighted()
end, {})

vim.api.nvim_create_user_command("WebSearchTerraform", function()
	core.search_tf()
end, {})
