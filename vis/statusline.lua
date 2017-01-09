-- Created:  2016-05-13
-- Modified: Mon 19 Dec 2016
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
	[vis.modes.NORMAL] = '',
	[vis.modes.OPERATOR_PENDING] = 'OPERATOR',
	[vis.modes.VISUAL] = 'VISUAL',
	[vis.modes.VISUAL_LINE] = 'VISUAL-LINE',
	[vis.modes.INSERT] = 'INSERT',
	[vis.modes.REPLACE] = 'REPLACE',
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
