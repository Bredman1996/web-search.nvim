local M = {}

require("web-search.commands")

local defaultMaps = {
	{ name = "aws", source = "hashicorp/aws" },
	{ name = "azure", source = "hashicorp/azure" },
}

local function has_item(maps, name)
	for _, item in ipairs(maps) do
		if item.name == name then
			return true
		end
	end
	return false
end

function M.setup(opts)
	if not opts then
		opts = {}
	end

	if not opts.sourceMaps then
		opts.sourceMaps = {}
	end

	for _, defaultMap in ipairs(defaultMaps) do
		if not has_item(opts.sourceMaps, defaultMap.name) then
			table.insert(opts.sourceMaps, defaultMap)
		end
	end

	require("web-search.core").init(opts)
end

return M
