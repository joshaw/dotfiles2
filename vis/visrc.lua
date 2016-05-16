-- load standard vis module, providing parts of the Lua API
require('vis')

require('utils')
require('navd_p')
require('tag_jump')
require('reg_save')
require('fmt_tabs')
vis.info_file = os.getenv('HOME') .. '/.config/vis/vis.info'
vis.pwd = os.getenv('PWD') .. '/'

vis.events.win_open = function(win)
	-- enable syntax highlighting for known file types
	vis.filetype_detect(win)
	vis.cwd = os.capture('dirname ' .. os.getenv('PWD') .. '/' .. (win.file.name or '.')) .. '/'

	vis:command('set theme molokai')
	vis:command('set number')
	vis:command('set tabwidth 4')
	vis:command('set autoindent')
	vis:command('set colorcolumn 80')
	vis:command('set show tabs')

	user_keybindings(win)
	registers_restore(win)
	statusline(win)
end

vis.events.win_close = function(win)
	registers_save(win)
end

user_keybindings = function(win)
	vis:command('map! normal ; <prompt-show>')
	vis:command('map! normal j <cursor-screenline-down>')
	vis:command('map! normal k <cursor-screenline-up>')
	vis:command('map! normal S <insert-newline>')
	vis:command('map! normal "[ " 0<insert-newline>')
	vis:command('map! normal "] " $l<insert-newline>k')
	vis:command('map! normal <C-Up> ddkP')
	vis:command('map! normal <C-Down> ddp')
	
	vis:command('map! insert <C-e> <cursor-line-end>')
	vis:command('map! insert <C-a> <cursor-line-start>')
	vis:command('map! insert <C-Right> <cursor-word-start-next>')
	vis:command('map! insert <C-Left> <cursor-word-start-prev>')

	vis:map(vis.MODE_NORMAL, '-', navd)
	vis:map(vis.MODE_NORMAL, 'K', function() statusline(vis.win) end)
	vis:map(vis.MODE_NORMAL, 'Q', function() registers_save(vis.win) end)
	vis:map(vis.MODE_NORMAL, 'W', function() registers_restore(vis.win) end)
	
	vis:map(vis.MODE_NORMAL, '<C-]>', jump_tag)
end

statusline = function(win)
	local modes = {
		[vis.MODE_NORMAL]           = '--NORMAL-- ',
		[vis.MODE_OPERATOR_PENDING] = '--OPERATOR_PENDING-- ',
		[vis.MODE_VISUAL]           = '--VISUAL-- ',
		[vis.MODE_VISUAL_LINE]      = '--VISUAL_LINE-- ',
		[vis.MODE_INSERT]           = '--INSERT-- ',
		[vis.MODE_REPLACE]          = '--REPLACE-- ',
	}
			
	local pwd = vis.pwd:gsub(os.getenv('HOME'), '~')
	local stll = string.format('%s%s | %s | %s | %s',
		modes[vis.mode] or '',
		win.file.name or '[No Name]',
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
