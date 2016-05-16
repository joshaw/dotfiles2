-- Created:  2016-05-13
-- Modified: 2016-05-13
-- Author:   Josh Wainwright
-- Filename: statusline.lua

statusline = function(win)
	local modes = {'--NORMAL-- ', '--OPERATOR_PENDING-- ', '--VISUAL-- ',
		'--VISUAL_LINE-- ', '--INSERT-- ', '--REPLACE-- '}
			
	local pwd = vis.pwd:gsub(os.getenv('HOME'), '~')
	local stll = string.format('%s%s %s| %s | %s | %s',
		modes[vis.mode+1] or '',
		win.file.name or '[No Name]',
		win.file.modified and '[+] ' or '',
		win.syntax or '',
		win.file.newlines,
		human_bytes(win.file.size or 0)
	)

	local stlr = string.format('%i(%i), %i  %i%%',
		win.cursor.line,
		#win.file.lines,
		win.cursor.col,
		math.ceil(win.cursor.pos/(win.file.size + 1)*100)
	)

	local columns = os.capture('tput cols')
	local stlpad = string.rep(' ', columns - (stll:len() + stlr:len()))
	local stl = stll .. stlpad .. stlr
	vis:info(stl)
end

function human_bytes(bytes)
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
