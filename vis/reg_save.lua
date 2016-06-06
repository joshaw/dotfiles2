-- Created:  2016-05-12
-- Modified: Tue 31 May 2016
-- Author:   Josh Wainwright
-- Filename: reg_save.lua

local reg_save = {}

local json = require("dkjson")
reg_save.info_file = os.getenv('HOME') .. '/.config/vis/.vis.info'

local get_fname = function(win)
	local fname = win.file.name
	if not fname then return end
	if fname:sub(1, 1) ~= '/' then
		fname = os.capture('realpath ' .. vis.pwd .. fname)
	end
	return fname
end

local registers_write = function(tbl)
	local json_str = json.encode(tbl, {indent=true})
	local f = assert(io.open(reg_save.info_file, 'w'))
	f:write(json_str)
	f:close()
end

local registers_read = function()
	local f = io.open(reg_save.info_file, 'r')
	if not f then
		return {}
	end
	local info_input = f:read('*all')
	f:close()
	local obj, pos, err = json.decode(info_input)
	if err then
		return {}
	end
	return obj
end

local file_exists = function(name)
	local f = io.open(name, "r")
	if f == nil then 
		return false 
	end
	f:close() 
	return true 
end

reg_save.save = function(win)
	local fname = get_fname(win)
	if not fname then return end
	-- List of flags to save in info file
	local flags = {}
	--for _, reg in pairs({'a','b','c','d','e','f','g','h','i','j','k','l','m',
	--		'n','o', 'p','q','r','s','t','u','v','w','x','y','z','"','@',':',
	--		'/','0'}) do
	--	local regval = vis:getreg(reg) -- TODO
	--	if regval ~= nil then
	--		flags[reg] = regval
	--	end
	--end
	local tbl = registers_read()
	local file_tbl = tbl[fname] or {}
	local file_info = {
		registers = flags,
		date = os.time(),
		cursor = { win.cursor.line, win.cursor.col },
		syntax = win.syntax or json.null,
		count = (file_tbl.count or 0) + 1
	}
	tbl[fname] = file_info
	registers_write(tbl)
end

reg_save.restore = function(win)
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

local oldfiles = function(num)
	local tbl = registers_read()
	local files = {}
	for i, n in pairs(tbl) do
		table.insert(files, {fname = i, date = n.date, count = n.count})
	end

	table.sort(files, function(a,b) return a.date>b.date end)

	local lines = {}
	local ngone = 0
	for i, n in ipairs(files) do
		local gone = ' '
		if not file_exists(n.fname) then
			gone = '*'
			ngone = ngone +1
		end
		local date = os.date('%Y-%m-%d %H:%M:%S', n.date)
		local nl = string.format('%s %-3s | %s | %s', gone, (n.count or 1), date, n.fname)
		table.insert(lines, nl)
	end

	local start = #lines - (num or #lines) + 1
	start = start < 0 and 1 or start

	local header = ':: ' .. #lines .. ' Files' 
	if ngone > 0 then
		header = header .. ' (' .. ngone .. ' removed)'
	end
	header = header .. ' ::\n'
	
	vis:message(header .. table.concat(lines, '\n', start))
	vis:feedkeys('dgg')
end

local remove_old = function()
	local tbl = registers_read()
	local count = 0
	local new_tbl = {}
	for fname, info in pairs(tbl) do
		if not file_exists(fname) then
			count = count + 1
		else
			new_tbl[fname] = info
		end
	end
	vis:info('Removed ' .. count .. ' entries from info file')
	registers_write(new_tbl)
	oldfiles()
end

vis:command_register('oldfiles', function(argv, force, win, cursor, range)
	if force then
		remove_old()
	else
		oldfiles(argv[1])
	end
end)

return reg_save
