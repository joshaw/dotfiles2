-- Created:  Fri 13 May 2016
-- Modified: Wed 15 Jun 2016
-- Author:   Josh Wainwright
-- Filename: tag_jump.lua

word_at_pos = function(line, pos)
	local word_end = line:match('[%w_]+', pos + 1) or ''

	local rev_cur_pos = line:len() - pos + 1
	local word_start = line:reverse():match('[%w_]+', rev_cur_pos) or ''

	local word = word_start:reverse() .. word_end
	return word
end

jump_tag = function()
	local win = vis.win
	local line = win.file.lines[win.cursor.line]
	local word = word_at_pos(line, win.cursor.col)
	local tags_f = assert(io.open(os.getenv('PWD') .. '/tags', 'r'))
	local tag_line = ""
	for line in tags_f:lines() do
		local match = line:find('^' .. word)
		if match then
			tag_line = line
			break
		end
	end
	local tagname, tagfile, tagaddress = tag_line:match('([^\t]+)\t([^\t]+)\t([^\t]+)')
	if not tagname or not tagfile or not tagaddress then
		vis:info('Tag not found: ' .. word)
		return
	end
	tagaddress = tagaddress:sub(1,-3)
	tagaddress = tagaddress:gsub('([()])', '\\%1')
	vis:info('TagJump: ' .. tagname .. ' | ' .. tagfile .. ' | ' .. tagaddress)
	vis:command('e ' .. tagfile)
	vis:feedkeys(tagaddress .. 'G')
end

vis:map(vis.MODE_NORMAL, '<C-]>', jump_tag)
