-- Created:  2016-05-09
-- Modified: 2016-05-19
-- Author:   Josh Wainwright
-- Filename: visrc.lua

-- load standard vis module, providing parts of the Lua API
require('vis')

require('utils')
require('navd_p')
require('tag_jump')
require('reg_save')
require('fmt_tabs')
require('statusline')
require('add_info')
require('diff_orig')

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
	header_update(win)
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

	vis:map(vis.MODE_NORMAL, 'K', function() statusline(vis.win) end)
	
	vis:map(vis.MODE_NORMAL, '<C-]>', jump_tag)
end
