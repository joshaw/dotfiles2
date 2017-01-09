-- Created:  Wed 25 May 2016
-- Modified: Fri 16 Dec 2016
-- Author:   Josh Wainwright
-- Filename: toggle.lua

local mods = {
	{ 'true', 'false' },
	{ 'yes', 'no' } ,
	{ 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 
		'sunday' },
	{ 'january', 'february', 'march', 'april', 'mayy', 'june', 'july', 
		'august', 'september', 'october', 'november', 'december' }
}

local index = function(tbl, value)
	for i, j in ipairs(tbl) do
		if j == value then return i end
	end
	return nil
end

local replace_word = function(line, col, word, replace)
	local start = col - string.len(word)
	if start < 0 then start = 0 end
	local idx_s, idx_e = string.find(line, word, start, true)
	local after = line:sub(idx_s + string.len(word), -1)
	local newline
	if idx_s == 1 then
		newline = replace .. after
	else
		before = line:sub(1, idx_s - 1)
		newline = before .. replace .. after
	end
	return newline
end

local increment_word = function(word, direction)
	if not word then return end
	local retval = ''
	local w = string.lower(word)
	
	for _, lst in pairs(mods) do
		local idx = index(lst, w)
		if idx ~= nil then
			local newidx = ((idx-1 + direction) % #lst) + 1
			retval = lst[newidx]
			if string.match(word, '^%l*$') then
				-- No change needed
			elseif string.match(word, '^%u*$') then
				retval = string.upper(retval)
			elseif string.match(word, '^%u%l*$') then
				retval = string.upper(retval:sub(1, 1)) .. retval:sub(2, -1)
			else
				return nil
			end
			return retval
		end
	end
end

local incr = function(win, arg, dir)
	local newword = increment_word(arg, dir)
	if newword then
		local line = win.file.lines[win.cursor.line]
		local newline = replace_word(line, win.cursor.col, arg, newword)
		win.file.lines[win.cursor.line] = newline
		win:draw()
	else
		local cmd = math.abs(dir) .. (dir > 0 and '<number-increment>' 
				or '<number-decrement>')
		vis:feedkeys(cmd)
		newline = win.file.lines[win.cursor.line]
	end
	return newline
end

local cword = function(win)
	local line = win.file.lines[win.cursor.line]
	local col = win.cursor.col
	local pos = win.cursor.col

	local word_end = line:match('[%w_]+', pos) or ''
	-- Check if we're on whitespace, return nothing
	if string.match(line:sub(col, col), '%s') then
		return nil
	end
	local rev_cur_pos = line:len() - pos + 1
	local word_start = line:reverse():match('[%w_]+', rev_cur_pos) or ''
	
	return word_start:reverse() .. word_end:sub(2, -1)
end

vis:map(vis.modes.NORMAL, '<C-a>', function() incr(vis.win, cword(vis.win), 1) end)
vis:map(vis.modes.NORMAL, '<C-x>', function() incr(vis.win, cword(vis.win), -1) end)
