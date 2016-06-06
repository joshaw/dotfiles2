-- Created:  Fri 20 May 2016
-- Modified: Tue 31 May 2016
-- Author:   Josh Wainwright
-- Filename: fs.lua

local fs = {}

fs.maxline = function(win, force)
	local line
	local max = 0
	local cnt = 1
	for line in win.file:lines_iterator() do
		if force then
			vis:info('Force')
			line = line:gsub('\t', '    ')
		end
		if #line > max then
			max = #line
			maxl = cnt
		end
		cnt = cnt + 1
	end
	vis:info('Max line is line ' .. maxl .. ' (' .. max .. ' chars)')
	win.cursor:to(maxl, 1)
end

vis:command_register('MaxLine', function(argv, force, win, cursor, range)
	fs.maxline(win, force)
end)

return fs