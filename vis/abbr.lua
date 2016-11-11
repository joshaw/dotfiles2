--local ABBR

local ABBR = {
	a = 'abcdefghijklm',
	jw = 'Josh Wainwright',
	www = 'www.google.com',
}

function abbr(c)
	local file   = vis.win.file
	local cursor = vis.win.cursor
	
	local line = file.lines[cursor.line]
	local abbr = line:match('%w+$')
	local word = ABBR[abbr]
	
	if word then
		file:delete(cursor.pos - abbr:len(), abbr:len())
		file:insert(cursor.pos, word .. c)
	else
		file:insert(cursor.pos, c)
	end
	
	vis:feedkeys('<Left><Right>')
end

vis:map(vis.MODE_INSERT, ' ', function() abbr(' ') end)
vis:map(vis.MODE_INSERT, '(', function() abbr('(') end)