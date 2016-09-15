-- Created:  2016-05-13
-- Modified: Thu 15 Sep 2016
-- Author:   Josh Wainwright
-- Filename: statusline.lua

local suffixes = {'B', 'KB', 'MB'}
local human_bytes = function(bytes)
	if bytes <= 0 then
		return ''
	end
	local n = 1
	while bytes >= 1024 do
		n = n + 1
		bytes = bytes / 1024
	end
	return string.format('%.2f', bytes) .. suffixes[n]
end

local modes = {
	[vis.MODE_NORMAL] = '',
	[vis.MODE_OPERATOR_PENDING] = '',
	[vis.MODE_VISUAL] = 'VISUAL',
	[vis.MODE_VISUAL_LINE] = 'VISUAL-LINE',
	[vis.MODE_INSERT] = 'INSERT',
	[vis.MODE_REPLACE] = 'REPLACE',
}

vis.events.win_status = function(win)
	local left = {}
	local right = {}

	local mode = modes[vis.mode]
	if mode ~= '' and vis.win == win then
		left[#left+1] = mode
	end

	local file = win.file
	left[#left+1] = (file.name or '[No Name]') ..
				(file.modified and ' [+]' or '') ..
				(vis.recording and ' @' or '')
	if win.syntax ~= '' then
		left[#left+1] = win.syntax
	end

	if file.newlines ~= "nl" then
		right[#right+1] = file.newlines
	end

	local size = file.size
	local cursor = win.cursor
	right[#right+1] = human_bytes(size)
	right[#right+1] = (size==0 and "0" or math.ceil(cursor.pos/size*100)).."%"

	if #win.cursors > 1 then
		right[#right+1] = cursor.number .. '/' .. #win.cursors
	end

	if not win.large then
		local col = cursor.col
		right[#right+1] = cursor.line .. ', ' .. col
		if size > 33554432 or col > 65536 then
			win.large = true
		end
	end

	local left_str = ' ' .. table.concat(left, " » ") .. ' '
	local right_str = ' ' .. table.concat(right, " « ") .. ' '
	win:status(left_str, right_str)
end

local status = function(win)
	local info = {}
	local fname = win.file.name
	if win.file.name:sub(1,1) ~= '/' then
		fname = os.getenv('PWD') .. '/' .. fname
	end
	info[#info+1] = 'Full file path:\n' .. fname

	local cmd = 'stat --printf "Creation:     %w\nAccess:       %x' ..
		'\nModification: %y\nStatus:       %z" "' .. win.file.name .. '"'
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	info[#info+1] = s

	info[#info+1] = 'File size:    ' .. win.file.size ..
		' (' .. human_bytes(win.file.size) .. ')'
	info[#info+1] = 'Lines:        ' .. #win.file.lines

	local words, chars = 0, 0
	for i in win.file:lines_iterator() do
		chars = chars + i:len()
		for j in i:gmatch('%S+') do
			words = words + 1
		end
	end
	info[#info+1] = 'Words:        ' .. words
	info[#info+1] = 'Chars:        ' .. chars

	vis:message(table.concat(info, '\n'))
	vis:feedkeys('dgg')
end

vis:command_register('Status', function(argv, force, win, cursor, range)
	status(win)
end)
