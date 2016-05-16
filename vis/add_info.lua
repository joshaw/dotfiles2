header_info = function(file, comment)
	local str = 'Created:  ' .. os.date('%Y-%m-%d') .. '\n' ..
		comment .. ' Modified: ' .. os.date('%Y-%m-%d') .. '\n' ..
		comment .. ' Author:   Josh Wainwright\n' ..
		comment .. ' Filename: ' .. file.name .. '\n'
	return str
end

header_insert = function(win)
	local cur_line = win.file.lines[win.cursor.line]
	local comment = string.match(cur_line, '^([^%s]+)')
	local str = header_info(win.file, comment)
	local cur_pos = win.cursor.pos
	win.file:insert(cur_pos, str)
end

header_update = function(win)
	local check_line = function(i)
		local line = win.file.lines[i]
		local match = line:match('^(.*Modified:[%s]+)') or 
						line:match('^(.*Created:%s+)TST') or
						line:match('^(.*Created:%s*)$')
		if match then
			win.file.lines[i] = match .. os.date('%Y-%m-%d')
		end
	end
	
	for i=1, 10, 1 do
		check_line(i)
	end
	local len = #win.file.lines
	for i=len, len-10, -1 do
		check_line(i)
	end
end

vis:map(vis.MODE_INSERT, '\\i', function() header_insert(vis.win) end)

vis:command_register('Info', function()
	header_update(vis.win)
end)