-- Created:  2016-05-12
-- Modified: 2016-05-19
-- Author:   Josh Wainwright
-- Filename: reg_save.lua

require('utils')
local json = require("dkjson")
vis.info_file = os.getenv('HOME') .. '/.config/vis/.vis.info'

get_fname = function(win)
	local fname = win.file.name
	if not fname then return end
	if fname:sub(1, 1) ~= '/' then
		fname = os.capture('realpath ' .. vis.pwd .. fname)
	end
	return fname
end

registers_save = function(win)
	local fname = get_fname(win)
	if not fname then return end
	-- List of flags to save in info file
	local flags = {}
	for _, reg in pairs({'a','b','c','d','e','f','g','h','i','j','k','l','m',
			'n','o', 'p','q','r','s','t','u','v','w','x','y','z','"','@',':',
			'/','0'}) do
		local regval = nil -- TODO vis:getreg(reg)
		if regval ~= nil then
			flags[reg] = regval
		end
	end
	local file_info = {
		registers = flags,
		date = os.time(),
		cursor = { win.cursor.line, win.cursor.col },
		syntax = win.syntax or json.null,
	}
	local tbl = registers_read()
	tbl[fname] = file_info
	local json_str = json.encode(tbl, {indent=true})
	--vis:message(json_str)
	local f = assert(io.open(vis.info_file, 'w'))
	f:write(json_str)
	f:flush()
	f:close()
end

registers_read = function()
	local f = assert(io.open(vis.info_file, 'r'))
	local info_input = f:read('*all')
	f:close()
	local obj, pos, err = json.decode(info_input)
	if err then
		return {}
	end
	return obj
end

registers_restore = function(win)
	local fname = get_fname(win)
	local file_info = registers_read()[fname]
	if not file_info then
		return
	end

	-- Cursor position
	win.cursor:to(unpack(file_info.cursor))

	-- Syntax highlighting
	local syntax = file_info.syntax
	if syntax then
		vis:command('set syntax ' .. syntax)
	end

	local registers = file_info.registers
	if registers then
		for reg, content in pairs(registers) do
			--vis:setreg(reg, content)
		end
	end
end

oldfiles = function(num)
	local tbl = registers_read()
	local files = {}
	for i, n in pairs(tbl) do
		table.insert(files, {fname = i, date = n.date})
	end

	table.sort(files, function(a,b) return a.date>b.date end)

	local lines = {}
	for i, n in ipairs(files) do
		table.insert(lines, os.date('%c', n.date) .. ' | ' .. n.fname)
	end

	local start = #lines - (num or #lines) + 1
	start = start < 0 and 1 or start

	local header = ':: ' .. #lines .. ' Files ::\n'
	vis:message(header .. table.concat(lines, '\n', start))
	vis:feedkeys('dgg')
end

vis:command_register('oldfiles', function(argv, force, win, cursor, range)
	oldfiles(argv[1])
end)