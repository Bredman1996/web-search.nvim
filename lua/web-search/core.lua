local M = {}

local sourceMaps = {}
local browserCommand = "xdg-open"
local browserArguments = {}

local state = {
	win = nil,
	buf = nil,
}

local objectTypeMaps = {
	resource = "resources",
	data = "data-sources",
}

local function search_google(text)
	local target = string.format("https://www.google.com?q=%s", text)
	vim.system({ browserCommand, table.unpack(browserArguments), target })
end

local function get_highlighted_text()
	vim.notify("Searching", vim.log.levels.INFO)
	local mode = vim.api.nvim_get_mode().mode
	local opts = {}
	if mode == "v" or mode == "V" or mode == "\22" then
		opts.type = mode
	end

	local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), opts)
	return table.concat(lines, " ")
end

local function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

function M.init(opts)
	sourceMaps = opts.sourceMaps
	browserCommand = opts.browserCommand
	browserArguments = opts.browserArguments
end

local terraformObjectTypes = { "resource", "data" }

local function find_block_type()
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

	if not line then
		vim.notify("No line found", vim.log.levels.ERROR)
		return nil
	end

	for _, value in ipairs(terraformObjectTypes) do
		local pattern = string.format("^%%s*%s", value)
		local result = line:match(pattern)
		if result then
			return result
		end
	end

	return nil
end

function M.search_current_buffer(text)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local matches = {}

	for line_num, line in ipairs(lines) do
		if line:find(text) then
			table.insert(matches, { line = line_num, text = line })
		end
	end

	return matches
end

function M.search_tf()
	local text = get_highlighted_text()
	if not text then
		vim.notify("Couldn't get highlighted text", vim.log.levels.ERROR)
		return
	end
	local search = text:match('^"(.*)"$') or text
	local splitText = split(search, "_")

	if #splitText <= 1 then
		local msg = string.format("'%s' is not a valid tf resource", text)
		vim.notify(msg, vim.log.levels.ERROR)
		return
	end
	-- https://registry.terraform.io</providers/hashicorp/aws/latest/docs/resources/s3_bucket
	local objectType = find_block_type()
	if not objectType then
		local msg = string.format("couldn't determine objectType from %s", objectType)
		vim.notify(msg, vim.log.levels.ERROR)
		return
	end

	local resourceType = objectTypeMaps[objectType]
	if not resourceType then
		vim.notify(string.format("Couldn't get resource type from %s", objectType), vim.log.levels.ERROR)
		return
	end

	local provider = table.remove(splitText, 1)

	local source = nil

	for _, sourceMap in ipairs(sourceMaps) do
		if sourceMap.name == provider then
			source = sourceMap.source
		end
	end

	if not source then
		local msg = string.format("No source for %s provider", provider)
		vim.notify(msg, vim.log.levels.ERROR)
		return
	end

	local resource = table.concat(splitText, "_")

	local target =
		string.format("https://registry.terraform.io/providers/%s/latest/docs/%s/%s", source, resourceType, resource)
	vim.system({ "xdg-open", target })
end

function M.search_highlighted()
	local text = get_highlighted_text()
	search_google(text)
end

function M.generic_search()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		return
	end

	state.buf = vim.api.nvim_create_buf(false, true)

	vim.bo[state.buf].buftype = "prompt"
	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].filetype = "web-search-prompt"

	vim.fn.prompt_setprompt(state.buf, ">")

	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		width = 50,
		height = 1,
		row = math.floor(vim.o.lines / 2),
		col = math.floor((vim.o.columns - 50) / 2),
		style = "minimal",
		border = "rounded",
	})

	vim.cmd("startinsert")

	vim.fn.prompt_setcallback(state.buf, function(text)
		M.on_submit_generic(text)
	end)
end

function M.on_submit_generic(text)
	vim.api.nvim_win_close(state.win, true)
	state.win = nil

	if text == "" then
		return
	end
	search_google(text)
end

return M
