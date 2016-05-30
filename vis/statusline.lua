-- Created:  2016-05-13
-- Modified: Fri 27 May 2016
-- Author:   Josh Wainwright
-- Filename: statusline.lua

local human_bytes = function(bytes)
	if bytes <= 0 then
		return ''
	end
	local n = 1
	while bytes >= 1024 do
		n = n + 1
		bytes = bytes / 1024
	end
	local s = {'B', 'KB', 'MB'}
	return string.format('%.2f', bytes) .. s[n]
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
		table.insert(left, mode)
	end

	local file = win.file
	table.insert(left, (file.name or '[No Name]') ..
				(file.modified and ' [+]' or '') .. 
				(vis.recording and ' @' or ''))
	if win.syntax ~= '' then
		table.insert(left, win.syntax)
	end

	if file.newlines ~= "nl" then
		table.insert(right, file.newlines)
	end

	local size = file.size
	local cursor = win.cursor
	table.insert(right, human_bytes(size))
	table.insert(right, 
			(size == 0 and "0" or math.ceil(cursor.pos/size*100)).."%")

	if #win.cursors > 1 then
		table.insert(right, cursor.number..'/'..#win.cursors)
	end

	if not win.large then
		local col = cursor.col
		table.insert(right, cursor.line..', '..col)
		if size > 33554432 or col > 65536 then
			win.large = true
		end
	end

	local left_str = ' ' .. table.concat(left, " » ") .. ' '
	local right_str = ' ' .. table.concat(right, " « ") .. ' '
	win:status(left_str, right_str)
end
