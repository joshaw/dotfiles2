-- Created:  2016-05-12
-- Modified: 2016-05-19
-- Author:   Josh Wainwright
-- Filename: add_info.lua

local LINES = 7
local AUTHOR = 'Josh Wainwright'

header_info = function(file, comment)
	local str =    'Created:  ' .. os.date('%Y-%m-%d') .. '\n' ..
		comment .. 'Modified: ' .. os.date('%Y-%m-%d') .. '\n' ..
		comment .. 'Author:   ' .. AUTHOR .. '\n' ..
		comment .. 'Filename: ' .. file.name .. '\n'
	return str
end

header_insert = function(win)
	local cur_line = win.file.lines[win.cursor.line]
	local comment = string.match(cur_line, '^([^%s]+%s)')
	local str = header_info(win.file, comment or '')
	local cur_pos = win.cursor.pos
	win.file:insert(cur_pos, str)
end

header_update = function(win)
	local fname = win.file.name
	if not fname then return end
	local save_line, save_col = win.cursor.line, win.cursor.col
	local check_line = function(i)
		local line = win.file.lines[i]
		if not line then return end
		local match = line:match('^(.*Modified:[%s]+)') or 
						line:match('^(.*Created:%s+)TST') or
						line:match('^(.*Created:%s*)$')
		if match then
			local newline = match .. os.date('%Y-%m-%d')
			if newline ~= line then
				win.file.lines[i] = match .. os.date('%Y-%m-%d')
			end
		end
	end
	
	for i=1, LINES, 1 do
		check_line(i)
	end
	local len = #win.file.lines
	for i=len, len-LINES, -1 do
		check_line(i)
	end
	win.cursor:to(save_line, save_col)
end

vis:map(vis.MODE_INSERT, '\\i', function() header_insert(vis.win) end)
