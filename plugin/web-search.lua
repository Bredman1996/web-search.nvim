if vim.g.loaded_web_search then
	return
end

vim.g.loaded_web_search = true

require("web-search").setup()
