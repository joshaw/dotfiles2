-- Created:  Fri 20 May 2016
-- Modified: Thu 26 May 2016
-- Author:   Josh Wainwright
-- Filename: fs.lua

local fs = {}

fs.remove = function(fname)
	local ok, err, _ = os.remove(fname)
	if ok then
		vis:info('Removed ' .. fname)
	else
		vis:info('Could not remove file. ' .. err)
	end
end

vis:command_register('RemoveFile', function(argv, force, win, cursor, range)
	fs.remove(argv[1] or win.file.name)
end)

fs.rename = function(oldname, newname)
	local ok, err, _ = os.rename(oldname, newname)
	if ok then
		vis:info('Renamed ' .. oldname .. ' to ' .. newname)
	else
		vis:info('Could not rename file. ' .. err)
	end
end

vis:command_register('RenameFile', function(argv, force, win, cursor, range)
	local oldname, newname
	if argv[2] then
		oldname = argv[1]
		newname = argv[2]
	elseif argv[1] then
		oldname = win.file.name
		newname = argv[1]
	else
		vis:info('Not enough arguments')
	end
	fs.rename(oldname, newname)
end)

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