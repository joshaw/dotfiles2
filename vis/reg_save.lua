-- Created:  2016-05-12
-- Modified: Fri 09 Dec 2016
-- Author:   Josh Wainwright
-- Filename: reg_save.lua

local reg_save_path = os.getenv('HOME') .. '/.config/vis'
local info_file = reg_save_path .. '/.vis.info'
local serialize = dofile(reg_save_path .. '/serialize.lua')

local function registers_write(tbl)
	local dl_str = serialize(tbl)
	local f = assert(io.open(info_file, 'w'))
	f:write(dl_str)
	f:close()
end

local function file_exists(name)
	local f = io.open(name, "r")
	if f == nil then
		return false
	end
	f:close()
	return true
end

local function save(win)
	local fname = win.file.path
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
	local tbl = dofile(info_file)
	local file_tbl = tbl[fname] or {}
	local file_info = {
		--registers = flags,
		date = os.time(),
		cursor = { win.cursor.line, win.cursor.col },
		syntax = win.syntax,
		count = (file_tbl.count or 0) + 1
	}
	tbl[fname] = file_info
	registers_write(tbl)
end
vis.events.subscribe(vis.events.WIN_CLOSE, save)

local function restore(win)
	local fname = win.file.path
	local file_info = dofile(info_file)[fname]
	if not file_info then
		return
	end

	-- Cursor position
	win.cursor:to(unpack(file_info.cursor))

	-- Syntax highlighting
	local syntax = file_info.syntax
	if syntax then
		--vis:command('set syntax ' .. syntax)
		win.syntax = syntax
	end

	--local registers = file_info.registers
	--if registers then
	--	for reg, content in pairs(registers) do
	--		vis:setreg(reg, content)
	--	end
	--end
end
vis.events.subscribe(vis.events.WIN_OPEN, restore)

local oldfiles = function(num)
	local tbl = dofile(info_file)
	local files = {}
	for i, n in pairs(tbl) do
		files[#files+1] = {fname=i, date=n.date, count=(n.count or 1)}
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
		local name = n.fname:gsub(os.getenv('HOME'), '~')
		local nl = string.format('%s%3s | %s | %s', gone, n.count, date, name)
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
end

local remove_old = function()
	local tbl = dofile(info_file)
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
end

vis:command_register('oldfiles', function(argv, force, win, cursor, range)
	if force then
		remove_old()
		oldfiles()
	else
		oldfiles(argv[1])
	end
end)
